note
	description: "An XML Tag"

class
	XML_TAG

create
	make

feature {NONE} -- Initialization

	make (a_parent: detachable XML_TAG; a_namespace, a_prefix: detachable STRING_8; a_local_part: STRING_8)
			--
		do
			parent := a_parent
			if attached a_namespace then
				namespace := a_namespace
			end
			if attached a_prefix then
				prefix := a_prefix
			end
			name := a_local_part
		ensure
			parent_set: attached a_parent as al_parent_arg implies (attached parent as al_parent and then al_parent ~ al_parent_arg)
			namespace_set: attached a_namespace as al_namespace_arg implies (attached namespace as al_namespace and then al_namespace ~ al_namespace_arg)
			prefix_set: attached a_prefix as al_prefix_arg implies (attached prefix as al_prefix and then al_prefix ~ al_prefix_arg)
			name_set: name.same_string (a_local_part)
		end

feature -- Access

	parent: detachable XML_TAG
			-- `parent' (if any) of Current.

	children: ARRAYED_LIST [XML_TAG]
			--
		attribute
			create Result.make (10)
		end

	has_children: BOOLEAN
			-- Does Current `has_children'?
		do
			Result := not children.is_empty
		end

	namespace: STRING
			-- `namespace' of Current.
		attribute
			create Result.make_empty
		end

	prefix: STRING
			-- `prefix' of Current.
		attribute
			create Result.make_empty
		end

	name: STRING
			-- `name' of Current (e.g. "local part").
		attribute
			create Result.make_empty
		end

	attributes: HASH_TABLE [STRING, STRING] -- key-value pairs
			-- List of `attributes' for Current.
		attribute
			create Result.make (5)
		end

	content: STRING
			-- `content' of Current.
		attribute
			create Result.make_empty
		end

	comment: STRING
			-- `comment' of Current.
		attribute
			create Result.make_empty
		end

feature -- Settings

	set_content (a_content: like content)
			--
		do
			content := a_content
		ensure
			set: content.same_string (a_content)
		end

	set_comment (a_comment: like comment)
			--
		do
			comment := a_comment
		ensure
			set: comment.same_string (a_comment)
		end

feature -- Output

	output (a_level: INTEGER): STRING
			--
		do
			create Result.make_empty
			Result.append_character ('<')
			Result.append_string_general (name)
			across
				attributes as ic_attr
			from
				attributes.start
			loop
				Result.append_character (' ')
				Result.append_string_general (attributes.key_for_iteration.out)
				Result.append_character ('=')
				Result.append_character ('"')
				Result.append_string_general (ic_attr.item)
				Result.append_character ('"')
				attributes.forth
			end
			if has_children then
				Result.append_character ('>')
				across
					children as ic_child
				loop
					Result.append_string_general (ic_child.item.output (a_level + 1))
				end
				Result.append_character ('%N')
				across 1 |..| a_level as ic_level loop Result.append_character ('%T') end
				Result.append_string_general ("</" + name + ">")
			elseif not content.is_empty then
				Result.append_character ('>')
				Result.append_string_general (content)
				Result.append_string ("</" + name + ">")
			else
				Result.append_character ('/')
				Result.append_character ('>')
			end
			if a_level > 0 then
				across
					1 |..| a_level as ic_level
				loop
					Result.prepend_character ('%T')
				end
			end
			Result.prepend_character ('%N')
			is_output := True
		end

	is_output: BOOLEAN

end
