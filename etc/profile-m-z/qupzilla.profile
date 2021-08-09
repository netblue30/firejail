# Firejail profile for qupzilla
# This file is overwritten after every install/update
# Persistent local customizations
include qupzilla.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/qupzilla
noblacklist ${HOME}/.config/qupzilla

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/qupzilla
mkdir ${HOME}/.config/qupzilla
whitelist ${HOME}/.cache/qupzilla
whitelist ${HOME}/.config/qupzilla

# Redirect
include falkon.profile
