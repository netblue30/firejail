.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

GAWK ?= gawk
GZIP ?= gzip
RM ?= rm -f

MOD_DIR := $(ROOT)/src/man
MANPAGES_IN := $(sort $(wildcard $(MOD_DIR)/*.in))
MANPAGES_GZ := $(MANPAGES_IN:.in=.gz)
TARGET = $(MANPAGES_GZ)

.PHONY: all
all: $(TARGET)

# foo.1: foo.1.in
$(MOD_DIR)/%: $(MOD_DIR)/%.in $(ROOT)/config.mk
	@printf 'Generating %s from %s\n' $@ $<
	@$(GAWK) -f $(MOD_DIR)/preproc.awk -- $(MANFLAGS) <$< | \
	  $(MOD_DIR)/mkman.sh $(VERSION) >$@

# foo.1.gz: foo.1
$(MOD_DIR)/%.gz: $(MOD_DIR)/%
	@printf 'Generating %s from %s\n' $@ $<
	@$(RM) $@
	@$(GZIP) -n9 $<

.PHONY: clean
clean:; $(RM) *.1 *.5 *.gz
