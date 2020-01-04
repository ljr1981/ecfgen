note
	description: "ECF Generator Main GUI Controls & Events"
	purpose_and_design: "See end-of-class notes"
	ca_ignore: "CA023" -- unneeded parenthesis

deferred class
	EG_MAIN_GUI

inherit
	EG_MAIN_GUI_CONTROLS

	EG_MAIN_GUI_EVENTS

	EG_IMG_CONSTANTS

feature {NONE} -- Initialization

	create_gui_objects
			-- Creation of GUI objects (see Controls feature group)
		do
			create_objects
		end

	extend_gui_objects
			-- Extend GUI objects into Current as a containership tree
		do
			controls.system_grid_vbox.extend (controls.system_grid.Widget)

			controls.libraries_vbox.extend (controls.libraries_tools_hbox)
			controls.libraries_tools_hbox.extend (controls.libraries_filter_hbox)
			controls.libraries_tools_hbox.extend (controls.libraries_toobar)
			controls.libraries_vbox.extend (controls.library_list)

			controls.libraries_filter_hbox.extend (controls.libraries_filter_label)
			controls.libraries_filter_hbox.extend (controls.libraries_filter_cbox)
			controls.libraries_filter_hbox.extend (controls.libraries_filter_apply_btn)
			controls.libraries_filter_hbox.extend (controls.libraries_filter_remove_btn)

			controls.libraries_toobar.extend (controls.libraries_tool_refresh)

			controls.status_hbox.extend (controls.status_bar)
			controls.status_bar.extend (controls.status_vbox)
			controls.status_vbox.extend (controls.status_message)
			controls.status_vbox.extend (controls.status_progress_bar)

			System_panel (controls.system_grid_vbox).do_nothing
			Library_panel (controls.libraries_vbox).do_nothing
			Outputs_panel (controls.status_hbox).do_nothing

			Docking_manager.close_editor_place_holder
			Window.refresh_now
		end

	format_gui_objects
			-- Format GUI objects in terms of size and behavior
		local
			l_font: EV_FONT
			l_pref: FONT_PREFERENCE
		do
			controls.libraries_vbox.disable_item_expand (controls.libraries_tools_hbox)
			controls.libraries_tools_hbox.disable_item_expand (controls.libraries_filter_hbox)

			controls.libraries_filter_hbox.disable_item_expand (controls.libraries_filter_label)
			controls.libraries_filter_hbox.disable_item_expand (controls.libraries_filter_cbox)
			controls.libraries_filter_cbox.set_minimum_width (150)
			controls.libraries_filter_hbox.disable_item_expand (controls.libraries_filter_apply_btn)
			controls.libraries_filter_hbox.disable_item_expand (controls.libraries_filter_remove_btn)

			controls.libraries_tool_refresh.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (create {IMG_OPEN}.make))
			controls.libraries_tool_refresh.disable_sensitive

			controls.status_vbox.disable_item_expand (controls.status_progress_bar)

			controls.libraries_vbox.set_padding (3)
			controls.libraries_vbox.set_border_width (3)

			controls.libraries_filter_hbox.set_padding (3)
			controls.libraries_filter_hbox.set_border_width (3)

			create l_font.make_with_values ({EV_FONT}.Family_typewriter, {EV_FONT}.Weight_regular, {EV_FONT}.Shape_regular, 12)
			l_font.name.set ("CourierNew", 1, ("CourierNew").count)
			controls.status_message.set_font (l_font)
		end

	hookup_gui_objects_event_handlers
			-- Hook-up GUI object event handlers
		do
			controls.libraries_filter_apply_btn.select_actions.extend (agent Events.on_apply_filter)
			controls.libraries_filter_remove_btn.select_actions.extend (agent Events.on_remove_filter)
			controls.libraries_tool_refresh.select_actions.extend (agent events.on_library_node_refresh)
		end

	startup_operations
			--
		do
			controls.status_message.set_text ("Loading EiffelStudio libraries list ...")
			window.show
			window.refresh_now

			application.Estudio.set_progress_updater (create {EG_PROGRESS_UPDATER}.make (1, 100, 25, gui.status_progress_bar, controls.on_update_message_agent))
