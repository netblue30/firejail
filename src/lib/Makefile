ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: lib

include $(ROOT)/src/common.mk

.PHONY: lib
lib: $(OBJS)

%.o : %.c $(H_FILE_LIST) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

.PHONY: clean
clean:; rm -fr $(OBJS) *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean
