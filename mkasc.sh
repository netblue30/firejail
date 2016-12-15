#!/bin/sh

echo "Calculationg SHA256 for all files in /transfer - firejail version $1"

cd /transfer
sha256sum * > firejail-$1-unsigned
gpg --clearsign --digest-algo SHA256 < firejail-$1-unsigned > firejail-$1.asc
gpg --verify firejail-$1.asc
gpg --detach-sign --armor firejail-$1.tar.xz
rm firejail-$1-unsigned

