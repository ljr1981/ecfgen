note
	description: "An XML Facet of being pattern-enabled (has-a pattern)"
	EIS: "name=definition", "src=https://www.w3.org/TR/2004/REC-xmlschema-2-20041028/datatypes.html#rf-pattern"
	EIS: "name=example", "src=https://github.com/gobo-eiffel/gobo/blob/master/library/regexp/example/pcre/pcre.e"

deferred class
	XML_PATTERN_ABLE

feature {NONE} -- Initialization

	make_with_string (a_pattern: STRING)
			--
		do
			create pattern.make
			pattern.compile (a_pattern)
		end

feature -- Access

	pattern_string: STRING
			--
		attribute
			create Result.make_empty
		end

	pattern: RX_PCRE_REGULAR_EXPRESSION
			-- A regex `pattern' for whatever {XML_ANY_TYPE} it is applied to.

invariant
	valid_pattern: pattern.has_matched

end
