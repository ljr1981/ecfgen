note
	description: "An {EV_TOP_LEFT_SCROLLABLE_AREA} with additional scroll functionality"
	date: "$Date: 2015-07-08 09:21:06 -0400 (Wed, 08 Jul 2015) $"
	revision: "$Revision: 11704 $"

class
	JV_TOP_LEFT_SCROLLABLE_AREA

inherit
	EV_TOP_LEFT_SCROLLABLE_AREA

feature -- Event handling

	vertical_scroll_actions: EV_SCROLL_ACTION_SEQUENCE
			-- Vertical bar scroll actions.
		do
			Result := attached_ev_scrollable_area_imp.vertical_scroll_action
		end

	horizontal_scroll_actions: EV_SCROLL_ACTION_SEQUENCE
			-- Horizontal bar scroll actions.
		do
			Result := attached_ev_scrollable_area_imp.horizontal_scroll_action
		end

feature -- Element change

	attempt_to_set_x_offset (a_x: INTEGER_32)
			-- Attempt to assign `a_x' offset.
		require
			not_destroyed: not is_destroyed
		do
			implementation.set_x_offset (a_x)
		end

	attempt_to_set_y_offset (a_y: INTEGER_32)
			-- Attempt to assign `a_y' offset.
		require
			not_destroyed: not is_destroyed
		do
			implementation.set_y_offset (a_y)
		end

feature {JV_TOP_LEFT_SCROLLABLE_AREA_TEST} -- Implementation

	ev_scrollable_area_imp: detachable EV_SCROLLABLE_AREA_IMP
			-- Implementation for EV_SCROLLABLE_AREA giving access to scroll events.
		local
			l_internal: INTERNAL
		do
			create l_internal
			across  1 |..| l_internal.field_count (Current) as ic_count loop
				if attached {EV_SCROLLABLE_AREA_IMP} l_internal.field (ic_count.item, Current) as al_field then
					Result := al_field
				end
			end
		end

	attached_ev_scrollable_area_imp: EV_SCROLLABLE_AREA_IMP
			-- Attached version of `ev_scrollable_area_imp'.
		do
			check attached_ev_scrollable_area_imp: attached ev_scrollable_area_imp as al_imp then 
				Result := al_imp	
			end
		end

end
