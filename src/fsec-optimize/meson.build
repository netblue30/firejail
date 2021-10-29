fsec_optimize_seources = [
  'main.c',
  'optimizer.c',

  '../lib/common.c',
  '../lib/errno.c',
]

executable('fsec-optimize', fsec_optimize_seources,
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
  install_mode: 'rwx--x--x',
)
