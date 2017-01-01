# Firejail profile for FossaMail

noblacklist ~/.gnupg
mkdir ~/.gnupg
whitelist ~/.gnupg

noblacklist ~/.fossamail
mkdir ~/.fossamail
whitelist ~/.fossamail

noblacklist ~/.cache/fossamail
mkdir ~/.cache/fossamail
whitelist ~/.cache/fossamail

include /etc/firejail/firefox.profile
