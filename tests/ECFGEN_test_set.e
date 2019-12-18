note
	description: "Tests of {ECFGEN}."
	testing: "type/manual"

class
	ECFGEN_TEST_SET

inherit
	TEST_SET_SUPPORT

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines: ECF Parse-validate

	ecf_parse_validate_test
			--
		local
			l_item: CONF_LOAD
		do
			create l_item.make (create {CONF_PARSE_FACTORY})
			l_item.retrieve_and_check_configuration (".\ecfgen.ecf")
			assert_32 ("not_is_error", not l_item.is_error)
			assert_32 ("not_is_invalid_xml", not l_item.is_invalid_xml)
			check attached {CONF_SYSTEM} l_item.last_system as al_conf_system then
				assert_strings_equal ("name", "ecfgen", al_conf_system.name)
				al_conf_system.Schema_1_21_0.do_nothing
				assert_strings_equal ("schema_1", "http://www.eiffel.com/developers/xml/configuration-1-21-0 http://www.eiffel.com/developers/xml/configuration-1-21-0.xsd", al_conf_system.Schema_1_21_0)
				assert_strings_equal ("schema_2", "http://www.eiffel.com/developers/xml/configuration-1-21-0 http://www.eiffel.com/developers/xml/configuration-1-21-0.xsd", al_conf_system.Latest_schema)
			end
		end

feature -- Test routines: ECF Schema

	ecf_xml_schema_test
			--
		local
			l_parser: XM_EIFFEL_PARSER
			l_handler: GENERIC_XML_CALLBACK_HANDLER
		do
			create l_parser.make
			create l_handler.make
			l_parser.set_callbacks (l_handler)
			l_parser.parse_from_string (Ecf_xml_schema)
		end

feature -- Test routines: Simple Outputs

	simple_output_test
			-- Test of very simple output.
		note
			goal: "[
				Parse a simple XML with {GENERIC_XML_CALLBACK_HANDLER}, leaving the results in the `tags' feature.
				Go across the `tags' in the list and "pretty-print" them into a text stream that is identical
				to the input. Therefore--output = input
				]"
			warning: "[
				Houston—we have a problem!
				
				I need to discover why my simple parsing is not good enough! The second test of the `Ecf_xml'
				shows the shortcomings of my XML parsing and then re-outputting. Things get dropped and missed.
				This is will NOT DO in a production bit of code that wants to read in ECF XML files and then
				modify and re-output them to replace an existing ECF file!
				]"
		local
			l_parser: XM_EIFFEL_PARSER
			l_handler: GENERIC_XML_CALLBACK_HANDLER
			l_out: STRING
		do
			create l_parser.make
			create l_handler.make
			l_parser.set_callbacks (l_handler)
			l_parser.parse_from_string (Parent_child_xml.twin)
			assert_strings_equal_diff ("matching_Parent_child_xml", replace_non_printables_keeping_newlines (Parent_child_xml), replace_non_printables_keeping_newlines (l_handler.output))

			create l_parser.make
			create {ECF_CALLBACK_HANDLER} l_handler.make
			l_parser.set_callbacks (l_handler)
			l_parser.parse_from_string (Ecf_xml.twin)

			l_out := l_handler.output

				-- I get this! Because it is unique to an ECF and perhaps not common elsewhere.
				-- NOTE: Add this to `Parent_child_xml' causes the parser to fail to parse.
			l_out.prepend_character ('%N')
			l_out.prepend_string_general ("<?xml version=%"1.0%" encoding=%"ISO-8859-1%"?>")

				-- However, I do NOT "get" these! Why is the parser removing text from various tag attributes and content?
			l_out.replace_substring_all (	"<description>implementation</description>",
											"<description>ecfgen implementation</description>") -- that does not explain content!
			l_out.replace_substring_all (	"<description>Tests</description>",
											"<description>ecfgen Tests</description>")

			assert_strings_equal_diff ("matching_Ecf_xml", replace_non_printables_keeping_newlines (Ecf_xml), replace_non_printables_keeping_newlines (l_out))
		end

