note
	description: "Representation of an Eiffel Studio Instance"
	goal: "[
		A class which describes an installed instance of Eiffel Studio.
		]"
	profile_history: "[
		The slowest routine is `libraries_in_path', which consumes about 95%
		of the total run-time to seek out and catalog ECF files from various
		sources (e.g. see `all_library_systems'). On this system, there are
		about 16K folders to visit while looking for ECF files, which is what
		takes all the time.
		]"
	solution: "[
		The solution to the slowness of execution might be to use SCOOP to spin
		up threads for each folder instead of just walking the directory trees.
		Thus, it may speed things up if we ID folders first and then spin-up
		threads to check each one for ECF files.
		
		The issue will be compounded by "template" (and other forms of) ECFs
		which are not able to be parsed without errors! There is an {EXCEPTION}.raise
		that is called that stops parsing dead-cold! So, we have to find a way to
		ID ECF files which will not parse properly.
		
		It may be that a blacklist is the proper solution. The other choice is
		to scan the ECF XML file as raw-text to detect signs of non-parse-able
		file content.
		]"
	ca_ignore: "CA023" -- `estudio_directory' feature: Removing parens results in syntax error.

class
	ES_INSTANCE

create
	make

feature {NONE} -- Initialization

	make (a_version_number: like version_number)
			-- `make' Current with `a_version_number'.
		require
			valid_value: a_version_number.to_real > 0.0
			valid_format: a_version_number.count = 5 and then
							a_version_number [3] = '.'
		do
			version_number := a_version_number
			create estudio_libs.make (100)
			create eiffel_src_libs.make (1_000)
			create github_libs.make (1_000)
		ensure
			set: version_number.same_string (a_version_number)
		end

