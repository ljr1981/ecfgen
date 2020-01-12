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
			default_create
			logger.write_information ("EG_APPLICATION.make")
			estudio.do_nothing
			code_analyzer.do_nothing

			main_window.build_menu_bar
			post_launch_actions.extend (agent main_window.show)
			main_window.close_request_actions.extend (agent destroy)

			launch
		end

feature {NONE} -- Implementation

	main_window: EG_MAIN_WINDOW
			-- Main window reference.
		once
			create Result.make_with_title ("ECF Generatiom Wizard")
		end

feature -- Access

	estudio: ES_INSTANCE
			-- Instance of `estudio' interface.
		once
			create Result.make_for_latest
		end

	logger: LOG_LOGGING_FACILITY
			--
		once
			create Result.make
			Result.enable_default_file_log
			Result.write_information ("Logging started%N")
		end

	docs: detachable EG_DOCS

	code_analyzer: EG_LINT
			-- A `code_analyzer' for Current.
		note
			purpose: "[
				We want a couple of things:
				
				1. We want to know that a library will compile without 
					necessarily bringing it in to ES to verify that it 
					does in fact compile.
				2. For display purposes, we want to ID: Class, Feature, Contracts
					in a tree-view format to facilitate our user exploring and
					discovering. Remember: The user will have the power to form
					up a new ECF together with WrapC bits added in, so we want
					our user to have everything they need to properly explore
					the ECF-universe around them and bring in useful parts.
				]"
		attribute
			create Result.make
		end

;note
	purpose: "[

		]"
	design: "[

		]"

end
