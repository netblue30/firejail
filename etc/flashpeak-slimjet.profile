# Firejail profile for flashpeak-slimjet
# This file is overwritten after every install/update
# Persistent local customizations
include flashpeak-slimjet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/slimjet
noblacklist ${HOME}/.config/slimjet

mkdir ${HOME}/.cache/slimjet
mkdir ${HOME}/.config/slimjet
whitelist ${HOME}/.cache/slimjet
whitelist ${HOME}/.config/slimjet

# Redirect
include chromium-common.profile
