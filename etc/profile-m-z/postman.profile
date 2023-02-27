# Firejail profile for postman
# This file is overwritten after every install/update
# Persistent local customizations
include postman.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/Postman
mkdir ${HOME}/Postman
whitelist ${HOME}/Postman

noblacklist ${HOME}/.config/Postman
mkdir ${HOME}/.config/Postman
whitelist ${HOME}/.config/Postman

#private-opt postman
private-bin postman,electron,electron[0-9],electron[0-9][0-9],locale,sh
private-etc alternatives,ca-certificates,crypto-policies,fonts,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,nsswitch.conf,pki,resolv.conf,ssl
whitelist-ro /usr/share/icons/hicolor/128x128/apps/postman.png

# Redirect
include electron.profile
