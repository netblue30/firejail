# Local customizations come here
include /etc/firejail/disable-passwdmgr.local

blacklist ${HOME}/.pki/nssdb
blacklist ${HOME}/.lastpass
blacklist ${HOME}/.keepassx
blacklist ${HOME}/.keepass
blacklist ${HOME}/.password-store
blacklist ${HOME}/keepassx.kdbx
blacklist ${HOME}/.config/keepassx
blacklist ${HOME}/.config/keepass
blacklist ${HOME}/.config/KeePass

