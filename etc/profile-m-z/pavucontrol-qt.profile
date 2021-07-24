# Firejail profile for pavucontrol-qt
# Description: PulseAudio Volume Control [Qt]
# This file is overwritten after every install/update
# Persistent local customizations
include pavucontrol-qt.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.config/pavucontrol-qt

mkdir ${HOME}/.config/pavucontrol-qt
allow  ${HOME}/.config/pavucontrol-qt

private-bin pavucontrol-qt
ignore private-lib

# Redirect
include pavucontrol.profile
