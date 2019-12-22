note
	description: "Summary description for {EG_MAIN_GUI_EVENTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EG_MAIN_GUI_EVENTS

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

end
