note
	description: "[
					{ABSTRACT_JV_PRINT_DIALOG} abstracts funtionality needed for printing PDFs.
				]"
	how: "[
					Feature `print_pdf' print the file located at its argument at least once, 
					but no more than `maximum_number_of_copies'.  The command is built upon the argument,
					with replacement tags replaced for file name and printer name.
			]"
	author: ""
	date: "$Date: 2015-10-26 16:39:52 -0400 (Mon, 26 Oct 2015) $"
	revision: "$Revision: 12545 $"

deferred class
	ABSTRACT_JV_PRINT_DIALOG

feature {NONE} -- Initialization

	make_with_pdf_file_name_and_printer_executable_path (a_pdf_file_name, a_printer_command: STRING_32)
			-- Initialize Current to print PDF at `a_pdf_file_name' using `a_printer_command'.
		require
			valid_file_suffix: a_pdf_file_name.ends_with (".pdf")
		do
			default_create
			printer_command := a_printer_command
			print_actions.extend (agent print_pdf (a_pdf_file_name))
		end

feature -- Access

	printer_name: STRING_32
			-- Name of selected printer.
		deferred
		end

	server_name: STRING_32
			-- Name of server for selected printer.
		deferred
		end

	printer_command: STRING_32
			-- Command to be used to print PDFs in `print_pdf'.
		attribute
			create Result.make_empty
		end

	print_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions run on print request.
		deferred
		end

	printers: ARRAYED_LIST [STRING_32]
			-- All printer contained in Current.
		deferred
		end

	set_selected_printer_name (a_name: READABLE_STRING_GENERAL)
			-- Sets the selected printer by `a_name'.
		deferred
		end

	copies: INTEGER
			-- Number of copies to print.
		deferred
		end

feature -- Status Report

	is_valid_printer_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_name' a valid (accessible) printer name?
		do
			Result := across printers as ic_printers some ic_printers.item.same_string_general (a_name) end
		end

	quoted_printer_name: STRING_32
			-- If not `printer_name' is empty, return `printer_name' surrounded with doubled quotes.
		local
			l_printer_name: like printer_name
		do
			create Result.make_empty
			l_printer_name := printer_name
			if not l_printer_name.is_empty then
				Result.extend ('"')
				Result.append_string_general (l_printer_name)
				Result.extend ('"')
			end
		end

	quoted_server_name: STRING_32
			-- If not `server_name' is empty, return `server_name' surrounded with doubled quotes.
		local
			l_server_name: like server_name
		do
			create Result.make_empty
			l_server_name := server_name
			if not l_server_name.is_empty then
				Result.extend ('"')
				Result.append_string_general (l_server_name)
				Result.extend ('"')
			end
		end

feature {JV_PRINT_DIALOG_TEST} -- Implementation

	print_pdf (a_pdf_file_name: STRING_32)
			-- Prints PDF at `a_pdf_file_name'.
		local
			l_execution_environment: EXECUTION_ENVIRONMENT
			l_command: STRING_32
		do
			create l_execution_environment
			l_command := print_command_for_file_name (a_pdf_file_name)
			-- Prints at least 1, but no more than `maximum_number_of_copies'.
			across 1 |..| copies.min (maximum_number_of_copies).max (1) as ic_copies loop
				l_execution_environment.launch (l_command)
			end
		end

	print_command_for_file_name (a_pdf_file_name: STRING_32): STRING_32
			-- Returns string value for print command for `printer_command' and `a_pdf_file_name'.
		do
			create Result.make_from_string_general (printer_command)
			Result.replace_substring_all (file_name_tag, a_pdf_file_name)
			Result.replace_substring_all (printer_name_tag, printer_name)
			Result.replace_substring_all (server_name_tag, server_name)
		end

feature {JV_PRINT_DIALOG_TEST} -- Implementation: Constants

	file_name_tag: STRING = "<<file_name>>"

	printer_name_tag: STRING = "<<printer_name>>"

	server_name_tag: STRING = "<<server_name>>"

	maximum_number_of_copies: INTEGER = 5

end
