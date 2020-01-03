note
	description: "[
		Representation of a line graph.
		]"
	purpose: "[
		To handle the need for showing plottable information on a line chart.
		]"
	usage: "[
		Example:
				create instance of Current

			. optional - general settings
				line_graph.set_minimum_size (800, 600)
				line_graph.set_title ("My graph title")	-- title

			. required - set x axis information
				METHOD 1 - This method will have no x-series text displaying
				line_graph.set_x_axis_range ("1", "12")	-- lower, upper
				line_graph.set_x_axis_step ("1")		-- step interval
				-- OR --
				METHOD 2 - This method will set x-series text to the integer values within the range
				           This method will overwrite settings from Method 3
				line_graph.set_x_axis_range_and_step ("Quarters", "1", "12", "1") -- x-axis title, lower, upper, step
				-- OR --
				METHOD 3 - This method will set the x-series text to the strings within the arrayed list
				           This method will overwrite settings from Method 2
				create x_series_text.make_from_array (<<"2012 Q1", "2012 Q2", "2012 Q3", "2012 Q4", "2013 Q1", "2013 Q2", "2013 Q3", "2013 Q4", "2014 Q1", "2014 Q2", "2014 Q3", "2014 Q4">>)
				line_graph.set_x_series_text ("Quarters", x_series_text)

			. required - set y axis information
				line_graph.set_y_axis_title ("Sales")	-- y-axis title
				line_graph.set_y_axis_range ("0", "500")	-- lower, upper
				line_graph.set_y_axis_step ("100")		-- step interval
				-- OR --
				line_graph.set_y_axis_range_and_step ("Sales", "0", "500", "100"0)	-- y-axis title, lower, upper, step

			. required - add data series
				METHOD 1 - Create a data series set and pass that in to add_data_series_set
				create data_series_set.make (5)
				data_series_set.extend ([<< "78.00", "100.00", "150.00", "200.00", "160.00", "200.00", "100.00", "247.00", "300.00", "263.00", "300.00", "250.00">>, (create {JV_STOCK_COLORS}).moccasin,   "ATL Jinny"])
				data_series_set.extend ([<<"400.00", "450.00", "380.00", "360.00", "385.00", "400.00", "415.00", "480.00", "500.00", "400.00", "420.00", "470.00">>, (create {JV_STOCK_COLORS}).dark_green, "CHI JBS"])
				data_series_set.extend ([<<"380.00", "400.00", "400.00", "380.00", "412.00", "448.00", "371.00", "400.00", "452.00", "470.00", "500.00", "400.00">>, (create {JV_STOCK_COLORS}).orange,     "MIA Jinny"])
				data_series_set.extend ([<<  "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00">>, (create {JV_STOCK_COLORS}).coral,      "MIA JBS"])
				data_series_set.extend ([<<"410.00", "500.00", "380.00", "300.00", "280.00", "300.00", "460.00", "420.00", "380.00", "300.00", "400.00", "500.00">>, (create {JV_STOCK_COLORS}).indian_red, "HOU Jinny"])
				line_graph.add_data_series_set (data_series_set)
				-- OR --
				METHOD 2 - Call add_data_series and pass in a data series each time
				line_graph.add_data_series ([<< "78.00", "100.00", "150.00", "200.00", "160.00", "200.00", "100.00", "247.00", "300.00", "263.00", "300.00", "250.00">>, (create {JV_STOCK_COLORS}).moccasin,   "ATL Jinny"])
				line_graph.add_data_series ([<<"400.00", "450.00", "380.00", "360.00", "385.00", "400.00", "415.00", "480.00", "500.00", "400.00", "420.00", "470.00">>, (create {JV_STOCK_COLORS}).dark_green, "CHI JBS"])
				line_graph.add_data_series ([<<"380.00", "400.00", "400.00", "380.00", "412.00", "448.00", "371.00", "400.00", "452.00", "470.00", "500.00", "400.00">>, (create {JV_STOCK_COLORS}).orange,     "MIA Jinny"])
				line_graph.add_data_series ([<<  "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00",   "0.00">>, (create {JV_STOCK_COLORS}).coral,      "MIA JBS"])
				line_graph.add_data_series ([<<"410.00", "500.00", "380.00", "300.00", "280.00", "300.00", "460.00", "420.00", "380.00", "300.00", "400.00", "500.00">>, (create {JV_STOCK_COLORS}).indian_red, "HOU Jinny"])

			. required
				line_graph.draw
			. extend Current's drawing area into the parent container
				my_parent_container.extend (line_graph.drawing_area)
			. Hook drawing the line graph to its parent container's resize actions
				my_parent_container.resize_actions.extend (agent draw_line_graph)
			. example of draw_line_graph routine:
				draw_line_graph (a_x, a_y, a_width, a_height: INTEGER)
						-- Draw `line_graph'.
					do
						line_graph.draw
					end
		]"

class
	JV_LINE_GRAPH

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			dot_label_skip := 1
			create_interface_objects
			initialize
		end

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
		do
			create drawing_area
			create graph_area
			create graph_title_area
			create x_axis_title_area
			create y_axis_title_area
			create data_area
			create x_axis_scale_area
			create y_axis_scale_area
			create plot_area
			create legend_area
			create x_axis_lower
			create x_axis_upper
			create x_axis_step
			create y_axis_lower
			create y_axis_upper
			create y_axis_step

			create internal_data.make (50)
			create x_series_text.make (0)
		end

	initialize
			-- Perform additional setup tasks.
		do
			drawing_area.set_line_width (default_line_width)
			drawing_area.expose_actions.force_extend (agent draw)
			text_padding := default_text_padding
			font_height_padding := default_font_height_padding
		end

feature -- Access

	title: detachable STRING
			-- Title for Current

	x_axis_title: detachable STRING
			-- Title for x-axis area

	x_axis_lower, x_axis_upper: like value_anchor
			-- Lower and upper bounds for x-axis

	x_axis_step: like value_anchor
			-- Size of distance between values in x-axis range

	y_axis_title: detachable STRING
			-- Title for y-axis area

	y_axis_lower, y_axis_upper: like value_anchor
			-- Lower and upper bounds for y-axis

	y_axis_step: like value_anchor
			-- Size of distance between values in y-axis range

	drawing_area: JV_DRAWING_AREA
			-- Area on which graph data is drawn.

	font_height_padding: INTEGER
			-- Padding for font height; used in `draw'.

	graph_padding: INTEGER
			-- Padding for graph area; used in `draw'.

	text_padding: INTEGER
			-- Padding for above, below, to the right and left of text; used in `draw'.

	as_pixmap: EV_PIXMAP
			-- Pixmap snapshot of `drawing_area', entire graph essentially.
		local
			l_rectangle: EV_RECTANGLE
--			l_pixmap: EV_PIXMAP
--			l_path: PATH
		do
			draw
			create l_rectangle.make (0, 0, drawing_area.width, drawing_area.height)
			Result := drawing_area.sub_pixmap (l_rectangle)
				-- Example to output to a png file.
--			create l_path.make_from_string ("d:\apps\junk\my_graph.png")
--			l_pixmap.save_to_named_path (create {EV_PNG_FORMAT}, l_path)
				-- End png file creation.
		end

	dot_label_skip: INTEGER
			-- Dot label's ought to be draw every `n' labels based on `dot_label_skip'.

