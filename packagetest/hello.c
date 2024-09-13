// RUN: %if target={{.*}}-esp-elf  \
// RUN:   %{ \
// RUN:     %clang --config rv32imac-zicsr-zifencei_ilp32_no-rtti_qemu_semihost.cfg %s -o %t.out && \
// RUN:     qemu-riscv32 -cpu rv32 %t.out 2>&1 | FileCheck %s && \
// RUN:     %clang --config esp32_no-rtti_qemu_semihost.cfg --ld-path=xtensa-esp32-elf-clang-ld -z noexecstack %s -o %t.out && \
// RUN:     qemu-system-xtensa -nographic -machine esp32 --semihosting -kernel %t.out 2>&1 | FileCheck %s \
// RUN:   %} \
// RUN: %else \
// RUN:   %{ \
// RUN:     %clang --config armv6m_soft_nofp_semihost.cfg -T %S/Inputs/microbit.ld %s -o %t.out && \
// RUN:     qemu-system-arm -M microbit -semihosting -nographic -device loader,file=%t.out 2>&1 | FileCheck %s \
// RUN:   %}

#include <stdio.h>

int main(void) {
  printf("Hello World!\n"); // CHECK: Hello World!
  return 0;
}
