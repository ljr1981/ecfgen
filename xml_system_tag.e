note
	description: "Representation of a <system> XML tag"

class
	XML_SYSTEM_TAG

inherit
	XML_TAG

create
	make

feature -- Access

	xml_namespace_attr: STRING do check attached attributes ["xmlns"] as al_item then Result := al_item end end
			-- What is the XML Namespace attribute value of Current?

	xsi_attr: STRING do check attached attributes ["xmlns:xsi"] as al_item then Result := al_item end end
			-- What is the XSI attribute value of Current?

	schema_location_attr: STRING do check attached attributes ["xsi:schemaLocation"] as al_item then Result := al_item end end
			-- What is the schema location (URI) attribute value of Current?

	name_attr: STRING do check attached attributes ["name"] as al_item then Result := al_item end end
			-- What is the name attribute value of Current?

	uuid_attr: STRING do check attached attributes ["uuid"] as al_item then Result := al_item end end
			-- What is the UUID attribute value of Current?

	readonly_attr: BOOLEAN do check attached attributes ["readyonly"] as al_item and then al_item.same_string ("true") then Result := True end end
			-- What is the ReadOnly flag attribute of Current?

end