feature -- Test routines: Attribute Data-types

	attribute_data_type_test
			-- Testing to see if we have capacity to detect data-types
			--	on tag attributes without XSD.
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
			EIS: "name=microsoft_embedded_XSD", "src=https://docs.microsoft.com/en-us/previous-versions/windows/desktop/ms759142(v%%3Dvs.85)"
		local
			l_parser: XM_EIFFEL_PARSER
			l_handler: GENERIC_XML_CALLBACK_HANDLER
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
			-- Simple test to see if we can parse XML, detecting and keeping
			-- 	the parent-child tree relationship between tags.
		local
			l_parser: XM_EIFFEL_PARSER
			l_handler: GENERIC_XML_CALLBACK_HANDLER
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


feature -- Test: Support: Parent-child

	parent_child_xml: STRING = "[
<parent kp1="vp1" kp2="vp2">
	<child_one key="value"/>
	<child_two kc1="vc1" kc2="vc2">
		<grandchild/>
	</child_two>
	<child_three key="value"/>
</parent>
]"

feature -- Test routines: Tag Counting

	counting_tags_test
			-- `counting_tags_test'
			-- 	All we want to do is know that we can detect
			--	each <tag> in the XML and we know that by counting them.
		do
			parse_xml (Ecf_xml, 39)
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

feature {NONE} -- Test Support

	ecf_xml_schema: STRING = "[
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.eiffel.com/developers/xml/configuration-1-20-0" targetNamespace="http://www.eiffel.com/developers/xml/configuration-1-20-0" elementFormDefault="qualified">
<xs:element name="redirection">
<xs:complexType>
<xs:attribute name="uuid" type="uuid" use="optional"/>
<xs:attribute name="location" type="location" use="required"/>
<xs:attribute name="message" type="xs:string" use="optional"/>
</xs:complexType>
</xs:element>
<xs:element name="system">
<xs:complexType>
<xs:sequence>
<xs:element name="note" type="note" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="target" type="target" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="name" type="xs:string" use="required"/>
<xs:attribute name="uuid" type="uuid" use="optional"/>
<xs:attribute name="readonly" type="xs:boolean" use="optional"/>
<xs:attribute name="library_target" type="xs:string" use="optional"/>
</xs:complexType>
</xs:element>
<xs:complexType name="note">
<xs:sequence>
<xs:any minOccurs="0" maxOccurs="unbounded" processContents="lax"/>
</xs:sequence>
<xs:anyAttribute processContents="lax"/>
</xs:complexType>
<xs:simpleType name="uuid">
<xs:restriction base="xs:string">
<xs:pattern value="[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}"/>
</xs:restriction>
</xs:simpleType>
<xs:simpleType name="location">
<xs:restriction base="xs:string"> </xs:restriction>
</xs:simpleType>
<xs:simpleType name="regexp">
<xs:restriction base="xs:string"> </xs:restriction>
</xs:simpleType>
<xs:complexType name="target">
<xs:sequence>
<xs:element name="note" type="note" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="root" type="root" minOccurs="0"/>
<xs:element name="version" type="version" minOccurs="0"/>
<xs:element name="file_rule" type="file_rule" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="option" type="option" minOccurs="0"/>
<xs:element name="setting" type="setting" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="capability" type="capability" minOccurs="0"/>
<xs:element name="mapping" type="mapping" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="external_include" type="external_location" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="external_cflag" type="external_value" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="external_object" type="external_location" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="external_library" type="external_location" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="external_resource" type="external_location" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="external_linker_flag" type="external_value" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="external_make" type="external_location" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="pre_compile_action" type="action" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="post_compile_action" type="action" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="variable" type="variable" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="precompile" type="precompile" minOccurs="0" maxOccurs="1"/>
<xs:element name="library" type="library" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="assembly" type="assembly" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="cluster" type="cluster" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="override" type="override" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="name" type="xs:string" use="required"/>
<xs:attribute name="extends" type="xs:string" use="optional">
<xs:annotation>
<xs:documentation>
An optional name of a target to be used as a parent of the current one: - another target of the current system if the attribute `extends_location` is not specified; - a specified target of another system if the attribute `extends_location` is specified; - a library target of another system if this attribute is not specified and the attribute `extends_location` is specified. See also: `extends_location`.
</xs:documentation>
</xs:annotation>
</xs:attribute>
<xs:attribute name="extends_location" type="xs:string" use="optional">
<xs:annotation>
<xs:documentation>
An optional location of a system describing a parent target. If specified, the attribute "extends" refers to a target of that system or defaults to the library target, otherwise, the attribute "extends" refers to a target of the current system. See also: `extends`.
</xs:documentation>
</xs:annotation>
</xs:attribute>
<xs:attribute name="abstract" type="xs:boolean" use="optional"/>
</xs:complexType>
<xs:complexType name="root">
<xs:attribute name="cluster" type="xs:string" use="optional"/>
<xs:attribute name="class" type="xs:string" use="optional"/>
<xs:attribute name="feature" type="xs:string" use="optional"/>
<xs:attribute name="all_classes" type="xs:boolean" use="optional"/>
</xs:complexType>
<xs:complexType name="version">
<xs:attribute name="major" type="xs:unsignedInt" use="optional"/>
<xs:attribute name="minor" type="xs:unsignedInt" use="optional"/>
<xs:attribute name="release" type="xs:unsignedInt" use="optional"/>
<xs:attribute name="build" type="xs:unsignedInt" use="optional"/>
<xs:attribute name="product" type="xs:string" use="optional"/>
<xs:attribute name="company" type="xs:string" use="optional"/>
<xs:attribute name="copyright" type="xs:string" use="optional"/>
<xs:attribute name="trademark" type="xs:string" use="optional"/>
</xs:complexType>
<xs:complexType name="file_rule">
<xs:sequence>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="exclude" type="regexp" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="include" type="regexp" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="condition" type="condition" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
</xs:complexType>
<xs:complexType name="option">
<xs:sequence>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="debug" type="debug" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="assertions" type="assertions" minOccurs="0"/>
<xs:element name="warning" type="warning" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="trace" type="xs:boolean" use="optional"/>
<xs:attribute name="profile" type="xs:boolean" use="optional"/>
<xs:attribute name="optimize" type="xs:boolean" use="optional"/>
<xs:attribute name="debug" type="xs:boolean" use="optional"/>
<xs:attribute name="warning" type="xs:boolean" use="optional"/>
<xs:attribute name="namespace" type="xs:string" use="optional"/>
<xs:attribute name="msil_application_optimize" type="xs:boolean" use="optional"/>
<xs:attribute name="full_class_checking" type="xs:boolean" use="optional" default="true"/>
<xs:attribute name="is_attached_by_default" type="xs:boolean" use="optional" default="true"/>
<xs:attribute name="is_obsolete_routine_type" type="xs:boolean" use="optional" default="false"/>
<xs:attribute name="syntax" use="optional" default="standard">
<xs:simpleType>
<xs:restriction base="xs:string">
<xs:enumeration value="obsolete"/>
<xs:enumeration value="transitional"/>
<xs:enumeration value="standard"/>
<xs:enumeration value="provisional"/>
</xs:restriction>
</xs:simpleType>
</xs:attribute>
<xs:attribute name="manifest_array_type" use="optional" default="standard">
<xs:annotation>
<xs:documentation>
Should a manifest array type be checked against a target type of the reattachment the array is involved in? - mismatch_error - yes, report an error if the types are different; - mismatch_warning - yes, report a warning if the types are different; - standard - no, do not perform any checks specific to manifest arrays.
</xs:documentation>
</xs:annotation>
<xs:simpleType>
<xs:restriction base="xs:string">
<xs:enumeration value="mismatch_error"/>
<xs:enumeration value="mismatch_warning"/>
<xs:enumeration value="standard"/>
</xs:restriction>
</xs:simpleType>
</xs:attribute>
</xs:complexType>
<xs:complexType name="capability">
<xs:all>
<xs:element name="catcall_detection" type="capability.catcall_detection" minOccurs="0"/>
<xs:element name="concurrency" type="capability.concurrency" minOccurs="0"/>
<xs:element name="void_safety" type="capability.void_safety" minOccurs="0"/>
</xs:all>
</xs:complexType>
<xs:complexType name="capability.catcall_detection">
<xs:attribute name="support" type="catcall_detection_value" use="optional" default="none">
<xs:annotation>
<xs:documentation>
Maximum supported level of cat call detection ordered as follows: - none - no checks; - conformance - conformance checks; - all - complete cat call safety.
</xs:documentation>
</xs:annotation>
</xs:attribute>
<xs:attribute name="use" type="catcall_detection_value" use="optional">
<xs:annotation>
<xs:documentation>
A CAT-call detection level to be used when an associated target is used as a root.
</xs:documentation>
</xs:annotation>
</xs:attribute>
</xs:complexType>
<xs:complexType name="capability.concurrency">
<xs:attribute name="support" type="concurrency_value" use="optional" default="scoop">
<xs:annotation>
<xs:documentation>
Concurrency values are ordered as follows: - thread - unstructured multithreading, least safe, least restrictions - none - single-threaded applications - scoop - SCOOP, most restrictions
</xs:documentation>
</xs:annotation>
</xs:attribute>
<xs:attribute name="use" type="concurrency_value" use="optional">
<xs:annotation>
<xs:documentation>
Concurrency value to be used when an associated target is used as a root.
</xs:documentation>
</xs:annotation>
</xs:attribute>
</xs:complexType>
<xs:complexType name="capability.void_safety">
<xs:attribute name="support" type="void_safety_value" use="optional" default="all">
<xs:annotation>
<xs:documentation>
Maximum supported level of void-safety ordered as follows: - none - no checks; - conformance - conformance checks; - initialization - checks that variables are initialized before use + conformance; - transitional - calls are only allowed on attached expressions + initialization; - all - complete void-safety.
</xs:documentation>
</xs:annotation>
</xs:attribute>
<xs:attribute name="use" type="void_safety_value" use="optional">
<xs:annotation>
<xs:documentation>
A void safety level to be used when an associated target is used as a root.
</xs:documentation>
</xs:annotation>
</xs:attribute>
</xs:complexType>
<xs:complexType name="setting">
<xs:attribute name="name" type="available_settings" use="required"/>
<xs:attribute name="value" type="xs:string" use="required"/>
</xs:complexType>
<xs:simpleType name="available_settings">
<xs:restriction base="xs:string">
<xs:enumeration value="absent_explicit_assertion"/>
<xs:enumeration value="address_expression"/>
<xs:enumeration value="array_optimization"/>
<xs:enumeration value="automatic_backup"/>
<xs:enumeration value="check_for_void_target"/>
<xs:enumeration value="check_generic_creation_constraint"/>
<xs:enumeration value="check_vape"/>
<xs:enumeration value="cls_compliant"/>
<xs:enumeration value="console_application"/>
<xs:enumeration value="dead_code_removal">
<xs:annotation>
<xs:documentation>
Dead code removal level during finalization: - none - do not remove any code; - feature - remove all features that are reachable neither from the root creation procedure nor from the features marked as visible (this is the default for the previous ECF schemas); - all (default) - same as "feature" plus remove all classes that are not used as targets of object creation and not marked as visible.
</xs:documentation>
</xs:annotation>
</xs:enumeration>
<xs:enumeration value="dotnet_naming_convention"/>
<xs:enumeration value="dynamic_runtime"/>
<xs:enumeration value="enforce_unique_class_names"/>
<xs:enumeration value="exception_trace"/>
<xs:enumeration value="executable_name"/>
<xs:enumeration value="external_runtime"/>
<xs:enumeration value="force_32bits"/>
<xs:enumeration value="il_verifiable"/>
<xs:enumeration value="inlining"/>
<xs:enumeration value="inlining_size"/>
<xs:enumeration value="java_generation"/>
<xs:enumeration value="library_root"/>
<xs:enumeration value="line_generation"/>
<xs:enumeration value="manifest_array_type">
<xs:annotation>
<xs:documentation>
An override for an option of the same name to control whether a manifest array type should be checked against a target type of the reattachment the array is involved in. The corresponding value can be one of: - default (default) - rely on the option value; - standard - force option value "standard" for all code used in the project; - mismatch_warning - force option value "mismatch_warning" for all code except the code for which the option is set to "standard"; - mismatch_error - force option value "mismatch_error" for all code except the code for which the option is set to "standard".
</xs:documentation>
</xs:annotation>
</xs:enumeration>
<xs:enumeration value="metadata_cache_path"/>
<xs:enumeration value="msil_classes_per_module"/>
<xs:enumeration value="msil_clr_version"/>
<xs:enumeration value="msil_culture"/>
<xs:enumeration value="msil_generation"/>
<xs:enumeration value="msil_generation_type"/>
<xs:enumeration value="msil_key_file_name"/>
<xs:enumeration value="msil_use_optimized_precompile"/>
<xs:enumeration value="old_feature_replication"/>
<xs:enumeration value="old_verbatim_strings"/>
<xs:enumeration value="platform"/>
<xs:enumeration value="shared_library_definition"/>
<xs:enumeration value="total_order_on_reals"/>
<xs:enumeration value="use_all_cluster_name_as_namespace"/>
<xs:enumeration value="use_cluster_name_as_namespace"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="debug">
<xs:attribute name="name" type="xs:string" use="required"/>
<xs:attribute name="enabled" type="xs:boolean" use="required"/>
</xs:complexType>
<xs:complexType name="assertions">
<xs:attribute name="precondition" type="xs:boolean" use="optional"/>
<xs:attribute name="postcondition" type="xs:boolean" use="optional"/>
<xs:attribute name="check" type="xs:boolean" use="optional"/>
<xs:attribute name="invariant" type="xs:boolean" use="optional"/>
<xs:attribute name="loop" type="xs:boolean" use="optional"/>
<xs:attribute name="supplier_precondition" type="xs:boolean" use="optional"/>
</xs:complexType>
<xs:complexType name="warning">
<xs:attribute name="name" type="available_warnings" use="required"/>
<xs:attribute name="enabled" type="xs:boolean" use="required"/>
</xs:complexType>
<xs:simpleType name="available_warnings">
<xs:restriction base="xs:string">
<xs:enumeration value="export_class_missing"/>
<xs:enumeration value="obsolete_class"/>
<xs:enumeration value="obsolete_feature"/>
<xs:enumeration value="old_verbatim_strings"/>
<xs:enumeration value="once_in_generic"/>
<xs:enumeration value="option_unknown_class"/>
<xs:enumeration value="renaming_unknown_class"/>
<xs:enumeration value="same_uuid"/>
<xs:enumeration value="syntax"/>
<xs:enumeration value="unused_local"/>
<xs:enumeration value="vjrv"/>
<xs:enumeration value="vwab"/>
<xs:enumeration value="vweq"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="variable">
<xs:attribute name="name" type="xs:string" use="required"/>
<xs:attribute name="value" type="xs:string" use="required"/>
</xs:complexType>
<xs:complexType name="action">
<xs:sequence>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="condition" type="condition" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="command" type="xs:string" use="required"/>
<xs:attribute name="working_directory" type="xs:string" use="optional"/>
<xs:attribute name="succeed" type="xs:boolean" use="optional"/>
</xs:complexType>
<xs:complexType name="condition">
<xs:sequence>
<xs:element name="platform" type="platform" minOccurs="0" maxOccurs="1"/>
<xs:element name="build" type="build" minOccurs="0" maxOccurs="1"/>
<xs:element name="concurrency" type="concurrency" minOccurs="0" maxOccurs="1"/>
<xs:element name="void_safety" type="condition.void_safety" minOccurs="0" maxOccurs="1"/>
<xs:element name="dotnet" type="dotnet" minOccurs="0" maxOccurs="1"/>
<xs:element name="dynamic_runtime" type="dynamic_runtime" minOccurs="0" maxOccurs="1"/>
<xs:element name="version" type="version_condition" minOccurs="0" maxOccurs="1"/>
<xs:element name="custom" type="custom" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
</xs:complexType>
<xs:complexType name="platform">
<xs:attribute name="value" type="platform_list"/>
<xs:attribute name="excluded_value" type="platform_list"/>
</xs:complexType>
<xs:simpleType name="platform_list">
<xs:list itemType="available_platforms"/>
</xs:simpleType>
<xs:simpleType name="available_platforms">
<xs:restriction base="xs:string">
<xs:enumeration value="windows"/>
<xs:enumeration value="unix"/>
<xs:enumeration value="macintosh"/>
<xs:enumeration value="vxworks"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="build">
<xs:attribute name="value" type="build_list"/>
<xs:attribute name="excluded_value" type="build_list"/>
</xs:complexType>
<xs:simpleType name="build_list">
<xs:list itemType="available_builds"/>
</xs:simpleType>
<xs:simpleType name="available_builds">
<xs:restriction base="xs:string">
<xs:enumeration value="workbench"/>
<xs:enumeration value="finalize"/>
</xs:restriction>
</xs:simpleType>
<xs:simpleType name="catcall_detection_value">
<xs:restriction base="xs:string">
<xs:enumeration value="none"/>
<xs:enumeration value="conformance"/>
<xs:enumeration value="all"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="concurrency">
<xs:attribute name="value" type="concurrency_list"/>
<xs:attribute name="excluded_value" type="concurrency_list"/>
</xs:complexType>
<xs:simpleType name="concurrency_list">
<xs:list itemType="concurrency_value"/>
</xs:simpleType>
<xs:simpleType name="concurrency_value">
<xs:restriction base="xs:string">
<xs:enumeration value="none"/>
<xs:enumeration value="thread"/>
<xs:enumeration value="scoop"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="condition.void_safety">
<xs:attribute name="value" type="void_safety.list"/>
<xs:attribute name="excluded_value" type="void_safety.list"/>
</xs:complexType>
<xs:simpleType name="void_safety.list">
<xs:list itemType="void_safety_value"/>
</xs:simpleType>
<xs:simpleType name="void_safety_value">
<xs:annotation>
<xs:documentation>
Void-safety rules to be checked: - none - no rules are checked, this is the only mode without attachment marks at run-time - conformance - attachment status is taken into account in conformance tests - initialization - rules about attribute initialization are checked - transitional - all rules except for object creation with incompletely initialized objects - complete - all rules
</xs:documentation>
</xs:annotation>
<xs:restriction base="xs:string">
<xs:enumeration value="none"/>
<xs:enumeration value="conformance"/>
<xs:enumeration value="initialization"/>
<xs:enumeration value="transitional"/>
<xs:enumeration value="all"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="dotnet">
<xs:attribute name="value" type="xs:boolean" use="required"/>
</xs:complexType>
<xs:simpleType name="code_list">
<xs:list itemType="code_value"/>
</xs:simpleType>
<xs:simpleType name="code_value">
<xs:restriction base="xs:string">
<xs:enumeration value="standard"/>
<xs:enumeration value="dotnet"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="dynamic_runtime">
<xs:attribute name="value" type="xs:boolean" use="required"/>
</xs:complexType>
<xs:complexType name="version_condition">
<xs:attribute type="version_type" name="type"/>
<xs:attribute type="version_number" name="min" use="optional"/>
<xs:attribute type="version_number" name="max" use="optional"/>
</xs:complexType>
<xs:simpleType name="version_type">
<xs:restriction base="xs:string">
<xs:enumeration value="compiler"/>
<xs:enumeration value="msil_clr"/>
</xs:restriction>
</xs:simpleType>
<xs:simpleType name="version_number">
<xs:restriction base="xs:string">
<xs:pattern value="\d*(\.\d*){0,3}"/>
</xs:restriction>
</xs:simpleType>
<xs:simpleType name="available_match_types">
<xs:restriction base="xs:string">
<xs:enumeration value="case-sensitive"/>
<xs:enumeration value="case-insensitive"/>
<xs:enumeration value="wildcard"/>
<xs:enumeration value="regexp"/>
</xs:restriction>
</xs:simpleType>
<xs:complexType name="custom">
<xs:attribute name="name" type="xs:string"/>
<xs:attribute name="value" type="xs:string" use="optional"/>
<xs:attribute name="excluded_value" type="xs:string" use="optional"/>
<xs:attribute name="match" type="available_match_types" use="optional" default="case-sensitive"/>
</xs:complexType>
<xs:complexType name="external_location">
<xs:sequence>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="condition" type="condition" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="location" type="location"/>
</xs:complexType>
<xs:complexType name="external_value">
<xs:sequence>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="condition" type="condition" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="value" type="xs:string"/>
</xs:complexType>
<xs:complexType name="renaming">
<xs:attribute name="old_name" type="xs:string"/>
<xs:attribute name="new_name" type="xs:string"/>
</xs:complexType>
<xs:complexType name="class_option">
<xs:complexContent>
<xs:extension base="option">
<xs:attribute name="class" type="xs:string"/>
</xs:extension>
</xs:complexContent>
</xs:complexType>
<xs:complexType name="group" abstract="true">
<xs:sequence>
<xs:element name="note" type="note" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="option" type="option" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="renaming" type="renaming" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="class_option" type="class_option" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="condition" type="condition" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="name" type="xs:string" use="required"/>
<xs:attribute name="location" type="location" use="required"/>
<xs:attribute name="readonly" type="xs:boolean" use="optional"/>
<xs:attribute name="prefix" type="xs:string" use="optional"/>
</xs:complexType>
<xs:complexType name="library">
<xs:complexContent>
<xs:extension base="group">
<xs:sequence>
<xs:element name="visible" type="visible" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="use_application_options" type="xs:boolean" use="optional"/>
</xs:extension>
</xs:complexContent>
</xs:complexType>
<xs:complexType name="precompile">
<xs:complexContent>
<xs:extension base="library">
<xs:attribute name="eifgens_location" type="xs:string" use="optional"/>
</xs:extension>
</xs:complexContent>
</xs:complexType>
<xs:complexType name="assembly">
<xs:complexContent>
<xs:extension base="group">
<xs:attribute name="assembly_name" type="xs:string" use="optional"/>
<xs:attribute name="assembly_version" type="xs:string" use="optional"/>
<xs:attribute name="assembly_culture" type="xs:string" use="optional"/>
<xs:attribute name="assembly_key" type="xs:string" use="optional"/>
</xs:extension>
</xs:complexContent>
</xs:complexType>
<xs:complexType name="abstract_cluster" abstract="true">
<xs:complexContent>
<xs:extension base="group">
<xs:sequence>
<xs:element name="file_rule" type="file_rule" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="uses" type="uses" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="visible" type="visible" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="mapping" type="mapping" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
<xs:attribute name="recursive" type="xs:boolean" use="optional"/>
<xs:attribute name="hidden" type="xs:boolean" use="optional"/>
</xs:extension>
</xs:complexContent>
</xs:complexType>
<xs:complexType name="cluster">
<xs:complexContent>
<xs:extension base="abstract_cluster">
<xs:sequence>
<xs:element name="cluster" type="cluster" minOccurs="0" maxOccurs="unbounded"/>
</xs:sequence>
</xs:extension>
</xs:complexContent>
</xs:complexType>
<xs:complexType name="mapping">
<xs:attribute name="old_name" type="xs:string" use="required"/>
<xs:attribute name="new_name" type="xs:string" use="required"/>
</xs:complexType>
<xs:complexType name="uses">
<xs:attribute name="group" type="xs:string" use="required"/>
</xs:complexType>
<xs:complexType name="visible">
<xs:attribute name="class" type="xs:string" use="required"/>
<xs:attribute name="feature" type="xs:string" use="optional"/>
<xs:attribute name="class_rename" type="xs:string" use="optional"/>
<xs:attribute name="feature_rename" type="xs:string" use="optional"/>
</xs:complexType>
<xs:complexType name="override">
<xs:complexContent>
<xs:extension base="abstract_cluster">
<xs:sequence>
<xs:element name="override" type="override" minOccurs="0" maxOccurs="unbounded"/>
<xs:element name="overrides" type="overrides" minOccurs="0" maxOccurs="1"/>
</xs:sequence>
</xs:extension>
</xs:complexContent>
</xs:complexType>
<xs:complexType name="overrides">
<xs:attribute name="group" type="xs:string" use="required"/>
</xs:complexType>
</xs:schema>
]"

end
