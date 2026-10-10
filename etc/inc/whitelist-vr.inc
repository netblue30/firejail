noblacklist ${HOME}/.config/openvr
noblacklist ${HOME}/.config/openxr
noblacklist ${HOME}/.config/wivrn
noblacklist ${HOME}/.local/share/envision
noblacklist ${HOME}/.local/share/flatpak/app
noblacklist ${HOME}/.local/state/xrizer
noblacklist ${RUNUSER}/monado_comp_ipc
noblacklist ${RUNUSER}/wivrn
noblacklist /var/lib/flatpak/app

whitelist ${HOME}/.config/openvr
whitelist ${HOME}/.config/openxr
whitelist ${HOME}/.config/wivrn
whitelist ${HOME}/.local/share/envision
whitelist ${HOME}/.local/share/flatpak/app/io.github.wivrn.wivrn
whitelist ${HOME}/.local/state/xrizer
#whitelist ${RUNUSER}/monado_comp_ipc
#whitelist ${RUNUSER}/wivrn
whitelist /opt/OpenComposite
whitelist /opt/xrizer
whitelist /var/lib/flatpak/app/io.github.wivrn.wivrn

private-lib libmonado*,libopenvr_api.so*,libopenxr_*

read-only ${HOME}/.local/share/flatpak/app/io.github.wivrn.wivrn
read-only ${HOME}/.local/share/envision
read-only ${HOME}/.config/openxr
read-only ${HOME}/.config/openvr
read-only ${HOME}/.config/wivrn
