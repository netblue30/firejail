# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-common-devel.local

# Git
nodeny  ${HOME}/.config/git
nodeny  ${HOME}/.gitconfig
nodeny  ${HOME}/.git-credentials

# Java
nodeny  ${HOME}/.gradle
nodeny  ${HOME}/.java

# Node.js
nodeny  ${HOME}/.node-gyp
nodeny  ${HOME}/.npm
nodeny  ${HOME}/.npmrc
nodeny  ${HOME}/.nvm
nodeny  ${HOME}/.yarn
nodeny  ${HOME}/.yarn-config
nodeny  ${HOME}/.yarncache
nodeny  ${HOME}/.yarnrc

# Python
nodeny  ${HOME}/.pylint.d
nodeny  ${HOME}/.python-history
nodeny  ${HOME}/.python_history
nodeny  ${HOME}/.pythonhist

# Rust
nodeny  ${HOME}/.cargo/*
