note
	description: "[
		Represenation of a {PROCESS_HELPER}.
		]"
	purpose_and_design: "See end-of-class notes"

class
	PROCESS_HELPER

feature -- Status Report

	has_file_in_path (a_name: STRING): BOOLEAN
			-- `has_file_in_path' as `a_name'?
		local
			l_result,
			l_msg: STRING
		do
			l_msg := dos_where_not_found_message.twin
			l_result := output_of_command ("where " + a_name, ".")
			Result := not l_result.same_string (l_msg) xor {PLATFORM}.is_unix
		end

feature -- Basic Operations

	last_error: INTEGER

	output_of_command (a_command_line: READABLE_STRING_32; a_directory: detachable READABLE_STRING_32): STRING_32
                -- `output_of_command' `a_command_line' launched in `a_directory' (e.g. "." = Current directory).
		require
			cmd_not_empty: not a_command_line.is_empty
			dir_not_empty: attached a_directory as al_dir implies not al_dir.is_empty
		local
			l_process: BASE_PROCESS
			l_buffer: SPECIAL [NATURAL_8]
			l_result: STRING_32
			l_args: ARRAY [STRING_32]
			l_cmd: STRING_32
			l_list: LIST [READABLE_STRING_32]
		do
			create Result.make_empty
			l_list := a_command_line.split (' ')
			l_cmd := l_list [1]
			if l_list.count >= 2 then
				create l_args.make_filled ({STRING_32} "", 1, l_list.count - 1)
				across
					2 |..| l_list.count as ic
				loop
					l_args.put (l_list [ic.item], ic.item - 1)
				end
			end
			l_process := (create {BASE_PROCESS_FACTORY}).process_launcher (l_cmd, l_args, a_directory)
			l_process.set_hidden (True)
			l_process.redirect_output_to_stream
			l_process.redirect_error_to_same_as_output
			l_process.launch
			if l_process.launched then
				from
					create l_buffer.make_filled (0, 512)
				until
					l_process.has_output_stream_closed or else l_process.has_output_stream_error
				loop
					l_buffer := l_buffer.aliased_resized_area_with_default (0, l_buffer.capacity)
					l_process.read_output_to_special (l_buffer)
					l_result := converter.console_encoding_to_utf32 (console_encoding, create {STRING_8}.make_from_c_substring ($l_buffer, 1, l_buffer.count))
					l_result.prune_all ({CHARACTER_32} '%R')
					Result.append (l_result)
				end
				l_process.wait_for_exit
			end
		end

	launch_fail_handler (a_result: STRING)
		do
			last_error_result := a_result
		end

	last_error_result: detachable STRING

feature -- Status Report: Wait for Exit

	is_not_wait_for_exit: BOOLEAN

	is_wait_for_exit: BOOLEAN
		do
			Result := not is_not_wait_for_exit
		end

	set_do_not_wait_for_exit
		do
			is_not_wait_for_exit := True
		end

	set_wait_for_exit
		do
			is_not_wait_for_exit := False
		end

feature {NONE} -- Code page conversion

	converter: LOCALIZED_PRINTER
			-- Converter of the input data into Unicode.
		once
			create Result
		end

	console_encoding: ENCODING
			-- Current console encoding.
		once
			Result := (create {SYSTEM_ENCODINGS}).console_encoding
		end

feature {TEST_SET_BRIDGE} -- Implementation: Constants

	DOS_where_not_found_message: STRING = "INFO: Could not find files for the given pattern(s).%N"

;note
	design: "[
		These "helper" features are designed to assist with
		use of the {PROCESS_IMP} and {PROCESS_FACTORY}.
		]"

end
