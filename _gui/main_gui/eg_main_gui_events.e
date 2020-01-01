note
	description: "Isolation of Main GUI Events."
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_GUI_EVENTS

inherit
	EG_ANY

feature {EG_MAIN_GUI} -- Events

	on_apply_filter
			-- What happens `on_apply_filter' to `controls.library_list'?
		local
			l_node: EV_TREE_NODE
			l_filter_text: STRING_32
			l_starts_with_mode,
			l_ends_with_mode,
			l_mid_text_mode: BOOLEAN
			l_img: IMG_TREE_ITEM
		do
			create l_img.make

			l_filter_text := controls.libraries_filter_cbox.text
			l_starts_with_mode := l_filter_text.ends_with ("*")
			l_ends_with_mode := l_filter_text.starts_with ("*")
			l_mid_text_mode := l_starts_with_mode and l_ends_with_mode
			l_starts_with_mode := l_starts_with_mode and not l_mid_text_mode
			l_ends_with_mode := l_ends_with_mode and not l_mid_text_mode

			l_filter_text.replace_substring_all ("*", "")

			across
				controls.library_list as ic
			loop
				across
					ic.item as ic_subnodes
				loop
					check attached {EV_TREE_ITEM} ic_subnodes.item as al_node then
						if l_starts_with_mode and then al_node.text.starts_with (l_filter_text) then
							al_node.enable_select
							al_node.set_pixmap (l_img.to_pixmap)
						elseif l_ends_with_mode and then al_node.text.ends_with (l_filter_text) then
							al_node.enable_select
							al_node.set_pixmap (l_img.to_pixmap)
						elseif l_mid_text_mode and then al_node.text.has_substring (l_filter_text) then
							al_node.enable_select
							al_node.set_pixmap (l_img.to_pixmap)
						else
							al_node.disable_select
							al_node.remove_pixmap
						end
					end
				end
			end
		end

	on_remove_filter
		do

		end

feature {NONE} -- References

	gui: EG_MAIN_GUI
			-- Reference to Main GUI.
		deferred
		end

	controls: EG_MAIN_GUI_CONTROLS
			-- Reference to GUI Controls.
		deferred
		end

	events: EG_MAIN_GUI_EVENTS once Result := Current end
			-- Reference to GUI Control Events.

note
	purpose: "[

		]"
	design: "[

		]"

end
