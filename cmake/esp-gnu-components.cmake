function(
    parse_gnu_toolchain_ver
    gnu_toolchain_ver
    gcc_ver
    date
)
    string(REPLACE "_" ";" ver_parts ${gnu_toolchain_ver})
    list(GET ver_parts 0 ver)
    list(GET ver_parts 1 dat)
    set(${gcc_ver} ${ver} PARENT_SCOPE)
    set(${date} ${dat} PARENT_SCOPE)
endfunction()

function(
    get_gnu_variant
    variant
    target_triple
    gnu_variant
)
    set(gnu_var ${variant})
    if(target_triple MATCHES "xtensa-esp32")
        string(FIND ${gnu_var} "_" pos)
        if(${pos} EQUAL -1)
            set(${gnu_variant} "" PARENT_SCOPE)
            return()
        endif()
        # pop first cpu component
        math(EXPR pos "${pos}+1")
        string(LENGTH ${gnu_var} len)
        string(SUBSTRING ${gnu_var} ${pos} ${len} gnu_var)
    endif()
    string(REPLACE "_" "/" gnu_var ${gnu_var})
    if(gnu_var MATCHES "^rv32")
        # rv32imc-zicsr-zifencei -> rv32imc_zicsr_zifencei
        string(REPLACE "/" ";" parts ${gnu_var})
        list(POP_FRONT parts arch_part)
        string(REPLACE "-" "_" arch_part ${arch_part})
        list(PREPEND parts ${arch_part})
        string(REPLACE ";" "/" gnu_var "${parts}")
    endif()
    set(${gnu_variant} ${gnu_var} PARENT_SCOPE)
endfunction()

function(
    get_gnu_toolchain_src_dir
    target_triple
    gnu_toolchain_src_dir
)
    if(target_triple MATCHES "^riscv32")
        set(gnu_tc_src_dir ${esp_riscv32_gnu_toolchain_SOURCE_DIR})
    elseif(target_triple STREQUAL "xtensa-esp-elf")
        set(gnu_tc_src_dir ${esp_xtensa_gnu_toolchain_SOURCE_DIR})
    else()
        if(target_triple STREQUAL "xtensa-esp32-elf")
            set(gnu_tc_src_dir ${esp32_gnu_toolchain_SOURCE_DIR})
        elseif(target_triple STREQUAL "xtensa-esp32s2-elf")
            set(gnu_tc_src_dir ${esp32s2_gnu_toolchain_SOURCE_DIR})
        elseif(target_triple STREQUAL "xtensa-esp32s3-elf")
            set(gnu_tc_src_dir ${esp32s3_gnu_toolchain_SOURCE_DIR})
        endif()
    endif()
    set(${gnu_toolchain_src_dir} ${gnu_tc_src_dir} PARENT_SCOPE)
endfunction()

function(
    get_xtensa_cpu
    variant
    mcpu_var
)
    string(REPLACE "_" ";" variant_comps ${variant})
    list(GET variant_comps 0 cpu)
    set(${mcpu_var} ${cpu} PARENT_SCOPE)
endfunction()

function(
    get_xtensa_target_triple
    variant
    target_triple_var
)
    # get CPU from variant
    get_xtensa_cpu(${variant} mcpu)
    set(${target_triple_var} "xtensa-${mcpu}-elf" PARENT_SCOPE)
endfunction()

function(
    add_libgcc
    gnu_toolchain_ver
    directory
    variant
    target_triple
)
    # if(target_triple MATCHES "^xtensa-esp")
    #     get_xtensa_target_triple(${variant} target_triple)
    #     message(STATUS "target_triple2=${target_triple}")
    # endif()
    parse_gnu_toolchain_ver(${gnu_toolchain_ver} gcc_ver date)
    get_gnu_variant(${variant} ${target_triple} gnu_variant)
    get_gnu_toolchain_src_dir(${target_triple} gnu_toolchain_src_dir)

    add_custom_target(
        libgcc_${variant}
        COMMAND
            "${CMAKE_COMMAND}" -E copy
            ${gnu_toolchain_src_dir}/lib/gcc/${target_triple}/${gcc_ver}/${gnu_variant}/libgcc.a
            # ${gnu_toolchain_src_dir}/lib/gcc/${target_triple}/${gcc_ver}/${gnu_variant}/crtbegin.o
            # ${gnu_toolchain_src_dir}/lib/gcc/${target_triple}/${gcc_ver}/${gnu_variant}/crtend.o
            ${LLVM_BINARY_DIR}/${directory}/lib
        BYPRODUCTS 
            ${LLVM_BINARY_DIR}/${directory}/lib/libgcc.a
            # ${LLVM_BINARY_DIR}/${directory}/lib/crtbegin.o
            # ${LLVM_BINARY_DIR}/${directory}/lib/crtend.o
        USES_TERMINAL
    )
    add_dependencies(
        llvm-toolchain-runtimes
        libgcc_${variant}
    )
