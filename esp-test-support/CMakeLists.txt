
cmake_minimum_required(VERSION 3.20.0)
project(esp-test-support LANGUAGES C ASM)

add_library(test_support STATIC
  sysconf.c
  clock_gettime.c
  sched_yield.c
  atomics.c
  pthread_stubs.c
)

if(RISCV)
  add_library(crt1_sim_test STATIC
    riscv/crt1-sim-test.S
  )
endif()

install(TARGETS test_support crt1_sim_test)
