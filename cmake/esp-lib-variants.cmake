# RISCV
add_library_variant(
    rv32i-zicsr-zifencei
    SUFFIX ilp32
    COMPILE_FLAGS "-march=rv32i_zicsr_zifencei -mabi=ilp32"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i_zicsr_zifencei -mabi=ilp32"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
add_library_variant(
    rv32i-zicsr-zifencei
    SUFFIX ilp32_no-rtti
    COMPILE_FLAGS "-march=rv32i_zicsr_zifencei -mabi=ilp32 -fno-rtti"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32i_zicsr_zifencei -mabi=ilp32 -fno-rtti"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
add_library_variant(
    rv32imc-zicsr-zifencei
    SUFFIX ilp32
    COMPILE_FLAGS "-march=rv32imc_zicsr_zifencei -mabi=ilp32"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32imc_zicsr_zifencei -mabi=ilp32"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
add_library_variant(
    rv32imc-zicsr-zifencei
    SUFFIX ilp32_no-rtti
    COMPILE_FLAGS "-march=rv32imc_zicsr_zifencei -mabi=ilp32 -fno-rtti"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32imc_zicsr_zifencei -mabi=ilp32 -fno-rtti"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
add_library_variant(
    rv32imac-zicsr-zifencei
    SUFFIX ilp32
    COMPILE_FLAGS "-march=rv32imac_zicsr_zifencei -mabi=ilp32"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32imac_zicsr_zifencei -mabi=ilp32"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
add_library_variant(
    rv32imac-zicsr-zifencei
    SUFFIX ilp32_no-rtti
    COMPILE_FLAGS "-march=rv32imac_zicsr_zifencei -mabi=ilp32 -fno-rtti"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32imac_zicsr_zifencei -mabi=ilp32 -fno-rtti"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
add_library_variant(
    rv32imafc-zicsr-zifencei
    SUFFIX ilp32f
    COMPILE_FLAGS "-march=rv32imafc_zicsr_zifencei -mabi=ilp32f"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32imafc_zicsr_zifencei -mabi=ilp32f"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
add_library_variant(
    rv32imafc-zicsr-zifencei
    SUFFIX ilp32f_no-rtti
    COMPILE_FLAGS "-march=rv32imafc_zicsr_zifencei -mabi=ilp32f -fno-rtti"
    MULTILIB_FLAGS "--target=riscv32-esp-unknown-elf -march=rv32imafc_zicsr_zifencei -mabi=ilp32f -fno-rtti"
    QEMU_MACHINE "riscv32"
    QEMU_CPU "rv32"
)
# Xtensa
add_library_variant(
    esp32
    SUFFIX ""
    COMPILE_FLAGS "-mcpu=esp32"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32"
    QEMU_MACHINE "esp32"
)
add_library_variant(
    esp32
    SUFFIX no-rtti
    COMPILE_FLAGS "-mcpu=esp32 -fno-rtti"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32 -fno-rtti"
    QEMU_MACHINE "esp32"
)
add_library_variant(
    esp32
    SUFFIX psram
    COMPILE_FLAGS "-mcpu=esp32 -mfix-esp32-psram-cache-issue"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32 -mfix-esp32-psram-cache-issue"
    QEMU_MACHINE "esp32"
)
add_library_variant(
    esp32
    SUFFIX psram_no-rtti
    COMPILE_FLAGS "-mcpu=esp32 -mfix-esp32-psram-cache-issue -fno-rtti"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32 -mfix-esp32-psram-cache-issue -fno-rtti"
    QEMU_MACHINE "esp32"
)
add_library_variant(
    esp32s2
    SUFFIX ""
    COMPILE_FLAGS "-mcpu=esp32s2"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32s2"
    QEMU_MACHINE "esp32s2"
)
add_library_variant(
    esp32s2
    SUFFIX no-rtti
    COMPILE_FLAGS "-mcpu=esp32s2 -fno-rtti"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32s2 -fno-rtti"
    QEMU_MACHINE "esp32s3"
)
add_library_variant(
    esp32s3
    SUFFIX ""
    COMPILE_FLAGS "-mcpu=esp32s3"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32s3"
    QEMU_MACHINE "esp32s3"
)
add_library_variant(
    esp32s3
    SUFFIX no-rtti
    COMPILE_FLAGS "-mcpu=esp32s3 -fno-rtti"
    MULTILIB_FLAGS "--target=xtensa-esp-unknown-elf -mcpu=esp32s3 -fno-rtti"
    QEMU_MACHINE "esp32s3"
)