--			application.Estudio.Load_all_library_systems
			window.refresh_now

			add_library_list_node ("Filtered Libraries", Void, Void, img_filter)
			filter_node := last_root_node
			add_library_list_node ("EiffelStudio Libraries", application.Estudio.estudio_libs, agent Estudio.load_estudio_libs, img_libraries)
			add_library_list_node ("EIFFEL_SRC Libraries", application.Estudio.eiffel_src_libs, agent Estudio.load_eiffel_src_libs, img_eiffel_src)
			add_library_list_node ("GITHUB Libraries", application.Estudio.github_libs, agent Estudio.load_github_libs, img_github)
			add_library_list_node ("Contrib Libraries", application.Estudio.contrib_libs, agent Estudio.load_contrib_libs, img_stick_man_16)
			add_library_list_node ("IRON Libraries", application.Estudio.iron_libs, agent Estudio.load_iron_libs, img_vav_16)
			add_library_list_node ("Unstable Libraries", application.Estudio.unstable_libs, agent Estudio.load_unstable_libs, img_unstable)
			add_library_list_node ("Duplicate UUID Libraries", application.Estudio.duplicate_uuid_libraries, Void, img_duplicate)

			controls.status_message.append_text ("%N%NReady.")
			controls.status_message.scroll_to_end
			controls.update_progress_percent (0)
			window.refresh_now
		end

	add_library_list_node (a_node_name: STRING; a_lib_list: detachable HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]; a_populate_agent: detachable PROCEDURE; a_pixmap: detachable EV_PIXMAP)
			-- Make a root node for `a_node_name' and populate it with
			--	child-nodes from `a_lib_list' in alpha-order.
		local
			l_list: LIST [STRING]
		do
			if attached a_lib_list then
				check create_root_item: attached {EV_TREE_ITEM} (create {EV_TREE_ITEM}.make_with_text (a_node_name)) as al_root_node then
					if attached a_pixmap then
						al_root_node.set_pixmap (a_pixmap)
					end
					controls.library_list.extend (al_root_node)
					al_root_node.select_actions.extend (agent events.on_root_node_select (al_root_node, a_lib_list, a_populate_agent))
					populate_node (al_root_node, a_lib_list)
				end
			else -- no lib list
				check create_root_item: attached {EV_TREE_ITEM} (create {EV_TREE_ITEM}.make_with_text (a_node_name)) as al_root_node then
					al_root_node.disable_select
					if attached a_pixmap then
						al_root_node.set_pixmap (a_pixmap)
					end
					controls.library_list.extend (al_root_node)
					last_root_node := al_root_node
				end
			end
		end

feature {EG_MAIN_GUI_EVENTS} -- Initialization

	populate_node (a_root_node: EV_TREE_ITEM; a_lib_list: HASH_TABLE [ES_CONF_SYSTEM_REF, UUID])
			--
		local
			l_ordered_list: SORTED_TWO_WAY_LIST [STRING]
			l_list: LIST [STRING]
		do
			last_root_node := a_root_node
			if not a_lib_list.is_empty then
				create l_ordered_list.make
				across a_lib_list as ic loop
					l_ordered_list.force (ic.item.name + "|" + ic.item.configuration.uuid.out)
				end
				across
					l_ordered_list as ic_libs -- HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
				loop
					l_list := ic_libs.item.split ('|')
					check create_item: attached l_list [2] as al_uuid and then
						attached a_lib_list.item (create {UUID}.make_from_string (al_uuid)) as al_item and then
						attached {EV_TREE_ITEM} (create {EV_TREE_ITEM}.make_with_text (al_item.name)) as al_node
					then
						al_node.set_data (al_item)
						al_node.set_pixmap (img_library)
						a_root_node.extend (al_node)
						al_node.select_actions.extend (agent events.on_node_select (a_root_node.text.to_string_8, al_item))
					end
				end
			end
		end

feature {EG_MAIN_WINDOW, EG_MAIN_MENU, EG_MAIN_GUI_EVENTS} -- Implementation: References

	estudio: ES_INSTANCE
		once
			Result := application.Estudio
		end

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

	filter_node: detachable EV_TREE_ITEM
			-- Whatever node reference is operating as `filter_node'
			--	(where we reference filtered nodes from list)

	last_root_node: detachable EV_TREE_ITEM
			-- The `last_root_node' created by `add_library_list_node'


feature {EG_MAIN_WINDOW, EG_MAIN_MENU, EG_MAIN_GUI_EVENTS} -- Implementation: Docking

	docking_manager: SD_DOCKING_MANAGER
		once
			create Result.make (window, window)
		end

	system_panel (a_widget: EV_WIDGET): SD_CONTENT
		once
			Result := new_panel (a_widget, "System", "ECF <system>", {SD_ENUMERATION}.Left)
			Result.set_description ("Tree structure representing <system> XML for an ECF")
			Result.set_pixel_buffer (create {IMG_PRETTY_XML_TOOL_BAR}.make)
		end

	library_panel (a_widget: EV_WIDGET): SD_CONTENT
		once
			Result := new_panel (a_widget, "Libraries", "Available libraries", {SD_ENUMERATION}.Right)
			Result.set_description ("Available libraries detected on your local drive resources")
		end

	outputs_panel (a_widget: EV_WIDGET): SD_CONTENT
		once
			Result := new_panel (a_widget, "Outputs", "Application outputs", {SD_ENUMERATION}.Bottom)
			Result.set_description ("Access to application outputs")
		end

	new_panel (a_widget: EV_WIDGET; a_short_name, a_long_name: STRING; a_dir: INTEGER): SD_CONTENT
			--
		do
			create Result.make_with_widget (a_widget, a_short_name, docking_manager)
			Result.set_long_title (a_short_name)
			Result.set_short_title (a_long_name)
			docking_manager.contents.extend (Result)
			Result.set_top (a_dir)
			Result.focus_out_actions.extend (agent on_panel_focus_out)
		end

	on_panel_focus_out
		do
			controls.status_message.scroll_to_end
		end

;note
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
