# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-xdg.local

blacklist ${DOCUMENTS}
blacklist ${MUSIC}
blacklist ${PICTURES}
blacklist ${VIDEOS}

# The following should be considered catch-all directories
#blacklist ${DESKTOP}
#blacklist ${DOWNLOADS}
