note
	description: "Dialog for picking color."
	date: "$Date: 2014-05-15 18:13:14 -0400 (Thu, 15 May 2014) $"
	revision: "$Revision: 9176 $"

class
	JV_COLOR_NAME_PICKER_DIALOG

inherit
	JV_DIALOG

	JV_STOCK_COLORS
		undefine
			default_create,
			copy
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		local
			l_font: EV_FONT
			l_colors_box: EV_VERTICAL_BOX
			l_hbox, l_row: EV_HORIZONTAL_BOX
			l_cell: EV_CELL
			l_color: EV_COLOR
		do
			create okay_button.make_with_text_and_action ("OK", agent okay_actions.call (Void))
			create cancel_button.make_with_text_and_action ("Cancel", agent cancel_actions.call (Void))
			create widget
			create example_label.make_with_text ("Example header")
			create l_colors_box
			make_with_title ("Select color")
			set_size (400, 340)
			set_minimum_size (400, 340)
			disable_user_resize
			extend (widget)
			create l_hbox
			widget.extend (l_hbox)
			l_hbox.extend (l_colors_box)
			l_hbox.disable_item_expand (l_colors_box)
			l_hbox.extend (example_label)
			create l_font
			l_font.set_weight ({EV_FONT_CONSTANTS}.weight_bold)
			example_label.set_font (l_font)
			example_label.align_text_vertical_center
			example_label.align_text_center
			create l_row

			across color_information as ic_information loop
				if ic_information.cursor_index \\ 10 = 1 then
					if not ic_information.is_first then
						l_colors_box.extend (l_row)
						l_colors_box.disable_item_expand (l_row)
					end
					create l_row
					l_row.set_minimum_height (20)
				end
				create l_cell
				l_color := ic_information.item.color
				l_cell.set_background_color (l_color)
				l_cell.pointer_button_press_actions.force_extend (agent set_color (ic_information.item))
				l_cell.set_minimum_width (20)
				l_row.extend (l_cell)
				l_row.disable_item_expand (l_cell)
			end
			if not l_row.is_empty then
				l_colors_box.extend (l_row)
			end

			create l_row
			l_row.extend (create {EV_CELL})
			l_row.extend (okay_button)
			l_row.disable_item_expand (okay_button)
			l_row.extend (cancel_button)
			l_row.disable_item_expand (cancel_button)
			widget.extend (l_row)
			widget.disable_item_expand (l_row)

			okay_button.disable_sensitive
			set_default_push_button (okay_button)
			cancel_button.select_actions.extend (agent destroy)
			okay_button.select_actions.extend (agent destroy)
			close_request_actions.extend (agent destroy)
		end

feature -- Access

	color_name: STRING
			-- Color name selected for Current.
		attribute
			create Result.make_empty
		end

	color: detachable EV_COLOR
			-- Possible color selected for Current.

	okay_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions called on press of `okay_button'.
		attribute
			create Result
		end

	cancel_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions called on press of `cancel_button'.
		attribute
			create Result
		end

