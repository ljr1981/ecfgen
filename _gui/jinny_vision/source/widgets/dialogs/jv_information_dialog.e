note
	description: "An information dialog for allowing override for testing without overriding EV level class."

class
	JV_INFORMATION_DIALOG

inherit
	EV_INFORMATION_DIALOG

create
	default_create,
	make_with_text,
	make_with_text_and_actions

end
