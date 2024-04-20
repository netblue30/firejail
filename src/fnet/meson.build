fnet_sources = [
  'main.c',
  'arp.c',
  'interface.c',
  'veth.c',

  '../lib/common.c',
  '../lib/libnetlink.c',
]

executable('fnet', fnet_sources,
  install: true,
  install_dir: libdir_firejail,
  install_mode: sbox_apps_non_dumpable_perms,

  c_args: [
    c_args, constants, facilities,
  ],
)

