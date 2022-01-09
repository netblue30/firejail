# Firejail profile for neovim                                                                                                                                                                                           
# Description: Nvim is open source and freely distributable
# This file is overwritten after every install/update                                                                                                                                                                
# Persistent local customizations                                                                                                                                                                                    
include nvim.local                                                                                                                                                                                                    
# Persistent global definitions                                                                                                                                                                                      
include globals.local 

noblacklist ${HOME}/.vim                                                                                                                                                                                             
                                                                                                                                                                                                                     
include disable-common.inc                                                                                                                                                                                           
include disable-programs.inc                                                                                                                                                                                         
include disable-devel.inc                                                                                                                                                                                            
include disable-passwdmgr.inc                                                                                                                                                                                        
include disable-xdg.inc                                                                                                                                                                                              
include disable-write-mnt.inc                                                                                                                                                                                        
include whitelist-runuser-common.inc                                                                                                                                                                                 

# Allows files commonly used by IDEs                                                                                                                                                                                 
include allow-common-devel.inc                                                                                                                                                                                       
                                                                                                                                                                                                                     
caps.drop all                                                                                                                                                                                                        
netfilter                                                                                                                                                                                                            
nodbus                                                                                                                                                                                                               
nodvd                                                                                                                                                                                                                
nogroups                                                                                                                                                                                                             
noinput                                                                                                                                                                                                              
nonewprivs                                                                                                                                                                                                           
noroot                                                                                                                                                                                                               
notv                                                                                                                                                                                                                 
nou2f                                                                                                                                                                                                                
novideo                                                                                                                                                                                                              
protocol unix,inet,inet6                                                                                                                                                                                             
seccomp                                                                                                                                                                                                              
                                                                                                                                                                                                                     
private-dev                                                                                                                                                                                                          
                                                                                                                                                                                                                     
read-write ${HOME}/.vim
read-only ${HOME}/.config
