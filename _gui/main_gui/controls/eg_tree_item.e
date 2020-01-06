note
	description: "An {EV_TREE_ITEM} specialized for {CONF_SYSTEM} tree items."

class
	EG_TREE_ITEM

inherit
	EV_TREE_ITEM
		redefine
			make_with_text
		end

	EG_NODE_ITEM
		undefine
			copy,
			default_create,
			is_equal
		end

create
	make_with_text

feature {NONE} -- Initialization

	make_with_text (a_text: STRING_32)
			--<Precursor>
			-- Add PickNDrop to the matter.
		do
			Precursor (a_text)
			set_pick_and_drop_mode
		end

end

