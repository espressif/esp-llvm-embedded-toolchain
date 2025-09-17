#include <pthread.h>
#include <stdlib.h>
#include <errno.h>
#undef errno
extern int errno;

/* simple pthread stubs which are intended to work in single-thread tests running in QEMU */
int pthread_mutex_init(pthread_mutex_t *mutex,
			    const pthread_mutexattr_t *attr) {
    return 0;
}

int pthread_mutex_destroy(pthread_mutex_t *mutex) {
    return 0;
}

int pthread_mutex_lock(pthread_mutex_t *mutex) {
    return 0;
}

int pthread_mutex_trylock(pthread_mutex_t *mutex) {
    return 0;
}

int pthread_mutex_unlock(pthread_mutex_t *mutex) {
    return 0;
}

int pthread_cond_init(pthread_cond_t *cond,
                const pthread_condattr_t *attr) {
    return 0;
}

int pthread_cond_destroy(pthread_cond_t *cond) {
    return 0;
}

int pthread_cond_wait(pthread_cond_t *cond,
                pthread_mutex_t *mutex) {
    return 0;
}

int pthread_cond_timedwait(pthread_cond_t *restrict cond,
                    pthread_mutex_t *restrict mutex,
                    const struct timespec *restrict abstime) {
    return 0;
}

int pthread_cond_broadcast(pthread_cond_t *cond) {
    return 0;
}

int pthread_cond_signal(pthread_cond_t *cond) {
    return 0;
}

int pthread_rwlock_init (pthread_rwlock_t *rwlock,
			     const pthread_rwlockattr_t *attr) {
    return 0;
}

int pthread_rwlock_wrlock (pthread_rwlock_t *rwlock) {
    return 0;
}

int pthread_rwlock_unlock (pthread_rwlock_t *rwlock) {
    return 0;
}

int pthread_rwlock_rdlock (pthread_rwlock_t *rwlock) {
    return 0;
}

int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                   void *(*start_routine) (void *), void *arg) {
    return 0;
}

int pthread_join(pthread_t thread, void **retval) {
    return 0;
}

int pthread_detach(pthread_t thread) {
    return 0;
}

pthread_t pthread_self(void) {
    return 0;
}

int pthread_key_create(pthread_key_t *key, void (*destructor)(void*)) {
    return 0;
}

#define MAX_THREAD_SPECIFIC_DATA 5
static void *specific_data[MAX_THREAD_SPECIFIC_DATA];

void *pthread_getspecific(pthread_key_t key) {
    if (key < MAX_THREAD_SPECIFIC_DATA) {
        return specific_data[key];
    }
    abort();
    return NULL;
}

int pthread_setspecific(pthread_key_t key, const void *value) {
    if (key < MAX_THREAD_SPECIFIC_DATA) {
        specific_data[key] = (void *)value;
        return 0;
    }
    abort();
    return -1;
}

int pthread_mutexattr_destroy(pthread_mutexattr_t *attr) {
    return 0;
}

int pthread_mutexattr_init(pthread_mutexattr_t *attr) {
    return 0;
}

int pthread_mutexattr_settype(pthread_mutexattr_t *attr, int type) {
    return 0;
}

int pthread_mutexattr_gettype(const pthread_mutexattr_t *restrict attr,
                    int *restrict type) {
    return 0;
}
