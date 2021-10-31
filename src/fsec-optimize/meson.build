fsec_optimize_sources = [
  'main.c',
  'optimizer.c',

  '../lib/common.c',
  '../lib/errno.c',
]

fsec_optimize = executable('fsec-optimize', fsec_optimize_sources,
  install: true,
  install_dir: libdir_firejail,
  install_mode: sbox_apps_non_dumpable_perms,

  c_args: [
    c_args, constants, facilities,
  ],
)
