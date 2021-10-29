fnet_sources = [
  'main.c',
  'arp.c',
  'interface.c',
  'veth.c',

  '../lib/common.c',
  '../lib/libnetlink.c',
]

executable('fnet', fnet_sources,
  install: true,                             
  install_dir: get_option('libdir') / meson.project_name(),
  install_mode: 'rwx--x--x',
)

