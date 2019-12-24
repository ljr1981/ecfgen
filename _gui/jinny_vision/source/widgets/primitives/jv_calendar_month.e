note
	description: "[
		A GUI Calendar control based on either Today or some arbitrary date.
		]"
	synopsis: "[
		Current is a JV_CELL (EV_CELL descendent), which is designed to be extended
		into some form a window (e.g. EV_POPUP_WINDOW, EV_DIALOG, etc). This windowed
		container is then drawn on or near the date-field into which a date is being
		potentially set. The user may either double-click the date to set or ESC to
		clear the calendar window and leave the date-field unaffected.
		]"
	date: "$Date: 2016-01-29 23:41:32 -0500 (Fri, 29 Jan 2016) $"
	revision: "$Revision: 13111 $"

class
	JV_CALENDAR_MONTH

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

create
	make_with_date_field

feature {NONE} -- Initialization

	make_with_date_field (a_date_field: JV_DATE_FIELD; a_set_date_callback: like date_field_set_date_callback; a_destroy_callback: like destroy_callback)
			-- Initialize Current based on `a_date_field'.
		do
			date_field := a_date_field
			date_field_set_date_callback := a_set_date_callback
			destroy_callback := a_destroy_callback
			create root_date.make_now
			if root_date.date_valid_default (a_date_field.text) then
				root_date := create {DATE}.make_from_string_default (a_date_field.text)
			end
			default_create
		end

	create_interface_objects
			-- <Precursor>
		do
			create calendar
			create dates
			create selector_combos
			create day_name_labels
			create month_selector.make_with_strings (month_names)
			create year_selector.make_with_strings (ten_years)
			create week_1
			create week_2
			create week_3
			create week_4
			create week_5
			create week_6
			Precursor
		end

	initialize
			-- <Precursor>
		local
			l_month_name: STRING
			l_root_date: like root_date
			l_label_box: EV_HORIZONTAL_BOX
			l_label: EV_LABEL
		do
			Precursor
			extend (calendar)
				-- Current ::= Calendar
				--
				-- Calendar ::= Selector_combos, Day_name_labels, Dates
			calendar.extend (selector_combos)
			calendar.extend (day_name_labels)
			calendar.extend (dates)
			calendar.set_padding (4)
				-- Selector_combos ::= Month_selector, Year_selector, Date_selector
			selector_combos.extend (month_selector)
			selector_combos.extend (year_selector)
			month_selector.disable_edit
			year_selector.disable_edit
			year_selector.set_text (root_date.year.out)
			selector_combos.set_padding (4)
				-- Dates ::= Week_1  ... 6
			create l_label_box
			create l_label.make_with_text ("Sun")
			l_label.set_foreground_color (dim_gray)
			l_label.set_minimum_size (30, 30)
			l_label_box.extend (l_label)
			create l_label.make_with_text ("Mon")
			l_label.set_minimum_size (30, 30)
			l_label_box.extend (l_label)
			create l_label.make_with_text ("Tue")
			l_label.set_minimum_size (30, 30)
			l_label_box.extend (l_label)
			create l_label.make_with_text ("Wed")
			l_label.set_minimum_size (30, 30)
			l_label_box.extend (l_label)
			create l_label.make_with_text ("Thu")
			l_label.set_minimum_size (30, 30)
			l_label_box.extend (l_label)
			create l_label.make_with_text ("Fri")
			l_label.set_minimum_size (30, 30)
			l_label_box.extend (l_label)
			create l_label.make_with_text ("Sat")
			l_label.set_foreground_color (dim_gray)
			l_label.set_minimum_size (30, 30)
			l_label_box.extend (l_label)
			dates.extend (l_label_box)
				-- Build data up from `root_date' ...
			create l_root_date.make (root_date.year, root_date.month, 1)
			dates.extend (week_1)
			dates.extend (week_2)
			dates.extend (week_3)
			dates.extend (week_4)
			dates.extend (week_5)
			dates.extend (week_6)
				-- Event handling
			month_selector.select_actions.extend (agent on_month_selection)
			year_selector.select_actions.extend (agent on_year_selection)
				-- Load data
			set_calendar_content (root_date)
		end

feature -- Access

	month_name: STRING
			-- Currently selected month name.
		do
			Result := month_selector.text
		end

	year_name: STRING
			-- Currently selected year name.
		do
			Result := year_selector.text
		end

feature {NONE} -- Implementation: Event Handling

	on_month_selection
			-- Reset `root_date' and `set_calendar_content' `on_month_selection'.
		do
			set_calendar_content (calculated_calendar_root_date)
			root_date := calculated_calendar_root_date
		end

	on_year_selection
			-- Reset `root_date' and `set_calendar_content' `on_year_selection'.
		do
			set_calendar_content (calculated_calendar_root_date)
			root_date := calculated_calendar_root_date
		end

