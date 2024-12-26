# It's a terminal UI program. Suppress any unintended output.
quiet
# Persistent local customizations
include hledger-ui.local
# Persistent global definitions
# added by included profile
#include globals.local

# This seems required for launching editor in hledger-ui
include allow-bin-sh.inc

include hledger-common.profile
