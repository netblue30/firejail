fsec_print_sources = [
  'main.c',
  'print.c',

  '../lib/common.c',
  '../lib/errno.c',
  '../lib/syscall.c',
]

executable('fsec-print', fsec_print_sources,
  install: true,
  install_dir: libdir_firejail,
  install_mode: sbox_apps_non_dumpable_perms,

  c_args: [
    c_args, constants, facilities,
  ],
)
