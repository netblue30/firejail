# Firejail profile for atril
# Description: MATE document viewer
# This file is overwritten after every install/update
# Persistent local customizations
include atril.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/atril
noblacklist ${HOME}/.config/atril
noblacklist ${DOCUMENTS}

#noblacklist ${HOME}/.local/share
# it seems to use only ${HOME}/.local/share/webkitgtk

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

#apparmor
caps.drop all
machine-id
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin 7z,7za,7zr,atril,atril-previewer,atril-thumbnailer,sh,tar,unrar,unzip,zipnote
private-dev
private-etc
# atril uses webkit gtk to display epub files
# waiting for globbing support in private-lib; for now hardcoding it to webkit2gtk-4.0
#private-lib webkit2gtk-4.0 # problems on Arch with the new version of WebKit
private-tmp

# webkit gtk killed by memory-deny-write-execute
#memory-deny-write-execute
restrict-namespaces
