note
	description: "Tests of {ES_INSTANCE}."
	testing: "type/manual"
	purpose: "[
		These "tests" are here as a sandbox for me to learn in.
		By these tests, I am learning how to read-and-validate
		existing ECF files, but then also how to construct new
		ones from scratch and then create new ECF files as a result.
		]"

class
	CONFIGURATION_TEST_SET

inherit
	TEST_SET_SUPPORT

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	CONF_ACCESS -- Allows access to change the configuration of a host of CONF_* objects.
		undefine
			default_create
		end

feature -- Test routines: PROCESS_HELPER

	dir_subdir_tests
			--
		local
			l_process: PROCESS_HELPER
		do
			create l_process
			assert_strings_equal ("dir", dir_subdir_example, l_process.output_of_command ("where /r D:\Users\LJR19\Documents\GitHub\ecfgen\docs *.png", Void))
		end

	dir_subdir_example: STRING = "[
D:\Users\LJR19\Documents\GitHub\ecfgen\docs\add_library_dialog.png
D:\Users\LJR19\Documents\GitHub\ecfgen\docs\parse_error_CONF_EXCEPTION_raised.PNG
D:\Users\LJR19\Documents\GitHub\ecfgen\docs\project_settings_dialog_example.PNG
D:\Users\LJR19\Documents\GitHub\ecfgen\docs\system_target.PNG

]"

feature -- Test routines: ES_INSTANCE

	iron_test
			--
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make_with_version ("19.10")
			assert_strings_equal_diff ("iron_dir", "C:\Users\LJR19\OneDrive\Documents\Eiffel User Files\19.09\iron%N", l_instance.iron_directory.path.name.out)
		end

	iron_libs_test
			-- Tests about IRON libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make_for_latest
			l_instance.load_iron_libs (l_instance.iron_libs)
			--assert_32 ("has_iron_libs", not l_instance.iron_libs.is_empty)
		end

	unstable_libs_test
			-- Tests about unstable libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make_with_version ("19.05")
			l_instance.load_unstable_libs (l_instance.unstable_libs)
			assert_32 ("has_contrib_libs", not l_instance.unstable_libs.is_empty)
			assert_integers_equal ("count", 62, l_instance.unstable_libs.count)
		end

	contrib_libs_test
			-- Tests about contrib libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make_with_version ("19.05")
			l_instance.load_contrib_libs (l_instance.contrib_libs)
			assert_32 ("has_contrib_libs", not l_instance.contrib_libs.is_empty)
			assert_integers_equal ("count", 99, l_instance.contrib_libs.count)
		end

	estudio_libs_test
			-- Tests about ES libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make_with_version ("19.05")
			l_instance.load_estudio_libs (l_instance.estudio_libs)
			assert_32 ("has_estudio_libs", not l_instance.estudio_libs.is_empty)
			assert_integers_equal ("count", 67, l_instance.estudio_libs.count)
		end

	estudio_src_libs_test
			-- Tests about EIFFEL_SRC libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make_with_version ("19.05")
			l_instance.Load_eiffel_src_libs (l_instance.eiffel_src_libs)
			assert_32 ("has_esrc_libs", not l_instance.eiffel_src_libs.is_empty)
			assert_integers_equal ("count", 351, l_instance.eiffel_src_libs.count)
		end

	github_libs_test
			-- Tests about GITHUB libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make_with_version ("19.05")
			l_instance.Load_github_libs (l_instance.github_libs)
			assert_32 ("has_github_libs", not l_instance.github_libs.is_empty)
			assert_integers_equal ("count", 418, l_instance.github_libs.count)
		end