endfunction()    


function(
    add_libstdcxx
    gnu_toolchain_ver
    directory
    variant
    target_triple
)
    # if(target_triple MATCHES "^xtensa-esp")
    #     get_xtensa_target_triple(${variant} target_triple)
    # endif()
    parse_gnu_toolchain_ver(${gnu_toolchain_ver} gcc_ver date)
    get_gnu_toolchain_src_dir(${target_triple} gnu_toolchain_src_dir)
    get_gnu_variant(${variant} ${target_triple} gnu_variant)

    add_custom_target(
        libstdcxx_${variant}
        COMMAND
            "${CMAKE_COMMAND}" -E copy
            ${gnu_toolchain_src_dir}/${target_triple}/lib/${gnu_variant}/libstdc++.a
            ${LLVM_BINARY_DIR}/${directory}/lib
        # copy config variant depenednt part
        COMMAND
            "${CMAKE_COMMAND}" -E copy_directory
            ${gnu_toolchain_src_dir}/${target_triple}/include/c++/${gcc_ver}/${target_triple}/${gnu_variant}
            ${LLVM_BINARY_DIR}/${directory}/include/c++/${gcc_ver}
        # HACK: remove 'esp32-psram' and 'no-rtti' multi-subdirs if any.
        # they will be copied to '${variant}_no-rtti' and '${variant}_esp32-psram' subdirs
        COMMAND
            "${CMAKE_COMMAND}" -E rm -rf 
            ${LLVM_BINARY_DIR}/${directory}/include/c++/${gcc_ver}/no-rtti
        COMMAND
            "${CMAKE_COMMAND}" -E rm -rf 
            ${LLVM_BINARY_DIR}/${directory}/include/c++/${gcc_ver}/esp32-psram
        BYPRODUCTS ${LLVM_BINARY_DIR}/${directory}/lib/libstdc++.a
        USES_TERMINAL
    )
    add_dependencies(
        llvm-toolchain-runtimes
        libstdcxx_${variant}
    )
endfunction()


function(
    add_libstdcxx_common_headers
    target_triple
)
    get_gnu_toolchain_src_dir(${target_triple} gnu_toolchain_src_dir)
    if(target_triple MATCHES "^xtensa-esp")
        set(dst_target_triple "xtensa-esp-unknown-elf")
    elseif(target_triple MATCHES "^riscv32-esp")
        set(dst_target_triple "riscv32-esp-unknown-elf")
    else()
        set(dst_target_triple ${target_triple})
    endif()    

    install(DIRECTORY ${gnu_toolchain_src_dir}/${target_triple}/include/c++
        DESTINATION ${TARGET_LIBRARIES_DIR}/${dst_target_triple}/include
        COMPONENT llvm-toolchain-gnu-headers_${target_triple}
        # do not install multilib-subdirs under ${target_triple} subdir
        REGEX include/c\\+\\+/[0-9]+\\.[0-9]+\\.[0-9]+/${target_triple} EXCLUDE
    )

    add_custom_target(
        install-llvm-toolchain-gnu-headers_${target_triple}
        COMMAND
            "${CMAKE_COMMAND}"
            --install ${CMAKE_BINARY_DIR}
            --component llvm-toolchain-gnu-headers_${target_triple}
        USES_TERMINAL
    )
    if(LLVM_TOOLCHAIN_CROSS_BUILD_MINGW)
        # LLVM MinGW build does not use  install-llvm-toolchain target
        # LLVM distributables are copied as part of the llvm-toolchain-mingw component,
        # so need to add dependency on package-llvm-toolchain explicitly to be included
        # into archive
        add_dependencies(
            package-llvm-toolchain
            install-llvm-toolchain-gnu-headers_${target_triple}
        )
    else()
        add_dependencies(
            install-llvm-toolchain
            install-llvm-toolchain-gnu-headers_${target_triple}
        )
    endif()
endfunction()


