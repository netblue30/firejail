firecfg_sources = [
  'main.c',
  'desktop_files.c',
  'sound.c',
  'util.c',

  '../lib/firejail_user.c',
]

executable('firecfg', firecfg_sources,
  install: true,

  c_args: [
    c_args, constants, facilities
  ],
)

install_data('firecfg.config', install_dir: libdir_firejail)
