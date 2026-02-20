function(add_esp_library_variants_for_cpu target_arch)
    set(
        one_value_args
        SUFFIX
        COMPILE_FLAGS
        MULTILIB_FLAGS
        PICOLIBC_BUILD_TYPE
        QEMU_MACHINE
        QEMU_CPU
        QEMU_PARAMS
        BOOT_FLASH_ADDRESS
        BOOT_FLASH_SIZE
        FLASH_ADDRESS
        FLASH_SIZE
        RAM_ADDRESS
        RAM_SIZE
        STACK_SIZE
    )
    cmake_parse_arguments(VARIANT "" "${one_value_args}" "" ${ARGN})
   
    foreach(enable_rtti IN ITEMS ON OFF)
        set(SUFFIXES)
        if(VARIANT_SUFFIX)
            list(APPEND SUFFIXES ${VARIANT_SUFFIX})
        endif()
        if(NOT enable_rtti)
            list(APPEND SUFFIXES "no-rtti")
        endif()
        list(JOIN SUFFIXES "_" COMBINED_SUFFIX)

        add_library_variant(
            "${target_arch}"
            SUFFIX "${COMBINED_SUFFIX}"
            COMPILE_FLAGS "${VARIANT_COMPILE_FLAGS}"
            MULTILIB_FLAGS "${VARIANT_MULTILIB_FLAGS}"
            PICOLIBC_BUILD_TYPE "${VARIANT_PICOLIBC_BUILD_TYPE}"
            QEMU_MACHINE "${VARIANT_QEMU_MACHINE}"
            QEMU_CPU "${VARIANT_QEMU_CPU}"
            # redirect qemu log, otherwise some output-sensitive tests fail
            QEMU_PARAMS "${VARIANT_QEMU_PARAMS}"
            BOOT_FLASH_ADDRESS "${VARIANT_BOOT_FLASH_ADDRESS}"
            BOOT_FLASH_SIZE "${VARIANT_BOOT_FLASH_SIZE}"
            FLASH_ADDRESS "${VARIANT_FLASH_ADDRESS}"
            FLASH_SIZE "${VARIANT_FLASH_SIZE}"
            RAM_ADDRESS "${VARIANT_RAM_ADDRESS}"
            RAM_SIZE "${VARIANT_RAM_SIZE}"
            STACK_SIZE "${VARIANT_STACK_SIZE}"
            ENABLE_EXCEPTIONS ON
            ENABLE_RTTI "${enable_rtti}"
        )
    endforeach()

    set(multilib_yaml_content "${multilib_yaml_content}" PARENT_SCOPE)
endfunction()

# RISCV
add_esp_library_variants_for_cpu(
    rv32imc-zicsr-zifencei
    SUFFIX ilp32
    COMPILE_FLAGS "-march=rv32i2p1_m2p0_c2p0_zicsr2p0_zifencei2p0 -mabi=ilp32"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i2p1_m2p0_c2p0_zicsr2p0_zifencei2p0 -mabi=ilp32"
    QEMU_MACHINE "esp32c3"
)
add_esp_library_variants_for_cpu(
    rv32imac-zicsr-zifencei
    SUFFIX ilp32
    COMPILE_FLAGS "-march=rv32i2p1_m2p0_a2p1_c2p0_zicsr2p0_zifencei2p0 -mabi=ilp32"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i2p1_m2p0_a2p1_c2p0_zicsr2p0_zifencei2p0 -mabi=ilp32"
)
add_esp_library_variants_for_cpu(
    rv32imac-zicsr-zifencei-zcb-zcmt
    SUFFIX ilp32
    COMPILE_FLAGS "-march=rv32i2p1_m2p0_a2p1_c2p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0 -mabi=ilp32"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i2p1_m2p0_a2p1_c2p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0 -mabi=ilp32"
)
add_esp_library_variants_for_cpu(
    rv32imacb-zicsr-zifencei-zcb-zcmt-zbc
    SUFFIX ilp32
    COMPILE_FLAGS "-march=rv32i2p1_m2p0_a2p1_c2p0_b1p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0_zbc1p0 -mabi=ilp32"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i2p1_m2p0_a2p1_c2p0_b1p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0_zbc1p0 -mabi=ilp32"
)
add_esp_library_variants_for_cpu(
    rv32imafc-zicsr-zifencei-zcb-zcmt
    SUFFIX ilp32f
    COMPILE_FLAGS "-march=rv32i2p1_m2p0_a2p1_f2p2_c2p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0 -mabi=ilp32f"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i2p1_m2p0_a2p1_f2p2_c2p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0 -mabi=ilp32f"
)
add_esp_library_variants_for_cpu(
    rv32imafcb-zicsr-zifencei-zcb-zcmt-zbc
    SUFFIX ilp32f
    COMPILE_FLAGS "-march=rv32i2p1_m2p0_a2p1_f2p2_c2p0_b1p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0_zbc1p0 -mabi=ilp32f"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i2p1_m2p0_a2p1_f2p2_c2p0_b1p0_zicsr2p0_zifencei2p0_zcb1p0_zcmt1p0_zbc1p0 -mabi=ilp32f"
)

# Xtensa
add_esp_library_variants_for_cpu(
    esp32
    SUFFIX ""
    COMPILE_FLAGS "--target=xtensa-esp-elf -mcpu=esp32"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32"
    QEMU_MACHINE "esp32"
)
add_esp_library_variants_for_cpu(
    esp32
    SUFFIX psram
    COMPILE_FLAGS "--target=xtensa-esp-elf -mcpu=esp32 -mfix-esp32-psram-cache-issue"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32 -mfix-esp32-psram-cache-issue"
    QEMU_MACHINE "esp32"
)
add_esp_library_variants_for_cpu(
    esp32s2
    SUFFIX ""
    COMPILE_FLAGS "--target=xtensa-esp-elf -mcpu=esp32s2"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32s2"
)
add_esp_library_variants_for_cpu(
    esp32s3
    SUFFIX ""
    COMPILE_FLAGS "--target=xtensa-esp-elf -mcpu=esp32s3"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32s3"
)
