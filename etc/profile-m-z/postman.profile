# Firejail profile for postman
# Description: API testing platform
# This file is overwritten after every install/update
# Persistent local customizations
include postman.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Postman
noblacklist ${HOME}/Postman

mkdir ${HOME}/.config/Postman
mkdir ${HOME}/Postman
whitelist ${HOME}/.config/Postman
whitelist ${HOME}/Postman
whitelist /opt/postman
include whitelist-run-common.inc

protocol unix,inet,inet6,netlink

private-bin Postman,electron,electron[0-9],electron[0-9][0-9],locale,node,postman,sh
private-etc @network,@tls-ca

# Redirect
include electron-common.profile
