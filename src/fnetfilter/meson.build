fnetfilter_sources = [
  'main.c',

  '../lib/common.c',
] 

executable('fnetfilter', fnetfilter_sources,           
  install: true,                             
  install_dir: libdir_firejail,
  install_mode: sbox_apps_non_dumpable_perms,

  c_args: [
    c_args, constants, facilities,
  ],
)
