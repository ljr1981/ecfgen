note
	description: "Eiffel Detection by way of Environment Variables"

class
	ED_ENVAR

feature -- Access

	is_es_1807_installed: BOOLEAN do Result := is_estudio_installed ("18.07") end

	is_es_1902_installed: BOOLEAN do Result := is_estudio_installed ("19.02") end

	is_es_1904_installed: BOOLEAN do Result := is_estudio_installed ("19.04") end

	is_es_1905_installed: BOOLEAN do Result := is_estudio_installed ("19.05") end

	is_es_1909_installed: BOOLEAN do Result := is_estudio_installed ("19.09") end

	is_es_1910_installed: BOOLEAN do Result := is_estudio_installed ("19.10") end


	estudio_path (a_version: STRING): detachable PATH
			--
		require
			version_format: a_version.to_real > 0
		do
			if attached {WEL_REGISTRY_KEY_VALUE} registry.open_key_value (Windows_HKEY_LOCAL_MACHINE_SOFTWARE_ISE_Eiffel + a_version, ISE_EIFFEL_envar) as al_key_value then
				create Result.make_from_string (al_key_value.string_value)
			end
		end

	estudio_directory (a_version: STRING): detachable DIRECTORY
			--
		do
			if attached {PATH} estudio_path (a_version) as al_path and then attached (create {DIRECTORY}.make_with_path (al_path)) as al_dir and then al_dir.exists then
				Result := al_dir
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation: Access

	is_estudio_installed (a_version: STRING): BOOLEAN
			--
		require
			version_format: a_version.to_real > 0
		do
			Result := attached estudio_directory (a_version)
		end

	environment: EXECUTION_ENVIRONMENT
			--
		attribute
			create Result
		end

	registry: WEL_REGISTRY
			--
		attribute
			create Result
		end

feature {TEST_SET_BRIDGE} -- Implementation: Constants

	Windows_HKEY_LOCAL_MACHINE_SOFTWARE_ISE_Eiffel: STRING = "HKEY_LOCAL_MACHINE\SOFTWARE\ISE\Eiffel_"

	ISE_EIFFEL_envar: STRING = "ISE_EIFFEL"

end
