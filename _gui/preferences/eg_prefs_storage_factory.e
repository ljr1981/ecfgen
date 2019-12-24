note
	description	: "Preferences storage factory"
	purpose_and_design: "See end-of-class notes."

class EG_PREFS_STORAGE_FACTORY

feature -- Access

	storage_for_basic: PREFERENCES_STORAGE_I
		do
	 		create {PREFERENCES_STORAGE_XML} Result.make_with_location ("user.conf")
	 	end

note
	purpose: "[

		]"
	design: "[
		
		]"

end
