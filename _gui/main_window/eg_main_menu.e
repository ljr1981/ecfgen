note
	description: "ECF Generator Main Menu"
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_MENU

feature {NONE} -- Menu implementation

	standard_menu_bar: EV_MENU_BAR attribute create Result end 	-- Standard menu bar for this window.
	file_menu: EV_MENU attribute create Result end 				-- "File" menu for this window (contains Exit...)
	help_menu: EV_MENU attribute create Result end 				-- "Help" menu for this window (contains About...)

feature {EG_APPLICATION} -- Menu implementation

	build_menu_bar
			-- Create and populate standard_menu_bar.
		local
			l_menu_item: EV_MENU_ITEM
		do
				-- Create the menu bar.
			create standard_menu_bar

				-- File Menu
			create file_menu.make_with_text ("&File")
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
			create help_menu.make_with_text ("&Help")
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

		end

	on_file_open_click
		do

		end

	on_file_save_click
		do

		end

	on_file_save_as_click
		do

		end

	on_file_preferences_click
		do
			window.preferences.show_standard_preference_window
		end

	on_file_close_click
		do

		end

	on_file_exit_click
		do
			window.destroy_and_exit_if_last
		end

	on_help_about_click
		do

		end

	on_help_documentation_click
		do

		end

feature {NONE} -- Implementation: References

	window: EG_MAIN_WINDOW
			-- Reference to Current main `window'.
		deferred
		end

	menu: EG_MAIN_MENU once Result := Current end
			-- Reference to Current Menu.

	gui: EG_MAIN_GUI
			-- Reference to `window' `gui'.
		deferred
		end

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
