note
	description: "Application Preferences"
	purpose_and_design: "See end-of-class notes."

deferred class
	EG_PREFS

feature {EG_MAIN_WINDOW} -- Initialization

	initialize_standard_preferences
			-- Initialize preferences using standard manager, factory and preference types.
		local
				-- Standard
			l_factory: GRAPHICAL_PREFERENCE_FACTORY
			l_manager: PREFERENCE_MANAGER
			br: BOOLEAN_PREFERENCE
			ir: INTEGER_PREFERENCE
			ar: ARRAY_PREFERENCE
			sr: STRING_PREFERENCE
			sr32: STRING_32_PREFERENCE
			fr: FONT_PREFERENCE
			cr: COLOR_PREFERENCE
			pp: PATH_PREFERENCE
			lst_s: STRING_LIST_PREFERENCE
			lst_p: PATH_LIST_PREFERENCE
			choice_s: STRING_CHOICE_PREFERENCE
			choice_p: PATH_CHOICE_PREFERENCE
			df: EV_FONT
			psf: EG_PREFS_STORAGE_FACTORY
			l_standard_preferences: like standard
		do
			create l_factory
			create psf

			--| Use file default.conf to load default values
			create l_standard_preferences.make_with_defaults_and_storage (<<"default.conf">>, psf.storage_for_basic)
			standard := l_standard_preferences

			create df.make_with_values (1, 6, 10, 8)
			df.preferred_families.extend ("verdana")
			df.preferred_families.extend ("arial")
			df.preferred_families.extend ("helvetica")

			--| preference under "display"
			l_manager := l_standard_preferences.new_manager ("display")
				br := l_factory.new_boolean_preference_value (l_manager, "display.fullscreen_at_startup", True)
				br.set_description ("Ought the application be displayed at full-screen resolution upon application startup?")
				cr := l_factory.new_color_preference_value (l_manager, "display.background_color", create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
				cr.set_description ("Application window background color preference.")

			--| Path location preferences
			l_manager := l_standard_preferences.new_manager ("locations")
				if attached window.estudio.Install_directory as al_install_directory then
					pp := l_factory.new_path_preference_value (l_manager, "locations.eiffel_studio", al_install_directory.path)
					pp.set_description ("Path to the latest installation of EiffelStudio.")
				end

			--| Blacklisted ECFs
			l_manager := l_standard_preferences.new_manager ("blacklist")
				lst_s := l_factory.new_string_list_preference_value (l_manager, "blacklist.blacklisted_ecfs", window.estudio.other_blacklisters)
				lst_s.set_description ("A CSV list of ECF files from any location that you do not want processed by this Wizard or available to be used for any reason.%NEXAMPLE: this.ecf,that.ecf,my.ecf,your.ecf")

			--| User Defined ECF folders
			l_manager := l_standard_preferences.new_manager ("user_defined")
				lst_p := l_factory.new_path_list_preference_value (l_manager, "user_defined.list.paths", <<>>)
				lst_p.set_description ("A CSV list of paths to folders you want searched and available for ECF inclusion and selection.")

--			--| Basic preferences under "examples"
--			l_manager := l_standard_preferences.new_manager ("examples")
--				ir := l_factory.new_integer_preference_value (l_manager, "examples.my_integer", 10)
--				ar := l_factory.new_array_preference_value (l_manager, "examples.my_list", <<"1","2","3">>)
--				ar := l_factory.new_array_preference_value (l_manager, "examples.my_list_as_choice", <<"1","2","3">>)
--				ar.set_is_choice (True)
--				if ar.selected_index = 0 then
--					ar.set_selected_index (2)
--				end

--				--| Graphical preferences under "examples"

--				fr := l_factory.new_font_preference_value (l_manager, "examples.my_font_preference", df)
--				sr := l_factory.new_string_preference_value (l_manager, "examples.my_string_preference", "a string")
--				sr := l_factory.new_string_preference_value (l_manager, "examples.driver_location", (create {DIRECTORY_NAME}.make_from_string ("C:\My Directory Location")).string)


--				--| List and Choice of strings preferences under "examples"
--				lst_s := l_factory.new_string_list_preference_value (l_manager, "examples.list.strings", <<{STRING_32} "你", {STRING_32} "好", {STRING_32} "吗">>)
--				choice_s := l_factory.new_string_choice_preference_value (l_manager, "examples.choice.strings", lst_s.value)
--				if choice_s.selected_index = 0 then
--					choice_s.set_selected_index (2)
--				end

--				--| List and Choice of Paths preferences under "examples"
--				lst_p := l_factory.new_path_list_preference_value (l_manager,
--						"examples.list.paths",
--						<<	create {PATH}.make_from_string ({STRING_32} "dir/你"), -- you
--							create {PATH}.make_from_string ({STRING_32} "dir/好"), -- okay
--							create {PATH}.make_from_string ({STRING_32} "dir/吗")  -- ?
--						>>
--					)
--				choice_p := l_factory.new_path_choice_preference_value (l_manager, "examples.choice.paths", lst_p.value)
--				if choice_p.selected_index = 0 then
--					choice_p.set_selected_index (2)
--				end

--				--| Unicode,Path, ... value preferences under "examples"
--				sr32 := l_factory.new_string_32_preference_value (l_manager, "examples.unicode.string_32", {STRING_32} "a unicode string 你好吗")
--				pp := l_factory.new_path_preference_value (l_manager, "examples.my_path", create {PATH}.make_from_string ({STRING_32} "C:\unicode\folder\你好吗\here"))

--				pp := l_factory.new_path_preference_value (l_manager, "examples.valid.existing_directory", (create {EXECUTION_ENVIRONMENT}).current_working_path)
--				pp.require_existing_directory

--			--| preference under "graphics"
--			l_manager := l_standard_preferences.new_manager ("graphics")
--				br := l_factory.new_boolean_preference_value (l_manager, "graphics.use_maximum_resolution", True)

			l_standard_preferences.export_to_storage (create {PREFERENCES_STORAGE_XML}.make_with_location ("backup.conf"), False)
		end

feature -- Access

	standard: detachable PREFERENCES
			-- Application `standard' {PREFERENCES}.

	preference_window: detachable PREFERENCES_GRID_DIALOG
			-- The default preference interface widget

	window: EG_MAIN_WINDOW
			-- The main window reference
		deferred
		end

	preferences: EG_PREFS
		once
			Result := Current
		end

feature -- Operations

	show_modal_to (a_main_window: EG_MAIN_WINDOW)
			-- Show preference window basic view
		local
			w: like preference_window
		do
			initialize_standard_preferences
			if attached standard as p then
				create w.make (p)
				preference_window := w
				w.show_modal_to_window (a_main_window)
			else
				check standard_preferences_exists: False end
			end
		end

;note
	purpose: "[
		The goal is to have a class that encloses all application
		preferences needed by the application and the user. The
		scope is wide-ranging--that is--we want a place where the
		user can not only store preferences about how the application
		works, but also preferences on their local ECF generation
		process and WrapC preferences (e.g. C-compiler and so on).
		]"
	design: "[
		See the EIS (below) for basic information about Preference library.
		
		1. Initialize the preferences (defaults, user, and so on) @ startup.
		2. Provide a reference to `standard' preferences.
		3. Provide a reference to a `preference_window' to use app-wide.
		4. Provide an app-wide means of showing the `preference_window'.
		]"
	EIS: "name=preference_library_docs", "src=https://www.eiffel.org/doc/solutions/Preferences"

end