feature -- Test routines: ECF Parse-validate

	build_base_ecf_test
		local
			l_factory: CONF_PARSE_FACTORY

			l_system: CONF_SYSTEM
			l_target,
			l_test_target: CONF_TARGET
			l_target_option: CONF_TARGET_OPTION
			l_root: CONF_ROOT
			l_target_settings: CONF_TARGET_SETTINGS
			l_library: CONF_LIBRARY
			l_cluster: CONF_CLUSTER
			l_file_rule: CONF_FILE_RULE
			l_note: CONF_NOTE_ELEMENT

			l_xml: STRING
			l_visitor: CONF_PRINT_VISITOR
			l_list: LIST [STRING]
		do
			create l_factory

			l_system := l_factory.new_system_generate_uuid_with_file_name ("a_file_name", "a_name", "a_namespace")
				-- Library Target
			l_target := l_factory.new_target ("mytarg", l_system)
			l_target.set_description ("library target")
			l_target.set_version (create {CONF_VERSION}.make_version (1, 2, 3, 4))
			l_target.add_capability ("void_safety", "transitional")
			l_target.add_capability ("concurrency", "none")
			l_system.add_target (l_target)
				-- Test Target
			l_test_target := l_factory.new_target ("test", l_system)
			l_test_target.set_description ("test target")
			create l_target_option.make_19_05
			l_target_option.set_description ("test target")
			l_test_target.set_options (l_target_option)
			l_test_target.set_parent (l_target)
			l_system.add_target (l_test_target)

			create l_visitor.make
			l_system.process (l_visitor)

				-- replaces generated UUID in `l_system' visitor output.
			l_xml := l_visitor.text
			l_list := l_xml.split ('"')
			l_xml.replace_substring_all (l_list [14], "B7873B26-8C5F-4734-823F-0E83390BBB4A")

			assert_strings_equal_diff ("system", Basic_ecf_xml, l_xml)
		end

	Basic_ecf_xml: STRING = "[
<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-21-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-21-0 http://www.eiffel.com/developers/xml/configuration-1-21-0.xsd" name="a_name" uuid="B7873B26-8C5F-4734-823F-0E83390BBB4A">
	<target name="mytarg">
		<description>library target</description>
		<version major="1" minor="2" release="3" build="4"/>
		<setting name="total_order_on_reals" value="false"/>
		<capability>
			<concurrency support="none"/>
			<void_safety support="transitional"/>
		</capability>
	</target>
	<target name="test" extends="mytarg">
		<description>test target</description>
		<setting name="total_order_on_reals" value="false"/>
	</target>
</system>

]"

	build_new_ecf_from_scratch_test
			--
		note
			testing: "execution/isolated"
			ecf_constructs: "[
				<system>						{CONF_SYSTEM}.make
					<description>				{CONF_SYSTEM}.set_description
					<target>					{CONF_TARGET}.make
						<root>					{CONF_ROOT}.make
						<option>				{CONF_OPTION}.make
						<setting>				{CONF_TARGET}.set_setting
						<capability>			{CONF_TARGET}.add_capability
							<concurrency>		...
							<void_safety>		...
						<library>				{CONF_LIBRARY}.make
						<cluster>				{CONF_CLUSTER}.make
							<file_rule>			{CONF_FILE_RULE}.make	({CONF_PARSE_FACTORY}.new_file_rule (...) --> )
								<exclude>		{CONF_FILE_RULE}.add_exclude (a_pattern)
								<include>		{CONF_FILE_RULE}.add_include (a_pattern)
				]"
		local
			l_factory: CONF_PARSE_FACTORY
			l_system: CONF_SYSTEM
			l_target: CONF_TARGET
			l_xml: STRING
			l_visitor: CONF_PRINT_VISITOR
			l_list: LIST [STRING]
			l_note: CONF_NOTE_ELEMENT
		do
			create l_factory

			l_system := l_factory.new_system_generate_uuid_with_file_name ("a_file_name", "a_name", "a_namespace")
			l_target := l_factory.new_target ("mytarg", l_system)
			l_target.set_description (Multi_line_description)
			l_target.set_version (create {CONF_VERSION}.make_version (1, 2, 3, 4))
			l_target.add_capability ("void_safety", "transitional")
			l_target.add_capability ("concurrency", "none")
			l_system.add_target (l_target)

			create l_visitor.make
			l_system.process (l_visitor)

			create l_note.make ("note")
			l_note.set_content ("my_content")
			l_system.set_note_node (l_note)
			l_system.process (l_visitor)

				-- replaces generated UUID in `l_system' visitor output.
			l_xml := l_visitor.text
			l_list := l_xml.split ('"')
			l_xml.replace_substring_all (l_list [14], "B7873B26-8C5F-4734-823F-0E83390BBB4A")

			assert_strings_equal_diff ("system", Generated_ecf_xml, l_xml)
		end

	Multi_line_description: STRING = "[
