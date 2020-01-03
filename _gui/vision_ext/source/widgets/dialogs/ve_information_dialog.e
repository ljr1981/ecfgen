note
	description: "An information dialog for allowing override for testing without overriding EV level class."

class
	VE_INFORMATION_DIALOG

inherit
	EV_INFORMATION_DIALOG

	VE_ANY
		undefine
			copy,
			default_create
		end

create
	default_create,
	make_with_text,
	make_with_text_and_actions

end
