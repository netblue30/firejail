fids_sources = [            
  'main.c',        
  'blake2b.c',
  'db.c',
  'db_exclude.c',
]                           
                            
executable('fids', fids_sources,
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
  install_mode: 'rwxr-xr-x',

  c_args: [
    c_args_constants,
  ],
)
