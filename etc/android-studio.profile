# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/android-studio.local

# Firejail profile for Android Studio

noblacklist ${HOME}/.AndroidStudio*
noblacklist ${HOME}/.android
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.gradle
noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
#nosound
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
#private-tmp

noexec /tmp
