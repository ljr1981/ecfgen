note
	description: "Representation of an Eiffel Studio Instance"
	purpose_and_design: "See end-of-class notes"
	ca_ignore: "CA023" -- `estudio_directory' feature: Removing parens results in syntax error.

class
	ES_INSTANCE

inherit
	EG_PROCESS_HELPER -- Because we want access to IRON

create
	make_with_version,
	make_for_latest

feature {NONE} -- Initialization

	make_for_latest
			-- Initialize Current for the newest (latest) version of EiffelStudio found.
		do
			if Ed.is_es_1912_installed then
				make_with_version ("19.12")
			elseif Ed.is_es_1910_installed then
				make_with_version ("19.10")
			elseif Ed.is_es_1905_installed then
				make_with_version ("19.05")
			elseif Ed.is_es_1807_installed then
				make_with_version ("18.07")
			else
				check unknown_version: False end
				make_with_version ("") -- never get here!
			end
		end

	make_with_version (a_version_number: like version_number)
			-- `make_with_version' Current with `a_version_number'.
		require
			valid_value: a_version_number.to_real > 0.0
			valid_format: a_version_number.count = 5 and then
							a_version_number [3] = '.'
		do
			version_number := a_version_number
			create estudio_libs.make (1_000)
			create contrib_libs.make (1_000)
			create unstable_libs.make (1_000)
			create eiffel_src_libs.make (1_000)
			create github_libs.make (1_000)
			create iron_libs.make (1_000)
			create user_defined_libs.make (1_000)
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

	iron_directory: DIRECTORY
			--
		do
			create Result.make (output_of_command (bin_directory + " path", Void))
		end

	bin_directory: STRING
			-- Where is the BIN folder located?
		require
			is_installed: is_installed
		local
			l_bin_path_string,
			l_bin_path_fragment,
			l_bin_exe: STRING
		once ("OBJECT")
			-- C:\Program Files\Eiffel Software\EiffelStudio 19.10 GPL\tools\spec\win64\bin
			check has_dir: attached install_directory as al_dir then
				if {PLATFORM}.is_windows and then {PLATFORM}.is_64_bits then
					l_bin_path_fragment := "tools\spec\win64\bin"
					l_bin_exe := "iron.exe"
				elseif {PLATFORM}.is_windows and then not {PLATFORM}.is_64_bits then
					l_bin_path_fragment := "tools\spec\win\bin"
					l_bin_exe := "iron.exe"
				elseif {PLATFORM}.is_unix then
					l_bin_path_fragment := "tools\spec\linux\bin"
					l_bin_exe := "iron"
				else
					check unknown_platform: False end
					create l_bin_path_fragment.make_empty
					l_bin_exe := "iron"
				end
				l_bin_path_string := al_dir.path.name.out
				l_bin_path_string.append_character ({OPERATING_ENVIRONMENT}.Directory_separator)
				l_bin_path_string.append_string_general (l_bin_path_fragment.out)
				l_bin_path_string.append_character ({OPERATING_ENVIRONMENT}.Directory_separator)
				l_bin_path_string.append_string_general (l_bin_exe)
				Result := l_bin_path_string
			end
		end

