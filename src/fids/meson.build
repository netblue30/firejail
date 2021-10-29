fids_sources = [            
  'main.c',        
  'blake2b.c',
  'db.c',
  'db_exclude.c',
]                           
                            
executable('fids', fids_sources,
  install: true,
  install_dir: libdir_firejail,

  c_args: [
    c_args_constants,
  ],
)