feature -- Access

	version_number: STRING
			-- What is the `version_number' of Current?

	is_installed: BOOLEAN
			-- Is this ES instance installed?
		once ("OBJECT")
			Result := attached install_directory
		end

	path: detachable PATH
			-- What is Current's `path'?
		once ("OBJECT")
			if {PLATFORM}.is_windows then
				if attached {WEL_REGISTRY_KEY_VALUE} registry.open_key_value (Windows_HKEY_LOCAL_MACHINE_SOFTWARE_ISE_Eiffel + version_number, ISE_EIFFEL_envar) as al_key_value then
					create Result.make_from_string (al_key_value.string_value)
				end
			else
				do_nothing -- Linux goes here ...
			end
		end

	install_directory: detachable DIRECTORY
			-- If `is_installed', where is the `install_directory'?
		once ("OBJECT")
			if
				attached {PATH} path as al_path and then
				attached (create {DIRECTORY}.make_with_path (al_path)) as al_dir and then
				al_dir.exists
			then
				Result := al_dir
			end
		end

	all_library_systems: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
			-- What are `all_library_systems' available?
		note
			goal: "[
				A list of `all_library_systems' as {CONF_SYSTEM} objects, uniquely
				identified by their UUID. By "all", we intend to mean:
				
				1. All libraries installed with the current EiffelStudio
				2. (Optionally) All ECF's with `library_target' found in EIFFEL_SRC (if defined)
				3. (Optionally) All ECF's with `library_target' found in GITHUB (if defined)
				4. (Optionally) All ECF's with `library_target' found in Iron (if defined)
				5. (Optionally) All ECF's with `library_target' found in User-defined root folder(s) (if any).
				]"
		once ("OBJECT")
			create Result.make (5_000)
			Load_estudio_libs (estudio_libs)
			across estudio_libs as ic_es_libs loop Result.force (ic_es_libs.item, estudio_libs.key_for_iteration) end
			load_eiffel_src_libs (eiffel_src_libs)
			across eiffel_src_libs as ic_esrc_libs loop Result.force (ic_esrc_libs.item, eiffel_src_libs.key_for_iteration) end
			load_github_libs (github_libs)
			across github_libs as ic_github_libs loop Result.force (ic_github_libs.item, github_libs.key_for_iteration) end
		end

	estudio_libs: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]

	load_estudio_libs (a_libs: like estudio_libs)
			-- 1. All libraries installed with the current EiffelStudio
		local
			l_factory: CONF_PARSE_FACTORY
			l_loader: CONF_LOAD
		once ("OBJECT")
			estudio_libs.wipe_out
			duplicate_uuid_libraries.do_nothing; duplicate_uuid_libraries.wipe_out
			create l_factory

			across
				Library_ecfs as ic_libs
			loop
				create l_loader.make (l_factory)
				l_loader.retrieve_configuration (ic_libs.item.name.out)
				if attached {CONF_SYSTEM} l_loader.last_system as al_system and then attached al_system.library_target then
					if a_libs.has (al_system.uuid) then
						duplicate_uuid_libraries.force (create {ES_CONF_SYSTEM_REF}.make (al_system), ic_libs.item)
					else
						a_libs.force (create {ES_CONF_SYSTEM_REF}.make (al_system), al_system.uuid)
					end
				end
			end
		end

	eiffel_src_libs: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
			-- References to EIFFEL_SRC libraries.

	load_eiffel_src_libs (a_libs: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID])
			-- 2. (Optionally) All ECF's with `library_target' found in EIFFEL_SRC (if defined)
		local
			l_factory: CONF_PARSE_FACTORY
			l_loader: CONF_LOAD
			l_libraries_in_path: HASH_TABLE [PATH, STRING]
		once ("OBJECT")
			create l_factory
			if attached env.starting_environment ["EIFFEL_SRC"] as al_path_string then
				create l_libraries_in_path.make (1_000)
				libraries_in_path (create {PATH}.make_from_string (al_path_string), {ARRAY [STRING]} <<"eweasel", "templates">>, l_libraries_in_path)
				across
					l_libraries_in_path as ic_libs
				loop
					create l_loader.make (l_factory)
					l_loader.retrieve_configuration (ic_libs.item.name.out)
					if
						not l_loader.is_error and then not attached l_loader.last_error and then
						attached {CONF_SYSTEM} l_loader.last_system as al_system and then
						attached al_system.library_target
					then
						if a_libs.has (al_system.uuid) then
							duplicate_uuid_libraries.force (create {ES_CONF_SYSTEM_REF}.make (al_system), ic_libs.item)
						else
							a_libs.force (create {ES_CONF_SYSTEM_REF}.make (al_system), al_system.uuid)
						end
					elseif l_loader.is_error and then attached l_loader.last_error then
						libraries_with_errors.force (create {PATH}.make_from_string (al_path_string), al_path_string.to_string_8)
					end
				end
			end
		end

	github_libs: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]

	load_github_libs (a_libs: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID])
			-- 3. (Optionally) All ECF's with `library_target' found in GITHUB (if defined)
			--	(not including "EiffelStudio" if repo is found there - We depend on EIFFEL_SRC instead)
		local
			l_factory: CONF_PARSE_FACTORY
			l_loader: CONF_LOAD
			l_libraries_in_path: HASH_TABLE [PATH, STRING]
			l_result: separate HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
		once ("OBJECT")
			create l_factory
			if attached env.starting_environment ["GITHUB"] as al_path_string then
				create l_libraries_in_path.make (1_000)
				libraries_in_path (create {PATH}.make_from_string (al_path_string), {ARRAY [STRING]} <<"EiffelStudio", "eweasel", "templates">>, l_libraries_in_path)
				across
					l_libraries_in_path as ic_libs
				loop
					create l_loader.make (l_factory)
					l_loader.retrieve_configuration (ic_libs.item.name.out)
					if
						not l_loader.is_error and then not attached l_loader.last_error and then
						attached {CONF_SYSTEM} l_loader.last_system as al_system and then
						attached al_system.library_target
					then
						if a_libs.has (al_system.uuid) then
							duplicate_uuid_libraries.force (create {ES_CONF_SYSTEM_REF}.make (al_system), ic_libs.item)
						else
							a_libs.force (create {ES_CONF_SYSTEM_REF}.make (al_system), al_system.uuid)
						end
					elseif l_loader.is_error and then attached l_loader.last_error then
						libraries_with_errors.force (create {PATH}.make_from_string (al_path_string), al_path_string.to_string_8)
					end
				end
			end
		end

	Env: EXECUTION_ENVIRONMENT once create Result end

	libraries_with_errors: HASH_TABLE [PATH, STRING]
			-- Libraries which will not parse without error.
		attribute
			create Result.make (100)
		end

	duplicate_uuid_libraries: HASH_TABLE [ES_CONF_SYSTEM_REF, PATH]
			-- Libraries which appear to be duplicates of others based on UUID
		attribute
			create Result.make (100)
		end

	library_ecfs: HASH_TABLE [PATH, STRING]
			-- Gather a list of `estudio_library_ecfs' based on `a_version' number.
		note
			design: "[
				The goal is a list of {PATH} items in a hash by file-name, where
				each item is an ECF file found in the "library" folder of the
				specified Eiffel Studio `a_version' number.
				]"
		local
			l_lib_dirs,
			l_lib_dir: DIRECTORY
			l_name,
			l_full_path,
			l_lib_full_path: STRING
		once ("OBJECT")
			create Result.make (10)
			if attached install_directory as al_dir then
				across -- Looking for "library" folder ...
					al_dir.entries as ic_entries
				loop
					if attached ic_entries.item.name as al_name then
						l_name := al_name.out
						if l_name.same_string ("library") then	-- Found it!
							l_full_path := al_dir.path.name.out + {OPERATING_ENVIRONMENT}.Directory_separator.out + l_name
							create l_lib_dirs.make_open_read (l_full_path)
							across -- Scanning the entries in "library" folder ...
								l_lib_dirs.entries as ic_lib_entries
							loop
								l_lib_full_path := l_full_path + {OPERATING_ENVIRONMENT}.Directory_separator.out + ic_lib_entries.item.name.out
								create l_lib_dir.make_open_read (l_lib_full_path)
								across	-- Looking for "ecf" files in each "library" folder ...
									l_lib_dir.entries as ic_files
								loop
									if ic_files.item.name.out.has_substring (".ecf") then -- We have an "ecf", so store it ...
										Result.force (create {PATH}.make_from_string (l_lib_full_path + {OPERATING_ENVIRONMENT}.Directory_separator.out + ic_files.item.name.out), ic_files.item.name.out)
									end
								end
							end
						end
					end
				end
			end
		end

	libraries_in_path (a_path: separate PATH; a_exclude_dirs: separate ARRAY [STRING]; a_libs_list: separate HASH_TABLE [PATH, STRING])
			--
		local
			l_dirs,
			l_dir: DIRECTORY
			l_name,
			l_full_path,
			l_lib_full_path: STRING
			l_is_excluded,
			l_is_ecf,
			l_is_dir,
			l_is_nothing_to_see_here: BOOLEAN
			l_libs_list: separate HASH_TABLE [PATH, STRING]
		do
			create l_dir.make_with_path (a_path)
			across
				l_dir.entries as ic_files
			from
				l_full_path := l_dir.path.name.out
			loop
				l_is_ecf := ic_files.item.name.count >= 4 and then ic_files.item.name.tail (4).same_string (".ecf")
				l_lib_full_path := l_full_path + {OPERATING_ENVIRONMENT}.Directory_separator.out + ic_files.item.name.out

				if l_is_ecf then
						a_libs_list.force (create {PATH}.make_from_string (l_lib_full_path), ic_files.item.name.out)
				else
					l_is_excluded :=
						attached ic_files.item.name.out.same_string (".") as al_is_current_dir and then al_is_current_dir or
						attached ic_files.item.name.out.same_string ("..") as al_is_parent_dir and then al_is_parent_dir or
						attached ic_files.item.name.out.same_string (".git") as al_is_git and then al_is_git or
						attached ic_files.item.name.out.same_string (".gitattributes") as al_is_git_attr and then al_is_git_attr or
						attached ic_files.item.name.out.same_string (".gitignore") as al_is_git_iggy and then al_is_git_iggy or
						attached ic_files.item.name.out.same_string ("EIFGENs") as al_is_eifgens and then al_is_eifgens or
						attached ic_files.item.name.out.same_string ("templates") as al_is_eifgens and then al_is_eifgens or
						attached ic_files.item.name.out.same_string ("defaults") as al_is_eifgens and then al_is_eifgens or
						attached ic_files.item.name.out.same_string ("wizards") as al_is_eifgens and then al_is_eifgens or
						attached ic_files.item.name.out.same_string ("tests") as al_is_eifgens and then al_is_eifgens or
						attached ic_files.item.name.out.same_string ("resources") as al_is_eifgens and then al_is_eifgens or
						attached a_exclude_dirs.has (ic_files.item.name.out) as al_has_excludes and then al_has_excludes

					l_is_dir := not l_is_excluded and then
								(attached {DIRECTORY} (create {DIRECTORY}.make (l_lib_full_path)) as al_dir and then al_dir.exists)

					if l_is_excluded then
						do_nothing -- either we have excluded entry or just another file of no interest ...
					elseif l_is_dir then
						create l_libs_list.make (100)
						libraries_in_path (create {PATH}.make_from_string (l_lib_full_path), {ARRAY [STRING]} <<>>, l_libs_list)
						across
							l_libs_list as ic_sub_files
						loop
							a_libs_list.force (ic_sub_files.item, ic_sub_files.item.name.out)
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	ed: ED_DETECT once create Result end
			-- Detector

feature {TEST_SET_BRIDGE} -- Implementation: Access

	environment: EXECUTION_ENVIRONMENT
			-- Execution Environment
		attribute
			create Result
		end

	registry: WEL_REGISTRY
			-- Registry (if Windows)
		attribute
			create Result
		end

feature {TEST_SET_BRIDGE} -- Implementation: Constants

	Windows_HKEY_LOCAL_MACHINE_SOFTWARE_ISE_Eiffel: STRING = "HKEY_LOCAL_MACHINE\SOFTWARE\ISE\Eiffel_"

	ISE_EIFFEL_envar: STRING = "ISE_EIFFEL"

end
