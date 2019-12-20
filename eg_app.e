note
	description: "ECF Generator App"

class
	EG_APP

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			--
		local
			l_start,
			l_end: DATE_TIME
		do
			print ("Instance @19.05%N")
			create instance.make ("19.05")
			print ("searching EIFFEL_SRC ...%N")
			create l_start.make_now
			estudio_src_libs_test
			print ("libs: " + instance.eiffel_src_libs.count.out + "%N")
			create l_end.make_now
			print ("TIME: " + (l_end.fine_second - l_start.fine_second).out + "%N")

			print ("searching GITHUB ...%N")
			create l_start.make_now
			github_libs_test
			print ("libs: " + instance.github_libs.count.out + "%N")
			create l_end.make_now
			print ("TIME: " + (l_end.fine_second - l_start.fine_second).out + "%N")
		end

feature {NONE} -- Implementation

	estudio_src_libs_test
			-- Tests about EIFFEL_SRC libraries
		do
			instance.Load_eiffel_src_libs (instance.eiffel_src_libs)
		end

	github_libs_test
			-- Tests about GITHUB libraries
		do
			instance.Load_github_libs (instance.github_libs)
		end

	instance: separate ES_INSTANCE
			--

end
