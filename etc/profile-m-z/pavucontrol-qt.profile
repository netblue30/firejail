# Firejail profile for pavucontrol-qt
# Description: PulseAudio Volume Control [Qt]
# This file is overwritten after every install/update
# Persistent local customizations
include pavucontrol-qt.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/pavucontrol-qt

# whitelisting in ${HOME} is broken, see #3112
#mkdir ${HOME}/.config/pavucontrol-qt
#whitelist ${HOME}/.config/pavucontrol-qt

private-bin pavucontrol-qt
ignore private-lib

# Redirect
include pavucontrol.profile
