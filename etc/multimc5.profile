#
#Profile for multimc5
#

#No Blacklist Paths
noblacklist ${HOME}/.local/share/multimc5
noblacklist ${HOME}/.multimc5

#Blacklist Paths
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

#Whitelist Paths
mkdir ${HOME}/.local/share/multimc5
whitelist ${HOME}/.local/share/multimc5
mkdir ${HOME}/.multimc5
whitelist ${HOME}/.multimc5
include /etc/firejail/whitelist-common.inc

#Options
caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
