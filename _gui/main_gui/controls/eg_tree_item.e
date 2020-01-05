note
	description: "An {EV_TREE_ITEM} specialized for {CONF_SYSTEM} tree items."

class
	EG_TREE_ITEM

inherit
	EV_TREE_ITEM

	EG_NODE_ITEM
		undefine
			copy,
			default_create,
			is_equal
		end

create
	default_create,
	make_with_text

end

