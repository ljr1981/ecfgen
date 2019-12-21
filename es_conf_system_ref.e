note
	description: "Representation of an EiffelStudio Configuration System Reference"
	purpose: "[
		Store and operate on a {CONF_SYSTEM} object with helper attributes.
		We a deeper description of a {CONF_SYSTEM} for our ECF-Generator.
		For example: We only need library targets and we need to know data
		about the library target (e.g. Void-safety settings, concurrency, etc.).
		]"
	BNFE: "[
		System ≜ 
			Has_library_target
			Library_target
			Is_void_safe
			Description (!description: detachable READABLE_STRING_32, set_description (a_description: like description))
			Note (note_node: detachable CONF_NOTE_ELEMENT, )
		]"

class
	ES_CONF_SYSTEM_REF

create
	make

feature {NONE} -- Initialization

	make (a_conf_system: CONF_SYSTEM)
			-- Initialize Current with `a_conf_system'.
		do
			conf_system := a_conf_system
		end

feature -- Queries

	has_library_target: BOOLEAN
			-- Does Current {CONF_SYSTEM} `has_library_target'?
		do
			Result := attached library_target
		end

	library_target: like conf_system.library_target
			-- The `library_target' of Current {CONF_SYSTEM} (if any).
		do
			Result := conf_system.library_target
		end

	void_safe_mode: INTEGER
			-- What is the `void_safe_mode' value of `library_target' (if any)?
		do
			if attached library_target as al_target then
				Result := al_target.void_safety_mode
			end
		end

	is_void_safety_complete: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_all end
	is_void_safety_transitional: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_transitional end
	is_void_safety_initialization: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_initialization end
	is_void_safety_conformance: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_conformance end
	is_void_safety_none: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_none end

feature {NONE} -- Implementation: Access

	conf_system: CONF_SYSTEM
			-- Configuration System.

end
