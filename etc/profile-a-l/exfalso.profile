# Firejail profile for exfalso
# Description: GTK audio tag editor
# This file is overwritten after every install/update
# Persistent local customizations
include exfalso.local
# Persistent global definitions
# added by included profile
#include globals.local

private-lib libatk-1.0.so.*,libgdk-3.so.*,libgdk_pixbuf-2.0.so.*,libgirepository-1.0.so.*,libgstreamer-1.0.so.*,libgtk-3.so.*,libgtksourceview-3.0.so.*,libpango-1.0.so.*,libpython*,libreadline.so.*,libsoup-2.4.so.*,libssl.so.1.*,python2*,python3*

dbus-user none

# Redirect
include quodlibet.profile
