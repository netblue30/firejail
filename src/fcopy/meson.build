fcopy_sources = [
  'main.c',

  '../lib/common.c',
]

executable('fcopy', fcopy_sources,
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
  # TODO: Maybe use something like 'install_mode: SBOX_APPS_NON_DUMPABLE_PERMS'
  install_mode: 'rwx--x--x',
)
