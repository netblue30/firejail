ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: firejail

include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/rundefs.h ../include/common.h ../include/ldd_utils.h ../include/euid_common.h ../include/pid.h ../include/seccomp.h ../include/syscall_i386.h ../include/syscall_x86_64.h ../include/firejail_user.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

firejail: $(OBJS) ../lib/common.o ../lib/ldd_utils.o ../lib/firejail_user.o ../lib/errno.o ../lib/syscall.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o ../lib/ldd_utils.o ../lib/firejail_user.o ../lib/errno.o ../lib/syscall.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o firejail *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean
