note
	description: "[
		Representation of a weeks worth of "day-widgets"
		]"
	date: "$Date: 2015-07-31 13:32:40 -0400 (Fri, 31 Jul 2015) $"
	revision: "$Revision: 11897 $"

class
	JV_CALENDAR_WEEK

inherit
	JV_CELL
		redefine
			create_interface_objects,
			initialize
		end

	JV_STOCK_COLORS
		undefine
			default_create,
			copy
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- <Precursor>
		do
			create day_controls
			create sunday
			create monday
			create tuesday
			create wednesday
			create thursday
			create friday
			create saturday
			Precursor
		end

	initialize
			-- <Precursor>
		do
			extend (day_controls)
			day_controls.extend (sunday)
			day_controls.extend (monday)
			day_controls.extend (tuesday)
			day_controls.extend (wednesday)
			day_controls.extend (thursday)
			day_controls.extend (friday)
			day_controls.extend (saturday)
				-- Sizing
			sunday.set_minimum_size (30, 30)
			monday.set_minimum_size (30, 30)
			tuesday.set_minimum_size (30, 30)
			wednesday.set_minimum_size (30, 30)
			thursday.set_minimum_size (30, 30)
			friday.set_minimum_size (30, 30)
			saturday.set_minimum_size (30, 30)
				-- Padding
			day_controls.set_padding (4)
			Precursor
		end

feature -- Access

	day_controls: EV_HORIZONTAL_BOX
		-- Collection for Calendar controls for display days in a week.

	sunday,
	monday,
	tuesday,
	wednesday,
	thursday,
	friday,
	saturday: EV_BUTTON
		-- Calendar_buttons

feature -- Basic Operations

	set_start (a_date: DATE; a_field: JV_DATE_FIELD; a_destroy_callback: PROCEDURE [ANY, TUPLE])
			-- Set as "start" week based on `a_date' for `a_field' with `a_destroy_callback'.
		note
			synopsis: "[
				The controls are always Sunday to Saturday (7 each from left to right). We start with
				the day-of-the-week, as represented in `a_date' and go from there to the end of the
				week (e.g. 7 or Saturday). For each day, we set the day-of-the-month number into the
				`text' of the GUI control (e.g. button) and the double-click actions of the control.
				On-double-click will set the `a_date' value into the `a_field' and then call the
				`a_destroy_callback', which closes (presumably) the entire month calendar control/window.
				]"
		local
			l_is_today: BOOLEAN
		do
			sunday.set_text ("")
			sunday.pointer_button_press_actions.wipe_out
			monday.set_text ("")
			monday.pointer_button_press_actions.wipe_out
			tuesday.set_text ("")
			tuesday.pointer_button_press_actions.wipe_out
			wednesday.set_text ("")
			wednesday.pointer_button_press_actions.wipe_out
			thursday.set_text ("")
			thursday.pointer_button_press_actions.wipe_out
			friday.set_text ("")
			friday.pointer_button_press_actions.wipe_out
			saturday.set_text ("")
			saturday.pointer_button_press_actions.wipe_out

			across a_date.day_of_the_week |..| 7 as ic loop
			l_is_today := a_date ~ create {DATE}.make_now
				inspect
					ic.item
				when 1 then
					sunday.set_text (a_date.day.out)
					sunday.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?, a_date.twin, a_field, a_destroy_callback))
					if l_is_today then
						sunday.set_foreground_color (blue)
					else
						sunday.set_foreground_color (dim_gray)
					end
				when 2 then
					monday.set_text (a_date.day.out)
					monday.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?, a_date.twin, a_field, a_destroy_callback))
					if l_is_today then
						monday.set_foreground_color (blue)
					else
						monday.set_foreground_color (black)
					end
				when 3 then
					tuesday.set_text (a_date.day.out)
					tuesday.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?, a_date.twin, a_field, a_destroy_callback))
					if l_is_today then
						tuesday.set_foreground_color (blue)
					else
						tuesday.set_foreground_color (black)
					end
				when 4 then
					wednesday.set_text (a_date.day.out)
					wednesday.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?, a_date.twin, a_field, a_destroy_callback))
					if l_is_today then
						wednesday.set_foreground_color (blue)
					else
						wednesday.set_foreground_color (black)
					end
				when 5 then
					thursday.set_text (a_date.day.out)
					thursday.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?, a_date.twin, a_field, a_destroy_callback))
					if l_is_today then
						thursday.set_foreground_color (blue)
					else
						thursday.set_foreground_color (black)
					end
				when 6 then
					friday.set_text (a_date.day.out)
					friday.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?, a_date.twin, a_field, a_destroy_callback))
					if l_is_today then
						friday.set_foreground_color (blue)
					else
						friday.set_foreground_color (black)
					end
				when 7 then
					saturday.set_text (a_date.day.out)
					saturday.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?, a_date.twin, a_field, a_destroy_callback))
					if l_is_today then
						saturday.set_foreground_color (blue)
					else
						saturday.set_foreground_color (dim_gray)
					end
				else
					check invalid_day_number: False end
				end
				a_date.day_forth
			end
		end

	on_click (a_x: INTEGER_32; a_y: INTEGER_32; a_button: INTEGER_32; a_x_tilt: REAL_64; a_y_tilt: REAL_64; a_pressure: REAL_64; a_screen_x: INTEGER_32; a_screen_y: INTEGER_32; a_date: DATE; a_field: JV_DATE_FIELD; a_destroy_callback: PROCEDURE [ANY, TUPLE])
			-- What happens on pointer click of date button--set the date and field text and then destroy the calendar.
		do
			a_field.set_date (a_date)
			a_field.set_text (a_date.out)
			a_destroy_callback.call (Void)
		end

end
