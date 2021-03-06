note
	description: "Pixel buffer that replaces original image file.%
		%The original version of this class has been generated by Image Eiffel Code."

class
	IMG_DEBUG

inherit
	EV_PIXEL_BUFFER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization
		do
			make_with_size (16, 15)
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
				A(FF,B4,CA,F3)A(FF,AB,B6,FA)A(FF,90,AC,F4)A(FF,90,AC,F4)A(FF,89,95,F9)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,54,89,EA)A(FF,54,89,EA)A(FF,47,78,D7)A(FF,4B,77,EE)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,15,65,D0)A(FF,AB,B6,FA)A(FF,89,95,F9)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,54,89,EA)A(FF,50,8A,D4)A(FF,4B,77,EE)A(FF,47,78,D7)A(FF,47,78,D7)A(FF,2C,6C,CC)A(FF,47,78,D7)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,90,AC,F4)A(FF,90,AC,F4)A(FF,89,95,F9)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,6D,90,F1)A(FF,50,8A,D4)A(FF,4B,77,EE)A(FF,50,8A,D4)A(FF,4B,77,EE)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,90,AC,F4)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,D4,EA,FC)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,D4,EA,FC)A(FF,27,59,D3)A(FF,89,95,F9)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,EE,D2,D0)A(FF,DE,A8,E4)A(FF,D6,8C,89)A(FF,C9,7B,83)A(FF,C9,7B,83)A(FF,C6,99,A3)A(FF,D9,D9,D9)A(FF,F0,F1,FB)A(FF,2C,6C,CC)
				A(FF,6D,90,F1)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,EE,D2,D0)A(FF,E8,AC,AC)A(FF,E9,90,8F)A(FF,D6,8C,89)A(FF,E9,90,8F)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,CB,B1,B1)A(FF,27,59,D3)A(FF,54,89,EA)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,E7,D8,E6)A(FF,E8,AC,AC)A(FF,E9,90,8F)A(FF,E8,AC,AC)A(FF,E9,90,8F)A(FF,E9,90,8F)A(FF,D6,8C,89)A(FF,D1,6F,6F)A(FF,CC,4F,4F)A(FF,B3,5C,67)A(FF,5A,6A,A0)A(FF,4B,77,EE)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,E8,AC,AC)A(FF,E9,90,8F)A(FF,E8,AC,AC)A(FF,E8,AC,AC)A(FF,E8,AC,AC)A(FF,E9,90,8F)A(FF,D6,8C,89)A(FF,D1,6F,6F)A(FF,CC,5F,60)A(FF,CC,4F,4F)A(FF,76,49,71)A(FF,47,78,D7)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,E9,90,8F)A(FF,D6,8C,89)A(FF,E9,90,8F)A(FF,E8,AC,AC)A(FF,E8,AC,AC)A(FF,D6,8C,89)A(FF,D6,8C,89)A(FF,D1,6F,6F)A(FF,CC,4F,4F)A(FF,B3,4C,4D)A(FF,91,4D,4C)A(FF,2C,6C,CC)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,E8,9B,5F)A(FF,D6,8C,89)A(FF,E9,90,8F)A(FF,E9,90,8F)A(FF,D6,8C,89)A(FF,D6,8C,89)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,CC,4F,4F)A(FF,B3,4C,4D)A(FF,B0,2C,2D)
				A(FF,2C,6C,CC)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,D6,8C,89)A(FF,C9,7B,83)A(FF,D6,8C,89)A(FF,D6,8C,89)A(FF,D6,8C,89)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,CC,4F,4F)A(FF,CC,4F,4F)A(FF,B3,4C,4D)A(FF,9C,32,4C)A(FF,2C,6C,CC)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,C6,99,A3)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,D1,6F,6F)A(FF,CC,5F,60)A(FF,CC,4F,4F)A(FF,B3,4C,4D)A(FF,B0,2C,2D)A(FF,76,49,71)A(FF,15,65,D0)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,F0,F1,FB)A(FF,EE,D2,D0)A(FF,D1,6F,6F)A(FF,CC,4F,4F)A(FF,CC,5F,60)A(FF,CC,4F,4F)A(FF,CC,4F,4F)A(FF,B3,4C,4D)A(FF,CC,4F,4F)A(FF,9C,32,4C)A(FF,B3,4C,4D)A(FF,5A,6A,A0)A(FF,2C,6C,CC)A(FF,2C,6C,CC)A(FF,10,5A,C4)A(FF,2C,6C,CC)A(FF,27,59,D3)A(FF,2C,64,B2)A(FF,5A,6A,A0)A(FF,91,4D,4C)A(FF,B3,4C,4D)A(FF,B3,4C,4D)A(FF,B3,4C,4D)A(FF,B3,4C,4D)A(FF,B0,2C,2D)A(FF,9C,32,4C)A(FF,5A,6A,A0)A(FF,2C,64,B2)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,D6,8C,89)A(FF,CC,4F,4F)A(FF,B3,4C,4D)A(FF,CC,4F,4F)A(FF,D6,8C,89)A(FF,FF,FF,FF)A(FF,FF,FF,FF)A(FF,FF,FF,FF);
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

end -- IMG_DEBUG
