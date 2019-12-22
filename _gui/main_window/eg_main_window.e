note
	description: "ECG Generator Wizard App Main Window"
	purpose: "[
		This class represents just the window and not its
		components, nor the actions and interactions of those
		components. This is a mere container and nothing more.
		]"
	BNFE: "[
		Main_window ∋
			Main_menu
			Main_gui
		]"

class
	EG_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize
		end

	EG_MAIN_MENU
		undefine
			default_create,
			copy
		end

	EG_MAIN_GUI
		undefine
			default_create,
			copy
		end

create
	make_with_title

feature {NONE} -- Initialization

	create_interface_objects
			--<Precursor>
		do
			Precursor
			create_gui_objects
		end

	initialize
			--<Precursor>
			-- Mostly about extending, expanding, borders, and padding
			-- and then putting it all in `main_box'
		do
			Precursor {EV_TITLED_WINDOW}
			set_size (800, 600)
			extend_gui_objects
			format_gui_objects
			hookup_gui_objects_event_handlers
		end

feature {NONE} -- Implementation

	window: like Current
			--<Precursor>
		do
			Result := Current
		end

end
