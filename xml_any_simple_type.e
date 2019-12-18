note
	description: "Representation of {XML_ANY_SIMPLE_TYPE} (XML anySimpleType)"

class
	XML_ANY_SIMPLE_TYPE

inherit
	XML_ANY_TYPE
		redefine
			name
		end

feature -- Access

	name: STRING
			--<Precursor>
		attribute
			Result := "anySimpleType"
		end

end
