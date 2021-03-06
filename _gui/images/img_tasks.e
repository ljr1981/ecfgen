note
	description: "Pixel buffer that replaces original image file.%
		%The original version of this class has been generated by Image Eiffel Code."

class
	IMG_TASKS

inherit
	EV_PIXEL_BUFFER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization
		do
			make_with_size (15, 16)
			fill_memory
		end

feature {NONE} -- Image data

	c_colors_0 (a_ptr: POINTER; a_offset: INTEGER)
			-- Fill `a_ptr' with colors data from `a_offset'.
		external
			"C inline"
		alias
			"{
			{
				#define B(q) \
					#q
				#ifdef EIF_WINDOWS
				#define A(a,r,g,b) \
					B(\x##b\x##g\x##r\x##a)
				#else
				#define A(a,r,g,b) \
					B(\x##r\x##g\x##b\x##a)
				#endif
				char l_data[] = 
				A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,D9,D9,D9)A(FF,AF,AF,AF)A(FF,AF,AF,AF)A(FF,AF,AF,AF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,D9,D9,D9)A(FF,AF,AF,AF)A(FF,AF,AF,AF)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,AF,AF,AF)A(FF,D9,D9,D9)A(FF,AF,AF,AF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,B2,B2,09)A(FF,92,92,05)A(FF,AF,AF,AF)A(FF,D9,D9,D9)A(FF,AF,AF,AF)A(FF,8F,8F,8F)A(FF,8F,8F,8F)A(FF,9E,6B,A2)A(FF,70,70,70)A(FF,8F,8F,8F)A(FF,4B,71,00)A(FF,6F,56,01)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,AD,8D,05)A(FF,93,DA,5B)A(FF,F0,F1,FB)A(FF,AF,AF,AF)A(FF,8F,8F,8F)A(FF,8F,89,71)A(FF,9E,6B,A2)A(FF,63,A3,5D)A(FF,70,70,70)A(FF,70,70,70)A(FF,70,70,70)A(FF,E7,D8,E6)A(FF,93,DA,5B)A(FF,4F,50,09)A(FF,FF,FF,FF)A(FF,B2,B2,09)A(FF,EE,D2,D0)A(FF,AF,AF,AF)A(FF,AF,AF,AF)A(FF,AF,AF,AF)A(FF,8F,8F,8F)A(FF,8F,8F,8F)A(FF,8F,8F,8F)A(FF,8F,8F,8F)A(FF,8F,8F,8F)A(FF,70,70,70)A(FF,8F,8F,8F)A(FF,EE,D2,D0)A(FF,4F,50,09)A(FF,FF,FF,FF)A(FF,92,92,05)A(FF,F5,F3,D3)A(FF,F0,F1,FB)A(FF,D9,D9,D9)A(FF,D9,D9,D9)
				A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,A1,CE,98)A(FF,63,A3,5D)A(FF,4E,A6,1B)A(FF,66,D6,5F)A(FF,92,92,05)A(FF,D9,D9,D9)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,A1,CE,98)A(FF,4E,A6,1B)A(FF,31,93,02)A(FF,4E,A6,1B)A(FF,63,A3,5D)A(FF,70,70,01)A(FF,D2,D1,B4)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F5,F3,D3)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,CF,D4,F5)A(FF,B7,C7,D2)A(FF,63,A3,5D)A(FF,39,B0,00)A(FF,31,93,02)A(FF,63,A3,5D)A(FF,FF,FF,FF)A(FF,70,70,01)A(FF,CD,E7,CB)A(FF,F0,F1,FB)A(FF,63,A3,5D)A(FF,63,A3,5D)A(FF,CD,E7,CB)A(FF,F0,F1,FB)A(FF,CF,D4,F5)A(FF,C6,E8,BB)A(FF,4E,A6,1B)A(FF,39,B0,00)A(FF,31,93,02)A(FF,94,A4,B4)A(FF,5A,6A,A0)A(FF,FF,FF,FF)A(FF,70,70,01)A(FF,F0,CD,AE)A(FF,63,A3,5D)A(FF,31,93,02)A(FF,39,B0,00)A(FF,4E,A6,1B)A(FF,CD,E7,CB)A(FF,B7,C7,D2)A(FF,4E,A6,1B)A(FF,31,93,02)A(FF,4E,A6,1B)A(FF,A1,CE,98)A(FF,90,AC,F4)A(FF,73,A6,EB)A(FF,54,89,EA)A(FF,70,70,01)A(FF,D9,D9,D9)A(FF,A1,CE,98)A(FF,31,93,02)A(FF,31,93,02)A(FF,39,B0,00)A(FF,4E,A6,1B)A(FF,4E,A6,1B)A(FF,39,B0,00)A(FF,31,93,02)
				A(FF,A1,CE,98)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,CF,D4,F5)A(FF,73,A6,EB)A(FF,4B,71,00)A(FF,D2,D1,B4)A(FF,F0,F1,FB)A(FF,A1,CE,98)A(FF,31,93,02)A(FF,31,93,02)A(FF,4E,A6,1B)A(FF,31,93,02)A(FF,31,93,02)A(FF,8D,AE,8E)A(FF,CF,D4,F5)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,CF,D4,F5)A(FF,6D,90,F1)A(FF,4F,50,09)A(FF,D2,D1,B4)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,A1,CE,98)A(FF,35,92,26)A(FF,31,93,02)A(FF,31,93,02)A(FF,A1,CE,98)A(FF,D4,EA,FC)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,B4,CA,F3)A(FF,50,8A,D4)A(FF,70,70,01)A(FF,AF,AD,4D)A(FF,F5,F3,D3)A(FF,EE,D2,D0)A(FF,D9,D9,D9)A(FF,A1,CE,98)A(FF,35,92,26)A(FF,63,A3,5D)A(FF,F0,F1,FB)A(FF,CF,D4,F5)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,D9,D9,D9)A(FF,CF,D4,F5)A(FF,70,93,CE)A(FF,FF,FF,FF)A(FF,70,70,01)A(FF,4F,50,09)A(FF,4F,50,09)A(FF,4F,50,09)A(FF,4F,50,09)A(FF,4F,50,09)A(FF,6D,90,F1)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,EE,D2,D0)A(FF,CF,D4,F5)A(FF,D9,D9,D9)A(FF,CF,D4,F5)A(FF,50,8A,D4)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,90,AC,F4)A(FF,73,A6,EB)A(FF,6D,90,F1)A(FF,50,8A,D4)A(FF,70,93,CE)A(FF,50,8A,D4)A(FF,50,8A,D4)A(FF,6D,90,F1);
				memcpy ((EIF_NATURAL_32 *)$a_ptr + $a_offset, &l_data, sizeof l_data - 1);
			}
			}"
		end

	build_colors (a_ptr: POINTER)
			-- Build `colors'.
		do
			c_colors_0 (a_ptr, 0)
		end

feature {NONE} -- Image data filling.

	fill_memory
			-- Fill image data into memory.
		local
			l_pointer: POINTER
		do
			if attached {EV_PIXEL_BUFFER_IMP} implementation as l_imp then
				l_pointer := l_imp.data_ptr
				if not l_pointer.is_default_pointer then
					build_colors (l_pointer)
					l_imp.unlock
				end
			end
		end

end -- IMG_TASKS
