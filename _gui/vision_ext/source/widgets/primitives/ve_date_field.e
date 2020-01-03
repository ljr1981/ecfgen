note
	description: "[
		Jinny Vision Date Field
		]"

class
	VE_DATE_FIELD

inherit
	EV_TEXT_FIELD
		redefine
			initialize
		end

	DATE_VALIDITY_CHECKER
		rename
			set_date as set_date_by_integers
		undefine
			default_create,
			copy
		end

	VE_ANY
		undefine
			copy,
			default_create
		end

create
	default_create,
	make_with_text,
	make_today,
	make_month_to_date,
	make_year_to_date,
	make_with_date

feature {NONE} -- Initialization

	make_with_date (a_date: DATE)
			-- Initialize Current with `a_date'.
		do
			make_with_text (a_date.out)
		end

	make_today
			-- Initialize Current with today's date.
		do
			make_with_text ((create {DATE}.make_now).out)
		ensure
			today: is_today
		end

	make_month_to_date
			-- Initialize Current with MTD.
		local
			l_date: DATE
		do
			create l_date.make_now
			l_date.month_back
			make_with_text (l_date.out)
		end

	make_year_to_date
			-- Initialize Current with YTD.
		local
			l_date: DATE
		do
			create l_date.make_now
			l_date.year_back
			make_with_text (l_date.out)
		end

	initialize
		do
			mouse_wheel_actions.extend (agent on_mouse_wheel)
			pointer_double_press_actions.extend (agent on_double_press)
			Precursor
		end

feature -- Access

	date: detachable DATE
			-- Date for Current.
		do
			if date_valid_default (text) then
				create Result.make_from_string_default (text)
			end
		end

feature -- Status Report

	is_today: BOOLEAN
			-- Is Current {VE_DATE_FIELD} set to `is_today'?
		do
			Result := text.same_string ((create {DATE}.make_now).out)
		end

feature -- Event Handling

	on_double_press (a_x: INTEGER_32; a_y: INTEGER_32; a_button: INTEGER_32; a_x_tilt: REAL_64; a_y_tilt: REAL_64; a_pressure: REAL_64; a_screen_x: INTEGER_32; a_screen_y: INTEGER_32)
			-- What happens on pointer double-click.
		local
			l_date: DATE
		do
			create l_date.make_now
			set_text (l_date.out)
		end

	on_mouse_wheel (a_value: INTEGER_32)
			-- What happens when user spins mouse wheel up or down.
		local
			l_increase: BOOLEAN
			l_on_month,
			l_on_year,
			l_on_day: BOOLEAN
			l_start_date, l_date: DATE
			l_list: LIST [STRING_32]
			l_location: INTEGER_32
		do
			l_increase := (a_value > 0)
			create l_date.make_now
			l_list := text.split ('/')
			if not text.is_empty and across l_list as ic_items all ic_items.item.is_integer end then
				if l_date.is_correct_date (l_list [3].to_integer, l_list [1].to_integer, l_list [2].to_integer) then
					create l_date.make_from_string_default (text)
					l_start_date := l_date.twin
					l_on_month := (<<1,2>>).has (start_selection)
					l_on_day := (<<3,4,5>>).has (start_selection)
					l_on_year := (<<6,7,8,9,10>>).has (start_selection)
					l_location := start_selection.twin
					if l_on_month and l_increase then
						l_date.month_forth
					elseif l_on_month and not l_increase then
						l_date.month_back
					elseif l_on_year and l_increase then
						l_date.year_forth
					elseif l_on_year and not l_increase then
						l_date.year_back
					elseif l_on_day and l_increase then
						l_date.day_forth
					elseif l_on_day and not l_increase then
						l_date.day_back
					end
					if (l_increase and l_date > l_start_date and l_date.year < 10000) or (not l_increase and l_date < l_start_date) then
						set_text (l_date.out)
						set_selection (l_location, l_location)
					end
				end
			end
		end

feature -- Settings

	set_date (a_date: DATE)
			-- Set `a_date' into Current `text'
		do
			set_text (a_date.out)
		end

end
