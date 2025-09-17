#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#define ATOMIC_LOAD_DEF(N, T) \
T __atomic_load_##N(T *ptr, int memorder) \
{ \
    (void)memorder; \
    return *ptr; \
}

#define ATOMIC_STORE_DEF(N, T) \
void __atomic_store_##N(T *ptr, T val, int memorder) \
{ \
    (void)memorder; \
    *ptr = val; \
}

#define ATOMIC_FETCH_ADD_DEF(N, T) \
T __atomic_fetch_add_##N(T *ptr, T val, int memorder) \
{ \
    (void)memorder; \
    T old = *ptr; \
    *ptr = old + val; \
    return old; \
}

#define ATOMIC_FETCH_SUB_DEF(N, T) \
T __atomic_fetch_sub_##N(T *ptr, T val, int memorder) \
{ \
    (void)memorder; \
    T old = *ptr; \
    *ptr = old - val; \
    return old; \
}

#define ATOMIC_FETCH_OR_DEF(N, T) \
T __atomic_fetch_or_##N(T *ptr, T val, int memorder) \
{ \
    (void)memorder; \
    T old = *ptr; \
    *ptr = old | val; \
    return old; \
}

#define ATOMIC_FETCH_AND_DEF(N, T) \
T __atomic_fetch_and_##N(T *ptr, T val, int memorder) \
{ \
    (void)memorder; \
    T old = *ptr; \
    *ptr = old & val; \
    return old; \
}

#define ATOMIC_FETCH_XOR_DEF(N, T) \
T __atomic_fetch_xor_##N(T *ptr, T val, int memorder) \
{ \
    (void)memorder; \
    T old = *ptr; \
    *ptr = old ^ val; \
    return old; \
}

#define ATOMIC_EXCHANGE_DEF(N, T) \
T __atomic_exchange_##N(T *ptr, T val, int memorder) \
{ \
    (void)memorder; \
    T tmp = *ptr; \
    *ptr = val; \
    return tmp; \
}

#define ATOMIC_COMPARE_EXCHANGE_DEF(N, T) \
bool __atomic_compare_exchange_##N(T *ptr, T *expected, T desired, bool weak, int success_memorder, int failure_memorder) \
{ \
    (void)weak; \
    (void)success_memorder; \
    (void)failure_memorder; \
    if (*ptr != *expected) \
    { \
        *expected = *ptr; \
        return false; \
    } \
    *ptr = desired; \
    return true; \
}

ATOMIC_LOAD_DEF(1, int8_t)
ATOMIC_LOAD_DEF(2, int16_t)
ATOMIC_LOAD_DEF(4, int32_t)
ATOMIC_LOAD_DEF(8, int64_t)

ATOMIC_STORE_DEF(1, int8_t)
ATOMIC_STORE_DEF(2, int16_t)
ATOMIC_STORE_DEF(4, int32_t)
ATOMIC_STORE_DEF(8, int64_t)

ATOMIC_FETCH_ADD_DEF(1, int8_t)
ATOMIC_FETCH_ADD_DEF(2, int16_t)
ATOMIC_FETCH_ADD_DEF(4, int32_t)
ATOMIC_FETCH_ADD_DEF(8, int64_t)

ATOMIC_FETCH_SUB_DEF(1, int8_t)
ATOMIC_FETCH_SUB_DEF(2, int16_t)
ATOMIC_FETCH_SUB_DEF(4, int32_t)
ATOMIC_FETCH_SUB_DEF(8, int64_t)

ATOMIC_FETCH_OR_DEF(1, int8_t)
ATOMIC_FETCH_OR_DEF(2, int16_t)
ATOMIC_FETCH_OR_DEF(4, int32_t)
ATOMIC_FETCH_OR_DEF(8, int64_t)

ATOMIC_FETCH_AND_DEF(1, int8_t)
ATOMIC_FETCH_AND_DEF(2, int16_t)
ATOMIC_FETCH_AND_DEF(4, int32_t)
ATOMIC_FETCH_AND_DEF(8, int64_t)

ATOMIC_FETCH_XOR_DEF(1, int8_t)
ATOMIC_FETCH_XOR_DEF(2, int16_t)
ATOMIC_FETCH_XOR_DEF(4, int32_t)
ATOMIC_FETCH_XOR_DEF(8, int64_t)

ATOMIC_EXCHANGE_DEF(1, int8_t)
ATOMIC_EXCHANGE_DEF(2, int16_t)
ATOMIC_EXCHANGE_DEF(4, int32_t)
ATOMIC_EXCHANGE_DEF(8, int64_t)

ATOMIC_COMPARE_EXCHANGE_DEF(1, int8_t)
ATOMIC_COMPARE_EXCHANGE_DEF(2, int16_t)
ATOMIC_COMPARE_EXCHANGE_DEF(4, int32_t)
ATOMIC_COMPARE_EXCHANGE_DEF(8, int64_t)

#pragma redefine_extname __atomic_is_lock_free_c __atomic_is_lock_free

bool __atomic_is_lock_free_c(unsigned int size, const volatile void *ptr)
{
#ifdef __riscv_atomic
    return size <= 4;
#else
    return false;
#endif
}