feature -- Status Report

	is_ready_to_draw: BOOLEAN
			-- Is Current ready to draw?
		do
			Result := is_x_axis_range_set
						and is_y_axis_range_set
						and is_valid_x_axis_step (x_axis_step)
						and is_valid_y_axis_step (y_axis_step)
		ensure
			valid_result: Result = is_x_axis_range_set
						and is_y_axis_range_set
						and is_valid_x_axis_step (x_axis_step)
						and is_valid_y_axis_step (y_axis_step)
		end

	is_x_axis_range_set: BOOLEAN
			-- Has x-axis range been set?
		do
			Result := x_axis_lower < x_axis_upper
		ensure
			valid_result: Result = (x_axis_lower < x_axis_upper)
		end

	is_valid_x_axis_step (a_step: like value_anchor): BOOLEAN
			-- Is `a_step' a non-negative value?
		do
			Result := a_step > "0"
		ensure
			valid_result: Result = (a_step > "0")
		end

	is_y_axis_range_set: BOOLEAN
			-- Has y-axis range been set?
		do
			Result := y_axis_lower < y_axis_upper
		ensure
			valid_result: Result = (y_axis_lower < y_axis_upper)
		end

	is_valid_y_axis_step (a_step: like value_anchor): BOOLEAN
			-- Is `a_step' a non-negative value?
		do
			Result := a_step > "0"
		ensure
			valid_result: Result = (a_step > "0")
		end

	is_valid_data_series (a_data_points: ARRAY [like value_anchor]): BOOLEAN
			-- Is `a_data_points' valid?  Does its count match number of x series plot points?
		do
			Result := a_data_points.count.is_equal (x_series_text.count) and then
				across a_data_points as ic_points all ic_points.item <= y_axis_upper and ic_points.item >= y_axis_lower end
		ensure
			valid_result: Result = a_data_points.count.is_equal (x_series_text.count)and then
				across a_data_points as ic_points all ic_points.item <= y_axis_upper and ic_points.item >= y_axis_lower end
		end

	is_data_empty: BOOLEAN
			-- Is data area empty?
		do
			Result := internal_data.is_empty
		ensure
			valid_result: Result = internal_data.is_empty
		end

feature -- Basic Operations

	add_data_series_set (a_data_series_set: ARRAYED_LIST [attached like data_series_anchor])
			-- Add data series in `a_data_series_set' to internal managed list.
		do
			across a_data_series_set as ic_data_series_set loop
				add_data_series (ic_data_series_set.item)
			end
		end

	add_data_series (a_data_series: attached like data_series_anchor)
			-- Add `a_data_series' to internal managed list.
		require
			is_valid_data_series: is_valid_data_series (a_data_series.data_points)
		do
			across a_data_series.data_points as ic_data_points loop
				if ic_data_points.item > y_axis_upper then
					y_axis_upper := ic_data_points.item
				end
				if ic_data_points.item < y_axis_lower then
					y_axis_lower := ic_data_points.item
				end
			end
			internal_data.extend (a_data_series)
		ensure
			data_series_extended: internal_data.has (a_data_series)
			in_range_y_axis_upper_lower: across a_data_series.data_points as ic_points all ic_points.item <= y_axis_upper and ic_points.item >= y_axis_lower end
		end

	wipe_out_data
			-- Wipe out the data.
		do
			internal_data.wipe_out
		ensure
			data_wiped_out: is_data_empty
		end

	draw
			-- Clear `drawing_area' and draw data.
			--| A drawing area does not keep its current image internally and must be redrawn each time it requests this, via the `expose_actions'.
		require
			is_ready_to_draw: is_ready_to_draw
		do
			drawing_area.clear
			drawing_area.set_line_width (default_line_width)

			set_up_coordinates_and_boundaries
			draw_titles

			draw_x_axis_series_text
			draw_y_axis_text_and_grid_lines
			draw_data_series
			draw_legend_area
		end

feature -- Settings

	set_minimum_size (a_width, a_height: INTEGER)
			-- Set minimum size of the drawing area.
		do
			drawing_area.set_minimum_size (a_width, a_height)
		ensure
			minimum_width_set: drawing_area.minimum_width = a_width
			minimum_height_set: drawing_area.minimum_height = a_height
		end

	set_title (a_title: like title)
			-- Set `title' with `a_title'.
		do
			title := a_title
		ensure
			title_set: title = a_title
		end

	set_x_axis_title (a_title: like x_axis_title)
			-- Set `x_axis_title' with `a_title'.
		do
			x_axis_title := a_title
		ensure
			x_axis_title_set: x_axis_title = a_title
		end

	set_x_series_text (a_title: like x_axis_title; a_x_series_text: like x_series_text)
			-- Update x series text to be `a_x_series_text'.
			-- Usually this will be a time series, such as dates.
		require
			not_empty: a_x_series_text.count > 0
			is_data_empty: is_data_empty
		do
			set_x_axis_title (a_title)
			x_series_text := a_x_series_text
				-- Do not call `set_x_axis_range_and_step' here as it creates a new x_series_text and sets the values
				-- It will overwrite the assignment above, instead call `set_x_axis_range' and `set_x_axis_step'.
			set_x_axis_range ("1", x_series_text.count.out)
			set_x_axis_step ("1")
		ensure
			x_series_text_set: x_series_text = a_x_series_text
			x_axis_lower_set: x_axis_lower.is_equal ("1")
			x_axis_upper_set: x_axis_upper.is_equal (a_x_series_text.count.out)
			x_axis_step_set: x_axis_step.is_equal ("1")
		end

	set_x_axis_range_and_step (a_title: like x_axis_title; a_lower, a_upper, a_step: like value_anchor)
			-- Set `x_axis_lower' to `a_lower', `x_axis_upper' to `a_upper', and `x_axis_step' to `a_step'.
			-- Populate `x_series_text' with text values based on upper, lower and step.
		require
			upper_greater_than_lower: a_upper > a_lower
			is_valid_x_axis_step: is_valid_x_axis_step (a_step)
		do
			set_x_axis_title (a_title)
			set_x_axis_range (a_lower, a_upper)
			set_x_axis_step (a_step)
			create_x_series_text_from_range_and_step
		end

	set_x_axis_range (a_lower, a_upper: like value_anchor)
			-- Set `x_axis_lower' to `a_lower' and `x_axis_upper' to `a_upper'.
		require
			upper_greater_than_lower: a_upper > a_lower
		do
			x_axis_lower := a_lower
			x_axis_upper := a_upper
		ensure
			x_axis_lower_set: x_axis_lower = a_lower
			x_axis_upper_set: x_axis_upper = a_upper
		end

	set_x_axis_step (a_step: like value_anchor)
			-- Set `x_axis_step' to `a_step', size of distance between values in x-axis range.
		require
			is_valid_x_axis_step (a_step)
		do
			x_axis_step := a_step
		ensure
			x_axis_step_set: x_axis_step = a_step
		end

	set_y_axis_title (a_title: like y_axis_title)
			-- Set `y_axis_title' with `a_title'.
		do
			y_axis_title := a_title
		ensure
			y_axis_title_set: y_axis_title = a_title
		end

	set_y_axis_range_and_step (a_title: like y_axis_title; a_lower, a_upper, a_step: like value_anchor)
			-- Set `y_axis_lower' to `a_lower', `y_axis_upper' to `a_upper', and `y_axis_step' to `a_step'.
		require
			upper_greater_than_lower: a_upper > a_lower
			is_valid_y_axis_step: is_valid_y_axis_step (a_step)
		do
			set_y_axis_title (a_title)
			set_y_axis_range (a_lower, a_upper)
			set_y_axis_step (a_step)
		end

	set_y_axis_range (a_lower, a_upper: like value_anchor)
			-- Set `y_axis_lower' to `a_lower' and `y_axis_upper' to `a_upper'.
		require
			upper_greater_than_lower: a_upper > a_lower
		do
			y_axis_lower := a_lower
			y_axis_upper := a_upper
		ensure
			y_axis_lower_set: y_axis_lower = a_lower
			y_axis_upper_set: y_axis_upper = a_upper
		end

	set_y_axis_step (a_step: like value_anchor)
			-- Set `y_axis_step' to `a_step', size of distance between values in y-axis range.
		require
			is_valid_y_axis_step: is_valid_y_axis_step (a_step)
		do
			y_axis_step := a_step
		ensure
			y_axis_step_set: y_axis_step = a_step
		end

	set_graph_padding (a_padding_value: INTEGER)
			-- Set `graph_padding' to `a_padding_value'
		require
			non_negative: a_padding_value >= 0
		do
			graph_padding := a_padding_value
		ensure
			graph_padding_set: graph_padding = a_padding_value
		end

	set_text_padding (a_padding_value: INTEGER)
			-- Set `text_padding' to `a_padding_value'
		require
			non_negative: a_padding_value >= 0
		do
			text_padding := a_padding_value
		ensure
			text_padding_set: text_padding = a_padding_value
		end

	set_dot_label_angle (a_angle: INTEGER)
			-- `set_dot_label_angle' with `a_angle'.
		do
			drawing_area.set_dot_label_angle (a_angle)
		end


	set_draw_dot_labels
			-- `set_draw_dot_labels'.
		do
			drawing_area.set_draw_dot_labels
		end

	reset_draw_dot_labels
			-- `reset_draw_dot_labels'.
		do
			drawing_area.reset_draw_dot_labels
		end

	set_dot_label_skip (a_skip_value: INTEGER)
			-- `set_dot_label_skip' to `a_skip_value'.
		do
			dot_label_skip := a_skip_value
		ensure
			set: dot_label_skip = a_skip_value
		end

