note
	description: "Representation of a {CONF_SYSTEM} GUI Grid."
	purpose_and_design: "See end-of-class notes."

class
	EG_SYSTEM_WIDGET

inherit
	EG_WIDGET
		rename
			item as system
		end

	CONF_ACCESS

feature -- Access

	widget: JV_GRID
			--<Precursor>
			-- A grid `widget' to display <system>.
		once ("OBJECT")
			create Result
			Result.enable_tree
			Result.enable_row_colorizing
			Result.disable_row_separators
			Result.disable_row_height_fixed
		end

	render
			--<Precursor>
		local
			l_row,
			l_target_row,
			l_capability_row: EV_GRID_ROW
			l_label: EV_GRID_LABEL_ITEM
			l_visitor: CONF_PRINT_VISITOR
		do
			widget.wipe_out

			add_row (Void, "System:", system.name, system.description)
			l_row := widget.row (1)

			across
				system.targets as ic
			loop
				add_row (l_row, "Target:", ic.item.name.out, ic.item.description)
				l_target_row := widget.row (widget.row_count)
				if attached {CONF_VERSION} ic.item.version as al_version then
					add_row (l_target_row, "Version:", al_version.version, "(major.minor.release.build)")
				end
				if attached ic.item.settings as al_settings then
					across
						al_settings as ic_settings
					loop
						add_row (l_target_row, "Setting", ic_settings.item, "?")
					end
				end
				if not ic.item.Known_capabilities.is_empty then
					add_row (l_target_row, "Capability", "", Void)
					l_capability_row := widget.row (widget.row_count)
					across
						ic.item.Known_capabilities as ic_capabilities
					loop
						add_row (l_capability_row, ic_capabilities.item, "?", "?")
					end
				end
			end

			create l_visitor.make
			system.configuration.process (l_visitor)
			add_row (l_row, "Text", l_visitor.text, "Output of current System as XML")

			widget.column (1).header_item.set_text ("Key")
			widget.column (1).set_width (200)
			widget.column (2).header_item.set_text ("Value")
			widget.column (2).set_width (300)
			widget.column (3).header_item.set_text ("Description")
			widget.column (3).set_width (500)
			across
				1 |..| (widget.row_count) as ic
			loop
				widget.row (ic.item).expand
			end
			widget.refresh_now
		end

	add_row (a_row: detachable EV_GRID_ROW; a_label, a_value: STRING; a_description: detachable READABLE_STRING_GENERAL)
			--
		local
			l_subrow: EV_GRID_ROW
			l_desc: STRING
			l_item: EV_GRID_LABEL_ITEM
		do
			create l_desc.make_empty
			if attached a_row then
				widget.set_row_count_to (widget.row_count + 1)
				l_subrow := widget.row (widget.row_count)
				a_row.add_subrow (l_subrow)
				l_subrow.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (a_label))
				create l_item.make_with_text (a_value)
				l_item.select_actions.extend (agent on_label_click (l_item))
				l_subrow.set_item (2, l_item)
				if attached a_description as al_desc then
					l_desc := al_desc.out
				end
				l_subrow.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_desc))
			else
				widget.set_item (1, 1, create {EV_GRID_LABEL_ITEM}.make_with_text (a_label))
				widget.set_item (2, 1, create {EV_GRID_LABEL_ITEM}.make_with_text (a_value))
				if attached a_description as al_desc then
					l_desc := al_desc.out
				end
				widget.set_item (3, 1, create {EV_GRID_LABEL_ITEM}.make_with_text (l_desc))
			end
		end

	on_label_click (l_item: EV_GRID_LABEL_ITEM)
		local
			l_row: EV_GRID_ROW
		do
			l_item.row.set_height (l_item.text_height)
		end

	set_item (a_item: attached like system)
		do
			item_internal := a_item
		end

	item_internal: detachable ES_CONF_SYSTEM_REF
			--<Precursor>

	new_system (a_window: EG_MAIN_WINDOW)
		local
			l_factory: CONF_PARSE_FACTORY

			l_system: CONF_SYSTEM
			l_target,
			l_test_target: CONF_TARGET
			l_target_option: CONF_TARGET_OPTION
			l_root: CONF_ROOT
			l_target_settings: CONF_TARGET_SETTINGS
			l_library: CONF_LIBRARY
			l_cluster: CONF_CLUSTER
			l_file_rule: CONF_FILE_RULE
			l_note: CONF_NOTE_ELEMENT

			l_visitor: CONF_PRINT_VISITOR

			l_file_name,
			l_name,
			l_namespace,
			l_target_name: STRING

			l_save_as: EV_FILE_SAVE_DIALOG
			l_list: LIST [STRING]
		do
			create l_factory

			create l_save_as.make_with_title ("New ECF")
			l_save_as.filters.extend (["ecf", "Eiffel Configuration File"])
			l_save_as.show_modal_to_window (a_window)

			if not l_save_as.file_name.is_empty then
				l_file_name := l_save_as.file_name
				if l_file_name.count >= 5 and l_file_name.substring (l_file_name.count - 3, l_file_name.count).same_string ("ecf") then
					do_nothing
				else
					l_file_name.append_string_general (".ecf")
				end
				l_name := (l_file_name.split ('.') [1])
				l_list := l_name.split ({OPERATING_ENVIRONMENT}.Directory_separator)
				l_name := l_list [l_list.count]
				l_namespace := l_factory.Namespace_1_21_0
				l_target_name := l_name.twin

				l_system := l_factory.new_system_generate_uuid_with_file_name (l_file_name, l_name, l_namespace)
					-- Library Target
				l_target := l_factory.new_target (l_target_name, l_system)
				l_target.set_description ("library target")
				l_target.set_version (create {CONF_VERSION}.make_version (1, 0, 0, 0))
				l_target.add_capability ("void_safety", "transitional")
				l_target.add_capability ("concurrency", "none")
				l_system.add_target (l_target)
					-- Test Target
				l_test_target := l_factory.new_target ("test", l_system)
				l_test_target.set_description ("test target")
				create l_target_option.make_19_05
				l_target_option.set_description ("test target")
				l_test_target.set_options (l_target_option)
				l_test_target.set_parent (l_target)
				l_system.add_target (l_test_target)

				create l_visitor.make
				l_system.process (l_visitor)

				create item_internal.make (l_system)
			end

		end

;note
	purpose: "[

		]"
	design: "[

		]"

end
