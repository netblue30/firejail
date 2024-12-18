# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-common-devel.local

# Arduino
noblacklist ${HOME}/.arduino15
noblacklist ${HOME}/Arduino

# Git
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials

# Java
noblacklist ${HOME}/.ammonite
noblacklist ${HOME}/.config/jgit
noblacklist ${HOME}/.g8
noblacklist ${HOME}/.gradle
noblacklist ${HOME}/.ivy2
noblacklist ${HOME}/.java
noblacklist ${HOME}/.sbt

# Node.js
noblacklist ${HOME}/.node-gyp
noblacklist ${HOME}/.npm
noblacklist ${HOME}/.npmrc
noblacklist ${HOME}/.nvm
noblacklist ${HOME}/.yarn
noblacklist ${HOME}/.yarn-config
noblacklist ${HOME}/.yarncache
noblacklist ${HOME}/.yarnrc

# PlatformIO
noblacklist ${HOME}/.platformio

# Python
noblacklist ${HOME}/.pylint.d
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.python_history
noblacklist ${HOME}/.pythonhist

# Ruby
noblacklist ${HOME}/.bundle

# Rust
noblacklist ${HOME}/.cargo
noblacklist ${HOME}/.rustup
