note
	description: "Commands and Queries in Support of AutoTest"
	goal: "[
		Create Commands, Queries, or both that enhance (support) the testing process.
		]"

class
	TEST_SET_SUPPORT

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

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
				
				this�is�an�
				�	example�of�
				�	�	replacement
				
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

	not_sign_U00AC_alt_0172: STRING = "�"
	not_sign_U00AC_alt_0172_with_newline: STRING = "�%N"
	degree_sign_U0080_alt_0176: STRING = "�"
	middle_dot_U00B7_alt_0183: STRING = "�"
	double_angle_right_U00BB_alt_0187: STRING = "�"
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
			Result.replace_substring_all ("�", "�%T")
		end

	assert_strings_equal_diff (a_tag, a_expected, a_actual: STRING)
			-- Assert that `a_expected' is the same as `a_actual'.
			--	If not, then show a list of differences as lines where
			--	the diffs happen.
		local
			l_diff: DIFF_TEXT
			l_result: BOOLEAN
		do
			create l_diff
			l_diff.set_text (a_expected, a_actual)
			l_diff.compute_diff
			l_result := attached l_diff.hunks as al_hunks and then
							attached l_diff.match as al_match and then
							al_hunks.count = 0 and then
							al_match.count = (a_expected.split ('%N').count) and then
							al_match.count = (a_actual.split ('%N').count)
			if
				not l_result and then
				attached l_diff.hunks as al_hunks and then
				attached l_diff.match as al_matches and then
				attached a_expected.split ('%N') as al_expected_list and then
				attached a_actual.split ('%N') as al_actual_list
			then
				print ("Non-matching hunk indexes:%N%N")
				across
					al_hunks as ic
				loop
					check attached {LIST [DIFF_LINE]} ic.item as al_list_diff_lines then
						across
							al_list_diff_lines as ic_lines
						loop
							print ("dst: " + ic_lines.item.dst.out + "%T%Tsrc: " + ic_lines.item.src.out + "%N")
							print ("%Tdst-actual   : " + al_actual_list [ic_lines.item.dst + 1] + "%N")
							print ("%Tsrc-expected : " + al_expected_list [ic_lines.item.src + 1] + "%N")
						end
					end
				end
			end
			assert_32 (a_tag, l_result)
		end

end