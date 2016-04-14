# Firejail profile for Mozilla Thunderbird (Icedove in Debian Stable)
# Users have icedove set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ~/.gnupg
mkdir ~/.gnupg
whitelist ~/.gnupg

noblacklist ~/.icedove
mkdir ~/.icedove
whitelist ~/.icedove

noblacklist ~/.cache/icedove
mkdir ~/.cache
mkdir ~/.cache/icedove
whitelist ~/.cache/icedove

include /etc/firejail/firefox.profile

