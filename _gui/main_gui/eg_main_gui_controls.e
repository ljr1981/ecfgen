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
			create main_box
			create system_grid
			create status_bar
			create status_message
			create status_spacer
			create status_progress_bar
		end

feature {EG_MAIN_GUI, EG_MAIN_MENU} -- GUI Objects

	main_box: EV_VERTICAL_BOX

	system_grid: EG_SYSTEM_WIDGET

	status_bar: EV_STATUS_BAR

	status_message: EV_LABEL
	status_spacer: EV_CELL
	status_progress_bar: EV_HORIZONTAL_PROGRESS_BAR

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
				status_message.set_text (l_list [l_list.count])
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

feature {NONE} -- References

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