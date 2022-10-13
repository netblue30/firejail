ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: firecfg

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) ../include/common.h ../include/euid_common.h ../include/libnetlink.h ../include/firejail_user.h ../include/pid.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

firecfg: $(OBJS) ../lib/common.o ../lib/firejail_user.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o ../lib/firejail_user.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o firecfg *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean
