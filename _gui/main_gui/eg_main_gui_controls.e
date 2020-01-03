note
	description: "Isolation of Main GUI Controls and their creations"
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_GUI_CONTROLS

inherit
	EG_ANY

feature {NONE} -- Initialization

	create_objects
			--<Precursor>
		do
			create main_vbox

			create system_grid
			create system_grid_vbox

			create libraries_vbox

			create library_list
			create libraries_tools_hbox

			create libraries_filter_hbox
			create libraries_filter_label.make_with_text ("Filter: ")
			create libraries_filter_cbox
			create libraries_filter_apply_btn.make_with_text ("Apply")
			create libraries_filter_remove_btn.make_with_text ("Remove")

			create libraries_toobar
			create libraries_tool_refresh

			create status_hbox
			create status_vbox
			create status_bar
			create status_message
			create status_progress_bar
		end

feature {EG_MAIN_GUI, EG_MAIN_MENU, EG_MAIN_GUI_EVENTS} -- GUI Objects

	main_vbox: EV_VERTICAL_BOX

	system_grid_vbox: EV_VERTICAL_BOX

	libraries_vbox: EV_VERTICAL_BOX
	libraries_tools_hbox: EV_HORIZONTAL_BOX

	libraries_filter_hbox: EV_HORIZONTAL_BOX
	libraries_filter_label: EV_LABEL
	libraries_filter_cbox: EV_COMBO_BOX
	libraries_filter_apply_btn: EV_BUTTON
	libraries_filter_remove_btn: EV_BUTTON

	libraries_toobar: EV_TOOL_BAR
	libraries_tool_refresh: EV_TOOL_BAR_BUTTON

	system_grid: EG_SYSTEM_WIDGET

	library_list: EV_CHECKABLE_TREE

	status_hbox: EV_HORIZONTAL_BOX
	status_vbox: EV_VERTICAL_BOX
	status_bar: EV_STATUS_BAR

	status_message: EV_RICH_TEXT
	status_progress_bar: EV_HORIZONTAL_PROGRESS_BAR

feature {EG_MAIN_GUI, EG_MAIN_MENU, EG_MAIN_GUI_EVENTS} -- Update Operations

	on_update_message_agent: PROCEDURE [STRING_32]
		do
			Result := agent update_status_message
		end

	on_update_progress_agent: PROCEDURE [INTEGER]
		do
			Result := agent update_progress_percent
		end

	update_status_message (a_message: STRING_32)
		local
			l_list: LIST [STRING_32]
		do
			if not a_message.is_empty then
				l_list := a_message.split ('%N')
				status_message.append_text (l_list [l_list.count])
				status_message.append_text ("%N")
				status_message.scroll_to_end
				status_message.refresh_now
			end
		end

	update_progress_percent (a_value: INTEGER)
		require
			one_to_hundred: (0 |..| 100).has (a_value)
		do
			status_progress_bar.set_value (a_value)
			status_progress_bar.refresh_now
		end

feature {EG_MAIN_WINDOW} -- References

	gui: EG_MAIN_GUI
			-- Reference to Main GUI.
		deferred
		end

	controls: EG_MAIN_GUI_CONTROLS once Result := Current end
			-- Reference to GUI Controls.

	events: EG_MAIN_GUI_EVENTS
			-- Reference to GUI Control Events.
		deferred
		end

note
	purpose: "[

		]"
	design: "[

		]"

end
