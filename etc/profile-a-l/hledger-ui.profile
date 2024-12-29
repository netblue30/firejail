# Firejail profile for hledger-ui
# Description: terminal interface (TUI) for hledger
# This file is overwritten after every install/update
# Persistent local customizations
include hledger-ui.local

# This seems required for launching editor in hledger-ui
# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include hledger.profile
