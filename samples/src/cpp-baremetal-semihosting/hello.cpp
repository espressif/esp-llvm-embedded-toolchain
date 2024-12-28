#include <vector>
#include <iostream>

int main(void) {
  std::vector<int> v = {1, 2, 3};
  v.push_back(4);
  v.insert(v.end(), 5);

  for (int elem: v) {
    std::cout << elem << " ";
  }
  std::cout << std::endl;

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
