ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/rundefs.h ../include/common.h ../include/ldd_utils.h ../include/euid_common.h ../include/pid.h ../include/seccomp.h ../include/syscall_i386.h ../include/syscall_x86_64.h ../include/firejail_user.h
MOD_OBJS = ../lib/common.o ../lib/ldd_utils.o ../lib/firejail_user.o ../lib/errno.o ../lib/syscall.o

.PHONY: all
all: firejail

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

firejail: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o firejail *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean
