note
	description: "Eiffel Detection (ED) by way of Environment Variables, Registry (Windows), and so on."
	ca_ignore: "CA023" -- `estudio_directory' feature: Removing parens results in syntax error.

class
	ED_ENVAR

feature -- Access

	is_es_1807_installed: BOOLEAN do Result := is_estudio_installed ("18.07") end

	is_es_1902_installed: BOOLEAN do Result := is_estudio_installed ("19.02") end

	is_es_1904_installed: BOOLEAN do Result := is_estudio_installed ("19.04") end

	is_es_1905_installed: BOOLEAN do Result := is_estudio_installed ("19.05") end

	is_es_1909_installed: BOOLEAN do Result := is_estudio_installed ("19.09") end

	is_es_1910_installed: BOOLEAN do Result := is_estudio_installed ("19.10") end


	estudio_path (a_version: STRING): detachable PATH
			--
		require
			version_format: a_version.to_real > 0
		do
			if {PLATFORM}.is_windows then
				if attached {WEL_REGISTRY_KEY_VALUE} registry.open_key_value (Windows_HKEY_LOCAL_MACHINE_SOFTWARE_ISE_Eiffel + a_version, ISE_EIFFEL_envar) as al_key_value then
					create Result.make_from_string (al_key_value.string_value)
				end
			else
				do_nothing -- Linux goes here ...
			end
		end

	estudio_directory (a_version: STRING): detachable DIRECTORY
			--
		do
			if
				attached {PATH} estudio_path (a_version) as al_path and then
				attached (create {DIRECTORY}.make_with_path (al_path)) as al_dir and then
				al_dir.exists
			then
				Result := al_dir
			end
		end

	estudio_library_ecfs (a_version: STRING): HASH_TABLE [PATH, STRING]
			-- Gather a list of `estudio_library_ecfs' based on `a_version' number.
		note
			design: "[
				The goal is a list of {PATH} items in a hash by file-name, where
				each item is an ECF file found in the "library" folder of the
				specified Eiffel Studio `a_version' number.
				]"
		require
			positive: a_version.to_real > 0.0
		local
			l_lib_dirs,
			l_lib_dir: DIRECTORY
			l_name,
			l_full_path,
			l_lib_full_path: STRING
		do
			create Result.make (10)
			if attached estudio_directory (a_version) as al_dir then
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

feature {TEST_SET_BRIDGE} -- Implementation: Access

	is_estudio_installed (a_version: STRING): BOOLEAN
			--
		require
			version_format: a_version.to_real > 0
		do
			if {PLATFORM}.is_windows then
				Result := attached estudio_directory (a_version)
			else
				do_nothing -- Linux goes here
			end
		end

	environment: EXECUTION_ENVIRONMENT
			--
		attribute
			create Result
		end

	registry: WEL_REGISTRY
			--
		attribute
			create Result
		end

feature {TEST_SET_BRIDGE} -- Implementation: Constants

	Windows_HKEY_LOCAL_MACHINE_SOFTWARE_ISE_Eiffel: STRING = "HKEY_LOCAL_MACHINE\SOFTWARE\ISE\Eiffel_"

	ISE_EIFFEL_envar: STRING = "ISE_EIFFEL"

end
