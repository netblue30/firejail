# Firejail profile for chromium-browser-privacy
# This file is overwritten after every install/update
# Persistent local customizations
include chromium-browser-privacy.local

noblacklist ${HOME}/.cache/ungoogled-chromium
noblacklist ${HOME}/.config/ungoogled-chromium

blacklist /usr/libexec

mkdir ${HOME}/.cache/ungoogled-chromium
mkdir ${HOME}/.config/ungoogled-chromium
whitelist ${HOME}/.cache/ungoogled-chromium
whitelist ${HOME}/.config/ungoogled-chromium

#private-bin basename,bash,cat,chromium-browser-privacy,dirname,mkdir,readlink,sed,touch,which,xdg-settings

# Redirect
include chromium.profile
