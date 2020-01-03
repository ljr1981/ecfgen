note
	description: "Specialization of {EV_DIALOG}."
	purpose: "To have an overrideable class for test targets which allows for use of the EV library precompile."

class
	VE_DIALOG

inherit
	EV_DIALOG

create
	default_create,
	make_with_title

end
