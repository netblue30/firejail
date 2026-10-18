# Firejail profile for ChiPass
# Description: Cross Platform Password Manager (KeePassXC fork)
# This file is overwritten after every install/update
# Persistent local customizations
include ChiPass.local
# Persistent global definitions
# added by included profile
#include globals.local

# Ignore entries from keepassxc.profile.
ignore mkdir ${RUNUSER}/app/org.keepassxc.KeePassXC
ignore whitelist ${RUNUSER}/app/org.keepassxc.KeePassXC
ignore dbus-user.own org.keepassxc.KeePassXC.*
ignore join-or-start keepassxc

# You can enable whitelisting for ChiPass by adding the below to your ChiPass.local.
# If you do, you MUST store your database under ${DOCUMENTS}/ChiPass/foo.kdbx.
#mkdir ${DOCUMENTS}/ChiPass
#whitelist ${DOCUMENTS}/ChiPass
#include whitelist-common.inc

mkdir ${RUNUSER}/app/org.chipass.ChiPass
whitelist ${RUNUSER}/app/org.chipass.ChiPass
whitelist /usr/share/ChiPass

private-bin ChiPass,ChiPass-cli,ChiPass-proxy

dbus-user.own org.chipass.ChiPass.*

# Mutex is stored in /tmp by default, which is broken by private-tmp.
join-or-start ChiPass

# Redirect
include keepassxc.profile
