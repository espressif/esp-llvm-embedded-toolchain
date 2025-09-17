#include <time.h>
#include <errno.h>
#undef errno
extern int errno;

int clock_gettime(clockid_t clock_id, struct timespec *t_time)
{
  errno = ENOSYS;
  return -1;
}
