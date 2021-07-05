# Firejail profile for uzbl-browser
# This file is overwritten after every install/update
# Persistent local customizations
include uzbl-browser.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/uzbl
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.local/share/uzbl

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/uzbl
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.local/share/uzbl
mkdir ${HOME}/.password-store
allow  ${DOWNLOADS}
allow  ${HOME}/.config/uzbl
allow  ${HOME}/.gnupg
allow  ${HOME}/.local/share/uzbl
allow  ${HOME}/.password-store
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
tracelog
