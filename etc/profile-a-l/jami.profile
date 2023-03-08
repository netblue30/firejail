# Firejail profile for jami
# Description: An encrypted peer-to-peer messenger
# This file is overwritten after every install/update
# Persistent local customizations
include jami.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.config/jami.net
noblacklist ${HOME}/Videos/Jami

mkdir ${HOME}/.config/jami.net
mkdir ${HOME}/Videos/Jami

whitelist ${HOME}/.config/jami.net
whitelist ${HOME}/Videos/Jami

# Redirect
include jami-gnome.profile
