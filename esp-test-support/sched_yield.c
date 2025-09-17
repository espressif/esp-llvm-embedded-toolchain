#include <sched.h>
#include <errno.h>
#undef errno
extern int errno;

int sched_yield( void )
{
  errno = ENOSYS;
  return -1;
}
