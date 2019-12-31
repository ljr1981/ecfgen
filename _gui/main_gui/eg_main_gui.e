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
			controls.status_bar.extend (controls.status_message)
			controls.status_bar.extend (controls.status_spacer)
			controls.status_bar.extend (controls.status_progress_bar)

			main_box.extend (controls.system_grid.widget)
			main_box.extend (controls.status_bar)

			window.extend (main_box)
		end

	format_gui_objects
			-- Format GUI objects in terms of size and behavior
		do
			controls.status_bar.disable_item_expand (controls.status_message)
			controls.status_bar.disable_item_expand (controls.status_progress_bar)
			controls.status_progress_bar.set_minimum_width (100)

			main_box.set_padding (3)
			main_box.set_border_width (3)
			main_box.disable_item_expand (controls.status_bar)
		end

	hookup_gui_objects_event_handlers
			-- Hook-up GUI object event handlers
		do

		end

	startup_operations
			--
		do
			controls.status_message.set_text ("Loading EiffelStudio libraries list ...")
			window.show
			window.refresh_now

			application.Estudio.set_progress_updater (create {EG_PROGRESS_UPDATER}.make (1, 25, 5, gui.status_progress_bar, controls.on_update_message_agent))
			application.Estudio.Load_estudio_libs (application.Estudio.estudio_libs)
			window.refresh_now

			application.Estudio.progress_updater_attached.reset (26, 50, 100)
			application.Estudio.Load_eiffel_src_libs (application.Estudio.eiffel_src_libs)
			window.refresh_now

			application.Estudio.progress_updater_attached.reset (51, 75, 100)
			application.Estudio.Load_github_libs (application.Estudio.github_libs)
			window.refresh_now

			controls.status_message.set_text ("Ready.")
			controls.update_progress_percent (0)
			window.refresh_now
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
