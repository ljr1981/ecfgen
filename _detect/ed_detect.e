note
	description: "Eiffel Detection (ED) by way of Environment Variables, Registry (Windows), and so on."

class
	ED_DETECT

feature -- Access

	installed_estudio_versions: HASH_TABLE [ES_INSTANCE, STRING]
			-- What `installed_estudio_versions' do we have to work with?
		once
			create Result.make (20)
			across versions as ic loop
				Result.force (create {ES_INSTANCE}.make_with_version (ic.item), ic.item)

			end
		end

	versions: ARRAY [STRING] once Result := <<"19.10", "19.09", "19.05", "19.04", "19.02",
												"18.11", "18.07", "18.01", "17.05", "17.01", "16.05",
												"15.12", "15.08", "15.01", "14.05", "13.11">> end

	is_es_1807_installed: BOOLEAN do Result := attached installed_estudio_versions.item ("18.07") as al and then al.is_installed end

	is_es_1902_installed: BOOLEAN do Result := attached installed_estudio_versions.item ("19.02") as al and then al.is_installed end

	is_es_1904_installed: BOOLEAN do Result := attached installed_estudio_versions.item ("19.04") as al and then al.is_installed end

	is_es_1905_installed: BOOLEAN do Result := attached installed_estudio_versions.item ("19.05") as al and then al.is_installed end

	is_es_1909_installed: BOOLEAN do Result := attached installed_estudio_versions.item ("19.09") as al and then al.is_installed end

	is_es_1910_installed: BOOLEAN do Result := attached installed_estudio_versions.item ("19.10") as al and then al.is_installed end

feature {TEST_SET_BRIDGE} -- Implementation: Access

	environment: EXECUTION_ENVIRONMENT
			-- Current {EXECUTION_ENVIRONMENT}.
		attribute
			create Result
		end

	registry: WEL_REGISTRY
			-- Windows `registry' access.
		attribute
			create Result
		end

end
