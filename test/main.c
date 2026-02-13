#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include "libasm.h"

#define PASS "\033[32m✓\033[0m"
#define FAIL "\033[31m✗\033[0m"
#define RESET "\033[0m"
#define BONUS "\033[33m★\033[0m"

static void	test_strlen(void)
{
	printf("\n=== Testing ft_strlen ===\n");
	
	const char *tests[] = {
		"Hello, World!",
		"",
		"42 Network",
		"A very long string to test the function with more characters than usual"
	};
	
	for (size_t i = 0; i < sizeof(tests) / sizeof(tests[0]); i++)
	{
		size_t ft_result = ft_strlen(tests[i]);
		size_t c_result = strlen(tests[i]);
		printf("Test %zu: ft=%zu | libc=%zu %s\n", 
			i + 1, ft_result, c_result, 
			ft_result == c_result ? PASS : FAIL);
	}
}

static void	test_strcpy(void)
{
	printf("\n=== Testing ft_strcpy ===\n");
	
	const char *tests[] = {
		"Hello",
		"",
		"42 Network rocks!",
		"Special chars: @#$%"
	};
	
	for (size_t i = 0; i < sizeof(tests) / sizeof(tests[0]); i++)
	{
		char ft_buffer[100] = {0};
		char c_buffer[100] = {0};
		
		char *ft_result = ft_strcpy(ft_buffer, tests[i]);
		char *c_result = strcpy(c_buffer, tests[i]);
		
		int match = (strcmp(ft_buffer, c_buffer) == 0 && ft_result == ft_buffer);
		printf("Test %zu: \"%s\" %s\n", i + 1, ft_buffer, match ? PASS : FAIL);
	}
}

static void	test_strcmp(void)
{
	printf("\n=== Testing ft_strcmp ===\n");
	
	struct {
		const char *s1;
		const char *s2;
		const char *desc;
	} tests[] = {
		{"Hello", "Hello", "equal strings"},
		{"abc", "abd", "less than"},
		{"test", "", "greater than empty"},
		{"", "", "both empty"},
		{"Hello", "hello", "case different"},
		{"test123", "test124", "differ at end"}
	};
	
	for (size_t i = 0; i < sizeof(tests) / sizeof(tests[0]); i++)
	{
		int ft_result = ft_strcmp(tests[i].s1, tests[i].s2);
		int c_result = strcmp(tests[i].s1, tests[i].s2);
		
		int match = ((ft_result == 0 && c_result == 0) ||
		             (ft_result < 0 && c_result < 0) ||
		             (ft_result > 0 && c_result > 0));
		
		printf("Test %zu (%s): ft=%d | libc=%d %s\n", 
			i + 1, tests[i].desc, ft_result, c_result, match ? PASS : FAIL);
	}
}

static void	test_write(void)
{
	printf("\n=== Testing ft_write ===\n");
	
	const char *msg1 = "Hello from ft_write\n";
	const char *msg2 = "Test message 2\n";
	
	printf("Test 1: ");
	ssize_t ft_ret1 = ft_write(1, msg1, strlen(msg1));
	printf("         Bytes written: %zd | Expected: %zu %s\n", 
		ft_ret1, strlen(msg1), ft_ret1 == (ssize_t)strlen(msg1) ? PASS : FAIL);
	
	printf("Test 2: ");
	ssize_t ft_ret2 = ft_write(1, msg2, strlen(msg2));
	printf("         Bytes written: %zd | Expected: %zu %s\n", 
		ft_ret2, strlen(msg2), ft_ret2 == (ssize_t)strlen(msg2) ? PASS : FAIL);
	
	ssize_t ft_ret3 = ft_write(1, "", 0);
	printf("Test 3 (empty):   Bytes written: %zd | Expected: 0 %s\n", 
		ft_ret3, ft_ret3 == 0 ? PASS : FAIL);
	
	errno = 0;
	ssize_t ft_err = ft_write(-1, "test", 4);
	int saved_errno = errno;
	printf("Test 4 (bad fd):  Result: %zd | errno: %d %s\n", 
		ft_err, saved_errno, (ft_err == -1 && saved_errno == EBADF) ? PASS : FAIL);
}

static void	test_read(void)
{
	printf("\n=== Testing ft_read ===\n");
	
	char ft_buffer[100];
	char c_buffer[100];
	int fd = open("test/main.c", O_RDONLY);
	
	if (fd >= 0)
	{
		ssize_t ft_ret = ft_read(fd, ft_buffer, 20);
		lseek(fd, 0, SEEK_SET);
		ssize_t c_ret = read(fd, c_buffer, 20);
		
		int match = (ft_ret == c_ret && memcmp(ft_buffer, c_buffer, ft_ret) == 0);
		printf("Test 1 (read 20 bytes): ft=%zd | libc=%zd %s\n", 
			ft_ret, c_ret, match ? PASS : FAIL);
		
		lseek(fd, 0, SEEK_SET);
		ft_ret = ft_read(fd, ft_buffer, 0);
		printf("Test 2 (read 0 bytes):  ft=%zd | Expected: 0 %s\n", 
			ft_ret, ft_ret == 0 ? PASS : FAIL);
		
		close(fd);
	}
	
	errno = 0;
	ssize_t ft_err = ft_read(-1, ft_buffer, 10);
	int ft_errno = errno;
	
	errno = 0;
	ssize_t c_err = read(-1, c_buffer, 10);
	int c_errno = errno;
	
	printf("Test 3 (bad fd):        ft=%zd (errno=%d) | libc=%zd (errno=%d) %s\n", 
		ft_err, ft_errno, c_err, c_errno, 
		(ft_err == c_err && ft_errno == c_errno) ? PASS : FAIL);
}

static void	test_strdup(void)
{
	printf("\n=== Testing ft_strdup ===\n");
	
	const char *tests[] = {
		"Hello, World!",
		"",
		"42 Network",
		"Testing with special chars !@#$%"
	};
	
	for (size_t i = 0; i < sizeof(tests) / sizeof(tests[0]); i++)
	{
		char *ft_result = ft_strdup(tests[i]);
		char *c_result = strdup(tests[i]);
		
		int match = (ft_result && c_result && strcmp(ft_result, c_result) == 0);
		printf("Test %zu: \"%s\" %s\n", 
			i + 1, ft_result ? ft_result : "(null)", match ? PASS : FAIL);
		
		free(ft_result);
		free(c_result);
	}
}

int main(void)
{
	printf("\n╔════════════════════════════════════════╗\n");
	printf("║     LIBASM - Test Suite                ║\n");
	printf("╚════════════════════════════════════════╝\n");
	
	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write();
	test_read();
	test_strdup();
	
	printf("\n╔════════════════════════════════════════╗\n");
	printf("║     All tests completed!               ║\n");
	printf("╚════════════════════════════════════════╝\n\n");
	
	return (0);
}
