fldd_source = [             
  'main.c',        
                            
  '../lib/common.c',       
  '../lib/ldd_utils.c',    
]                           
                            
executable('fldd', fldd_source,
  install: true,            
  install_dir: libdir_firejail,
  install_mode: sbox_apps_non_dumpable_perms,
                            
  c_args: [                 
    c_args_constants,       
  ],                        
)
