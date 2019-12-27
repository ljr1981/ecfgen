note
	description: "ECF Generator GUI Application"
	purpose_and_design: "See end-of-class notes"

class
	EG_APPLICATION

inherit
	EV_APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization of Current `application'.
		do
			create main_window.make_with_title ("ECF Generatiom Wizard")
			default_create
			main_window.build_menu_bar

			post_launch_actions.extend (agent main_window.show)
			main_window.close_request_actions.extend (agent destroy)

			launch
		end

feature {NONE} -- Implementation

	main_window: EG_MAIN_WINDOW
			-- Main window reference.

;note
	purpose: "[

		]"
	design: "[

		]"

end
