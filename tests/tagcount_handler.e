note
	description: "For Test Purposes Only"

class
	TAGCOUNT_HANDLER

inherit
	XM_CALLBACKS_NULL
		redefine
			on_start,
			on_start_tag
		end

create

	make

feature -- Events

	on_start
			--<Precursor>
			-- Reset tag count.
		do
			count := 0
		end

	on_start_tag (a_namespace: STRING; a_prefix: STRING; a_local_part: STRING)
			--<Precursor>
			-- Count start tags.
		do
			count := count + 1
		end

feature -- Access

	count: INTEGER
			-- Number of tags detected.

end
