note
	description: "An Entity that knows how to update Progress"
	purpose_and_design: "See end-of-class notes."

class
	EG_PROGRESS_UPDATER

inherit
	EG_ANY

create
	make

feature {NONE} -- Initialization

	make (a_start, a_end, a_estimated: INTEGER; a_progress_bar: like progress_bar; a_output_agent: like on_output_agent)
			-- Initialize Current with `a_start' to `a_end' and an `a_estimated' item count.
			--	Also include a reference to `a_progress_bar' (what is being updated) and
			--	an `a_output_agent', which is used for sending "update messages" to whatever
			-- 	reporting update progress.
		do
			start_percent := a_start
			end_percent := a_end
			estimated_item_count := a_estimated
			progress_bar := a_progress_bar
			on_output_agent := a_output_agent
		ensure
			start_set: start_percent = a_start
			end_set: end_percent = a_end
			estimated_set: estimated_item_count = a_estimated
			agent_set: on_output_agent ~ a_output_agent
		end

feature -- Access

	start_percent,
	end_percent,
	estimated_item_count: INTEGER
			-- At what percent to we start and end (block)
			-- and how many items do we estimate are being
			-- updated?

	progress_bar: EV_PROGRESS_BAR
			-- The `progress_bar' reference being used to
			-- report our progress as a percent from 0 to 100.

	on_output_agent: detachable PROCEDURE [STRING_32]
			-- What routine taking a "message" will be
			-- responsible for reportinging text update messages?

feature -- Settings

	reset (a_start, a_end, a_estimated: INTEGER)
		do
			set_start_percent (a_start)
			set_end_percent (a_end)
			set_estimated_item_count (a_estimated)
		end

	set_start_percent (a_value: like start_percent)
		do
			start_percent := a_value
		ensure
			set: start_percent = a_value
		end

	set_end_percent (a_value: like end_percent)
		do
			end_percent := a_value
		ensure
			set: end_percent = a_value
		end

	set_estimated_item_count (a_value: like estimated_item_count)
		do
			estimated_item_count := a_value
		ensure
			set: estimated_item_count = a_value
		end

	set_on_output_agent (a_agent: attached like on_output_agent)
		do
			on_output_agent := a_agent
		ensure
			set: on_output_agent ~ a_agent
		end

note
	purpose: "[
		This class provides a single place to keep information
		and references related to updating "progress".
		]"
	design: "[
		Progress is generally expected to be measured in terms of
		a percentage ranging from 0 to 100%. Sometimes, the progress
		is done in blocks of percentages (i.e. start to end percent).
		
		Sometimes, we do not know how many "things" (items) we will be
		processing and reporting progress on. However, we might have an
		estimate of how many. Therefore, we can compute progress along
		the start-to-end percentage block based on a basic formula:
		
		cp = current-percent
		s = start
		e = end
		est = estimated item count
		i = actual count
		
		if i.mod (est) = 0 and then (s + (i / est).truncated_to_integer) <= e then
			cp = s + (i / est).truncated_to_integer
		end
		]"

end
