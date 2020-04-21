# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-common-devel.local

# Git
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials

# Java
noblacklist ${HOME}/.gradle
noblacklist ${HOME}/.java

# Python
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.python_history
noblacklist ${HOME}/.pythonhist

# Rust
noblacklist ${HOME}/.cargo/config
noblacklist ${HOME}/.cargo/registry
