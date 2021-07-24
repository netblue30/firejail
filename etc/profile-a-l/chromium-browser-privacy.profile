# Firejail profile for chromium-browser-privacy
# This file is overwritten after every install/update
# Persistent local customizations
include chromium-browser-privacy.local

nodeny  ${HOME}/.cache/ungoogled-chromium
nodeny  ${HOME}/.config/ungoogled-chromium

deny  /usr/libexec

mkdir ${HOME}/.cache/ungoogled-chromium
mkdir ${HOME}/.config/ungoogled-chromium
allow  ${HOME}/.cache/ungoogled-chromium
allow  ${HOME}/.config/ungoogled-chromium

# private-bin basename,bash,cat,chromium-browser-privacy,dirname,mkdir,readlink,sed,touch,which,xdg-settings

# Redirect
include chromium.profile
