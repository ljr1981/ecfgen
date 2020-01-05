note
	description: "An {EV_GRID_LABEL_ITEM} crafted for {CONF_SYSTEM} nodes."

class
	EG_GRID_LABEL_ITEM

inherit
	EV_GRID_LABEL_ITEM

	EG_NODE_ITEM
		undefine
			copy,
			default_create
		end

create
	default_create,
	make_with_text

end
