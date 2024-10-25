TESTS_TO_SKIP = [
# Nested functions, unsupported in clang
"20000822-1.c",
"20010209-1.c",
"20010605-1.c",
"20030501-1.c",
"20040520-1.c",
"20061220-1.c",
"20090219-1.c",
"920415-1.c",
"920428-2.c",
"920501-7.c",
"920612-2.c",
"920721-4.c",
"921017-1.c",
"921215-1.c",
"931002-1.c",
"comp-goto-2.c",
"nest-align-1.c",
"nest-stdar-1.c",
"nestfunc-1.c",
"nestfunc-2.c",
"nestfunc-3.c",
"nestfunc-5.c",
"nestfunc-6.c",
"nestfunc-7.c",
"pr22061-3.c",
"pr22061-4.c",
"pr24135.c",
"pr51447.c",
"pr71494.c",

# Expects gnu89 inline behaviour
"20001121-1.c",
"20020107-1.c",
"930526-1.c",
"961223-1.c",
"980608-1.c",
"bcp-1.c",
"loop-2c.c",
"p18298.c",
"restrict-1.c",
"unroll-1.c",
"va-arg-7.c",
"va-arg-8.c",

# Variable length arrays in structs, unsupported in clang
"20020412-1.c",
"20040308-1.c",
"20040423-1.c",
"20041218-2.c",
"20070919-1.c",
"align-nest.c",
"pr41935.c",

# Initialization of flexible array member unsupported in clang
"pr28865.c",

# Runtime failure even on clang x86
"20021127-1.c",
"20031003-1.c",
"alloca-1.c",
"bitfld-3.c",
"bitfld-5.c",
"eeprof-1.c",
"pr32244-1.c",
"pr34971.c",

# Non-void function must return a value
"920302-1.c",
"920501-3.c",
"920728-1.c",

# x86 only
"990413-2.c",

# Unsupported builtins, even on x86 clang
"pr39228.c",
"pr47237.c",
"va-arg-pack-1.c",

# Requires mmap
"loop-2f.c",
"loop-2g.c",

# Link error, even on x86 clang
"medce-1.c",

# Clang does not support 'DD' suffix on floating constant
"pr80692.c",

# No support for __builtin_longjmp/__builtin_setjmp. Also true of clang for
# AArch64.
"built-in-setjmp.c",
"pr60003.c",

# Clang at O0 does not work out the code referencing the undefined symbol can
# never be executed
"ieee/fp-cmp-7.c",

# Clang-16 error: error: size of array element of type 'XXX' (NNN bytes) isn't a multiple of its alignment (KKK bytes)
"pr36093.c",
"pr43783.c"
]

TESTS_TO_SKIP_RISCV = [
# Xtensa specific
"abi/call_abi_test.c"
]

TESTS_TO_SKIP_XTENSA = [
# Clang has no __builtin_malloc
"20071018-1.c",
"20071120-1.c",
"pr36765.c",
"pr43008.c",

# Must link with libm
"980709-1.c",
"float-floor.c",
# Unsupported builtins, even on x86 clang
"builtin-bitops-1.c",
"pr78586.c",
"pr79327.c",

# Requires definitions of stdout/stderr
"fprintf-1.c",
"fprintf-chk-1.c",
"gofast.c",
"vfprintf-1.c",
"vfprintf-chk-1.c",

# 64-bit Multiply-with-overflow expands to a __mulodi4, which is present in
# compiler-rt but not libgcc
"pr71554.c",

# __assert_fail is not defined in newlib
"pr58831.c",

# Test depends on Clang having the same __builtin_constant_p(x) behaviour as gcc.
# Fails on Clang x86-64 with optimisation enabled
"builtin-constant.c",

# pragma optimize("-option") is ignored by Clang
"alias-1.c",
"pr79043.c",

# Expects that function is always inlined
"990208-1.c",

# Checks optimiser-specific behaviour, also fails on Clang x86 with O1
"printf-chk-1.c",
"vprintf-chk-1.c",

# Test relies on undefined signed overflow behaviour (int foo - INT_MIN).
# Should really require -fwrapv
"20040409-1.c",
"20040409-2.c",
"20040409-3.c",

# clang complains the array is too large ???
"991014-1.c",

#Tests which doesn't currently fit to ESP test environment
"pr60822.c",
"20101011-1.c",
"20010122-1.c",
"960521-1.c",
"pr28982b.c",
"pr23135.c",
"990826-0.c",
"printf-1.c",

#It seems FP Div operation is not correctly simulated
"20071030-1.c",

#This tests correctly exectutes on hardware but not in test environment yet
"pr56982.c",
"pr78622.c",

#Test contains tricky feature like passing struct by value to va_arg, will be implemented in feature
"920625-1.c",
"920908-1.c",
"931004-10.c",
"931004-12.c",
"931004-14.c",
"931004-2.c",
"931004-4.c",
"931004-6.c",
"931004-8.c",
"pr38151.c",
"pr44575.c",
"stdarg-3.c",
"strct-stdarg-1.c",
"strct-varg-1.c",
"va-arg-22.c",

#xtensa-esp32-elf-gcc link error
"991112-1.c",

#It seems that these tests fail because of error in some LLVM optimizations and not by errors in Xtensa backend
"20000605-1.c",
"20041213-2.c",
"920612-1.c",
"920711-1.c",
"930529-1.c",
"pr22493-1.c",
"pr23047.c",
]
