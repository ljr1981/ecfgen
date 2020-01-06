note
	description: "Specifics of {CONF_SYSTEM} nodes"

deferred class
	EG_NODE_ITEM

feature -- Access

	system_ref: detachable ES_CONF_SYSTEM_REF

feature -- Settings

	set_system_ref (a_ref: ES_CONF_SYSTEM_REF)
			--
		do
			system_ref := a_ref
		end

end
