# Firejail profile for Mozilla Thunderbird
# Users have thunderbird set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ~/.gnupg
mkdir ~/.gnupg
whitelist ~/.gnupg

noblacklist ~/.thunderbird
mkdir ~/.thunderbird
whitelist ~/.thunderbird

noblacklist ~/.cache/thunderbird
mkdir ~/.cache/thunderbird
whitelist ~/.cache/thunderbird

include /etc/firejail/firefox.profile

