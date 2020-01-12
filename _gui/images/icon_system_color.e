note
	description: "Pixel buffer that replaces original image file.%
		%The original version of this class has been generated by Image Eiffel Code."

class
	ICON_SYSTEM_COLOR

inherit
	EV_PIXEL_BUFFER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization
		do
			make_with_size (16, 16)
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
				A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(FF,00,00,80)A(00,01,01,01)A(FF,00,00,80)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,80)A(00,01,01,01)A(FF,00,00,80)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,B9)A(FF,00,00,80)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,00,00,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,00,00,00)A(00,01,01,01)
				A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,00,00,00)A(FF,80,80,00)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,E6,E6,E6)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,F2,F2,F2)A(FF,E6,E6,E6)A(FF,F2,F2,F2)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,00,00,00)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,E6,E6,E6)A(FF,F2,F2,F2)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,00,00,00)A(FF,C0,C0,C0)A(FF,00,00,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,00,00,00)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,00,00,00)A(00,01,01,01)
				A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,DA,DA,DA)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,F2,F2,F2)A(FF,E6,E6,E6)A(FF,00,00,00)A(FF,80,80,00)A(FF,80,80,00)A(FF,DC,DC,00)A(FF,80,80,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,00,00,00)A(FF,80,80,00)A(FF,00,00,00)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,DA,DA,DA)A(FF,E6,E6,E6)A(FF,DA,DA,DA)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,F2,F2,F2)A(FF,E6,E6,E6)A(FF,F2,F2,F2)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,DA,DA,DA)A(FF,DA,DA,DA)A(FF,E6,E6,E6)A(FF,DA,DA,DA)A(FF,E6,E6,E6)A(FF,E6,E6,E6)A(FF,00,00,00)A(00,01,01,01)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(00,01,01,01)
				A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01)A(00,01,01,01);
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

end -- ICON_SYSTEM_COLOR