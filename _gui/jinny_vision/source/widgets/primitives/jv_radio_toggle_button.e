note
	description: "A toggle button with radio button functionality."
	date: "$Date: 2014-05-13 14:52:00 -0400 (Tue, 13 May 2014) $"
	revision: "$Revision: 9162 $"

class
	JV_RADIO_TOGGLE_BUTTON

inherit
	EV_TOGGLE_BUTTON
		redefine
			initialize
		end

create
	default_create,
	make_with_text,
	make_with_text_and_action

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		do
			Precursor
			select_actions.extend (agent on_toggle_button_press)
		end

feature -- Settings

	set_specified_peers (a_peers: LINEAR [EV_WIDGET])
			-- Sets `specified_peers' with `a_peers'.
		do
			create specified_peers.make (6)
			if attached specified_peers as al_peers then
				from
					a_peers.start
				until
					a_peers.off
				loop
					if attached {like Current} a_peers.item as al_item then
						al_peers.extend (al_item)
					end
					a_peers.forth
				end
			else
				check attached_specified_peers: False end
			end
		end

feature {NONE} -- Implementation

	peers: ARRAYED_LIST [like Current]
			-- Radio toggle buttons contained in `parent', including Current.
		local
			l_peers: LINEAR [EV_WIDGET]
		do
			check attached_parent: attached parent as al_parent then
				l_peers := al_parent.linear_representation
			end
			create Result.make (2)
			from
				l_peers.start
			until
				l_peers.off
			loop
				if attached {like Current} l_peers.item as al_item then
					Result.extend (al_item)
				end
				l_peers.forth
			end
		end

	specified_peers: detachable like peers
			-- Manually specified override of `peers'.

	on_toggle_button_press
			-- Action called when Current is pressed.
		local
			l_peers: like peers
		do
			if is_selected then
				if attached specified_peers as al_peers and then not al_peers.is_empty then
					l_peers := al_peers
				else
					l_peers := peers
				end
				across l_peers as ic_peers loop
					if ic_peers.item /= Current then
						ic_peers.item.select_actions.block
						ic_peers.item.disable_select
						ic_peers.item.select_actions.resume
					end
				end
			else
				select_actions.block
				enable_select
				select_actions.resume
			end
		end

end
