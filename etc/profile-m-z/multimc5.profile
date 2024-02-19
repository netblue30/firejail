# Firejail profile for multimc5
# This file is overwritten after every install/update
# Persistent local customizations
include multimc5.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/multimc
noblacklist ${HOME}/.local/share/multimc5
noblacklist ${HOME}/.multimc5
noblacklist ${HOME}/.cache/JNA
noblacklist /tmp/lwjgl_*

# Ignore noexec on ${HOME} as MultiMC installs LWJGL native
# libraries in ${HOME}/.local/share/multimc
ignore noexec ${HOME}

# Ignore noexec on /tmp as LWJGL extracts libraries to /tmp
ignore noexec /tmp

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.local/share/multimc
mkdir ${HOME}/.local/share/multimc5
mkdir ${HOME}/.multimc5
mkdir ${HOME}/.cache/JNA
whitelist ${HOME}/.local/share/multimc
whitelist ${HOME}/.local/share/multimc5
whitelist ${HOME}/.multimc5
whitelist ${HOME}/.cache/JNA
whitelist /tmp/lwjgl_*
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
#seccomp

disable-mnt
# private-bin works, but causes weirdness
#private-bin apt-file,awk,bash,chmod,dirname,dnf,grep,java,kdialog,ldd,mkdir,multimc5,pfl,pkgfile,readlink,sort,valgrind,which,yum,zenity,zypper
private-dev
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
