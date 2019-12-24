note
	description: "Specialization of {EV_DIALOG}."
	purpose: "To have an overrideable class for test targets which allows for use of the EV library precompile."
	author: ""
	date: "$Date: 2014-06-27 13:30:35 -0400 (Fri, 27 Jun 2014) $"
	revision: "$Revision: 9444 $"

class
	JV_DIALOG

inherit
	EV_DIALOG

create
	default_create,
	make_with_title

note
	glossary: "[
					JV: Jinny Vision, which is a library of classes as direct descendents of their Eiffel Vision
							counterparts and serve the purpose of extending or specializing those classes for
							the needs of the JLOFT framework and system.
					]"
end
