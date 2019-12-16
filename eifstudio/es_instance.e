note
	description: "Representation of an Eiffel Studio Instance"
	goal: "[
		A class which describes an installed instance of Eiffel Studio.
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
