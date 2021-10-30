custom_target('libtracelog.so',
  build_by_default: true,
  command: [cc, c_args, c_args_libtrace, '-o', '@OUTPUT@', '@INPUT@'],
  input: 'libtracelog.c',
  install: true,
  install_dir: libdir_firejail,
  output: 'libtracelog.so',
)
