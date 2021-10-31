fcopy_sources = [
  'main.c',

  '../lib/common.c',
]

executable('fcopy', fcopy_sources,
  install: true,
  install_dir: libdir_firejail,
  install_mode: sbox_apps_non_dumpable_perms,

  dependencies: libselinux,

  c_args: [
    c_args, constants, facilities,
  ],
)
