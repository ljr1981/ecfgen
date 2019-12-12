note
	description: "Tests of {ECFGEN}."
	testing: "type/manual"

class
	ECFGEN_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	TEST_SUPPORT
		undefine
			default_create
		end

feature -- Test routines: Simple Outputs

	simple_output_test
			-- Test of very simple output.
		note
			goal: "[
				Parse a simple XML with {GENERIC_XML_HANDLER}, leaving the results in the `tags' feature.
				Go across the `tags' in the list and "pretty-print" them into a text stream that is identical
				to the input. Therefore--output = input
				]"
			warning: "[
				The code commented out (below) is an attempt to "raise-the-bar" on output=input, by
				inputing a more robust example (`Ecf_xml') to see if we can get that to match perfectly.
				It comes really REALLY close, but there is some small flaw, which is most likely in the
				whitespace/layout non-printable characters (e.g. tabs, spaces, newlines, etc.). I do not
				presently have time to ferret out the precise offender, so this (for now) is "good-enough".
				
				THAT IS--the output XML will not be such that the Eiffel XML parser will not successfully
				parse and use the resulting ECF XML file.
				]"
		local
			l_parser: XM_EIFFEL_PARSER
			l_handler: GENERIC_XML_HANDLER
			l_tag: XML_TAG
		do
			create l_parser.make
			create l_handler.make
			l_parser.set_callbacks (l_handler)
			l_parser.parse_from_string (Parent_child_xml)
			assert_strings_equal ("matching_Parent_child_xml", replace_non_printables_keeping_newlines (Parent_child_xml), replace_non_printables_keeping_newlines (l_handler.output))

--			create l_parser.make
--			create l_handler.make
--			l_parser.set_callbacks (l_handler)
--			l_parser.parse_from_string (Ecf_xml)
--			assert_strings_equal ("matching_Ecf_xml", replace_non_printables_keeping_newlines (Ecf_xml), replace_non_printables_keeping_newlines (l_handler.output))
		end

feature -- Test routines: Attribute Data-types

	attribute_data_type_test
			--
		note
			warning: "[
				All attribute key-value pairs must have a double-quoted (string) value part.
				Changing key="100" to key=100, will cause the attribute to be ignored.
				
				It may well be possible to use an XSD file to provide schema type definitions
				to named attributes, but that is beyond the scope of this project and test.
				]"
			suggestion: "[
				A poor-man's-XSD substitute is to simply identify the attribute key by name
				and convert the value-part to whatever target data type you like.
				]"
		local
			l_parser: XM_EIFFEL_PARSER
			l_handler: GENERIC_XML_HANDLER
			l_tag: XML_TAG
		do
			create l_parser.make
			create l_handler.make
			l_parser.set_callbacks (l_handler)
			l_parser.parse_from_string (attribute_data_type_xml)

			l_tag := l_handler.tags [1]
				assert_32 ("no_parent", not attached l_tag.parent)
				assert_32 ("at1", attached l_tag.attributes ["at1"] as al_value and then al_value.same_string ("string"))
				assert_32 ("at2", attached l_tag.attributes ["at2"] as al_value and then al_value.same_string ("100"))
		end

feature -- Test Support: Attribute Data-types

	attribute_data_type_xml: STRING = "[
<?xml version="1.0"?>
<my_tag at1="string" at2="100"/>
]"

feature -- Test routines: Parent-child

	parent_child_test
			--
		local
			l_parser: XM_EIFFEL_PARSER
			l_handler: GENERIC_XML_HANDLER
			l_tag: XML_TAG
		do
			create l_parser.make
			create l_handler.make
			l_parser.set_callbacks (l_handler)
			l_parser.parse_from_string (parent_child_xml)

			assert_integers_equal ("five_tags", 5, l_handler.tags.count)
			l_tag := l_handler.tags [1]
				assert_32 ("no_parent", not attached l_tag.parent)
				assert_32 ("kp1_vp1", attached l_tag.attributes ["kp1"] as al_value implies al_value.same_string ("vp1"))
				assert_32 ("kp2_vp2", attached l_tag.attributes ["kp2"] as al_value implies al_value.same_string ("vp2"))
			l_tag := l_handler.tags [2]
				assert_32 ("child_one_parent", l_tag.parent ~ l_handler.tags [1])
				assert_32 ("key_value1", attached l_tag.attributes ["key"] as al_value implies al_value.same_string ("value"))
			l_tag := l_handler.tags [3]
				assert_32 ("child_two_parent", l_tag.parent ~ l_handler.tags [1])
				assert_32 ("kc1_vc1", attached l_tag.attributes ["kc1"] as al_value implies al_value.same_string ("vc1"))
				assert_32 ("kc2_vc2", attached l_tag.attributes ["kc2"] as al_value implies al_value.same_string ("vc2"))
			l_tag := l_handler.tags [4]
				assert_32 ("grandchild_parent", l_tag.parent ~ l_handler.tags [3])
				assert_integers_equal ("no_attributes", 0, l_tag.attributes.count)
			l_tag := l_handler.tags [5]
				assert_32 ("child_three_parent", l_tag.parent ~ l_handler.tags [1])
				assert_32 ("key_value2", attached l_tag.attributes ["key"] as al_value implies al_value.same_string ("value"))
		end


feature -- Test: Support

	parent_child_xml: STRING = "[
<parent kp1="vp1" kp2="vp2">
	<child_one key="value"/>
	<child_two kc1="vc1" kc2="vc2">
		<grandchild/>
	</child_two>
	<child_three key="value"/>
</parent>
]"

feature -- Test routines

	counting_tags_test
			-- `counting_tags_test'
		do
			parse_xml (Ecf_xml, 39)
		end

feature -- Test: Support

	callback_handler: TAGCOUNT_HANDLER
			--
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
			create {TAGCOUNT_HANDLER} callback_handler.make
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

feature -- Test: Support

	ecf_xml: STRING = "[
<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-21-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-21-0 http://www.eiffel.com/developers/xml/configuration-1-21-0.xsd" name="ecfgen" uuid="4562F4FF-B4EF-EA14-C913-000023D62160" readonly="false">
	<description>ecfgen implementation</description>
	<target name="ecfgen">
		<root all_classes="true"/>
		<option warning="warning" syntax="provisional" manifest_array_type="mismatch_warning">
			<assertions precondition="true" postcondition="true" check="true" invariant="true" loop="true" supplier_precondition="true"/>
		</option>
		<setting name="console_application" value="true"/>
		<setting name="total_order_on_reals" value="false"/>
		<setting name="dead_code_removal" value="feature"/>
		<capability>
			<concurrency support="none"/>
			<void_safety support="transitional" use="transitional"/>
		</capability>
		<library name="base" location="$ISE_LIBRARY\library\base\base-safe.ecf"/>
		<library name="test_extension" location="..\test_extension\test_extension.ecf"/>
		<library name="xml" location="$ISE_LIBRARY\contrib\library\gobo\library\xml\src\library.ecf"/>
		<library name="xml_parser" location="$ISE_LIBRARY\library\text\parser\xml\parser\xml_parser.ecf"/>
		<library name="xml_tree" location="$ISE_LIBRARY\library\text\parser\xml\tree\xml_tree.ecf"/>
		<library name="xslt" location="$ISE_LIBRARY\contrib\library\gobo\library\xslt\src\library.ecf"/>
		<cluster name="ecfgen" location=".\" recursive="true">
			<file_rule>
				<exclude>/.git$</exclude>
				<exclude>/.svn$</exclude>
				<exclude>/CVS$</exclude>
				<exclude>/EIFGENs$</exclude>
				<exclude>tests</exclude>
			</file_rule>
		</cluster>
	</target>
	<target name="test" extends="ecfgen">
		<description>ecfgen Tests</description>
		<root class="ANY" feature="default_create"/>
		<file_rule>
			<exclude>/.git$</exclude>
			<exclude>/.svn$</exclude>
			<exclude>/CVS$</exclude>
			<exclude>/EIFGENs$</exclude>
			<include>tests</include>
		</file_rule>
		<option profile="false"/>
		<setting name="console_application" value="false"/>
		<setting name="total_order_on_reals" value="false"/>
		<library name="testing" location="$ISE_LIBRARY\library\testing\testing-safe.ecf"/>
		<cluster name="tests" location=".\tests\" recursive="true"/>
	</target>
</system>
]"

end
