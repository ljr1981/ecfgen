note
	description: "Representation of a Specialized ECF XML Callback Handler."

class
	ECF_CALLBACK_HANDLER

inherit
	GENERIC_XML_CALLBACK_HANDLER
		redefine
			on_start_tag
		end

create
	make

feature -- Operations

	on_start_tag (a_namespace, a_prefix: detachable STRING_8; a_local_part: STRING_8)
			-- Start of start tag.
		require else -- from XM_CALLBACKS
			unresolved_namespace_is_void: has_resolved_namespaces implies a_namespace /= Void
			local_part: is_local_part (a_local_part)
		local
			l_tag: XML_TAG
		do
			if a_local_part.same_string ("system") then
				create {XML_SYSTEM_TAG} l_tag.make (last_tag, a_namespace, a_prefix, a_local_part)
			else -- The "generic" ({XML_TAG}) case ...
				create l_tag.make (last_tag, a_namespace, a_prefix, a_local_part)
			end
			last_tag := l_tag
			tags.force (l_tag)
		end

end
