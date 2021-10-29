fnetfilter_sources = [
  'main.c',

  '../lib/common.c',
] 

executable('fnetfilter', fnetfilter_sources,           
  install: true,                             
  install_dir: get_option('libdir') / meson.project_name(),
  install_mode: 'rwx--x--x',
)
