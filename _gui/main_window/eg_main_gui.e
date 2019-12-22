note
	description: "ECF Generator Main GUI Controls & Events"
	purpose: "[
		This class is a container for both control objects,
		their events, and their interactions. It provides
		reference features to both the window container and
		the menu for qualified calls from GUI controls and
		event code.
		]"

deferred class
	EG_MAIN_GUI

feature {NONE} -- Initialization

	create_gui_objects
			-- Creation of GUI objects (see Controls feature group)
		do

		end

	extend_gui_objects
			-- Extend GUI objects into Current as a containership tree
		do

		end

	format_gui_objects
			-- Format GUI objects in terms of size and behavior
		do

		end

	hookup_gui_objects_event_handlers
			-- Hook-up GUI object event handlers
		do

		end

feature {NONE} -- Controls



feature {NONE} -- Events



feature {NONE} -- Implementation: References

	window: EG_MAIN_WINDOW
			-- Reference to Current main `window'.
		deferred
		end

	menu: EG_MAIN_MENU
			-- Reference to `window' `menu'.
		deferred
		end

	gui: EG_MAIN_GUI once Result := Current end
			-- Reference to Current GUI.

end
