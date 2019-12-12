note
	description: "A {GENERIC_XML_CALLBACK_HANDLER} (callback handler)"
	goal: "[
		Build a parent-child tree of XML tag-objects, with attributes/contents as data.
		]"
	purpose: "[
		To assess relevant parts, allowing modification, and then outputting with modifications.
		]"
	design: "[
		The heart of the design is found in the Access feature group:
		
		1. `tags' — a list of `tags', linked in parent-child relations.
		2. `last_parent' — the `last_parent' tag detected.
		3. `last_tag' — the `last_tag' detected.
		
		See: {ECFGEN_TEST_SET}.parent_child_test for typical example parsing steps.
		
		You end up with a list of `tags', where each {XML_TAG} has a link to its
		parent tag.
		]"

class
	GENERIC_XML_CALLBACK_HANDLER

inherit
	XM_CALLBACKS_NULL
		redefine
			on_attribute,
			on_comment,
			on_content,
			on_end_tag,
			on_finish,
			on_processing_instruction,
			on_start,
			on_start_tag,
			on_start_tag_finish,
			on_xml_declaration
		end

create
	make

feature -- Access

	tags: ARRAYED_LIST [XML_TAG]
			-- A list of `tags' (i.e. {XML_TAG} objects)
		attribute
			create Result.make (100)
		end

	last_parent: detachable XML_TAG
			-- The `last_parent' detected.
		do
			if attached last_tag as al_last_tag then
				Result := al_last_tag.parent
			end
		end

	last_tag: detachable XML_TAG
			-- The `last_tag' detected.

feature -- Handlers: Document callbacks

	on_start
			--<Precursor>
		require else
			not_has_parent_tag: not attached last_parent and not attached last_tag
		do

		end

	on_xml_declaration (a_version: STRING_8; an_encoding: detachable STRING_8; a_standalone: BOOLEAN)
			--<Precursor>
		do

		end

	on_finish
			--<Precursor>
		do

		end

feature -- Handlers: Start & End

	on_start_tag (a_namespace, a_prefix: detachable STRING_8; a_local_part: STRING_8)
			--<Precursor>
		local
			l_tag: XML_TAG
		do
			create l_tag.make (last_tag, a_namespace, a_prefix, a_local_part)
			last_tag := l_tag
			tags.force (l_tag)
		end

	on_start_tag_finish
			--<Precursor>
		do

		end

	on_end_tag (a_namespace, a_prefix: detachable STRING_8; a_local_part: STRING_8)
			--<Precursor>
		do
			if attached last_tag as al_last_tag and then attached al_last_tag.parent as al_parent then
				al_parent.children.force (al_last_tag)
				last_tag := al_parent
			else
				last_tag := Void
			end
		end

feature -- Handlers: Tag Internals

	on_attribute (a_namespace, a_prefix: detachable STRING_8; a_local_part, a_value: STRING_8)
			--<Precursor>
		require else
			unresolved_namespace_is_void: has_resolved_namespaces implies a_namespace /= Void
			local_part: is_local_part (a_local_part)
			a_value_not_void: a_value /= Void
			has_last_tag: attached last_tag
		do
			if attached last_tag as al_tag then
				al_tag.attributes.force (a_value, a_local_part)
			end
		end

	on_comment (a_content: STRING_8)
			--<Precursor>
		do
			if attached last_tag as al_last_tag then
				al_last_tag.set_comment (a_content)
			end
		end

	on_content (a_content: STRING_8)
			--<Precursor>
		do
			check has_last_tag: attached last_tag as al_last_tag then
				al_last_tag.set_content (a_content)
			end
		end

	on_processing_instruction (a_name, a_content: STRING_8)
			--<Precursor>
		do

		end

feature -- Outputs

	output: STRING
			--
		do
			create Result.make_empty
			across
				tags as ic_tags
			loop
				if not ic_tags.item.is_output then
					Result.append_string_general (ic_tags.item.output (0))
				end
			end
			if not Result.is_empty then
				Result.remove_head (1)
			end
		end

end
