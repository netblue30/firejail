.SUFFIXES:
ROOT = ..
-include $(ROOT)/config.mk

RM ?= rm -f

TESTS=$(patsubst %/,%,$(wildcard */))

.PHONY: $(TESTS)
$(TESTS):
	cd $@ && ./$@.sh 2>&1 | tee $@.log
	cd $@ && grep -a TESTING $@.log && ! grep -a -q "TESTING ERROR" $@.log

.PHONY: clean
clean:
	for test in $(TESTS); do $(RM) "$$test/$$test.log"; done
	$(RM) -r environment/-testdir
	$(RM) environment/index.html*
	$(RM) environment/logfile*
	$(RM) environment/wget-log*
	$(RM) sysutils/firejail_t*
	$(RM) utils/firejail-test-file*
	$(RM) utils/index.html*
	$(RM) utils/lstesting
	$(RM) utils/wget-log
	cd compile && (./compile.sh --clean || true)
