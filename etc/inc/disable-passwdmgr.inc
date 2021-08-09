# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-passwdmgr.local

blacklist ${HOME}/.config/Bitwarden
blacklist ${HOME}/.config/KeePass
blacklist ${HOME}/.config/keepass
blacklist ${HOME}/.config/keepassx
blacklist ${HOME}/.config/keepassxc
blacklist ${HOME}/.config/KeePassXCrc
blacklist ${HOME}/.config/Sinew Software Systems
blacklist ${HOME}/.fpm
blacklist ${HOME}/.keepass
blacklist ${HOME}/.keepassx
blacklist ${HOME}/.keepassxc
blacklist ${HOME}/.lastpass
blacklist ${HOME}/.local/share/KeePass
blacklist ${HOME}/.local/share/keepass
blacklist ${HOME}/.password-store

# Remove environment variables with auth tokens.
# Note however that the sandbox might still have access to the
# files where these variables are set.
rmenv GH_TOKEN
rmenv GITHUB_TOKEN
rmenv GH_ENTERPRISE_TOKEN
rmenv GITHUB_ENTERPRISE_TOKEN
rmenv CARGO_REGISTRY_TOKEN
rmenv RESTIC_KEY_HINT
rmenv RESTIC_PASSWORD_COMMAND
rmenv RESTIC_PASSWORD_FILE
