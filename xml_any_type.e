note
	description: "Representation of an {XML_ANY_TYPE} (XML anyTYpe) defined by XSD"
	EIS: "name=eiffel_schema", "src=https://www.eiffel.com/developers/xml/configuration-1-20-0.xsd"
	EIS: "name=instruction", "src=https://www.xml.com/pub/a/2001/08/22/easyschema.html"
	EIS: "name=schema_type_graphic", "src=https://www.w3.org/TR/xmlschema-2/#built-in-datatypes"
	EIS: "name=simple_type_facets", "src=https://www.w3.org/TR/xmlschema-0/#SimpleTypeFacets"

class
	XML_ANY_TYPE

feature -- Access

	name: STRING
			-- `name' of Current type.
		attribute
			Result := "anyType"
		end

end
