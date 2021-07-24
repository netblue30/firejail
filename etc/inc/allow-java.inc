# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-java.local

nodeny  ${HOME}/.java
nodeny  ${PATH}/java
nodeny  /etc/java
nodeny  /usr/lib/java
nodeny  /usr/share/java
