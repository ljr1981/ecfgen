note
	description: "ECF Generator GUI Application"

class
	EG_APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create application
			create main_window.make_with_title ("ECF Generator Wizard")
			main_window.build_menu_bar

			application.post_launch_actions.extend (agent main_window.show)
			main_window.close_request_actions.extend (agent application.destroy)

			application.launch
		end

feature {NONE} -- Implementation

	application: EV_APPLICATION

	main_window: EG_MAIN_WINDOW

end