function(
    add_binutils
    target_triple
)
    list(APPEND config_opts
        --disable-werror --enable-ld=yes --enable-gold=no
        --enable-deterministic-archives --enable-multilib --disable-sim
        --disable-gdb --disable-nls
    )

    if(HOST_TRIPLE MATCHES "darwin")
        set(use_cc "${CMAKE_C_COMPILER_LAUNCHER} ${HOST_TRIPLE}-clang")
        set(use_cxx "${CMAKE_C_COMPILER_LAUNCHER} ${HOST_TRIPLE}-clang++")
    else()
        set(use_cc "${CMAKE_C_COMPILER_LAUNCHER} ${HOST_TRIPLE}-gcc")
        set(use_cxx "${CMAKE_C_COMPILER_LAUNCHER} ${HOST_TRIPLE}-g++")
    endif()

    if(HOST_TRIPLE MATCHES "mingw")
        set(EXE_SUFFIX ".exe")
    endif()

    if(target_triple MATCHES "^xtensa-esp")
        # binutils sources are patched for every Xtensa CPU, 
        # so create separate source dir for every CPU to avoid source conflicts when building in parallel
        string(REPLACE "-" ";" var_comps ${target_triple})
        list(GET var_comps 1 cpu)
        get_filename_component(binutils_src_dir ${binutils_SOURCE_DIR} NAME)
        set(binutils_src_dir /tmp/${binutils_src_dir}_${target_triple})
        message(STATUS "Make source dir copy for ${cpu}. ${binutils_SOURCE_DIR} -> ${binutils_src_dir}")
        file(COPY ${binutils_SOURCE_DIR}/ DESTINATION ${binutils_src_dir})
        message(STATUS "Apply Xtensa overlay for ${cpu}. ${xtensa_overlays_SOURCE_DIR}/xtensa_${cpu}/binutils -> ${binutils_src_dir}")
        file(COPY ${xtensa_overlays_SOURCE_DIR}/xtensa_${cpu}/binutils/ DESTINATION ${binutils_src_dir})
    else()
        set(binutils_src_dir ${binutils_SOURCE_DIR})
    endif()

    ExternalProject_Add(
        binutils_${target_triple}
        SOURCE_DIR ${binutils_src_dir}
        INSTALL_DIR ${LLVM_BINARY_DIR}
        PREFIX binutils
        CONFIGURE_COMMAND 
            env CC=${use_cc}
            env CXX=${use_cxx}
            ${binutils_src_dir}/configure --host=${HOST_TRIPLE} --target=${target_triple} --prefix=<INSTALL_DIR> ${config_opts}
        BUILD_COMMAND make -j${MAKE_JOBS_NUM}
        INSTALL_COMMAND make install-strip
        USES_TERMINAL_CONFIGURE TRUE
        USES_TERMINAL_BUILD TRUE
        USES_TERMINAL_TEST TRUE
        # LIST_SEPARATOR " "
        # Always run the build command so that incremental builds are correct.
        BUILD_ALWAYS TRUE
        # CONFIGURE_HANDLED_BY_BUILD TRUE
    )

    # install necessary programs only
    install(PROGRAMS
        ${LLVM_BINARY_DIR}/bin/${target_triple}-objcopy${EXE_SUFFIX}
        ${LLVM_BINARY_DIR}/bin/${target_triple}-as${EXE_SUFFIX}
        ${LLVM_BINARY_DIR}/bin/${target_triple}-ld${EXE_SUFFIX}
        ${LLVM_BINARY_DIR}/bin/${target_triple}-objdump${EXE_SUFFIX}
        TYPE BIN
        COMPONENT llvm-toolchain-gnu-binutils_${target_triple}
    )

    add_dependencies(
        llvm-toolchain
        binutils_${target_triple}
    )

    add_custom_target(
        install-llvm-toolchain-gnu-binutils_${target_triple}
        COMMAND
            "${CMAKE_COMMAND}"
            --install ${CMAKE_BINARY_DIR}
            --component llvm-toolchain-gnu-binutils_${target_triple}
        USES_TERMINAL
    )
    add_dependencies(
        install-llvm-toolchain-gnu-binutils_${target_triple}
        binutils_${target_triple}
    )
    if(LLVM_TOOLCHAIN_CROSS_BUILD_MINGW)
        # LLVM MinGW build does not use  install-llvm-toolchain target
        # LLVM distributables are copied as part of the llvm-toolchain-mingw component,
        # so need to add dependency on package-llvm-toolchain explicitly to be included
        # into archive
        add_dependencies(
            package-llvm-toolchain
            install-llvm-toolchain-gnu-binutils_${target_triple}
        )
    else()
        add_dependencies(
            install-llvm-toolchain
            install-llvm-toolchain-gnu-binutils_${target_triple}
        )
    endif()
endfunction()
