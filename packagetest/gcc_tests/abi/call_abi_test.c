#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

struct s1{
  int x[4];
};

struct s2{
  int x[6];
};

struct s3{
  int x[7];
};

struct s4{
  long long x[1];
};

int call_abi_test_1(int a1, int a2, char a3, int a4, int a5, int a6, int a7)
{
  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_test_2(int a1, int a2, int a3, long long a4, int a5, int a6, int a7)
{
  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_test_3(int a1, short a2, int a3, int a4, int a5, long long a6, int a7)
{
  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_test_4(int a1, int a2, int a3, int a4, int a5, long long a6, long long a7)
{
  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_test_5(int a1, int a2, int a3, int *a4, int a5, long long a6, long long *a7)
{
  return a1 + a2 + a3 + a4[0] + a5 + a6 + a7[0];
}

int call_abi_test_6(int a1, int a2, struct s1 a3, int a4, int a5, struct s2 a6, int a7)
{
  int res;
  
  res = a3.x[0] + a3.x[1] + a3.x[2] + a3.x[3];
  res += a6.x[0] + a6.x[1] + a6.x[2] + a6.x[3] + a6.x[4] + a6.x[5];
  
  return a1 + a2 + a4 + a5 + a7 + res;
}

int call_abi_test_7(struct s1 a1, struct s2 a2, int a3, int a4, int a5, int a6, int a7)
{
  int res;
  
  res = a1.x[0] + a1.x[1] + a1.x[2] + a1.x[3];
  res += a2.x[0] + a2.x[1] + a2.x[2] + a2.x[3] + a2.x[4] + a2.x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}

int call_abi_test_8(struct s1 *a1, struct s2 *a2, int a3, int a4, int a5, int a6, int a7)
{
  int res;
  
  res = a1->x[0] + a1->x[1] + a1->x[2] + a1->x[3];
  res += a2->x[0] + a2->x[1] + a2->x[2] + a2->x[3] + a2->x[4] + a2->x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}

int call_abi_test_9(struct s3 a1, struct s2 *a2, int a3, int a4, int a5, int a6, int a7)
{
  int res;
  
  res = a1.x[0] + a1.x[1] + a1.x[2] + a1.x[3] + a1.x[4] + a1.x[5] + a1.x[6];
  res += a2->x[0] + a2->x[1] + a2->x[2] + a2->x[3] + a2->x[4] + a2->x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}

int call_abi_test_10(struct s3 a1, struct s2 *a2, int a3, int a4, int a5, int a6, int a7, long long a8)
{
  int res;
  
  res = a1.x[0] + a1.x[1] + a1.x[2] + a1.x[3] + a1.x[4] + a1.x[5] + a1.x[6];
  res += a2->x[0] + a2->x[1] + a2->x[2] + a2->x[3] + a2->x[4] + a2->x[5];
  
  return a3 + a4 + a5 + a6 + a7 + a8 + res;
}

int call_abi_test_11(int a1, struct s4 a2, int a3, int a4, int a5, int a6, int a7, long long a8)
{
  int res;
  
  res = a1 + a2.x[0];
  
  return a3 + a4 + a5 + a6 + a7 + a8 + res;
}

//Test of functions with variable arguments
int call_abi_va_test_1(int a1, ...)
{
  va_list ap;

  va_start(ap, a1);
  int a2  = va_arg(ap, int);
  char a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  int a6  = va_arg(ap, int);
  int a7  = va_arg(ap, int);
  
  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_va_test_2(int a1, ...)
{
  va_list ap;

  va_start(ap, a1);
  int a2  = va_arg(ap, int);
  int a3  = va_arg(ap, int);
  long long a4  = va_arg(ap, long long);
  int a5  = va_arg(ap, int);
  int a6  = va_arg(ap, int);
  int a7  = va_arg(ap, int);

  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_va_test_3(int a1, ...)
{
  va_list ap;

  va_start(ap, a1);
  short a2  = va_arg(ap, int);
  int a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  long long a6  = va_arg(ap, long long);
  int a7  = va_arg(ap, int);

  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_va_test_4(int a1, ...)
{
  va_list ap;

  va_start(ap, a1);
  int a2  = va_arg(ap, int);
  int a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  long long a6  = va_arg(ap, long long);
  long long a7  = va_arg(ap, long long);
  
  return a1 + a2 + a3 + a4 + a5 + a6 + a7;
}

int call_abi_va_test_5(int a1, ...)
{
  va_list ap;

  va_start(ap, a1);
  int a2  = va_arg(ap, int);
  int a3  = va_arg(ap, int);
  int* a4  = va_arg(ap, int*);
  int a5  = va_arg(ap, int);
  long long a6  = va_arg(ap, long long);
  long long *a7  = va_arg(ap, long long *);
  
  return a1 + a2 + a3 + a4[0] + a5 + a6 + a7[0];
}

int call_abi_va_test_6(int a1, ...)
{
  va_list ap;
  int res;

  va_start(ap, a1);
  int a2  = va_arg(ap, int);
  struct s1 a3  = va_arg(ap, struct s1);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  struct s2 a6  = va_arg(ap, struct s2);
  int a7  = va_arg(ap, int);
  
  res = a3.x[0] + a3.x[1] + a3.x[2] + a3.x[3];
  res += a6.x[0] + a6.x[1] + a6.x[2] + a6.x[3] + a6.x[4] + a6.x[5];
  
  return a1 + a2 + a4 + a5 + a7 + res;
}

int call_abi_va_test_7(struct s1 a1, ...)
{
  va_list ap;
  int res;

  va_start(ap, a1);
  struct s2 a2  = va_arg(ap, struct s2);
  int a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  int a6  = va_arg(ap, int);
  int a7  = va_arg(ap, int);

  
  res = a1.x[0] + a1.x[1] + a1.x[2] + a1.x[3];
  res += a2.x[0] + a2.x[1] + a2.x[2] + a2.x[3] + a2.x[4] + a2.x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}

int call_abi_va_test_8(struct s1 *a1, ...)
{
  va_list ap;
  int res;

  va_start(ap, a1);
  struct s2 *a2  = va_arg(ap, struct s2 *);
  int a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  int a6  = va_arg(ap, int);
  int a7  = va_arg(ap, int);
  
  res = a1->x[0] + a1->x[1] + a1->x[2] + a1->x[3];
  res += a2->x[0] + a2->x[1] + a2->x[2] + a2->x[3] + a2->x[4] + a2->x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}

int call_abi_va_test_9(struct s3 a1, ...)
{
  va_list ap;
  int res;

  va_start(ap, a1);
  struct s2 *a2  = va_arg(ap, struct s2 *);
  int a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  int a6  = va_arg(ap, int);
  int a7  = va_arg(ap, int);
  
  res = a1.x[0] + a1.x[1] + a1.x[2] + a1.x[3] + a1.x[4] + a1.x[5] + a1.x[6];
  res += a2->x[0] + a2->x[1] + a2->x[2] + a2->x[3] + a2->x[4] + a2->x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}

int call_abi_va_test_10(struct s3 a1, struct s2 *a2, ...)
{
  va_list ap;
  int res;
  
  va_start(ap, a2);
  int a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  int a6  = va_arg(ap, int);
  int a7  = va_arg(ap, int);
  
  res = a1.x[0] + a1.x[1] + a1.x[2] + a1.x[3] + a1.x[4] + a1.x[5] + a1.x[6];
  res += a2->x[0] + a2->x[1] + a2->x[2] + a2->x[3] + a2->x[4] + a2->x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}

int call_abi_va_test_11(struct s1 a1, struct s2 *a2, ...)
{
  va_list ap;
  int res;
  
  va_start(ap, a2);
  int a3  = va_arg(ap, int);
  int a4  = va_arg(ap, int);
  int a5  = va_arg(ap, int);
  int a6  = va_arg(ap, int);
  int a7  = va_arg(ap, int);
  
  res = a1.x[0] + a1.x[1] + a1.x[2] + a1.x[3];
  res += a2->x[0] + a2->x[1] + a2->x[2] + a2->x[3] + a2->x[4] + a2->x[5];
  
  return a3 + a4 + a5 + a6 + a7 + res;
}


struct s1 v1 = {{0x00, 0x01, 0x02, 0x03}};
struct s2 v2 = {{0x00, 0x01, 0x02, 0x03, 0x04, 0x05}};
struct s3 v3 = {{0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x07}};
struct s4 v4 = {{0x1234}};

//Test of functions with fixed arguments
extern int call_abi_gcc_test_1(int a1, int a2, char a3, int a4, int a5, int a6, int a7);
extern int call_abi_gcc_test_2(int a1, int a2, int a3, long long a4, int a5, int a6, int a7);
extern int call_abi_gcc_test_3(int a1, short a2, int a3, int a4, int a5, long long a6, int a7);
extern int call_abi_gcc_test_4(int a1, int a2, int a3, int a4, int a5, long long a6, long long a7);
extern int call_abi_gcc_test_5(int a1, int a2, int a3, int *a4, int a5, long long a6, long long *a7);
extern int call_abi_gcc_test_6(int a1, int a2, struct s1 a3, int a4, int a5, struct s2 a6, int a7);
extern int call_abi_gcc_test_7(struct s1 a1, struct s2 a2, int a3, int a4, int a5, int a6, int a7);
extern int call_abi_gcc_test_8(struct s1 *a1, struct s2 *a2, int a3, int a4, int a5, int a6, int a7);
extern int call_abi_gcc_test_9(struct s3 a1, struct s2 *a2, int a3, int a4, int a5, int a6, int a7);
extern int call_abi_gcc_test_10(struct s3 a1, struct s2 *a2, int a3, int a4, int a5, int a6, int a7, long long a8);

//Test of functions with variable arguments
extern int call_abi_va_gcc_test_1(int a1, ...);
extern int call_abi_va_gcc_test_2(int a1, ...);
extern int call_abi_va_gcc_test_3(int a1, ...);
extern int call_abi_va_gcc_test_4(int a1, ...);
extern int call_abi_va_gcc_test_5(int a1, ...);
extern int call_abi_va_gcc_test_6(int a1, ...);
extern int call_abi_va_gcc_test_7(struct s1 a1, ...);
extern int call_abi_va_gcc_test_8(struct s1 *a1, ...);
extern int call_abi_va_gcc_test_9(struct s3 a1, ...);
extern int call_abi_va_gcc_test_10(struct s3 a1, struct s2 *a2, ...);
extern int call_abi_va_gcc_test_11(struct s1 a1, struct s2 *a2, ...);

extern int call_abi_gcc_test_all();

int call_abi_test_all()
{
	int res1, res2;
	int a;
	long long b;
	
	if (call_abi_gcc_test_all()) return 1;
	
	res1 = call_abi_gcc_test_1(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_test_1(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_gcc_test_1 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	res1 = call_abi_gcc_test_2(0x33, 0x47, 0x55, 0x22ll, 0x1234, 0x01, 0x823);
	res2 = call_abi_test_2(0x33, 0x47, 0x55, 0x22ll, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_gcc_test_2 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	res1 = call_abi_gcc_test_3(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823);
	res2 = call_abi_test_3(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823);
	if (res1 != res2) {
		printf("call_abi_gcc_test_3 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	res1 = call_abi_gcc_test_4(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823ll);
	res2 = call_abi_test_4(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823ll);
	if (res1 != res2) {
		printf("call_abi_gcc_test_4 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	a = 0x22;
	b = 0x823;
	res1 = call_abi_gcc_test_5(0x33, 0x47, 0x55, &a, 0x1234, 0x01ll, &b);
	res2 = call_abi_test_5(0x33, 0x47, 0x55, &a, 0x1234, 0x01ll, &b);
	if (res1 != res2) {
		printf("call_abi_gcc_test_5 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_gcc_test_6(0x33, 0x47, v1, 0x22, 0x1234, v2, 0x823);
	res2 = call_abi_test_6(0x33, 0x47, v1, 0x22, 0x1234, v2, 0x823);
	if (res1 != res2) {
		printf("call_abi_gcc_test_6 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_gcc_test_7(v1, v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_test_7(v1, v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_gcc_test_7 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_gcc_test_8(&v1, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_test_8(&v1, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_gcc_test_8 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_gcc_test_9(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_test_9(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_gcc_test_9 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_gcc_test_10(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823, 0x3344556677ll);
	res2 = call_abi_test_10(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823, 0x3344556677ll);
	if (res1 != res2) {
		printf("call_abi_gcc_test_10 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_gcc_test_11(0x33, v4, 0x55, 0x22, 0x1234, 0x01, 0x823, 0x3344556677ll);
	res2 = call_abi_test_11(0x33, v4, 0x55, 0x22, 0x1234, 0x01, 0x823, 0x3344556677ll);
	if (res1 != res2) {
		printf("call_abi_gcc_test_11 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

        //Run tests of functions with variable arguments
	res1 = call_abi_va_gcc_test_1(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_va_test_1(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_1 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	res1 = call_abi_va_gcc_test_2(0x33, 0x47, 0x55, 0x22ll, 0x1234, 0x01, 0x823);
	res2 = call_abi_va_test_2(0x33, 0x47, 0x55, 0x22ll, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_2 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	res1 = call_abi_va_gcc_test_3(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823);
	res2 = call_abi_va_test_3(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_3 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	res1 = call_abi_va_gcc_test_4(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823ll);
	res2 = call_abi_va_test_4(0x33, 0x47, 0x55, 0x22, 0x1234, 0x01ll, 0x823ll);
	if (res1 != res2) {
		printf("call_abi_va_test_4 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
	
	a = 0x22;
	b = 0x823;
	res1 = call_abi_va_gcc_test_5(0x33, 0x47, 0x55, &a, 0x1234, 0x01ll, &b);
	res2 = call_abi_va_test_5(0x33, 0x47, 0x55, &a, 0x1234, 0x01ll, &b);
	if (res1 != res2) {
		printf("call_abi_va_test_5 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_va_gcc_test_6(0x33, 0x47, v1, 0x22, 0x1234, v2, 0x823);
	res2 = call_abi_va_test_6(0x33, 0x47, v1, 0x22, 0x1234, v2, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_6 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_va_gcc_test_7(v1, v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_va_test_7(v1, v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_7 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_va_gcc_test_8(&v1, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_va_test_8(&v1, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_8 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_va_gcc_test_9(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_va_test_9(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_9 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_va_gcc_test_10(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_va_test_10(v3, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_10 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}

	res1 = call_abi_va_gcc_test_11(v1, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	res2 = call_abi_va_test_11(v1, &v2, 0x55, 0x22, 0x1234, 0x01, 0x823);
	if (res1 != res2) {
		printf("call_abi_va_test_11 failed res1 = %x res2 = %x\n", res1, res2);
		return 1;
	}
    return 0;
}

int main()
{
	if (call_abi_test_all())
		abort();
	return 0;
}
