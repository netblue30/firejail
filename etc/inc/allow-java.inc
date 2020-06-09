# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-java.local

noblacklist ${HOME}/.java
noblacklist ${PATH}/java
noblacklist /etc/java
noblacklist /usr/lib/java
noblacklist /usr/share/java
