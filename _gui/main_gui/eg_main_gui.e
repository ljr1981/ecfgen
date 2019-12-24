note
	description: "ECF Generator Main GUI Controls & Events"
	purpose_and_design: "See end-of-class notes"

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
			main_box.extend (controls.system_grid.widget)

			window.extend (main_box)
		end

	format_gui_objects
			-- Format GUI objects in terms of size and behavior
		do
			main_box.set_padding (3)
			main_box.set_border_width (3)
		end

	hookup_gui_objects_event_handlers
			-- Hook-up GUI object event handlers
		do

		end

feature {EG_MAIN_WINDOW, EG_MAIN_MENU} -- Implementation: References

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

note
	purpose: "[
		This class is a container for both control objects,
		their events, and their interactions. It provides
		reference features to both the window container and
		the menu for qualified calls from GUI controls and
		event code.
		]"
	design: "[
		PROBLEM: The Code Analyzer will complain if a class
			gets too long in terms of number of feature groups
			and number of features. (it also complains of long
			code in routines as well, but that's another story.)
		SOLUTION (POTENTIAL): By creating classes like EG_MAIN_GUI_CONTROLS
			and EG_MAIN_GUI_EVENTS, I am attempting to not only
			solve the PROBLEM (above), but to give myself something
			I've not had before--namely--by having a reference feature,
			I am setting up the code to have qualified calls of the
			following structure:
			
			controls.my_control.*
			
			events.on_my_control_event (...)
			
			Whereas, normally I would isolate EV_ANY controls into a
			feature group called "feature -- Controls", I can now
			reference those as a qualified call, where the dot-call
			itself reveals the contextual call target. The same is
			true of the event. Previously, I would have used the
			prefix of "on_*" to visuall inidicate a call to an event
			handler. I can now choose to not include the prefix because
			the qualified call itself reveals that the routine being
			called is an event handler.
		]"

end
