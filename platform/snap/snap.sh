#!/bin/bash

rm -fr faudit-snap
rm -f faudit_*.snap
mkdir faudit-snap
cd faudit-snap
snapcraft init
cp ../snapcraft.yaml .
#snapcraft stage
mkdir -p stage/usr/lib/firejail
cp ../../../src/faudit/faudit stage/usr/lib/firejail/.
find stage
snapcraft stage
snapcraft snap
cd ..
mv faudit-snap/faudit_*.snap ../../.
rm -fr faudit-snap