Line one.
Line two.
]"

	Generated_ecf_xml: STRING = "[
<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-21-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-21-0 http://www.eiffel.com/developers/xml/configuration-1-21-0.xsd" name="a_name" uuid="B7873B26-8C5F-4734-823F-0E83390BBB4A">
	<note/>
	<target name="mytarg">
		<description>Line one.
Line two.</description>
		<version major="1" minor="2" release="3" build="4"/>
		<setting name="total_order_on_reals" value="false"/>
		<capability>
			<concurrency support="none"/>
			<void_safety support="transitional"/>
		</capability>
	</target>
</system>

]"

	ecf_parse_validate_test
			--
		note
			testing:  "execution/isolated"
		local
			l_ecf: CONF_LOAD
			l_xml: STRING
			l_visitor: CONF_PRINT_VISITOR
		do
			create l_ecf.make (create {CONF_PARSE_FACTORY})
			l_ecf.retrieve_and_check_configuration (".\ecfgen.ecf")
			assert_32 ("not_is_error", not l_ecf.is_error)
			assert_32 ("not_is_invalid_xml", not l_ecf.is_invalid_xml)
			check attached {CONF_SYSTEM} l_ecf.last_system as al_conf_system then
				assert_strings_equal ("name", "ecfgen", al_conf_system.name)
				al_conf_system.Schema_1_21_0.do_nothing
				assert_strings_equal ("schema_1", "http://www.eiffel.com/developers/xml/configuration-1-21-0 http://www.eiffel.com/developers/xml/configuration-1-21-0.xsd", al_conf_system.Schema_1_21_0)
				assert_strings_equal ("schema_2", "http://www.eiffel.com/developers/xml/configuration-1-21-0 http://www.eiffel.com/developers/xml/configuration-1-21-0.xsd", al_conf_system.Latest_schema)

					-- Let's ensure we get back what we started with ...
				create l_visitor.make
				al_conf_system.process (l_visitor)
				assert_strings_equal_diff ("pretty_print", Ecf_xml, l_visitor.text)
			end
		end

feature -- Test routines: Tag Counting

	counting_tags_test
			-- `counting_tags_test'
			-- 	All we want to do is know that we can detect
			--	each <tag> in the XML and we know that by counting them.
		note
			testing:  "execution/isolated"
		do
			parse_xml (Ecf_xml, 52)
		end

feature -- Test: Support

	callback_handler: TAGCOUNT_CALLBACK_HANDLER
			-- A `callback_handler'
		note
			design: "[
				The terms "callback" and "handler" are synonymous. I prefer
				the term "handler" alone, but even that term is insufficient.
				So, here I have called this "callback_handler" because the
				two terms together tell a sufficient story about what this is.
				]"
		attribute
			create Result.make
		end

	parse_xml (a_xml: STRING; a_count: INTEGER)
			-- Parse XML string in `a_xml'.
		local
			a_parser: XM_PARSER
		do
			-- Create the parser.
			-- It is left in the default state, which means:
			-- ascii only, no external entities or DTDs,
			-- no namespace resolving.
			create {XM_EIFFEL_PARSER} a_parser.make

			-- Create the parser event consumer or handler that counts start tags.
			create {TAGCOUNT_CALLBACK_HANDLER} callback_handler.make
			a_parser.set_callbacks (callback_handler)

			-- Parse ...
			a_parser.parse_from_string (a_xml)

			-- ... and display result
			if not a_parser.is_correct then
				print (a_parser.last_error_extended_description)
				check parser_not_correct: False end
			else
				print ("Number of tags found: " + callback_handler.count.out)
				assert_integers_equal ("n_tags", a_count, callback_handler.count)
			end
		end

	ecf_xml: STRING
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_read (".\ecfgen.ecf")
			l_file.read_stream (l_file.count)
			l_file.close
			Result := l_file.last_string
		end

end
