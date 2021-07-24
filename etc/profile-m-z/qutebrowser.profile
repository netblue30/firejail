# Firejail profile for qutebrowser
# Description: Keyboard-driven, vim-like browser based on PyQt5
# This file is overwritten after every install/update
# Persistent local customizations
include qutebrowser.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/qutebrowser
nodeny  ${HOME}/.config/qutebrowser
nodeny  ${HOME}/.local/share/qutebrowser

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/qutebrowser
mkdir ${HOME}/.config/qutebrowser
mkdir ${HOME}/.local/share/qutebrowser
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/qutebrowser
allow  ${HOME}/.config/qutebrowser
allow  ${HOME}/.local/share/qutebrowser
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
# blacklisting of chroot system calls breaks qt webengine
seccomp !chroot,!name_to_handle_at
# tracelog
