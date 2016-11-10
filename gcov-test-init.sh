#!/bin/bash

USER=`whoami`
firejail --help
firemon --help
/usr/lib/firejail/fnet --help
/usr/lib/firejail/fseccomp --help
/usr/lib/firejail/ftee --help
firecfg --help
sudo chown $USER:$USER `find .`
touch gcov-test-initialized
