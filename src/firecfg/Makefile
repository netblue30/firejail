ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h ../include/euid_common.h ../include/libnetlink.h ../include/firejail_user.h ../include/pid.h
MOD_OBJS = ../lib/common.o ../lib/firejail_user.o

.PHONY: all
all: firecfg

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

firecfg: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o firecfg *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean
