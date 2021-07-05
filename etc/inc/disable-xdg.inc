# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-xdg.local

deny  ${DOCUMENTS}
deny  ${MUSIC}
deny  ${PICTURES}
deny  ${VIDEOS}

# The following should be considered catch-all directories
#blacklist ${DESKTOP}
#blacklist ${DOWNLOADS}
