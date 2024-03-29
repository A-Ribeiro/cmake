############################################################################
# IDE setup
############################################################################
if(OS_TARGET STREQUAL win)

    if(CMAKE_COMPILER_IS_GNUCXX)
        create_missing_cmake_build_type()
        if (CMAKE_BUILD_TYPE STREQUAL Release)
            add_definitions(-DNDEBUG)
            add_compile_options(-O3 -fno-strict-aliasing)
        endif()
    elseif(MSVC)
        # change the multithread debug DLL to multithread debug static compilation
        # avoid link with another VS DLL...
        foreach(flag
                CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO

                CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
                CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO )
            if(${flag} MATCHES "/MD")
                string(REGEX REPLACE "/MD" "/MT" ${flag} "${${flag}}")
                SET ( ${flag} "${${flag}}" CACHE STRING "" FORCE)
            endif()
            set("${flag}" "${${flag}} /MP")
            #message(STATUS "${${flag}}")
        endforeach()
    endif()

elseif(OS_TARGET STREQUAL mac)

    create_missing_cmake_build_type()
    if (CMAKE_BUILD_TYPE STREQUAL Release)
        add_definitions(-DNDEBUG)
        add_compile_options(-O3 -fno-strict-aliasing)
    endif()

    #SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -all_load")
    #SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -v")
    #add_linker_flag_global(-ObjC)
    SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -ObjC")

elseif(OS_TARGET STREQUAL linux)

    create_missing_cmake_build_type()
    if (CMAKE_BUILD_TYPE STREQUAL Release)
        add_definitions(-DNDEBUG)
        add_compile_options(-O3 -fno-strict-aliasing) # -fsanitize=address
        #SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=address -static-libasan")
        
    elseif( CMAKE_BUILD_TYPE STREQUAL Debug)
        add_compile_options(-fsanitize=address -fno-omit-frame-pointer)
        #add_linker_flag_global(-fsanitize=address -static-libasan)
        SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=address -static-libasan")
    endif()

elseif(OS_TARGET STREQUAL android)

    add_compile_options(
        -fexceptions
        -O3 -fno-strict-aliasing
        -ftree-vectorize
        -Wall
        -Wno-parentheses
        -ffast-math
    )

    if (${ARCH_TARGET} STREQUAL "armeabi-v7a")
    
        add_compile_options(
            -march=armv7-a
            -mfpu=neon
            -mfloat-abi=softfp
            -ftree-vectorize
        )

    endif()

else()
    message(FATAL_ERROR "ARibeiro Lib not tested on this OS")
endif()
