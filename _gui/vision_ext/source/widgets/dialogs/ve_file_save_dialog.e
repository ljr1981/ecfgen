note
	description: "Summary description for {VE_FILE_SAVE_DIALOG}."

class
	VE_FILE_SAVE_DIALOG

inherit
	EV_FILE_SAVE_DIALOG

	VE_ANY
		undefine
			copy,
			default_create
		end

create
	default_create,
	make_with_title

end
