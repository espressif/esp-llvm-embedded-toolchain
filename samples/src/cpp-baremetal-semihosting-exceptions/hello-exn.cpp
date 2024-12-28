#include <iostream>

/* A helper function for __do_global_ctors, which is in crtend.o.
 * It has been adapted from GCC source code. In GCC, it resides under
 * the USE_EH_FRAME_REGISTRY macro, which is not enabled in Espressif
 * toolchains to save small memory amount. Nevertheless, when C++ exceptions
 * are enabled this initialization becomes necessary.
 */
extern "C" void __do_global_ctors_1(void)
{
    struct object {
        long placeholder[10];
    };
    void __register_frame_info(const void *begin, struct object * ob);
    extern char __eh_frame[];

    static struct object ob;
    __register_frame_info(__eh_frame, &ob);
}

int main(void) {
  // ESP-IDF calls this at startup
  __do_global_ctors_1();

  try {
    throw "error";
  } catch(...) {
    std::cout << "Exception caught." << std::endl;
    return 0;
  }
  std::cout << "Exception skipped." << std::endl;
  return 1;
}

#ifndef _GLIBCXX_HAVE_ATOMIC_LOCK_POLICY
int pthread_mutex_lock (pthread_mutex_t *__mutex) {
  return 0;
}
int pthread_mutex_unlock (pthread_mutex_t *__mutex) {
  return 0;
}
int pthread_cond_broadcast (pthread_cond_t *__cond) {
  return 0;
}
#endif
