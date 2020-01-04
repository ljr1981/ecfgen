note
	description: "ECF Generator Main Menu"
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_MENU

inherit
	EG_ANY

feature {NONE} -- Menu implementation

	standard_menu_bar: EV_MENU_BAR once create Result end 				-- Standard menu bar for main window.
	file_menu: EV_MENU once create Result.make_with_text ("File") end 	-- "File" menu for this window (contains Exit...)
	help_menu: EV_MENU once create Result.make_with_text ("Help") end 	-- "Help" menu for this window (contains About...)

feature {EG_APPLICATION} -- Menu implementation

	build_menu_bar
			-- Create and populate standard_menu_bar.
		local
			l_menu_item: EV_MENU_ITEM
		do
				-- File Menu
			standard_menu_bar.extend (file_menu)

				-- File->New
			create l_menu_item.make_with_text ("&New ...")
			l_menu_item.select_actions.extend (agent on_file_new_click)
			file_menu.extend (l_menu_item)
				-- File->Open
			create l_menu_item.make_with_text ("O&pen ...")
			l_menu_item.select_actions.extend (agent on_file_open_click)
			file_menu.extend (l_menu_item)
				-- File->Save
			create l_menu_item.make_with_text ("Save ...")
			l_menu_item.select_actions.extend (agent on_file_save_click)
			file_menu.extend (l_menu_item)
				-- File->Save-as
			create l_menu_item.make_with_text ("Save as ...")
			l_menu_item.select_actions.extend (agent on_file_save_as_click)
			file_menu.extend (l_menu_item)
				-- File->Close
			create l_menu_item.make_with_text ("Close")
			l_menu_item.select_actions.extend (agent on_file_close_click)
			file_menu.extend (l_menu_item)
				-- File->Preferences
			create l_menu_item.make_with_text ("Preferences ...")
			l_menu_item.select_actions.extend (agent on_file_preferences_click)
			file_menu.extend (l_menu_item)
				-- File->Exit
			create l_menu_item.make_with_text ("E&xit")
			l_menu_item.select_actions.extend (agent on_file_exit_click)
			file_menu.extend (l_menu_item)

				-- Help Menu
			standard_menu_bar.extend (help_menu)
				-- Help->About
			create l_menu_item.make_with_text ("&About")
			l_menu_item.select_actions.extend (agent on_help_about_click)
			help_menu.extend (l_menu_item)
				-- Help->Documentation
			create l_menu_item.make_with_text ("&Documentation")
			l_menu_item.select_actions.extend (agent on_help_documentation_click)
			help_menu.extend (l_menu_item)

			window.set_menu_bar (standard_menu_bar)
		ensure
			menu_bar_created: attached standard_menu_bar and then
								not standard_menu_bar.is_empty
		end

feature {NONE} -- Menu Events

	on_file_new_click
		do
			Window.Gui.system_grid.new_system (Window)
			if attached Window.system_grid.item_internal then
				Window.Gui.system_grid.render
			end
		end

	on_file_open_click
			-- What happens with the user clicks File -> Open?
		local
			l_dialog: EV_FILE_OPEN_DIALOG
			l_file: PLAIN_TEXT_FILE
			l_factory: CONF_PARSE_FACTORY
			l_loader: CONF_LOAD
			l_ref: ES_CONF_SYSTEM_REF
		do
			create l_dialog.make_with_title ("Open ECF ...")
			l_dialog.show_modal_to_window (window)
			if not l_dialog.file_name.is_empty then
				create l_factory
				create l_loader.make (l_factory)
				l_loader.retrieve_configuration (l_dialog.file_name)
				if attached {CONF_SYSTEM} l_loader.last_system as al_system then
					create l_ref.make (al_system)
				end
			end
		end

	on_file_save_click
			-- What happens with the user clicks File -> Save?
		do

		end

	on_file_save_as_click
			-- What happens with the user clicks File -> Save-as?
		do

		end

	on_file_preferences_click
			-- What happens with the user clicks File -> Preferences?
		do
			window.preferences.show_modal_to (window)
			window.initialize_startup_preferences
		end

	on_file_close_click
			-- What happens with the user clicks File -> Close?
		do

		end

	on_file_exit_click
			-- What happens with the user clicks File -> Exit?
		do
			window.destroy_and_exit_if_last
		end

	on_help_about_click
			-- What happens with the user clicks File -> Help -> About?
		do

		end

	on_help_documentation_click
			-- What happens with the user clicks File -> Help -> Documentation?
		do

		end

feature {NONE} -- Implementation: References

	window: EG_MAIN_WINDOW
			-- Reference to Current main `window'.
		deferred
		end

	menu: EG_MAIN_MENU once Result := Current end
			-- Reference to Current Menu.

--	gui: EG_MAIN_GUI
--			-- Reference to `window' `gui'.
--		deferred
--		end

note
	purpose: "[
		This class is all things "menu", including
		menu controls, menu event handlers, and interactions
		between them. It also includes reference features
		to the main window and GUI for interactions between
		the menu and those objects.
		]"
	design: "[

		]"


end
