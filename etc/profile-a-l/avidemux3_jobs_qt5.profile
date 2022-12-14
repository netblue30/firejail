# Firejail profile for avidemux3_jobs_qt5
# Description: The Qt5 GUI to run Avidemux jobs.
# This file is overwritten after every install/update
# Persistent local customizations
include avidemux3_jobs_qt5.local
# Persistent global definitions
# added by included profile
#include globals.local

# Provide a shell to spawn avidemux3_cli
include allow-bin-sh.inc
private-bin sh

# Needs to bind to a socket on localhost
protocol inet,inet6

# Redirect
include avidemux3_qt5.profile
