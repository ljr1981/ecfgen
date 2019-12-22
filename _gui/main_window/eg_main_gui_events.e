note
	description: "Isolation of Main GUI Events."
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_GUI_EVENTS

feature {EG_MAIN_GUI} -- Events



feature {NONE} -- References

	gui: EG_MAIN_GUI
			-- Reference to Main GUI.
		deferred
		end

	controls: EG_MAIN_GUI_CONTROLS
			-- Reference to GUI Controls.
		deferred
		end

	events: EG_MAIN_GUI_EVENTS once Result := Current end
			-- Reference to GUI Control Events.

note
	purpose: "[

		]"
	design: "[

		]"

end
