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

inherit
	EG_MAIN_GUI_CONTROLS

	EG_MAIN_GUI_EVENTS

feature {NONE} -- Initialization

	create_gui_objects
			-- Creation of GUI objects (see Controls feature group)
		do
			create_objects
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

feature {NONE} -- Controls: New



feature {NONE} -- Events



feature {NONE} -- Implementation: References

	window: EG_MAIN_WINDOW
			--<Precursor>
		deferred
		end

	menu: EG_MAIN_MENU
			--<Precursor>
		deferred
		end

	gui: EG_MAIN_GUI once Result := Current end
			-- Reference to Current GUI.

end
