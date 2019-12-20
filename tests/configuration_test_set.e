﻿note
	description: "Tests of {ECFGEN}."
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

feature -- Test routines: ES_INSTANCE

	estudio_libs_test
			-- Tests about ES libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make ("19.05")
			assert_32 ("has_estudio_libs", not l_instance.Estudio_libs.is_empty)
		end

	estudio_src_libs_test
			-- Tests about EIFFEL_SRC libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make ("19.05")
			assert_32 ("has_esrc_libs", not l_instance.Eiffel_src_libs.is_empty)
		end

	github_libs_test
			-- Tests about GITHUB libraries
		local
			l_instance: ES_INSTANCE
		do
			create l_instance.make ("19.05")
			assert_32 ("has_github_libs", not l_instance.Github_libs.is_empty)
		end

feature -- Test routines: ECF Parse-validate

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
			l_ecf: CONF_LOAD
			l_factory: CONF_PARSE_FACTORY
			l_system: CONF_SYSTEM
			l_target: CONF_TARGET
			l_target_option: CONF_TARGET_OPTION
			l_xml: STRING
			l_visitor: CONF_PRINT_VISITOR
			l_list: LIST [STRING]
		do
			create l_factory
			create l_ecf.make (l_factory)

			l_system := l_factory.new_system_generate_uuid_with_file_name ("a_file_name", "a_name", "a_namespace")
			l_target := l_factory.new_target ("mytarg", l_system)
			create l_target_option.make_19_05
			l_target.set_options (l_target_option)
			l_target.set_description (Multi_line_description)
			l_target.set_version (create {CONF_VERSION}.make_version (1, 2, 3, 4))
			l_target.add_capability ("void_safety", "transitional")
			l_target.add_capability ("concurrency", "none")
			l_system.add_target (l_target)

			create l_visitor.make
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
			parse_xml (Ecf_xml, 44)
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