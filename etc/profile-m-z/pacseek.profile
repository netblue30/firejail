# Firejail profile for pacseek
# Description: TUI for searching and installing Arch Linux packages
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pacseek.local
# Persistent global definitions
#include globals.local

blacklist /tmp/.X11-unix
blacklist /usr/libexec
blacklist ${RUNUSER}

noblacklist ${HOME}/.config/pacseek

# This profile could be significantly strengthened by adding the following to
# pacseek.local:
#whitelist ${HOME}/<your-build-folder>
#whitelist ${HOME}/.gnupg

# Enable severely restricted access to ${HOME}/.gnupg:
#noblacklist ${HOME}/.gnupg
#read-only ${HOME}/.gnupg/gpg.conf
#read-only ${HOME}/.gnupg/trustdb.gpg
#read-only ${HOME}/.gnupg/pubring.kbx
#blacklist ${HOME}/.gnupg/random_seed
#blacklist ${HOME}/.gnupg/pubring.kbx~
#blacklist ${HOME}/.gnupg/private-keys-v1.d
#blacklist ${HOME}/.gnupg/crls.d
#blacklist ${HOME}/.gnupg/openpgp-revocs.d

# pacman (no capabilities, hence automatically read-only)
noblacklist /var/cache/pacman
noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /var/cache/pacman
whitelist /var/lib/pacman
include whitelist-run-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
# noroot is only disabled to allow the creation of kernel headers from an
# official PKGBUILD.
#noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private
private-bin pacman*,pacseek
private-cache
private-dev
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-write ${HOME}/.config/pacseek
restrict-namespaces
