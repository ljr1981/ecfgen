note
	description: "Abstract notion of GUI Constants"

deferred class
	EG_GUI_CONSTANTS

feature -- Constants

	tree_node_anchor: detachable EG_TREE_ITEM
			-- What tree nodes ought to be.

	grid_label_anchor: detachable EG_GRID_LABEL_ITEM
			-- What grid cell nodes ought to be.

end