feature -- Access: Libraries

	All_library_systems_by_name: HASH_TABLE [ES_CONF_SYSTEM_REF, STRING]
			-- Hash of `All_library_systems' stored by ECF name
		do
			create Result.make (All_library_systems.count)
			across
				All_library_systems as ic
			loop
				if ic.item.is_void_safe then
					Result.force (ic.item, ic.item.ecf_name)
				end
			end
		end

	All_library_systems: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
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
		do
			create Result.make (5_000)

			Load_estudio_libs
			if not estudio_libs.is_empty then
				across
					estudio_libs as ic_es_libs
				from
					estudio_libs.start
				loop
					Result.force (ic_es_libs.item, estudio_libs.key_for_iteration)
					estudio_libs.forth
				end
			end
			check loaded: Result.count = estudio_libs.count end

			Load_eiffel_src_libs
			if not eiffel_src_libs.is_empty then
				eiffel_src_libs.start
				across eiffel_src_libs as ic_esrc_libs loop Result.force (ic_esrc_libs.item, eiffel_src_libs.key_for_iteration) end
			end

			Load_github_libs
			if not github_libs.is_empty then
				github_libs.start
				across github_libs as ic_github_libs loop Result.force (ic_github_libs.item, github_libs.key_for_iteration) end
			end

			load_iron_libs
			if not iron_libs.is_empty then
				iron_libs.start
				across iron_libs as ic_iron_libs loop Result.force (ic_iron_libs.item, iron_libs.key_for_iteration) end
			end

			load_unstable_libs
			if not unstable_libs.is_empty then
				unstable_libs.start
				across unstable_libs as ic_unstable_libs loop Result.force (ic_unstable_libs.item, unstable_libs.key_for_iteration) end
			end

			load_contrib_libs
			if not contrib_libs.is_empty then
				contrib_libs.start
				across contrib_libs as ic_contrib_libs loop Result.force (ic_contrib_libs.item, contrib_libs.key_for_iteration) end
			end

			load_user_defined_libs
			if not user_defined_libs.is_empty then
				user_defined_libs.start
				across user_defined_libs as ic_udf_libs loop Result.force (ic_udf_libs.item, user_defined_libs.key_for_iteration) end
			end
		end

	Load_all_library_systems
		do
			All_library_systems.do_nothing
		end

feature -- Access: Libraries: IRON

	iron_libs: attached like lib_list_anchor
			-- List of `iron_libs'.

	load_iron_libs
		do
			load_iron_libs_internal (iron_libs)
		end

	load_iron_libs_internal (a_libs: like iron_libs)
		local
			l_result: separate HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
		do
			if attached iron_directory.path.name.out as al_path_string then
				libs_in_path (al_path_string, a_libs, Common_ecf_blacklist)
			end
		end

feature -- Access: Libraries: Unstable

	unstable_libs: attached like lib_list_anchor
			-- List of Unstable Libraries

	load_unstable_libs
		do
			load_unstable_libs_internal (unstable_libs)
		end

	load_unstable_libs_internal (a_libs: like unstable_libs)
			-- Load `unstable_libs'.
		local
			l_path_string: STRING
		do
			if attached Install_directory as al_dir and then attached al_dir.path.name.out as al_path_string then
				l_path_string := al_path_string + {OPERATING_ENVIRONMENT}.Directory_separator.out + "unstable"
				libs_in_path (l_path_string, a_libs, Common_ecf_blacklist)
			end
		end

feature -- Access: Libraries: Contrib

	contrib_libs: attached like lib_list_anchor
			-- List of User contributed libraries.

	load_contrib_libs
		do
			load_contrib_libs_internal (contrib_libs)
		end

	load_contrib_libs_internal (a_libs: like contrib_libs)
			-- Load `contrib_libs'.
		local
			l_path_string: STRING
		do
			if attached Install_directory as al_dir and then attached al_dir.path.name.out as al_path_string then
				l_path_string := al_path_string + {OPERATING_ENVIRONMENT}.Directory_separator.out + "contrib"
				libs_in_path (l_path_string, a_libs, Common_ecf_blacklist)
			end
		end

feature -- Access: Libraries: EStudio

	estudio_libs_by_name: HASH_TABLE [ES_CONF_SYSTEM_REF, STRING]
		once
			create Result.make (estudio_libs.count)
			across
				estudio_libs as ic
			loop
				if ic.item.is_void_safe then
					Result.force (ic.item, ic.item.ecf_name)
				end
			end
		end

	estudio_libs: attached like lib_list_anchor
			-- Libraries included with EiffelStuido in library folder.

	load_estudio_libs
		do
			load_estudio_libs_internal (estudio_libs)
		end

	load_estudio_libs_internal (a_libs: like estudio_libs)
			-- 1. All libraries installed with the current EiffelStudio
		local
			l_path_string: STRING
		do
			if attached Install_directory as al_dir and then attached al_dir.path.name.out as al_path_string then
				l_path_string := al_path_string + {OPERATING_ENVIRONMENT}.Directory_separator.out + "library"
				libs_in_path (l_path_string, a_libs, Common_ecf_blacklist)
			end
		end

feature -- Access: Libraries: EIFFL_SRC

	eiffel_src_libs: attached like lib_list_anchor
			-- References to EIFFEL_SRC libraries.

	load_eiffel_src_libs
		do
			load_eiffel_src_libs_internal (eiffel_src_libs)
		end

	load_eiffel_src_libs_internal (a_libs: like eiffel_src_libs)
			-- 2. (Optionally) All ECF's with `library_target' found in EIFFEL_SRC (if defined)
		do
			if attached env.starting_environment ["EIFFEL_SRC"] as al_path_string then
				libs_in_path (al_path_string, a_libs, Common_ecf_blacklist_eiffel_src)
			end
		end