feature {NONE} -- Implementation: Access

	x_series_text: ARRAYED_LIST [STRING]
			-- Array of strings containing text for x series intervals.

	data_series_anchor: detachable TUPLE [data_points: ARRAY [like value_anchor]; color: EV_COLOR; legend_title: STRING]
			-- Type anchor for a data series.

	value_anchor: DECIMAL
			-- Type anchor for axes and step values.
		attribute
			create Result
		end

	graph_area: EV_RECTANGLE
			-- Parent rectangle; contains all other areas in the drawing area

	graph_title_area: EV_RECTANGLE
			-- Area within `graph_area' for overall graph title.

	x_axis_title_area: EV_RECTANGLE
			-- Area within `graph_area' for x-axis title

	y_axis_title_area: EV_RECTANGLE
			-- Area within `graph_area' for y-axis title

	data_area: EV_RECTANGLE
			-- Area within `graph_area' containing `x_axis_scale_area', `y_axis_scale_area', and `plot_area'.

	x_axis_scale_area: EV_RECTANGLE
			-- Area within `data_area' containing labels for x-axis steps.

	y_axis_scale_area: EV_RECTANGLE
			-- Area within `data_area' containing labels for y-axis steps.

	plot_area: EV_RECTANGLE
			-- Area within `data_area' containing data plot lines

	legend_area: EV_RECTANGLE
			-- Area within `graph_area' containing legend information.

	internal_data: ARRAYED_LIST [attached like data_series_anchor]
			-- Data to be plotted in `plot_area'.

	calculated_x_axis_step_amount: INTEGER
			--
		do
			Result := (plot_area.width // ((x_axis_upper - x_axis_lower) // x_axis_step)).round_to (0).to_integer
		ensure
			valid_result: Result = ((plot_area.width // ((x_axis_upper - x_axis_lower) // x_axis_step)).round_to (0).to_integer)
		end

	calculated_y_axis_step_amount: INTEGER
			--
		do
			Result := (plot_area.height // ((y_axis_upper - y_axis_lower) // y_axis_step)).round_to (0).to_integer
		ensure
			valid_result: Result = ((plot_area.height // ((y_axis_upper - y_axis_lower) // y_axis_step)).round_to (0).to_integer)
		end

	default_text_padding: INTEGER = 4
			-- Default value for `text_padding'

	default_font_height_padding: INTEGER = 12
			-- Default value for `font_height_padding'

	default_foreground_color: EV_COLOR
			-- Default foreground color for `drawing_area'
		once
			Result := (create {EV_STOCK_COLORS}).default_foreground_color
		end

	default_grid_line_color: EV_COLOR
			-- Default grid line color for `drawing_area'
		once
			Result := (create {JV_STOCK_COLORS}).light_gray
		end

	default_text_color: EV_COLOR
			-- Default text color for `drawing_area'
		once
			Result := (create {JV_STOCK_COLORS}).black
		end

	default_line_width: INTEGER = 1
			-- Default value for width of general lines.

	default_grid_line_width: INTEGER = 1
			-- Default value for width of grid lines.

	default_data_line_width: INTEGER = 2
			-- Default value for width of data lines.

	default_dot_diameter: INTEGER = 10
			-- Default diameter value of drawn dots.

