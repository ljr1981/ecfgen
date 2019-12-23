note
	description: "Isolation of Main GUI Controls and their creations"
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_GUI_CONTROLS

feature {NONE} -- Initialization

	create_objects
			--<Precursor>
		do
			create main_box
		end

feature {EG_MAIN_GUI} -- GUI Objects

	main_box: EV_VERTICAL_BOX

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
