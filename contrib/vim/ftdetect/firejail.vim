" Default paths
autocmd BufNewFile,BufRead /etc/firejail/*.inc          setfiletype firejail
autocmd BufNewFile,BufRead /etc/firejail/*.local        setfiletype firejail
autocmd BufNewFile,BufRead /etc/firejail/*.profile      setfiletype firejail
autocmd BufNewFile,BufRead ~/.config/firejail/*.inc     setfiletype firejail
autocmd BufNewFile,BufRead ~/.config/firejail/*.local   setfiletype firejail
autocmd BufNewFile,BufRead ~/.config/firejail/*.profile setfiletype firejail

" Arbitrary paths
autocmd BufNewFile,BufRead */firejail/*.inc             set filetype=firejail
autocmd BufNewFile,BufRead */firejail/*.local           set filetype=firejail
autocmd BufNewFile,BufRead */firejail/*.profile         set filetype=firejail
