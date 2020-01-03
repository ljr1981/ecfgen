note
	description: "{EV_PRINT_DIALOG} specialization for printing from PDF files."
	brief: "When provided a PDF file name with the `make_with_pdf_file_name' creation prodedure, will print specified PDF to printer selected at time the 'Print' button is pressed."
	example: "[
				l_print_dialog: JV_PRINT_DIALOG
				window: EV_WINDOW	
					--| Used the name of a PDF on my local machine for this example. Provide the appropriate PDF name as the argument when creation the dialog.
				create l_print_dialog.make_with_pdf_file_name ("C:\Users\pulrich\Downloads\75 N Cobb.pdf") 
				l_print_dialog.show_modal_to_window (window)
			]"

class
	JV_PRINT_DIALOG

inherit
	EV_PRINT_DIALOG
		redefine
			create_interface_objects,
			printer_name
		end

	ABSTRACT_JV_PRINT_DIALOG
		undefine
			default_create,
			copy
		end

create
	default_create, make_with_pdf_file_name_and_printer_executable_path

feature {NONE} -- Initialization

	create_interface_objects
			-- <Precursor>
		local
			l_byte_array: ARRAY [INTEGER_8]
			a: ANY
			l_printer_count, l_bytes_needed: NATURAL_32
			i: INTEGER
			l_native_string: NATIVE_STRING
			l_pointer: POINTER
		do
			Precursor
			l_bytes_needed := c_enum_printers_required_byte_count
			create l_byte_array.make_filled (0, 1, l_bytes_needed.as_integer_32)
			a := l_byte_array.area
			l_printer_count := c_populate_array_and_return_printer_count ($a, l_bytes_needed)
			create printers.make (l_printer_count.as_integer_32)

			from
				i := 0
			until
				i >= l_printer_count.as_integer_32
			loop
				l_pointer := c_printer_name_from_enum_array ($a, i)
				create l_native_string.make_from_pointer (l_pointer)
				printers.extend (l_native_string.string)
				i := i + 1
			end
		end

feature -- Access

	printer_name: STRING_32
			-- <Precursor>
		local
			l_native_string: NATIVE_STRING
			l_array: ARRAY [INTEGER_8]
			a: ANY
		do
			create Result.make_empty
			if attached {EV_PRINT_DIALOG_IMP} implementation as al_imp then
					-- Allocate memory to copy the result into.  This memory will be managed by the Eiffel runtime.
				create l_array.make_filled (0, 1, 1024)
				a := l_array.area
				c_printer_name (al_imp.item, $a, 1024)
				create l_native_string.make_from_pointer ($a)
				create Result.make_from_string (l_native_string.string)
			end
		end

	server_name: STRING_32
			-- <Precursor>
		attribute
			create Result.make_empty
		end

	printers: ARRAYED_LIST [STRING_32]

feature -- Settings

	set_selected_printer_name (a_name: READABLE_STRING_GENERAL)
			-- Set selected printer name to `a_name'.
			--| Call this before calling `show_modal_to_window'.
		require else
			is_valid_printer_name: is_valid_printer_name (a_name)
		local
			l_native_string: NATIVE_STRING
			l_dev_mode_handle, l_dev_names_handle: POINTER
			l_result: BOOLEAN
		do
			if attached {EV_PRINT_DIALOG_IMP} implementation as al_imp then
				create l_native_string.make (a_name.as_string_32)
				l_result := c_get_printer_device_data (l_native_string.item, $l_dev_names_handle, $l_dev_mode_handle)
				if l_result then
					c_print_dlg_set_dev_mode_handle (al_imp.item, l_dev_mode_handle)
					c_print_dlg_set_dev_names_handle (al_imp.item, l_dev_names_handle)
				end
			end
		end

