# Firejail profile for qupzilla
# This file is overwritten after every install/update
# Persistent local customizations
include qupzilla.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.cache/qupzilla
nodeny  ${HOME}/.config/qupzilla

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/qupzilla
mkdir ${HOME}/.config/qupzilla
allow  ${HOME}/.cache/qupzilla
allow  ${HOME}/.config/qupzilla

# Redirect
include falkon.profile