feature -- Access: Libraries: GITHUB

	github_libs: attached like lib_list_anchor

	load_github_libs
		do
			load_github_libs_internal (github_libs)
		end

	load_github_libs_internal (a_libs: like github_libs)
			-- 3. (Optionally) All ECF's with `library_target' found in GITHUB (if defined)
			--	(not including "EiffelStudio" if repo is found there - We depend on EIFFEL_SRC instead)
		local
			l_factory: CONF_PARSE_FACTORY
			l_loader: CONF_LOAD
			l_result: separate HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
		do
			create l_factory
			if attached env.starting_environment ["GITHUB"] as al_path_string then
				libs_in_path (al_path_string, a_libs, Common_ecf_blacklist)
			end
		end

feature -- Access: Libraries: UDF

	user_defined_lib_directories: ARRAYED_LIST [DIRECTORY]
			-- List of `user_defined_lib_directories' (e.g. DIRECTORY with ecf files)
		attribute
			create Result.make (10)
		end

	user_defined_libs: attached like lib_list_anchor
			-- List of `user_defined_libs' (e.g. ECF files)

	load_user_defined_libs
			-- `load_user_defined_libs', UDF = User Defined Libraries
		do
			load_user_defined_libs_internal (user_defined_libs)
		end

	load_user_defined_libs_internal (a_libs: like user_defined_libs)
			-- 3. (Optionally) All ECF's with `library_target' found in GITHUB (if defined)
			--	(not including "EiffelStudio" if repo is found there - We depend on EIFFEL_SRC instead)
		local
			l_result: separate HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
		do
			across
				user_defined_lib_directories as ic_dirs
			loop
				if attached ic_dirs.item.path.name.out as al_path_string then
					libs_in_path (al_path_string, a_libs, Common_ecf_blacklist)
				end
			end
		end

feature -- Access: Libraries: Dupes

	Duplicate_libs_by_name: HASH_TABLE [ES_CONF_SYSTEM_REF, STRING_8]
		do
			create Result.make (duplicate_uuid_libraries.count)
			across
				duplicate_uuid_libraries as ic
			loop
				if ic.item.is_void_safe then
					Result.force (ic.item, ic.item.ecf_name)
				end
			end
		end

	duplicate_uuid_libraries: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
			-- Libraries which appear to be duplicates of others based on UUID
		attribute
			create Result.make (100)
		end

feature -- Other lists

	libraries_with_errors: HASH_TABLE [PATH, STRING]
			-- Libraries which will not parse without error.
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

feature -- Operations

	libs_in_path (a_path_string: STRING; a_libs: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]; a_blacklist: like Common_ecf_blacklist)
			-- Determine libraries in `a_path_string' into `a_libs', ignoring items in `a_blacklist'.
		local
			l_factory: CONF_PARSE_FACTORY
			l_loader: CONF_LOAD
			l_ns, l_schema: STRING
			l_files_in_path: HASH_TABLE [PATH, STRING]
		do
			create l_files_in_path.make (1_000)
			files_in_path (create {PATH}.make_from_string (a_path_string), hash_from_array (a_blacklist), l_files_in_path, "ecf")
			across
				l_files_in_path as ic_libs
			from
				create l_factory
			loop
				create l_loader.make (l_factory)
				l_loader.retrieve_configuration (ic_libs.item.name.out)
				if
					not l_loader.is_error and then not attached l_loader.last_error and then
					attached {CONF_SYSTEM} l_loader.last_system as al_system and then
					attached al_system.library_target
				then
					if a_libs.has (al_system.uuid) then
						duplicate_uuid_libraries.force (create {ES_CONF_SYSTEM_REF}.make (al_system), al_system.uuid)
					else
						a_libs.force (create {ES_CONF_SYSTEM_REF}.make (al_system), al_system.uuid)
					end
				elseif l_loader.is_error and then attached l_loader.last_error then
					libraries_with_errors.force (create {PATH}.make_from_string (a_path_string), a_path_string.to_string_8)
				end
			end
		end

	files_in_path (a_path: separate PATH; a_blacklist: separate HASH_TABLE [STRING, STRING]; a_libs_list: separate HASH_TABLE [PATH, STRING]; a_file_ext: STRING)
			-- What files with `a_file_ext' are in `a_path', excluding directory names in `a_exclude_dirs'?
		local
			l_cmd,
			l_output,
			l_file_name: STRING
			l_dir_list: LIST [STRING]
			l_file_name_is_empty,
			l_blacklist_has_file_name,
			l_dir_has_blacklist_item: BOOLEAN
		do
			l_cmd := "WHERE /R %"" + a_path.name.out + "%" *." + a_file_ext
			l_output := output_of_command (l_cmd, Void).to_string_8
			across
				l_output.split ('%N') as ic_folders
			loop
				l_dir_list := ic_folders.item.split ({OPERATING_ENVIRONMENT}.Directory_separator)
				l_file_name := l_dir_list [l_dir_list.count]
				l_file_name_is_empty := l_file_name.is_empty
				l_blacklist_has_file_name := a_blacklist.has (l_file_name)
				l_dir_has_blacklist_item := directory_has_any_blacklist_item (l_dir_list, a_blacklist)
				if -- handle our excludes ...
					not l_file_name_is_empty and then
					not l_blacklist_has_file_name and then
					not l_dir_has_blacklist_item
				then -- otherwise, load the libary reference ...
					a_libs_list.force (create {PATH}.make_from_string (ic_folders.item), l_file_name)
				end
			end
		end

	directory_has_any_blacklist_item (a_dir_list: LIST [STRING]; a_blacklist: separate HASH_TABLE [STRING, STRING]): BOOLEAN
			-- Does any directory item from `a_dir_list' have a matching item in `a_blacklist'?
		do
			Result := across a_dir_list as al_dir_list some a_blacklist.has (al_dir_list.item) end
		end