feature {JV_PRINT_DIALOG_TEST} -- Implementation

	c_printer_name (a_dialog_ptr, a_storage_ptr: POINTER; a_byte_count: NATURAL_32)
		external
			"C inline use <windows.h>, <wchar.h>"
		alias
			"[
				{
					size_t  luiCharCount = $a_byte_count / 2;
					LPPRINTDLG dlgPrint = (LPPRINTDLG)$a_dialog_ptr;
					DEVNAMES *pDevNames = (DEVNAMES*)GlobalLock(dlgPrint->hDevNames);
					LPCTSTR  lpPrinterName = (LPCTSTR)pDevNames + pDevNames->wDeviceOffset;
					size_t  luiCopyCount = wcsnlen_s(lpPrinterName, luiCharCount)+1;
					wmemcpy_s((wchar_t*)$a_storage_ptr, luiCharCount, lpPrinterName, luiCopyCount);
					GlobalUnlock(dlgPrint->hDevNames);
				}
			]"
		end

	c_print_dlg_set_dev_names_handle (ptr: POINTER; value: POINTER)
		external
			"C inline use <windows.h>"
		alias
			"((LPPRINTDLG) $ptr)->hDevNames = (HGLOBAL) $value;"
		end

	c_print_dlg_set_dev_mode_handle (ptr: POINTER; value: POINTER)
		external
			"C inline use <windows.h>"
		alias
			"((LPPRINTDLG) $ptr)->hDevMode = (HGLOBAL) $value;"
		end

	c_get_printer_device_data (a_printer_name_ptr, a_dev_names_handle_ptr, a_dev_mode_handle_ptr: POINTER): BOOLEAN
			--// returns a DEVMODE and DEVNAMES for the printer name specified
			--BOOL GetPrinterDevice(LPTSTR pszPrinterName, HGLOBAL* phDevNames, HGLOBAL* phDevMode)
		external
			"C++ inline use <windows.h>, <winspool.h>"
		alias
			"[
				{
					LPTSTR pszPrinterName = (LPTSTR)$a_printer_name_ptr;
					HGLOBAL* phDevNames = (HGLOBAL*)$a_dev_names_handle_ptr;
					HGLOBAL* phDevMode = (HGLOBAL*)$a_dev_mode_handle_ptr;
					// if NULL is passed, then assume we are setting app object's devmode and devnames
					if (phDevMode == NULL || phDevNames == NULL)
					{
						return FALSE;
					}

					// Open printer
					HANDLE hPrinter;
					if (OpenPrinter(pszPrinterName, &hPrinter, NULL) == FALSE)
					{
						return FALSE;
					}

					// obtain PRINTER_INFO_2 structure and close printer
					DWORD dwBytesReturned, dwBytesNeeded;
					GetPrinter(hPrinter, 2, NULL, 0, &dwBytesNeeded);
					PRINTER_INFO_2* p2 = (PRINTER_INFO_2*)GlobalAlloc(GPTR, dwBytesNeeded);
					if (GetPrinter(hPrinter, 2, (LPBYTE)p2, dwBytesNeeded, &dwBytesReturned) == 0)
					{
						GlobalFree(p2);
						ClosePrinter(hPrinter);
						return FALSE;
					}
					ClosePrinter(hPrinter);

					// Allocate a global handle for DEVMODE
					HGLOBAL  hDevMode = GlobalAlloc(GHND, sizeof(*p2->pDevMode) + p2->pDevMode->dmDriverExtra);
					//ASSERT(hDevMode);
					// TODO: Implement Eiffel assert
					DEVMODE* pDevMode = (DEVMODE*)GlobalLock(hDevMode);
					//ASSERT(pDevMode);
					// TODO: Implement Eiffel assert

					// copy DEVMODE data from PRINTER_INFO_2::pDevMode
					memcpy(pDevMode, p2->pDevMode, sizeof(*p2->pDevMode) + p2->pDevMode->dmDriverExtra);
					GlobalUnlock(hDevMode);

					// Compute size of DEVNAMES structure from PRINTER_INFO_2's data
					DWORD drvNameLen = lstrlen(p2->pDriverName)+1;  // driver name
					DWORD ptrNameLen = lstrlen(p2->pPrinterName)+1; // printer name
					DWORD porNameLen = lstrlen(p2->pPortName)+1;    // port name

					// Allocate a global handle big enough to hold DEVNAMES.
					HGLOBAL hDevNames = GlobalAlloc(GHND, sizeof(DEVNAMES) + (drvNameLen + ptrNameLen + porNameLen)*sizeof(TCHAR));
					//ASSERT(hDevNames);
					// TODO: Implement Eiffel assert
					DEVNAMES* pDevNames = (DEVNAMES*)GlobalLock(hDevNames);
					//ASSERT(pDevNames);
					// TODO: Implement Eiffel assert

					// Copy the DEVNAMES information from PRINTER_INFO_2
					// tcOffset = TCHAR Offset into structure
					int tcOffset = sizeof(DEVNAMES)/sizeof(TCHAR);
					//ASSERT(sizeof(DEVNAMES) == tcOffset*sizeof(TCHAR));
					// TODO: Implement Eiffel assert

					pDevNames->wDriverOffset = tcOffset;
					memcpy((LPTSTR)pDevNames + tcOffset, p2->pDriverName, drvNameLen*sizeof(TCHAR));
					tcOffset += drvNameLen;

					pDevNames->wDeviceOffset = tcOffset;
					memcpy((LPTSTR)pDevNames + tcOffset, p2->pPrinterName, ptrNameLen*sizeof(TCHAR));
					tcOffset += ptrNameLen;

					pDevNames->wOutputOffset = tcOffset;
					memcpy((LPTSTR)pDevNames + tcOffset, p2->pPortName, porNameLen*sizeof(TCHAR));
					pDevNames->wDefault = 0;

					GlobalUnlock(hDevNames);
					GlobalFree(p2);   // free PRINTER_INFO_2

					// set the new hDevMode and hDevNames
					*phDevMode = hDevMode;
					*phDevNames = hDevNames;
					return TRUE;
				}
			]"
		end

	c_printer_name_from_enum_array (a_ptr: POINTER; i: INTEGER): POINTER
		external
			"C++ inline use <windows.h>"
		alias
			"[
				{
					//LPPRINTER_INFO_2 lpPrinterInfo2;
					//lpPrinterInfo2 = (LPPRINTER_INFO_2)$a_ptr + $i;
					//return lpPrinterInfo2->pPrinterName;
					LPPRINTER_INFO_4 lpPrinterInfo4;
					lpPrinterInfo4 = (LPPRINTER_INFO_4)$a_ptr + $i;
					return lpPrinterInfo4->pPrinterName;
				}
			]"
		end

	c_populate_array_and_return_printer_count (a_ptr: POINTER; a_bytes_needed: NATURAL_32): NATURAL_32
		external
			"C++ inline use <windows.h>"
		alias
			"[
				{
					DWORD dwBytesNeeded, dwNumPrinters;
					EnumPrinters(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS, NULL, 4, (LPBYTE)$a_ptr, (DWORD)$a_bytes_needed, &dwBytesNeeded, &dwNumPrinters);
					return dwNumPrinters;
				}
			]"
		end

	c_enum_printers_required_byte_count: NATURAL_32
		external
			"C++ inline use <windows.h>"
		alias
			"[
				{ 
					DWORD dwBytesNeeded, dwNumPrinters;
					EnumPrinters(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS, NULL, 4, NULL, 0, &dwBytesNeeded, &dwNumPrinters);
					return dwBytesNeeded;
				}
			]"
		end

;end
