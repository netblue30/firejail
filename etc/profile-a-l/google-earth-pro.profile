# Firejail profile for google-earth-pro
# This file is overwritten after every install/update
# Persistent local customizations
include google-earth-pro.local
# Persistent global definitions
# added by included profile
#include globals.local

# If you see errors about missing commands, uncomment the below or put 'ignore private-bin' into your google-earth-pro.local
#ignore private-bin
private-bin google-earth-pro,googleearth,googleearth-bin,gpsbabel,readlink,repair_tool,which,xdg-mime,xdg-settings

# Redirect
include google-earth.profile