feature {NONE} -- Implementation

	hash_from_array (a_array: ARRAY [STRING]): HASH_TABLE [STRING, STRING]
			-- Change a `hash_from_array' in `a_array'.
		do
			create Result.make (a_array.count)
			across
				a_array as ic
			loop
				Result.force (ic.item, ic.item)
			end
		end

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

feature -- Access

	other_blacklisters: ARRAYED_LIST [STRING]
			-- A list of `other_blacklisters'
			--	(items ignored when searching for ECF libraries).
		attribute
			create Result.make (10)
		end

feature {TEST_SET_BRIDGE} -- Implementation: Constants

	frozen ed: ED_DETECT once create Result end
			-- Detector

	frozen Env: EXECUTION_ENVIRONMENT once create Result end

	frozen Windows_HKEY_LOCAL_MACHINE_SOFTWARE_ISE_Eiffel: STRING = "HKEY_LOCAL_MACHINE\SOFTWARE\ISE\Eiffel_"

	frozen ISE_EIFFEL_envar: STRING = "ISE_EIFFEL"

	frozen Common_ecf_blacklist: ARRAY [STRING]
		local
			l_result: ARRAYED_LIST [STRING]
		do
			l_result := other_blacklisters.twin
			create l_result.make_from_array ({ARRAY [STRING]} <<
											"default-scoop.ecf",
											"default.ecf",
											"eweasel.ecf",
											"template.ecf",
											"eiffel_unit_test_ecf_template.ecf",
											"template_config.ecf",
											"template_config-scoop.ecf",
											"${APP_NAME}.ecf",
											"${LIB_NAME}.ecf",
											"objc_wrapper.ecf",
											"config045", 			-- $GITHUB\EiffelStudio\eweasel\tests\config045
											"config044",
											"peerjs-server-eiffel",
											"template-safe.ecf">>)
			l_result.append (other_blacklisters)
			Result := l_result.to_array
		end

	frozen Common_ecf_blacklist_EIFFEL_SRC: ARRAY [STRING]
			--
		local
			l_result: ARRAYED_LIST [STRING]
		do
			create l_result.make_from_array ({ARRAY [STRING]} <<
											"default-scoop.ecf",
											"default.ecf",
											"eweasel.ecf",
											"template.ecf",
											"eiffel_unit_test_ecf_template.ecf",
											"template_config.ecf",
											"template_config-scoop.ecf",
											"${APP_NAME}.ecf",
											"${LIB_NAME}.ecf",
											"objc_wrapper.ecf",
											"library_.ecf",
											"library_ise.ecf",
											"config045", 			-- $GITHUB\EiffelStudio\eweasel\tests\config045
											"config044",
											"peerjs-server-eiffel",
											"template-safe.ecf">>)
			l_result.append (other_blacklisters)
			Result := l_result.to_array
		end

	frozen lib_list_anchor: detachable HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
			-- Common type anchor for lists of libraries.

;note
	purpose: "[
		A class which describes an installed instance of Eiffel Studio.
		]"
	profile_history: "[
		The slowest routine is `files_in_path', which consumes about 95%
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

end
