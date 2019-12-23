﻿note
	description: "Representation of an EiffelStudio Configuration System Reference"
	purpose_and_design: "See end-of-class notes"

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

feature -- Target

	targets: HASH_TABLE [CONF_TARGET, STRING]
		attribute
			create Result.make (10)
		end

	add_target (a_target: CONF_TARGET)
		do
			targets.force (a_target, a_target.name.to_string_8)
		end

feature -- Target->Root

feature -- Target->Option

feature -- Target->Setting

feature -- Target->Capability

feature -- Target->Capability->Concurrency

feature -- Target->Capability->Void-safety

feature -- Target->Library

feature -- Target->Cluster

feature -- Target->Cluster->File-rule

feature -- Target->Cluster->File-rule->Exclude

feature -- Target->Cluster->File-rule->Include

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

	is_void_safe: BOOLEAN do Result := void_safe_mode > 0 end
	is_void_safety_complete: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_all end
	is_void_safety_transitional: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_transitional end
	is_void_safety_initialization: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_initialization end
	is_void_safety_conformance: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_conformance end
	is_void_safety_none: BOOLEAN do Result := void_safe_mode = {CONF_STATE}.Void_safety_none end

feature {NONE} -- Implementation: Access

	conf_system: CONF_SYSTEM
			-- Configuration System.

;note
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

end