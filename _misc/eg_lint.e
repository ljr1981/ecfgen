note
	description: "Version of GELINT for non-cmd-prompt use."

class
	EG_LINT

inherit
	GELINT
		redefine
			execute
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create target_option.make (' ', " ")
			create version_flag.make (' ', " ")
			create thread_option.make (' ', " ")
			create variable_option.make (' ', " ")
			create capability_option.make (' ', " ")
			create setting_option.make (' ', " ")
			create catcall_flag.make (' ', " ")
			create noflatdbc_flag.make (' ', " ")
			create flat_flag.make (' ', " ")
			create ecma_flag.make (' ', " ")
			create ise_option.make (' ', " ")
			create silent_flag.make (' ', " ")
			create metrics_flag.make (' ', " ")
			create no_benchmark_flag.make (' ', " ")
			create nested_benchmark_flag.make (' ', " ")
			create verbose_flag.make (' ', " ")
			create ecf_filename.make_empty
			execute
		end

	execute
			--<Precursor>
		do
			Arguments.set_program_name ("gelint")
				-- For compatibility with ISE's tools, define the environment
				-- variable "$ISE_LIBRARY" to $ISE_EIFFEL" if not set yet.
			ise_variables.set_ise_library_variable
			create error_handler.make_standard
				-- Manually set arguments, except `ecf_filename'.
--			parse_arguments
				--usage: gelint [--target=target_name] [--verbose] [--no-benchmark]
				--              [--nested-benchmark] [--metrics] [--silent]
				--              [--ise[=major[.minor[.revision[.build]]]]] [--ecma] [--flat]
				--              [--noflatdbc] [--catcall] [--setting=name=value]
				--              [--capability=name=value] [--variable=NAME=VALUE] ecf_filename
				--       gelint [-V]
				--       gelint [-h]
		end

feature -- Settings

	set_file_and_process (a_file_name: STRING)
			--
		require
			has_ecf: attached ecf_filename and then not ecf_filename.is_empty
		local
			l_filename: STRING
			l_file: KL_TEXT_INPUT_FILE
		do
			create ecf_filename.make_from_string (a_file_name)
			l_filename := ecf_filename
			create l_file.make (l_filename)
			l_file.open_read
			if l_file.is_open_read then
				last_system := Void
				parse_ecf_file (l_file)
				l_file.close
				if attached last_system as l_last_system then
					process_system (l_last_system)
					debug ("stop")
						std.output.put_line ("Press Enter...")
						io.read_line
					end
					if error_handler.has_eiffel_error then
						Exceptions.die (2)
					elseif error_handler.has_internal_error then
						Exceptions.die (5)
					end
				else
					Exceptions.die (3)
				end
			else
				report_cannot_read_error (l_filename)
				Exceptions.die (1)
			end
		rescue
			Exceptions.die (4)
		end

end
