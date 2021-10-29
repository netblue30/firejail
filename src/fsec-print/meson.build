fsec_print_sources = [
  'main.c',
  'print.c',

  '../lib/common.c',
  '../lib/errno.c',
  '../lib/syscall.c',
]

executable('fsec_print', fsec_print_sources,
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
)
