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
		do
			print ("Instance @19.05%N")
			create instance.make ("19.05")
			print ("searching EIFFEL_SRC ...%N")
			estudio_src_libs_test
			print ("libs: " + instance.estudio_libs.count.out + "%N")
			print ("searching GITHUB ...%N")
			github_libs_test
			print ("libs: " + instance.github_libs.count.out + "%N")
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

	instance: ES_INSTANCE
			--

end
