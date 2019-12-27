note
	description: "Isolation of Main GUI Controls and their creations"
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_GUI_CONTROLS

inherit
	EG_ANY

feature {NONE} -- Initialization

	create_objects
			--<Precursor>
		do
			create main_box
			create system_grid
		end

feature {EG_MAIN_GUI, EG_MAIN_MENU} -- GUI Objects

	main_box: EV_VERTICAL_BOX

	system_grid: EG_SYSTEM_WIDGET

feature {NONE} -- References

	gui: EG_MAIN_GUI
			-- Reference to Main GUI.
		deferred
		end

	controls: EG_MAIN_GUI_CONTROLS once Result := Current end
			-- Reference to GUI Controls.

	events: EG_MAIN_GUI_EVENTS
			-- Reference to GUI Control Events.
		deferred
		end

note
	purpose: "[

		]"
	design: "[

		]"

end
