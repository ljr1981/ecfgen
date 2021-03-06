note
	description: "Isolation of Main GUI Events."
	purpose_and_design: "See end-of-class notes"

deferred class
	EG_MAIN_GUI_EVENTS

inherit
	EG_ANY

	EG_IMG_CONSTANTS

	EG_GUI_CONSTANTS

feature {EG_MAIN_GUI, EG_MAIN_GUI_EVENTS} -- Events

	on_apply_filter
			-- What happens `on_apply_filter' to `controls.library_list'?
		local
			l_node: EV_TREE_NODE
			l_item: EV_TREE_ITEM
			l_filter_text: STRING_32
			l_starts_with_mode,
			l_ends_with_mode,
			l_mid_text_mode: BOOLEAN
			l_img: IMG_TREE_ITEM
		do
			check has_filter_node: attached gui.filter_node as al_filter_node then
				al_filter_node.wipe_out
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
								create l_item.make_with_text (al_node.text)
								check has_ref: attached {ES_CONF_SYSTEM_REF} al_node.data as al_system_ref then
									l_item.select_actions.extend (agent events.on_node_select (l_item.text.to_string_8, al_system_ref))
									al_filter_node.extend (l_item)
									al_filter_node.set_pixmap (img_library)
								end
							elseif l_ends_with_mode and then al_node.text.ends_with (l_filter_text) then
								create l_item.make_with_text (al_node.text)
								check has_ref: attached {ES_CONF_SYSTEM_REF} al_node.data as al_system_ref then
									l_item.select_actions.extend (agent events.on_node_select (l_item.text.to_string_8, al_system_ref))
									al_filter_node.extend (l_item)
									al_filter_node.set_pixmap (img_library)
								end
							elseif l_mid_text_mode and then al_node.text.has_substring (l_filter_text) then
								create l_item.make_with_text (al_node.text)
								check has_ref: attached {ES_CONF_SYSTEM_REF} al_node.data as al_system_ref then
									l_item.select_actions.extend (agent events.on_node_select (l_item.text.to_string_8, al_system_ref))
									al_filter_node.extend (l_item)
									al_filter_node.set_pixmap (img_library)
								end
							else
								do_nothing
							end
						end
					end
				end
			end
		end

	on_remove_filter
			-- What happens when we remove a library filter.
		do

		end

	on_node_select (a_node_name: STRING; a_node: ES_CONF_SYSTEM_REF)
			-- What happens `on_node_select' of the library list.
		do
			controls.status_message.set_text (a_node_name + ": " + a_node.configuration.directory.name.out)
		end

	on_library_node_refresh
			-- What happens when user clicks the libraries refresh tool
		do
			check
				attached last_selected_root_node as al_node and then
				attached last_lib_list as al_libs
			then
				if attached last_refresh_agent as al_agent then
					controls.status_message.set_text ("Refreshing library list ...%N%N")
					al_agent.call (Void)
					controls.status_message.append_text (al_libs.count.out + " items loaded in " + al_node.text + " node.%N")
					controls.status_message.append_text ("Ready.%N")
					controls.status_message.scroll_to_end
					controls.status_message.scroll_down (3)
					controls.status_progress_bar.set_value (0)
				else
					controls.status_message.append_text ("%NNo library load agent found for " + al_node.text + " node.%N")
					controls.status_message.append_text (al_libs.count.out + " items loaded in " + al_node.text + " node.%N%NReady.%N")
				end
				gui.populate_node (al_node, al_libs)
				controls.library_list.refresh_now
			end
		end

	on_root_node_select (a_root_node: attached like tree_node_anchor; a_lib_list: detachable HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]; a_refresh_agent: detachable PROCEDURE)
			-- What happens when user clicks a library root node.
		do
			last_selected_root_node := a_root_node
			last_lib_list := a_lib_list
			last_refresh_agent := a_refresh_agent
			controls.libraries_tool_refresh.enable_sensitive
		end

	last_selected_root_node: like tree_node_anchor
			-- The `last_selected_root_node' of library list.

	last_lib_list: detachable HASH_TABLE [ES_CONF_SYSTEM_REF, UUID]
			-- The `last_lib_list' sent with the `last_selected_root_node' of library list.

	last_refresh_agent: detachable PROCEDURE
			-- The `last_refresh_agent' sent with the `last_selected_root_node' of library list.

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
