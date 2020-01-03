note
	description: "Abstract notion of a ECF Generation Widget."

deferred class
	EG_WIDGET

inherit
	EG_ANY

feature {NONE} -- Implementation

	widget: EV_WIDGET
			-- Primary `widget' of Current.
		deferred
		end

	item: attached like item_internal
			-- Attached version of `item_internal'.
		do
			check attached item_internal as al_item then Result := al_item end
		end

	render
			-- Render `item'
		deferred
		end

	item_internal: detachable ANY
			--
		deferred
		end

end
