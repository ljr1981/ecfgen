note
	description: "Isolation of Main GUI Controls and their creations"

deferred class
	EG_MAIN_GUI_CONTROLS

feature {NONE} -- Initialization

	create_objects
			--<Precursor>
		do

		end

feature {NONE} -- GUI Objects


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

end
