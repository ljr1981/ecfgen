note
	description: "Commands and Queries in Support of AutoTest"
	goal: "[
		Create Commands, Queries, or both that enhance (support) the testing process.
		]"

class
	TEST_SET_SUPPORT

feature -- Support

	replace_non_printables (a_string: STRING): STRING
			-- `replace_non_printables' (space, newline, etc) with
			--	ASCII printable values not commonly used.
		note
			examples: "[
				this is an
					example of
						replacement
				
				becomes ...
				
				this·is·an¬
				»	example·of¬
				»	»	replacement
				
				Thus, non-printables become "seen" to help
				understand string comparisons where there might
				be issues stemming from non-printable characters.
				]"
		do
			Result := a_string.twin
			Result := replace_with_replacements (a_string, {ARRAY [TUPLE [CHARACTER_8, STRING_8]]}
						<<
							[' ', middle_dot_U00B7_alt_0183],
							['%N', not_sign_U00AC_alt_0172],
							['%U', degree_sign_U0080_alt_0176],
							['%T', double_angle_right_U00BB_alt_0187]
						>>)
		end

	replace_non_printables_keeping_newlines (a_string: STRING): STRING
			-- `replace_non_printables' (space, newline, etc) with
			--	ASCII printable values not commonly used.
			--  Keep newlines.
		do
			Result := a_string.twin
			Result := replace_with_replacements (a_string, {ARRAY [TUPLE [CHARACTER_8, STRING_8]]}
						<<
							[' ', middle_dot_U00B7_alt_0183],
							['%N', not_sign_U00AC_alt_0172_with_newline],
							['%U', degree_sign_U0080_alt_0176],
							['%T', double_angle_right_U00BB_alt_0187]
						>>)
		end

	not_sign_U00AC_alt_0172: STRING = "¬"
	not_sign_U00AC_alt_0172_with_newline: STRING = "¬%N"
	degree_sign_U0080_alt_0176: STRING = "°"
	middle_dot_U00B7_alt_0183: STRING = "·"
	double_angle_right_U00BB_alt_0187: STRING = "»"
		-- Each constant (above) has "name", "unicode code", "ASCII keyboard keystrokes"
		--  in the name to reveal the precise character being used and for what purpose.

	replace_with_replacements (a_string: STRING; a_replacements: ARRAY [TUPLE [original: CHARACTER; replacement: STRING]]): STRING
			-- `replace_with_replacements' in `a_replacements' into `a_string'.
		do
			Result := a_string.twin
			across
				a_replacements as ic
			loop
				Result.replace_substring_all (ic.item.original.out, ic.item.replacement)
			end
			Result.replace_substring_all ("»", "»%T")
		end

end
