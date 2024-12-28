#include <iostream>

int main(void) {
  std::cout << "No exceptions." << std::endl;
  return 0;
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
