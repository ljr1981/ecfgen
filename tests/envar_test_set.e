note
	description: "Tests of {ED_DETECT}."
	testing: "type/manual"
	warning: "[
		Presently, we have no support for Linux, so this will fail to show anything
		for a Linux OS. Only Windows will presently work. Depending on what versions
		you have installed on Windows, some of the tests may fail.
		]"
	ca_ignore: "CA029" -- not quite true

class
	ENVAR_TEST_SET

inherit
	TEST_SET_SUPPORT

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	envar_test
			-- New test routine
		note
			testing:  "execution/isolated"
			detail: "[
				On a 64-bit install of ES the `starting_environment' call accesses the 
				HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
				(64-bot list)and not the HKEY_CURRENT_USER\Environment (32-bit list).
				This test is intended to show this by referencing "PROCESSOR_LEVEL"
				and "NUMBER_OF_PROCESSORS"
				]"
		do
			assert_32 ("envars", attached {HASH_TABLE [STRING_32, STRING_32]} ed.environment.starting_environment as al_envar_list and then
				across
					<<"EIFFEL_SRC", "ISE_EIFFEL", "ISE_C_COMPILER", "TEMP", "TMP", "Path", "PROCESSOR_LEVEL">> as ic
				all
					al_envar_list.has (ic.item)
				end)
			assert_32 ("number_of_processors",
				attached {STRING_32} ed.environment.starting_environment ["NUMBER_OF_PROCESSORS"])
			assert_32 ("github",
				attached {STRING_32} ed.environment.starting_environment ["GITHUB"])
		end

	registry_test
			-- Windows `registry_test'
		note
			plan: "[
				This test shows that on a Windows machine, we can use the Windows Registry
				to discover what installations of EiffelStudio we have. On a Linux box, we
				will need other means, so this will be driven by detecting platform and 
				responding accordingly.
				]"
		do
			assert_32 ("1807", ed.is_es_1807_installed)
			assert_32 ("1902", ed.is_es_1902_installed)
			assert_32 ("1904", ed.is_es_1904_installed)
			assert_32 ("1905", ed.is_es_1905_installed)
			assert_32 ("1909", ed.is_es_1909_installed)
			assert_32 ("1910", ed.is_es_1910_installed)

			if attached es1905.path as al_path then
				assert_strings_equal_diff ("path", "C:\Program Files\Eiffel Software\EiffelStudio 19.05 GPL", al_path.name.out)
			end
			if attached es1905.install_directory as al_dir and then attached al_dir.path.name.out as al_path_string then
				assert_strings_equal_diff ("dir", "C:\Program Files\Eiffel Software\EiffelStudio 19.05 GPL", al_path_string)
			end

			check has_1905: attached ed.Installed_estudio_versions ["19.05"] as al_version then
				across
					al_version.library_ecfs as ic_libs
				loop
					print (ic_libs.item.name.out + "%N")
				end
				assert_integers_equal ("ecf_count", 114, al_version.library_ecfs.count)
			end
		end

feature {NONE} -- Test Support

	es1905: ES_INSTANCE
		once
			check has_instance: attached ed.Installed_estudio_versions ["19.05"] as al_result then
				Result := al_result
			end
		end

	ed: ED_DETECT once create Result end

end


