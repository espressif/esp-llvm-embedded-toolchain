
// RUN: %if target={{.*}}-esp-elf  \
// RUN:   %{ \
// RUN:     %clang -march=rv32imc -mabi=ilp32 -fno-rtti -nostartfiles -lcrt1-sim -lsemihost -lpthread_stubs -T %S/Inputs/esp32c3.ld %s -o %t.out && \
// RUN:     qemu-system-riscv32 -nographic -machine esp32c3 --semihosting -kernel %t.out 2>&1 | FileCheck %s \
// RUN:     && \
// RUN:     %clang --target=xtensa-esp-elf -mcpu=esp32 -fno-rtti -nostartfiles -lcrt1-sim -lpthread_stubs -Wl,--whole-archive,-lgloss,-lsys_qemu,--no-whole-archive -T memory.elf.ld -T app.elf.ld --ld-path=xtensa-esp32-elf-clang-ld -z noexecstack %s -o %t.out && \
// RUN:     qemu-system-xtensa -nographic -machine esp32 --semihosting -kernel %t.out 2>&1 | FileCheck %s \
// RUN:   %} \
// RUN: %else \
// RUN:   %{ \
// RUN:     %clang --target=armv6m-none-eabi -mfloat-abi=soft -march=armv6m -mfpu=none -lcrt0-semihost -lsemihost -T %S/Inputs/microbit.ld %s -o %t.out && \
// RUN:     qemu-system-arm -M microbit -semihosting -nographic -device loader,file=%t.out 2>&1 | FileCheck %s \
// RUN:   %}

#include <stdio.h>

int main(void) {
  printf("Hello World!\n"); // CHECK: Hello World!
  return 0;
}
