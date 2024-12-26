# This is a comment line wallet. Suppress firejail output.
quiet
# Persistent local customizations
include monero-wallet-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

# Since there is no standard path to wallet files,
# you are going to have to manually whitelist the directory that contains
# wallet files in monero-wallet-cli.local

mkdir ${HOME}/.shared-ringdb
whitelist ${HOME}/.shared-ringdb

private-bin monero-wallet-cli

include cryptonote-wallet-cli-common.profile
