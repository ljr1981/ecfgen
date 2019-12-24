note
	description: "An information dialog for allowing override for testing without overriding EV level class."
	date: "$Date: 2014-05-15 18:13:06 -0400 (Thu, 15 May 2014) $"
	revision: "$Revision: 9175 $"

class
	JV_INFORMATION_DIALOG

inherit
	EV_INFORMATION_DIALOG

create
	default_create,
	make_with_text,
	make_with_text_and_actions

end
