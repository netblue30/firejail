# Firejail profile for trivalent
# Description: Secureblue's hardened Chromium fork
# This file is overwritten after every install/update
# Persistent local customizations
include trivalent.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/trivalent
noblacklist ${HOME}/.config/trivalent

mkdir ${HOME}/.cache/trivalent
mkdir ${HOME}/.config/trivalent
whitelist ${HOME}/.cache/trivalent
whitelist ${HOME}/.config/trivalent

# We need this for some reason, just pulse/native doesn't work
whitelist ${RUNUSER}/pulse

private-bin arch,cat,dirname,exec,grep,mkdir,ps,readlink,sh,trivalent,uname

# Redirect
include chromium-common.profile
include chromium-common-hardened.inc.profile
