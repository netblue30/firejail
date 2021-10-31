custom_target('libtrace.so',
  build_by_default: true,
  command: [cc, c_args, c_args_libtrace, '-o', '@OUTPUT@', '@INPUT@'],
  input: 'libtrace.c',
  install: true,
  install_dir: libdir_firejail,
  output: 'libtrace.so',
)
