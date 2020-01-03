note
	description: "Extends functionality of {EV_DRAWING_AREA}."

class
	VE_DRAWING_AREA

inherit
	EV_DRAWING_AREA
		redefine
			draw_rotated_text
		end

	VE_ANY
		undefine
			copy,
			default_create
		end

feature -- Access

	dot_label_angle: INTEGER
			-- What is the current `dot_label_angle'?

	draw_dot_labels: BOOLEAN
			-- Does Current `draw_dot_labels' when (for example) `draw_dot'?

feature -- Settings

	set_draw_dot_labels
			-- `set_draw_dot_labels' True.
		do
			draw_dot_labels := True
		end

	reset_draw_dot_labels
			-- `reset_draw_dot_labels'.
		do
			draw_dot_labels := False
		end


	set_dot_label_angle (a_angle: INTEGER)
			-- `set_dot_label_angle' to `a_angle'.
		require
			range: a_angle >= 0 and a_angle <= 90
		do
			dot_label_angle := a_angle
		end

feature -- Drawing operations

	draw_dot (a_x, a_y, a_diameter: INTEGER; a_label: STRING)
			-- Draw a dot centered at `x',`y', with diameter `a_diameter'.
		require
			not_destroyed: not is_destroyed
			non_negative_diameter: a_diameter >= 0
		local
			l_offset: INTEGER
		do
			if a_diameter > 0 then
				l_offset := a_diameter // 2
			end
			if draw_dot_labels then
				draw_rotated_text_by_degree (a_x + l_offset, a_y - l_offset, dot_label_angle, a_label)
			end
			implementation.fill_ellipse (a_x - l_offset, a_y - l_offset, a_diameter, a_diameter)
		end

	draw_box_dot (a_x, a_y, a_side_length: INTEGER)
			-- Draw square with upper-left corner on (`a_x', `a_y') with size `a_side_length'.
		require
			not_destroyed: not is_destroyed
			non_negative_lengeth: a_side_length >= 0
		do
			implementation.fill_rectangle (a_x, a_y, a_side_length, a_side_length)
		end

	draw_rotated_text_by_degree (a_x, a_y, a_degree: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' rotated with left of baseline at (`a_x', `a_y') using `font'.
			-- Rotation is number of `a_degree's counter-clockwise from horizontal plane.
		require
			not_destroyed: not is_destroyed
			a_text_not_void: a_text /= Void
		local
			l_radians: REAL
		do
			l_radians := a_degree.to_real * 0.0174532925
			draw_rotated_text (a_x, a_y, l_radians, a_text)
		end

	draw_rotated_text (a_x, a_y: INTEGER; a_angle: REAL; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' rotated with left of baseline at (`a_x', `a_y') using `font'.
			-- Rotation is number of `a_angle' radians counter-clockwise from horizontal plane.
		require else
			not_destroyed: not is_destroyed
			a_text_not_void: a_text /= Void
		do
			implementation.draw_rotated_text (a_x, a_y, a_angle, a_text)
		end

invariant
	dot_label_angle_range: dot_label_angle >= 0 and dot_label_angle <= 90

end
