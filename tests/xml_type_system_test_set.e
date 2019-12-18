note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	XML_TYPE_SYSTEM_TEST_SET

inherit
	TEST_SET_SUPPORT

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	xml_type_system_tests
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_any_type: XML_ANY_TYPE
			l_any_simple_type: XML_ANY_SIMPLE_TYPE
		do

		end

end


