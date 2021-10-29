fldd_source = [             
  'main.c',        
                            
  '../lib/common.c',       
  '../lib/ldd_utils.c',    
]                           
                            
executable('fldd', fldd_source,
  install: true,            
  install_dir: get_option('libdir') / meson.project_name(),
  install_mode: 'rwx--x--x',
                            
  c_args: [                 
    c_args_constants,       
  ],                        
)
