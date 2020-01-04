note
	description: "Images available to all"

class
	EG_IMG_CONSTANTS

feature -- Access

	img_system: EV_PIXMAP once Result := (create {IMG_SYSTEM}.make).to_pixmap end
	img_target: EV_PIXMAP once Result := (create {IMG_TARGET}.make).to_pixmap end
	img_assertions: EV_PIXMAP once Result := (create {IMG_ASSERTIONS}.make).to_pixmap end
	img_groups: EV_PIXMAP once Result := (create {IMG_GROUPS}.make).to_pixmap end
	img_libraries: EV_PIXMAP once Result := (create {IMG_LIBRARIES}.make).to_pixmap end
	img_library: EV_PIXMAP once Result := (create {IMG_LIBRARY}.make).to_pixmap end
	img_advanced: EV_PIXMAP once Result := (create {IMG_ADVANCED}.make).to_pixmap end
	img_debug: EV_PIXMAP once Result := (create {IMG_DEBUG}.make).to_pixmap end
	img_externals: EV_PIXMAP once Result := (create {IMG_EXTERNALS}.make).to_pixmap end
	img_tasks: EV_PIXMAP once Result := (create {IMG_TASKS}.make).to_pixmap end
	img_type_mapping: EV_PIXMAP once Result := (create {IMG_TYPE_MAPPING}.make).to_pixmap end
	img_variables: EV_PIXMAP once Result := (create {IMG_VARIABLES}.make).to_pixmap end
	img_warnings: EV_PIXMAP once Result := (create {IMG_WARNINGS}.make).to_pixmap end
	img_github: EV_PIXMAP once Result := (create {IMG_GITHUB_SMALL}.make).to_pixmap end
	img_vav_16: EV_PIXMAP once Result := (create {IMG_VAV_16}.make).to_pixmap end
	img_stick_man_16: EV_PIXMAP once Result := (create {IMG_STICK_MAN_16}.make).to_pixmap end

	img_16_x_16: EV_PIXMAP once Result := (create {IMG_16_X_16}.make).to_pixmap end

	img_filter: EV_PIXMAP once Result := img_16_x_16.sub_pixmap (create {EV_RECTANGLE}.make (base_mult * 3, base_mult * 16, base_size, base_size)) end
	img_eiffel_src: EV_PIXMAP once Result := img_16_x_16.sub_pixmap (create {EV_RECTANGLE}.make (base_mult * 2, base_mult * 4, base_size, base_size)) end
	img_unstable: EV_PIXMAP once Result := img_16_x_16.sub_pixmap (create {EV_RECTANGLE}.make (base_mult * 20, base_mult * 4, base_size, base_size)) end
	img_duplicate: EV_PIXMAP once Result := img_16_x_16.sub_pixmap (create {EV_RECTANGLE}.make (base_mult * 21, base_mult * 4, base_size, base_size)) end
	img_anchor: EV_PIXMAP once Result := img_16_x_16.sub_pixmap (create {EV_RECTANGLE}.make (base_mult * 14, base_mult * 17, base_size, base_size)) end

	base_size: INTEGER = 17
	base_mult: INTEGER = 17

end
