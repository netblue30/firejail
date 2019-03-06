# Firejail profile for sysprof-cli
# Description: Kernel based performance profiler (CLI)
# This file is overwritten after every install/update
# Persistent local customizations
include sysprof-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

nodbus

# There is no GUI help menu to break in the CLI version
private-bin sysprof-cli
private-lib

memory-deny-write-execute


# Redirect
include sysprof.profile