feature {NONE} -- Implementation

	calculated_calendar_root_date: DATE
			-- Root date for calendar based on month and year, but always the 1st.
		local
			l_month: INTEGER
		do
			if month_selector.text.same_string (month_selector.i_th (1).text) then
				l_month := 1
			elseif month_selector.text.same_string (month_selector.i_th (2).text) then
				l_month := 2
			elseif month_selector.text.same_string (month_selector.i_th (3).text) then
				l_month := 3
			elseif month_selector.text.same_string (month_selector.i_th (4).text) then
				l_month := 4
			elseif month_selector.text.same_string (month_selector.i_th (5).text) then
				l_month := 5
			elseif month_selector.text.same_string (month_selector.i_th (6).text) then
				l_month := 6
			elseif month_selector.text.same_string (month_selector.i_th (7).text) then
				l_month := 7
			elseif month_selector.text.same_string (month_selector.i_th (8).text) then
				l_month := 8
			elseif month_selector.text.same_string (month_selector.i_th (9).text) then
				l_month := 9
			elseif month_selector.text.same_string (month_selector.i_th (10).text) then
				l_month := 10
			elseif month_selector.text.same_string (month_selector.i_th (11).text) then
				l_month := 11
			elseif month_selector.text.same_string (month_selector.i_th (12).text) then
				l_month := 12
			end
			create Result.make (year_selector.text.to_integer_32, l_month, 1)
		end

	date_field: JV_DATE_FIELD
			-- `date_field' being serviced by Current.

	root_date: DATE
			-- Current date as originally derived from `date_field'.

	date_field_set_date_callback: PROCEDURE [ANY, TUPLE [DATE]]
			-- Callback for setting date, if set.

	destroy_callback: PROCEDURE [ANY, TUPLE]
		-- Callback used to destroy the windowed container of Current after the user has selected a date.

feature {NONE} -- Implementation: Basic Operations

	set_calendar_content (a_date: DATE)
			-- Set calendar content based on `a_date'.
		note
			warning: "[
				The block of code below commented with "SEE WARNING NOTE!" corresponds to this warning:

				NOTE: This knowledge comes from examining assembly code that is emitted from a C compiler.

				You must never attempt to edit (update or change) a string which is a "Manifest". In
				this case: root_date.long_months_text [a_date.month]

				Doing so causes a 'ptr' to contain an address pointing into the instruction space, because
				the bytes "manifest string" are stored in program space. You can READ from it endlessly,
				but not write.

				PC CPU's, when they are in the mode of running a user program (as opposed to running
				an Operating System task), have MEMORY MAPS about where "code" is and where "variable RAM"
				is, and if anything tries to execute a CPU instruction that writes into the "code" block,
				it generates a CPU exception (seg-fault).

				EXAMPLE:
				========

				my_string: STRING = "something_in_string"
				...
				my_string.to_lower
				...
				my_string [1].to_upper

				The above code will cause a write into restricted memory and a seg-fault.

				SOLUTION:
				=========

				Create a copy of the manifest string and then manipulate that string. See code below.
				]"
			EIS: "name=c_ptr_issue", "protocol=URI", "tag=warning",
					"src=http://stackoverflow.com/questions/25909130/segmentation-fault-while-using-tolower-on-dynamic-arrays"
			EIS: "name=c_ptr_issue", "protocol=URI", "tag=warning",
					"src=http://stackoverflow.com/questions/26786951/how-to-convert-a-string-char-to-upper-or-lower-case-in-c"
		local
			l_root_date: DATE
			l_month_name,
			l_new_name: STRING
		do
			create l_root_date.make (a_date.year, a_date.month, 1)
			check same_month: l_root_date.month = a_date.month end
			check same_year: l_root_date.year = a_date.year end
			check first_day: l_root_date.day = 1 end
			week_1.set_start (l_root_date, date_field, destroy_callback)
			week_2.set_start (l_root_date, date_field, destroy_callback)
			week_3.set_start (l_root_date, date_field, destroy_callback)
			week_4.set_start (l_root_date, date_field, destroy_callback)
			week_5.set_start (l_root_date, date_field, destroy_callback)
			if l_root_date.month = a_date.month then
				week_6.show
				week_6.set_start (l_root_date, date_field, destroy_callback)
			else
				week_6.hide
			end
				-- Set Month Name
				--| SEE WARNING NOTE!
			create l_month_name.make_from_string (root_date.long_months_text [a_date.month])
			l_month_name.to_lower
			l_new_name := l_month_name [1].out
			l_new_name.to_upper
			l_new_name.append (l_month_name.substring (2, l_month_name.count))
			month_selector.set_text (l_new_name)

				-- Set Year Name
			year_selector.set_text (a_date.year.out)
		end

feature {NONE} -- Implementation: Constants

	month_names: ARRAY [STRING]
			-- Names of months
		do
			Result := <<"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December">>
		end

feature {TEST_SET_BRIDGE} -- Implementation: GUI Elements

	calendar,
	dates: EV_VERTICAL_BOX

	selector_combos,
	day_name_labels: EV_HORIZONTAL_BOX

	month_selector,
	year_selector: EV_COMBO_BOX

	week_1,
	week_2,
	week_3,
	week_4,
	week_5,
	week_6: JV_CALENDAR_WEEK
			-- A GUI representation of 6 weeks (Sun-Sat) on a standard monthly calendar.
		note
			synopsis: "[
				The standard calendar typically has 5 or 6 week control sets in it. The
				real calendar has 4+ (generally). Because the days do not always start
				on Sunday, nor end precisely on Saturday, there is overlap in the display
				of the prior and next months "day dates". However, there are never more
				than 6 weeks required to display any one month in the year.
				]"
		attribute
			create Result
		end

	ten_years: ARRAY [STRING]
			-- A calculated list of years going from current year and back 10 (e.g. 2015 to 2005).
		local
			l_temp: ARRAYED_LIST [STRING]
			l_year: INTEGER
			l_date: DATE
		attribute
			create l_temp.make (10)
			create l_date.make_now
			l_year := l_date.year
			l_temp.force (l_year.out)
			across 1 |..| 10 as ic loop
				l_year := l_year - 1
				l_temp.force (l_year.out)
			end
			Result := l_temp.to_array
		end

end
