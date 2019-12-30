note
	description: "An Entity that knows how to update Progress"

class
	EG_PROGRESS_UPDATER

create
	make

feature {NONE} -- Initialization

	make (a_start, a_end, a_estimated: INTEGER; a_progress_bar: like progress_bar)
			--
		do
			start_percent := a_start
			end_percent := a_end
			estimated_item_count := a_estimated
			progress_bar := a_progress_bar
		ensure
			start_set: start_percent = a_start
			end_set: end_percent = a_end
			estimated_set: estimated_item_count = a_estimated
		end

feature -- Access

	start_percent,
	end_percent,
	estimated_item_count: INTEGER

	progress_bar: EV_PROGRESS_BAR

end
