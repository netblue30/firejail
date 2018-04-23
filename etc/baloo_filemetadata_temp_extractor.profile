# Firejail profile for baloo_filemetadata_temp_extractor
# This file is overwritten after every install/update
# Persistent local customizations
quiet
include /etc/firejail/baloo_filemetadata_temp_extractor.local
# Persistent global definitions
include /etc/firejail/globals.local


# Redirect
include /etc/firejail/baloo_file.profile
