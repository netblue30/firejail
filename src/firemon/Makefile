ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: firemon

include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h ../include/pid.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

firemon: $(OBJS) ../lib/common.o ../lib/pid.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o ../lib/pid.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o firemon *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean
