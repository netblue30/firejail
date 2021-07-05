# Firejail profile for android-studio
# This file is overwritten after every install/update
# Persistent local customizations
include android-studio.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/Google
nodeny  ${HOME}/.AndroidStudio*
nodeny  ${HOME}/.android
nodeny  ${HOME}/.jack-server
nodeny  ${HOME}/.jack-settings
nodeny  ${HOME}/.local/share/JetBrains
nodeny  ${HOME}/.tooling

# Allows files commonly used by IDEs
include allow-common-devel.inc

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-cache
# private-tmp

# noexec /tmp breaks 'Android Profiler'
#noexec /tmp
