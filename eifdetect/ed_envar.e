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


feature {TEST_SET_BRIDGE} -- Implementation: Access

	is_estudio_installed (a_version: STRING): BOOLEAN
			--
		do
			Result := attached {WEL_REGISTRY_KEY_VALUE} registry.open_key_value ("HKEY_LOCAL_MACHINE\SOFTWARE\ISE\Eiffel_" + a_version, "ISE_EIFFEL")
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

end
