# Firejail profile for baloo_filemetadata_temp_extractor
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include baloo_filemetadata_temp_extractor.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore read-write
read-only ${HOME}

# Redirect
include baloo_file.profile
