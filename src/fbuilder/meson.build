fbuilder_sources = [
  'main.c',
  'build_bin.c',
  'build_fs.c',
  'build_home.c',
  'build_profile.c',
  'build_seccomp.c',
  'filedb.c',
  'utils.c',
]

executable('fbuilder', fbuilder_sources,
  install: true,
  install_dir: libdir_firejail,

  c_args: [
    c_args_constants,
  ],
)
