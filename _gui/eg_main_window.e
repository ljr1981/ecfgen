note
	description: "ECG Generator Wizard App Main Window"

class
	EG_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize
		end

create
	make_with_title

feature {NONE} -- Initialization

	create_interface_objects
			--<Precursor>
		do
			Precursor
		end

	initialize
			--<Precursor>
			-- Mostly about extending, expanding, borders, and padding
			-- and then putting it all in `main_box'
		do
			Precursor {EV_TITLED_WINDOW}
		end

feature {EG_APPLICATION} -- Menu implementation

	standard_menu_bar: EV_MENU_BAR attribute create Result end -- Standard menu bar for this window.
	file_menu: EV_MENU attribute create Result end -- "File" menu for this window (contains Exit...)
	help_menu: EV_MENU attribute create Result end -- "Help" menu for this window (contains About...)

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
				-- File->Open
			create l_menu_item.make_with_text ("O&pen")
			l_menu_item.select_actions.extend (agent on_file_open_click)
			file_menu.extend (l_menu_item)
				-- File->Save
			create l_menu_item.make_with_text ("Save")
			l_menu_item.select_actions.extend (agent on_file_save_click)
			file_menu.extend (l_menu_item)
				-- File->Close
			create l_menu_item.make_with_text ("Close")
			l_menu_item.select_actions.extend (agent on_file_close_click)
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

			set_menu_bar (standard_menu_bar)
		ensure
			menu_bar_created: attached standard_menu_bar and then
								not standard_menu_bar.is_empty
		end

feature -- Menu Events

	on_file_open_click
		do

		end

	on_file_save_click
		do

		end

	on_file_close_click
		do

		end

	on_file_exit_click
		do
			destroy_and_exit_if_last
		end

	on_help_about_click
		do

		end

	on_help_documentation_click
		do

		end

end
