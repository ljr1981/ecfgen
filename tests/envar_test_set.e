note
	description: "Tests of {ED_ENVAR}."
	testing: "type/manual"

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
		local
			l_item: ED_ENVAR
		do
			create l_item
			if attached l_item.environment.item ("ISE_EIFFEL") as al_actual then
				assert_strings_equal ("ise", "C:\Program Files\Eiffel Software\EiffelStudio 19.09 GPL", al_actual)
			end
			-- EIFFEL_SRC
			if attached l_item.environment.item ("EIFFEL_SRC") as al_actual then
				assert_strings_equal ("eiffel_src", "D:\Users\LJR19\Documents\GitHub\EiffelStudio\Src", al_actual)
			end
			-- ISE_C_COMPILER
			if attached l_item.environment.item ("ISE_C_COMPILER") as al_actual then
				assert_strings_equal ("compiler", "msc_vc140", al_actual)
			end
			-- WRAP_C
			if attached l_item.environment.item ("WRAP_C") as al_actual then
				assert_strings_equal ("wrapc", "D:\Users\LJR19\Documents\GitHub\WrapC", al_actual)
			end
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
		local
			l_item: ED_ENVAR
		do
			create l_item
			assert_32 ("1807", l_item.is_es_1807_installed)
			assert_32 ("1902", l_item.is_es_1902_installed)
			assert_32 ("1904", l_item.is_es_1904_installed)
			assert_32 ("1905", l_item.is_es_1905_installed)
			assert_32 ("1909", l_item.is_es_1909_installed)
			assert_32 ("1910", l_item.is_es_1910_installed)

			if attached l_item.estudio_path ("19.05") as al_path then
				assert_strings_equal_diff ("path", "C:\Program Files\Eiffel Software\EiffelStudio 19.05 GPL", al_path.name.out)
			end
			if attached l_item.estudio_directory ("19.05") as al_dir then
				assert_strings_equal_diff ("dir", "C:\Program Files\Eiffel Software\EiffelStudio 19.05 GPL", al_dir.path.name.out)
			end
		end

end


