note
	description: "Any EG_* Thing."

class
	EG_ANY

inherit
	EV_SHARED_APPLICATION

feature

	application: EG_APPLICATION
		do
			check attached {EG_APPLICATION} ev_application as al_app then Result := al_app end
		end

end
