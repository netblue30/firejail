.SUFFIXES:
ROOT = ..
-include $(ROOT)/config.mk

TESTS=$(patsubst %/,%,$(wildcard */))

.PHONY: $(TESTS)
$(TESTS):
	cd $@ && ./$@.sh 2>&1 | tee $@.log
	cd $@ && grep -a TESTING $@.log && ! grep -a -q "TESTING ERROR" $@.log

.PHONY: clean
clean:
	for test in $(TESTS); do rm -f "$$test/$$test.log"; done
	rm -fr environment/-testdir
	rm -f environment/index.html*
	rm -f environment/logfile*
	rm -f environment/wget-log*
	rm -f sysutils/firejail_t*
	rm -f utils/firejail-test-file*
	rm -f utils/index.html*
	rm -f utils/lstesting
	rm -f utils/wget-log
	cd compile && (./compile.sh --clean || true)
