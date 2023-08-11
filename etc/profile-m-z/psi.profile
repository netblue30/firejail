# Firejail profile for psi
# Description: Native XMPP client with GPG support
# This file is overwritten after every install/update
# Persistent local customizations
include psi.local
# Persistent global definitions
include globals.local

# Add the next line to your psi.local to enable GPG support.
#noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.cache/psi
noblacklist ${HOME}/.cache/Psi
noblacklist ${HOME}/.config/psi
noblacklist ${HOME}/.local/share/psi
noblacklist ${HOME}/.local/share/Psi

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Add the next line to your psi.local to enable GPG support.
#mkdir ${HOME}/.gnupg
mkdir ${HOME}/.cache/psi
mkdir ${HOME}/.cache/Psi
mkdir ${HOME}/.config/psi
mkdir ${HOME}/.local/share/psi
mkdir ${HOME}/.local/share/Psi
# Add the next line to your psi.local to enable GPG support.
#whitelist ${HOME}/.gnupg
whitelist ${HOME}/.cache/psi
whitelist ${HOME}/.cache/Psi
whitelist ${HOME}/.config/psi
whitelist ${HOME}/.local/share/psi
whitelist ${HOME}/.local/share/Psi
whitelist ${DOWNLOADS}
# Add the next lines to your psi.local to enable GPG support.
#whitelist /usr/share/gnupg
#whitelist /usr/share/gnupg2
whitelist /usr/share/psi
# Add the next lines to your psi.local to enable GPG support.
#whitelist ${RUNUSER}/gnupg
#whitelist ${RUNUSER}/keyring
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
novideo
nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
#tracelog # breaks on Arch

disable-mnt
# Add the next line to your psi.local to enable GPG support.
#private-bin gpg,gpg2,gpg-agent,pinentry-curses,pinentry-emacs,pinentry-fltk,pinentry-gnome3,pinentry-gtk,pinentry-gtk2,pinentry-gtk-2,pinentry-qt,pinentry-qt4,pinentry-tty,pinentry-x2go,pinentry-kwallet
private-bin getopt,psi
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
