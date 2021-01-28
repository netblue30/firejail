# Firejail profile for google-earth-pro
# This file is overwritten after every install/update
# Persistent local customizations
include google-earth-pro.local
# Persistent global definitions
# added by included profile
#include globals.local

# Google Earth Pro can show issues that make it unpleasant to use, even when running unsandboxed.
# See https://wiki.archlinux.org/index.php/Google_Earth#Troubleshooting for details.
# Firejailing this application will demand extra work, as there are issues only upstream can fix (see #3906).
# As an alternative one could use the web version: https://earth.google.com/web/.
# The desktop version from the AUR can be made to work with firejail by appending the below snippet
# to /usr/bin/googleearth-pro:
# <--- snippet --->
# Post-shutdown cleaning
#_lock_app_running="${HOME}/.googleearth/instance-running-lock"
#[[ -L "$_lock_app_running" ]] && rm -f "${_lock_app_running:?}"
#_lock_collada_cache="/tmp/geColladaModelCacheLock"
#[[ -e "$_lock_collada_cache" ]] && rm -f "${_lock_collada_cache:?}"
#_lock_icon_cache="/tmp/geIconCacheLock"
#[[ -e "$_lock_icon_cache" ]] && rm -f "${_lock_icon_cache:?}"
# <--- end of snippet --->

# If you see errors about missing commands, uncomment the below or put 'ignore private-bin' into your google-earth-pro.local
#ignore private-bin
private-bin google-earth-pro,googleearth,googleearth-bin,gpsbabel,readlink,repair_tool,rm,which,xdg-mime,xdg-settings

# Redirect
include google-earth.profile