feature {NONE} -- Implementation: Basic Operations

	set_up_coordinates_and_boundaries
			-- Set coordinates and boundaries for all areas within `drawing_area'.
		require
			is_ready_to_draw: is_ready_to_draw
		local
			l_font_width, l_font_height, l_font_height_with_padding: INTEGER
			l_title_area_height, l_y_axis_title_area_width, l_x_axis_title_area_height: INTEGER
			l_legend_width: INTEGER
			l_data_area_width: INTEGER
			l_x_axis_scale_area_height, l_y_axis_scale_area_width: INTEGER
		do
			l_font_width := drawing_area.font.width
			l_font_height := drawing_area.font.height
			l_font_height_with_padding := l_font_height + default_font_height_padding

				-- Set up graph area to be size of drawing area less padding
			graph_area.move_and_resize (graph_padding, graph_padding, drawing_area.width - (graph_padding * 2), drawing_area.height - (graph_padding * 2))

				-- Set up graph title area
			if attached title as al_title and then not al_title.is_empty then
				l_title_area_height := l_font_height_with_padding
			end
			graph_title_area.move_and_resize (graph_area.x, graph_area.y, graph_area.width, l_title_area_height)

				-- Set up y-axis and x-axis title areas
			l_legend_width := (l_font_width * 20) + ((l_font_width + l_font_height) * 2) + 10	-- 20 characters wide + room for color box plus 10 extra pixels
			l_data_area_width := graph_area.width - l_font_height_with_padding - l_legend_width

			if attached y_axis_title as al_y_axis_title and then not al_y_axis_title.is_empty then
				l_y_axis_title_area_width := l_font_height_with_padding
			end
			if attached x_axis_title as al_x_axis_title and then not al_x_axis_title.is_empty then
				l_x_axis_title_area_height := l_font_height_with_padding
			end

			y_axis_title_area.move_and_resize (graph_area.x, graph_area.y + graph_title_area.height, l_y_axis_title_area_width, graph_area.height - graph_title_area.height - l_x_axis_title_area_height)
			x_axis_title_area.move_and_resize (graph_area.x + l_x_axis_title_area_height, graph_area.height - l_x_axis_title_area_height + graph_padding, l_data_area_width, l_x_axis_title_area_height)

				-- Set up data area
			data_area.move_and_resize (y_axis_title_area.x + y_axis_title_area.width, y_axis_title_area.y, l_data_area_width, y_axis_title_area.height)

				-- Set up y-axis and x-axis scale areas
			l_y_axis_scale_area_width := (l_font_width * 10) + 10	-- 10 characters wide + 10 pixel buffer
			l_x_axis_scale_area_height := l_font_height * 4	-- 4 instead of 2 to add space to rotate the x series text by 30 degrees, see TODO above

			y_axis_scale_area.move_and_resize (data_area.x, data_area.y, l_y_axis_scale_area_width, data_area.height - l_x_axis_scale_area_height)
			x_axis_scale_area.move_and_resize (y_axis_scale_area.x + y_axis_scale_area.width, y_axis_scale_area.y + y_axis_scale_area.height, data_area.width - y_axis_scale_area.width, l_x_axis_scale_area_height)

				-- Set up plot area
			plot_area.move_and_resize (x_axis_scale_area.x, y_axis_scale_area.y, x_axis_scale_area.width, y_axis_scale_area.height)

				-- Set up legend area
			legend_area.move_and_resize (data_area.x + data_area.width, data_area.y, l_legend_width, data_area.height)
		end

	draw_titles
			-- Draw graph title, x-axis title, and y-axis title.
		require
			is_ready_to_draw: is_ready_to_draw
		local
			l_x_axis_title_text_x, l_x_axis_title_text_y: INTEGER
			l_y_axis_title_text_x, l_y_axis_title_text_y: INTEGER
			l_font_width, l_font_height: INTEGER
		do
			l_font_width := drawing_area.font.width
			l_font_height := drawing_area.font.height

				-- Graph title
			if attached title as al_title and then not al_title.is_empty then
				drawing_area.draw_text_top_left (graph_title_area.x + text_padding, graph_title_area.y + text_padding, al_title)
			end
				-- X-axis title
			if attached x_axis_title as al_x_axis_title and then not al_x_axis_title.is_empty then
					-- Center the text horizontally in x-axis title area
				l_x_axis_title_text_x := (drawing_area.width // 2) - ((al_x_axis_title.count * l_font_width) // 2)
					-- Center the text vertically in x-axis title area
				l_x_axis_title_text_y := x_axis_title_area.y + ((x_axis_title_area.height - l_font_height) // 2)
				drawing_area.draw_text_top_left (l_x_axis_title_text_x, l_x_axis_title_text_y, al_x_axis_title)
			end
				-- Y-axis title
			if attached y_axis_title as al_y_axis_title and then not al_y_axis_title.is_empty then
					-- Center the text horizontally in the y-axis title area, after tilt
				l_y_axis_title_text_x := y_axis_title_area.x + (y_axis_title_area.width // 2) + text_padding
					-- Center the text vertically in the y-axis title area, after tilt
				l_y_axis_title_text_y := (drawing_area.height // 2) + ((al_y_axis_title.count * l_font_width) // 2)
					-- Draw text rotated counter-clockwise by 90 degrees
				drawing_area.draw_rotated_text_by_degree (l_y_axis_title_text_x, l_y_axis_title_text_y, 90, al_y_axis_title)
			end
		end

	draw_x_axis_series_text
			-- Draw x-axis series text.
		require
			is_ready_to_draw: is_ready_to_draw
		local
			l_font_height: INTEGER
			l_step_text_x, l_step_text_y, l_step_amount: INTEGER
		do
			drawing_area.set_foreground_color (default_text_color)
			l_font_height := drawing_area.font.height

			l_step_text_x := plot_area.left
			l_step_text_y := y_axis_title_area.bottom - l_font_height
			l_step_amount := calculated_x_axis_step_amount

			across x_series_text as ic_text loop
					-- Draw the x-axis series text rotated counter-clockwise by 30 degrees
				drawing_area.draw_rotated_text_by_degree (l_step_text_x, l_step_text_y, 30, ic_text.item)
				l_step_text_x := l_step_text_x + l_step_amount
			end
		end

	draw_y_axis_text_and_grid_lines
			-- Draw the horizontal grid lines and the corresponding y-axis text.
		require
			is_ready_to_draw: is_ready_to_draw
		local
			l_font_width, l_font_height: INTEGER
			l_step_position, l_step_amount, l_step_value, l_step_text_x, l_step_text_y: INTEGER
			l_step_text: STRING
		do
			l_font_width := drawing_area.font.width
			l_font_height := drawing_area.font.height

				-- Set line width and draw the horizontal step lines in light gray
			drawing_area.set_line_width (default_grid_line_width)
			from
				l_step_position := plot_area.bottom
				l_step_amount := calculated_y_axis_step_amount
				l_step_value := y_axis_lower.round_to (0).to_integer
			until
				l_step_position <= plot_area.top
			loop
					-- Draw the horizontal grid line.
				drawing_area.set_foreground_color (default_grid_line_color)
				drawing_area.draw_segment (plot_area.left, l_step_position, plot_area.right, l_step_position)
					-- Draw the corresponding y-axis text.
				l_step_text := l_step_value.out
				l_step_text_x := y_axis_scale_area.right - (l_step_text.count * (l_font_width * 2))	-- text to the left of step line with some spacing
				l_step_text_y := l_step_position + (l_font_height // 2)	-- center the text on the step line
				drawing_area.set_foreground_color (default_text_color)
				drawing_area.draw_text (l_step_text_x, l_step_text_y, l_step_text)
				l_step_position := l_step_position - l_step_amount
				l_step_value := l_step_value + y_axis_step.round_to (0).to_integer
			end
		end

	draw_data_series
			-- Draw data series in plot area.
		require
			is_ready_to_draw: is_ready_to_draw
		local
			l_range_factor, l_plot_y: like value_anchor
			i: INTEGER
			l_step_position, l_step_amount: INTEGER
			l_left_coordinate, l_right_coordinate: EV_COORDINATE
			l_label_text: STRING
		do
				-- Set thicker line width and draw data lines
			drawing_area.set_line_width (default_data_line_width)

			l_range_factor := plot_area.height / (y_axis_upper - y_axis_lower)

				-- Plot data series from `internal_data'
			across internal_data as ic_data loop
				from
					i := 1
					l_step_position := plot_area.left
					l_step_amount := calculated_x_axis_step_amount
					l_plot_y := plot_area.bottom - ic_data.item.data_points.item (i) * l_range_factor
					create l_right_coordinate.make (l_step_position, (l_plot_y.round_to (0)).to_integer)
					drawing_area.set_foreground_color (ic_data.item.color)
					drawing_area.draw_dot (l_right_coordinate.x, l_right_coordinate.y, default_dot_diameter, dot_label (ic_data.item.data_points.item (i)))
				until
					i > ic_data.item.data_points.count
				loop
					i := i + 1
					if i <= ic_data.item.data_points.count then
						create l_left_coordinate.make (l_right_coordinate.x, l_right_coordinate.y)
						l_step_position := l_step_position + l_step_amount
						l_plot_y := plot_area.bottom - ic_data.item.data_points.item (i) * l_range_factor
						create l_right_coordinate.make (l_step_position, (l_plot_y.round_to (0)).to_integer)
						drawing_area.draw_segment (l_left_coordinate.x, l_left_coordinate.y, l_right_coordinate.x, l_right_coordinate.y)
						drawing_area.draw_dot (l_left_coordinate.x, l_left_coordinate.y, default_dot_diameter, "")
						if (i \\ dot_label_skip = 0) or i = ic_data.item.data_points.count then
							l_label_text := dot_label (ic_data.item.data_points.item (i))
						else
							l_label_text := ""
						end
						drawing_area.draw_dot (l_right_coordinate.x, l_right_coordinate.y, default_dot_diameter, l_label_text)
					end
				end
			end
		end

	dot_label (a_value: DECIMAL): STRING
			-- Convert `a_value' to a `dot_label' string.
		local
			l_decimal: DECIMAL
		do
			l_decimal := a_value.round_to (2)
			Result := l_decimal.out
		end

	draw_legend_area
			-- Draw `legend_area'
		require
			is_ready_to_draw: is_ready_to_draw
		local
			l_plot_y, l_font_width, l_font_height: INTEGER
		do
				-- Calculate y values only, x will remain steady
			l_plot_y := plot_area.top + text_padding
			l_font_width := drawing_area.font.width
			l_font_height := drawing_area.font.height

			across internal_data as ic_data loop
				drawing_area.set_foreground_color (ic_data.item.color)
				drawing_area.draw_box_dot (legend_area.left + (l_font_width * 2), l_plot_y, l_font_height + 2)
				drawing_area.set_foreground_color (default_foreground_color)
				drawing_area.draw_text_top_left (legend_area.left + (l_font_width * 2) + l_font_height + l_font_width, l_plot_y, ic_data.item.legend_title)

				l_plot_y := l_plot_y + (l_font_height * 2)
			end
		end

	create_x_series_text_from_range_and_step
			-- Re-create `x_series_tex' from `x_axis_upper', `x_axis_lower', and `x_axis_step'
		require
			is_x_axis_range_set: is_x_axis_range_set
			is_valid_x_axis_step (x_axis_step)
		local
			i: like value_anchor
		do
			create x_series_text.make (((x_axis_upper - x_axis_lower) \\ x_axis_step).round_to (0).to_integer)
			from
				i := 1
			until
				i = x_axis_upper
			loop
				x_series_text.extend (i.out)
				i := i + x_axis_step
			end
		end

end
