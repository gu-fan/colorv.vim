"=============================================
"    Name: cache.vim
"    File: cache.vim
" Summary: cache things for colorv
"  Author: Rykka G.F
"  Update: 2012-12-29
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! colorv#cache#write(file, variable) "{{{
    if !g:colorv_load_cache
        return 0
    endif
    try
        call writefile([string(a:variable)], a:file)
    catch /^Vim\%((\a\+)\)\=:E/
        call colorv#error("Could not write cache.\r ".v:exception)
        return 0
    endtry
endfun "}}}
fun! colorv#cache#read(file) "{{{
    if !g:colorv_load_cache
        return []
    endif
    try
        let var = eval(readfile(a:file)[0])
        return var
    catch /^Vim\%((\a\+)\)\=:E/
        call colorv#debug("Could not read cache.\r ".v:exception)
        return []
    endtry
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
