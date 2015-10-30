################################
# Generic GUI application profile
################################
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
blacklist ${HOME}/.pki/nssdb
blacklist ${HOME}/.lastpass
blacklist ${HOME}/.keepassx
blacklist ${HOME}/.password-store
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot

