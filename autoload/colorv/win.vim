"=============================================
"    Name: win.vim
"    File: win.vim
" Summary: manage windows
"  Author: Rykka G.F
"  Update: 2012-12-29
"=============================================
let s:cpo_save = &cpo
set cpo-=C

fun! colorv#win#get(name) "{{{
    if bufwinnr(bufnr(a:name)) != -1
        exe bufwinnr(bufnr(a:name)) . "wincmd w"
        return 1
    else
        return 0
    endif
endf "}}}
fun! colorv#win#new(name,...) "{{{
    " Optional win arg [dir, loc, size]
    let [dir, loc, size] = a:0 ? a:1 : ['','', 5]
    let loc = empty(loc) ? g:colorv_win_pos : loc
    let exists_buffer= bufnr(a:name)
    if exists_buffer== -1
        silent! exec loc.' '.size.dir.'new '. a:name
    else
        let exists_window = bufwinnr(exists_buffer)
        if exists_window != -1
            if winnr() != exists_window
                silent! exe exists_window . "wincmd w"
            endif
        else
            call colorv#win#get(a:name)
            silent! exe loc." ".size.dir."split +buffer" . exists_buffer
        endif
    endif

    call s:win_setl()
endfun "}}}

function! s:check_win(name) "{{{
    if bufnr('%') != bufnr(a:name)
        return 0
    else
        return 1
    endif
endfunction "}}}
function! s:win_setl() "{{{
    " local setting
    setl buftype=nofile bufhidden=hide nobuflisted
    setl noswapfile
    setl winfixwidth winfixheight noea
    setl nocursorline nocursorcolumn
    setl nolist nowrap
    setl nofoldenable nonumber foldcolumn=0
    setl tw=0 nomodeline
    setl sidescrolloff=0
    if v:version >= 703
        setl cc=
    endif
endfunction "}}}

fun! colorv#win#back(bufinfo) "{{{
    let [bufnr,bufname,bufwinnr,pos] = a:bufinfo
    
    " If buf win not exists
    if bufwinnr(bufnr) == -1
        call colorv#debug("No such buffer window.")
        return 0
    endif

    " switch to bufwin
    if bufwinnr != bufwinnr('%')
        exe bufwinnr."wincmd w"
    endif

    " check if it's same buf win
    if bufnr != bufnr('%') || bufname != bufname('%')
        call colorv#debug("Doesn't get the right buffer.")
        return 0
    else
        call setpos('.',pos)
        return 1
    endif
endfun "}}}

function! colorv#win#is_same(name) "{{{
    if bufnr('%') != bufnr(a:name)
        return 0
    else
        return 1
    endif
endfunction "}}}
fun! colorv#win#exit(name) "{{{
    if colorv#win#get(a:name)
        call colorv#clear_all()
        close
    else
        return -1
    endif
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