feature {NONE} -- Implementation

	cancel_button, okay_button: EV_BUTTON

	widget: EV_VERTICAL_BOX

	example_label: EV_LABEL

	set_color (a_color: like color_information.item)
			-- Set color selected for Current.
		local
			l_color: EV_COLOR
		do
			color_name := a_color.name
			okay_button.enable_sensitive
			okay_button.set_text ("OK (" + color_name + ")")
			l_color := a_color.color
			example_label.set_background_color (l_color)
			color := l_color
		end

	color_information: ARRAY [TUPLE [name: STRING; color: EV_COLOR]]
			-- Information about all colors to pick in Current.
		once
			Result := (<<
				-- Reds
			["chestnut", chestnut],
			["indian_red", indian_red],
			["light_coral", light_coral],
			["salmon", salmon],
			["dark_salmon", dark_salmon],
			["light_salmon", light_salmon],
			["red", red],
			["fire_brick", fire_brick],
			["dark_red", dark_red],
				-- Pinks
			["pink", pink],
			["light_pink", light_pink],
			["hot_pink", hot_pink],
			["deep_pink", deep_pink],
			["medium_violet_red", medium_violet_red],
			["pale_violet_red", pale_violet_red],
				-- Oranges
			["coral", coral],
			["tomato", tomato],
			["orange_red", orange_red],
			["dark_orange", dark_orange],
			["orange", orange],
				-- Yellows
			["gold", gold],
			["yellow", yellow],
			["light_yellow", light_yellow],
			["lemon_chiffon", lemon_chiffon],
			["light_goldenrod_yellow", light_goldenrod_yellow],
			["papaya_whip", papaya_whip],
			["moccasin", moccasin],
			["peach_puff", peach_puff],
			["pale_goldenrod", pale_goldenrod],
			["khaki", khaki],
			["dark_khaki", dark_khaki],
				-- Purples
			["lavender", lavender],
			["thistle", thistle],
			["plum", plum],
			["violet", violet],
			["orchid", orchid],
			["magenta", magenta],
			["medium_orchid", medium_orchid],
			["medium_purple", medium_purple],
			["amethyst", amethyst],
			["blue_violet", blue_violet],
			["dark_violet", dark_violet],
			["dark_orchid", dark_orchid],
			["dark_magenta", dark_magenta],
			["purple", purple],
			["indigo", indigo],
			["slate_blue", slate_blue],
			["dark_slate_blue", dark_slate_blue],
				-- Greens
			["green_yellow", green_yellow],
			["chartreuse", chartreuse],
			["lawn_green", lawn_green],
			["lime", lime],
			["lime_green", lime_green],
			["pale_green", pale_green],
			["light_green", light_green],
			["spring_green", spring_green],
			["medium_sea_green", medium_sea_green],
			["sea_green", sea_green],
			["forest_green", forest_green],
			["green", green],
			["dark_green", dark_green],
			["yellow_green", yellow_green],
			["olive_drab", olive_drab],
			["olive", olive],
			["dark_olive_green", dark_olive_green],
			["medium_aquamarine", medium_aquamarine],
			["dark_sea_green", dark_sea_green],
			["light_sea_green", light_sea_green],
			["dark_cyan", dark_cyan],
			["teal", teal],
				-- Blues
			["cyan", cyan],
			["light_cyan", light_cyan],
			["pale_turquoise", pale_turquoise],
			["aquamarine", aquamarine],
			["turquoise", turquoise],
			["medium_turquoise", medium_turquoise],
			["dark_turquoise", dark_turquoise],
			["cadet_blue", cadet_blue],
			["steel_blue", steel_blue],
			["light_steel_blue", light_steel_blue],
			["powder_blue", powder_blue],
			["light_blue", light_blue],
			["sky_blue", sky_blue],
			["light_sky_blue", light_sky_blue],
			["deep_sky_blue", deep_sky_blue],
			["dodger_blue", dodger_blue],
			["cornflower_blue", cornflower_blue],
			["medium_slate_blue", medium_slate_blue],
			["royal_blue", royal_blue],
			["blue", blue],
			["medium_blue", medium_blue],
			["dark_blue", dark_blue],
			["navy", navy],
			["navy_blue", navy_blue],
			["midnight_blue", midnight_blue],
				-- Browns
			["cornsilk", cornsilk],
			["blanched_almond", blanched_almond],
			["bisque", bisque],
			["navajo_white", navajo_white],
			["wheat", wheat],
			["burly_wood", burly_wood],
			["tan", tan],
			["rosy_brown", rosy_brown],
			["sandy_brown", sandy_brown],
			["goldenrod", goldenrod],
			["dark_goldenrod", dark_goldenrod],
			["peru", peru],
			["chocolate", chocolate],
			["saddle_brown", saddle_brown],
			["sienna", sienna],
			["brown", brown],
			["maroon", maroon],
				-- Whites
			["white", white],
			["snow", snow],
			["honeydew", honeydew],
			["mint_cream", mint_cream],
			["azure", azure],
			["alice_blue", alice_blue],
			["ghost_white", ghost_white],
			["white_smoke", white_smoke],
			["seashell", seashell],
			["old_lace", old_lace],
			["floral_white", floral_white],
			["ivory", ivory],
			["antique_white", antique_white],
			["linen", linen],
			["lavender_blush", lavender_blush],
			["misty_rose", misty_rose],
				-- Grays
			["windows_default_background_color", windows_default_background_color],
			["gainsboro", gainsboro],
			["light_grey", light_grey],
			["silver", silver],
			["dark_gray", dark_gray],
			["gray", gray],
			["dim_gray", dim_gray],
			["light_slate_gray", light_slate_gray],
			["slate_gray", slate_gray],
			["dark_slate_gray", dark_slate_gray],
			["black", black]
			>>)
		end

end
