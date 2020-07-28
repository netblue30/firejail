# Firejail profile for android-studio
# This file is overwritten after every install/update
# Persistent local customizations
include android-studio.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.AndroidStudio*
noblacklist ${HOME}/.android
noblacklist ${HOME}/.jack-server
noblacklist ${HOME}/.jack-settings
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

# Allows files commonly used by IDEs
include allow-common-devel.inc

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
