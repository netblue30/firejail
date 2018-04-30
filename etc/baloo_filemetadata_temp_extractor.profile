# Firejail profile for baloo_filemetadata_temp_extractor
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/baloo_filemetadata_temp_extractor.local
# Persistent global definitions
include /etc/firejail/globals.local

ignore read-write
read-only ${HOME}

# Redirect
include /etc/firejail/baloo_file.profile
