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

	EG_SYSTEM_PROCESSOR

feature -- Settings

	set_system (a_ref: ES_CONF_SYSTEM_REF)
			--
		do
			set_item (a_ref)
		end

feature -- Access

	widget: VE_GRID
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
			l_xml: STRING_32
		do
			widget.wipe_out

			add_row (Void, "System:", system.name, system.description)
			l_row := widget.row (1)

			across
				system.targets as ic
			loop
				add_row (l_row, "Target:", ic.item.name.out, ic.item.description)
				l_target_row := widget.row (widget.row_count)
					-- <cersion>
				if attached {CONF_VERSION} ic.item.version as al_version then
					add_row (l_target_row, "Version:", al_version.version.to_string_8, "(major.minor.release.build)")
				end
					-- <settings>
				render_settings (l_target_row, ic.item.settings)
					-- <capabilities>
				render_capabilities (l_target_row, ic.item.Known_capabilities, ic.item.internal_options)
					-- <library> items
				across
					ic.item.internal_libraries as ic_libs
				loop
					add_row (l_target_row, ic_libs.item.name.to_string_8, ic_libs.item.location.evaluated_directory.name.out, "")
				end
			end
				-- Render `system' as XML text
			create l_visitor.make
			system.configuration.process (l_visitor)
			l_xml := l_visitor.text
			l_xml.replace_substring_all ("%T", {STRING_32} "   ")
			add_row (l_row, "Text", l_xml.to_string_8, "Output of current System as XML")
			check attached last_added_value_item as al_item then
				al_item.select_actions.extend (agent on_system_xml_label_click (al_item))
			end

				-- Add grid column headers
			widget.column (1).header_item.set_text ("Key")
			widget.column (1).set_width (200)
			widget.column (2).header_item.set_text ("Value")
			widget.column (2).set_width (300)
			widget.column (3).header_item.set_text ("Description")
			widget.column (3).set_width (500)

				-- Expand everything
			across
				1 |..| (widget.row_count) as ic
			loop
				widget.row (ic.item).expand
			end
			widget.refresh_now
		end

	render_settings (a_target_row: EV_GRID_ROW; a_settings: detachable STRING_TABLE [READABLE_STRING_32])
			--
		local
			l_subrow: EV_GRID_ROW
		do
			if attached a_settings as al_settings then
				add_row (a_target_row, "Settings", "", Void)
				l_subrow := widget.row (widget.row_count)
				across
					al_settings as ic_settings
				from
					al_settings.start
				loop
					ic_settings.item.do_nothing
					add_row (l_subrow, al_settings.key_for_iteration.out, ic_settings.item.to_string_8, Void)
					al_settings.forth
				end
			end
		end

	render_capabilities (a_target_row: EV_GRID_ROW; a_known_capabilities: SEARCH_TABLE [STRING_8]; a_internal_options: detachable CONF_TARGET_OPTION)
			-- `render_capabilities' against `a_target_row', based on `a_known_capabilities'
			--	and `a_internal_options'
		local
			l_capability_row: EV_GRID_ROW
		do
			if not a_known_capabilities.is_empty then
				add_row (a_target_row, "Capability", "", Void)
				l_capability_row := widget.row (widget.row_count)
				across
					a_known_capabilities as ic_capabilities
				loop
					if
						ic_capabilities.item.same_string ("concurrency") and then
						attached a_internal_options as al_opts and then
						not al_opts.concurrency.item.is_empty
					then
						add_row (l_capability_row, ic_capabilities.item.to_string_8, al_opts.concurrency.item.to_string_8, "")
					end
					if
						ic_capabilities.item.same_string ("void_safety") and then
						attached a_internal_options as al_opts and then
						not al_opts.void_safety.item.is_empty
					then
						add_row (l_capability_row, ic_capabilities.item.to_string_8, al_opts.void_safety.item.to_string_8, "")
					end
				end
			end
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
				l_subrow.set_item (2, l_item)
				last_added_value_item := l_item
				if attached a_description then
					l_desc := a_description.out
				end
				l_subrow.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_desc))
			else
				widget.set_item (1, 1, create {EV_GRID_LABEL_ITEM}.make_with_text (a_label))
				create l_item.make_with_text (a_value)
				widget.set_item (2, 1, l_item)
				last_added_value_item := l_item
				if attached a_description then
					widget.set_item (3, 1, create {EV_GRID_LABEL_ITEM}.make_with_text (a_description.out))
				end
			end
			last_added_row := widget.row (widget.row_count)
		end

	last_added_row: detachable EV_GRID_ROW
			-- What was the `last_added_row' reference (if any)?

	last_added_value_item: detachable EV_GRID_LABEL_ITEM
			-- What was the `last_added_value_item' (if any)?

	on_system_xml_label_click (a_item: EV_GRID_LABEL_ITEM)
			-- Refresh the XML and form the text of `l_item'
		local
			l_row: EV_GRID_ROW
			l_visitor: CONF_PRINT_VISITOR
			l_xml: STRING_32
		do
			create l_visitor.make
			system.configuration.process (l_visitor)
			l_xml := l_visitor.text
			l_xml.replace_substring_all ("%T", {STRING_32} "   ")
			a_item.set_text (l_xml)
			a_item.row.set_height (a_item.text_height)
			a_item.redraw
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

			l_file_name,
			l_system_name,
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
				if application.Estudio.estudio_libs.is_empty then
					application.Estudio.load_estudio_libs
					a_window.set_ready_status
				end
					-- Build the `l_file_name' ...
				l_file_name := l_save_as.file_name.to_string_8
				if l_file_name.count >= 5 and l_file_name.substring (l_file_name.count - 3, l_file_name.count).same_string ("ecf") then
					do_nothing -- the file name extension is already "ecf"
				else
					l_file_name.append_string_general (".ecf")
				end

					-- Extract the `l_name' from the `l_file_name' ...
				l_system_name := l_file_name.split ('.') [1]
				l_list := l_system_name.split ({OPERATING_ENVIRONMENT}.Directory_separator)
				l_system_name := l_list [l_list.count]

					-- Build the `l_namespace' and `l_target_name'
				l_namespace := l_factory.Namespace_1_21_0.to_string_8
				l_target_name := l_system_name.twin

					-- Make the `l_system'
				l_system := l_factory.new_system_generate_uuid_with_file_name (l_file_name, l_system_name, l_namespace)

					-- Library Target
				l_target := l_factory.new_target (l_target_name, l_system)
				l_target.set_description ("library target")
				l_target.set_version (create {CONF_VERSION}.make_version (1, 0, 0, 0))
				l_target.add_capability ("void_safety", "transitional")
				l_target.add_capability ("concurrency", "none")
				l_library := l_factory.new_library ("base", library_location (a_window, "base.ecf"), l_target)
				l_target.add_library (l_library)
				l_system.add_target (l_target)

					-- Test Target
				l_test_target := l_factory.new_target ("test", l_system)
				l_test_target.set_description ("test target")
				create l_target_option.make_19_05
				l_target_option.set_description ("test target")
				l_test_target.set_options (l_target_option)
				l_test_target.set_parent (l_target)
				l_library := l_factory.new_library ("testing", library_location (a_window, "testing.ecf"), l_target)
				l_test_target.add_library (l_library)
				l_system.add_target (l_test_target)

				l_system.process (create {CONF_PRINT_VISITOR}.make)

				create item_internal.make (l_system)
			end
		end

	library_location (a_window: EG_MAIN_WINDOW; a_name: STRING): STRING
			-- The `library_location' of a library named `a_name'.
		do
			check has_lib: attached a_window.application.Estudio.estudio_libs_by_name.item (a_name) as al_system then
				Result := al_system.configuration.file_path.name.out
			end
		end

;note
	purpose: "[

		]"
	design: "[

		]"

end
