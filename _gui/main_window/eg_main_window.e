note
	description: "ECF Generator Wizard App Main Window"
	purpose_and_design: "See end-of-class notes"

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

	EG_PREFS
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
			preferences.initialize_standard_preferences
			initialize_startup_preferences

				--| GUI Objects
			extend_gui_objects
			format_gui_objects
			hookup_gui_objects_event_handlers
			startup_operations
		end

feature {NONE} -- Implementation

	window: like Current
			--<Precursor>
		do
			Result := Current
		end

feature {EG_MAIN_MENU, EG_MAIN_GUI} -- Implementation: Preferences

	initialize_startup_preferences
			-- Initialize Current with startup preferences (sizing, color, etc.)
		do
			check has_preferences: attached preferences.standard as al_pref then
				--| display.fullscreen_at_startup
				check has_full_screen: attached {BOOLEAN_PREFERENCE} al_pref.get_preference ("display.fullscreen_at_startup") as al_full_screen then
					if al_full_screen.value then
						window.maximize
					else
						window.set_size (800, 600)
					end
				end
				--| display.background_color
				check has_background_color: attached {COLOR_PREFERENCE} al_pref.get_preference ("display.background_color") as al_background then
					window.main_box.set_background_color (al_background.value)
				end
				--| blacklist.blacklisted_ecfs
				check has_blacklist: attached {STRING_LIST_PREFERENCE} al_pref.get_preference ("blacklist.blacklisted_ecfs") as al_blacklist then
					across
						al_blacklist.value_as_array as ic
					loop
						application.estudio.other_blacklisters.force (ic.item.to_string_8)
					end
				end
				--| user_defined.list.paths
				check has_udf: attached {PATH_LIST_PREFERENCE} al_pref.get_preference ("user_defined.list.paths") as al_udf then
					across
						al_udf.value_as_array as ic
					loop
						application.estudio.udf_lib_directories.force (create {DIRECTORY}.make_with_path (ic.item))
					end
				end
			end
		end

;note
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
	design: "[
		PROBLEM: The Code Analyzer will complain if a class
			gets too long in terms of number of feature groups
			and number of features. (it also complains of long
			code in routines as well, but that's another story.)
		SOLUTION (POTENTIAL): By creating classes like EG_MAIN_MENU
			and EG_MAIN_GUI, I am attempting to not only
			solve the PROBLEM (above), but to give myself something
			I've not had before--namely--by having a reference feature,
			I am setting up the code to have qualified calls of the
			following structure:

			gui.controls.my_control.*

			gui.events.on_my_control_event (...)

			Whereas, normally I would isolate EV_ANY controls into a
			feature group called "feature -- Controls", I can now
			reference those as a qualified call, where the dot-call
			itself reveals the contextual call target. The same is
			true of the event. Previously, I would have used the
			prefix of "on_*" to visually inidicate a call to an event
			handler. I can now choose to not include the prefix because
			the qualified call itself reveals that the routine being
			called is an event handler.

		NOTE: So far, I have not used this design in the EG_MAIN_MENU
			class structure, because I thought of it first in the
			context of the gui.controls structure. For the moment,
			if one examines the EG_MAIN_MENU, you will see that the
			internal design of the class is based on the older design
			style of using feature groups to isolate related groups
			of features. This works fine, but shifts the chore of identifying
			the "type-of-feature" on to "prefix" and other naming conventions.
			The design of EG_MAIN_GUI with its isolation classes is an
			attempt to use qualified calls instead of feature groups.

		UNINTENDED-CONSEQUENCES: Whether one uses naming conventions or
			class-based qualified calls, one is left with the consquences
			of style. On the one hand, all of the features are parked in
			a single class in many (and large) feature groups. The class
			code can become huge and unwieldy when scrolling up and down
			looking for the right-group-right-feature. Some of this is
			mitigated by the Features-tool (see right of ES dev env window).

			On the other hand, one has the beauty of isolating like features
			in properly named, inherited, and referenced classes. The reference
			features used in qualified calls tells a great story of what
			the feature is and both its overall semantic purpose, but reveals
			why its being called when it is. Because of Pick-and-Drop, like
			the one-class-fits-all solution, we find easy access to the feature.
			Moreover, unlike the one-class-fits-all, we can more easily see
			and edit related features in various editor panes, instead of
			bouncing around a single class.
		]"

end
