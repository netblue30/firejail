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

.PHONY: distclean
distclean: clean
