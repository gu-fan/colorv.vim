"=============================================
"    Name: mark.vim
"    File: mark.vim
" Summary: mark faved colors
"  Author: Rykka G.F
"  Update: 2012-12-30
"=============================================
let s:cpo_save = &cpo
set cpo-=C


fun! s:expand(list,len,item) "{{{
    " Expand list to length with item
    let lst_len = len(a:list)
    if lst_len < a:len
        call extend(a:list, map(range(a:len-lst_len),'a:item'), 0)
    endif
endfun "}}}
fun! s:trunc(list,len) "{{{
    " return a:list[-a:len : -1]
    if len(a:list) > a:len
        call remove(a:list, 0 , (len(a:list)-a:len-1))
    endif
endfun "}}}

fun! colorv#mark#save() "{{{
    call s:trunc(g:_colorv['mark'],20)
    call colorv#cache#write(g:colorv_cache_file, g:_colorv['mark'])
endfun "}}}
fun! colorv#mark#load() "{{{
    let g:_colorv['mark'] = colorv#cache#read(g:colorv_cache_file)
    call s:expand(g:_colorv['mark'],20,'0')
endfun "}}}

fun! colorv#mark#draw() "{{{
    let len=len(g:_colorv['mark'])
    let clr_list=[]
    if &background=="light"
        let t="333333"
    else
        let t="AAAAAA"
    endif
    for i in range(19)
        " let cpd_color= len>i ? g:_colorv['mark'][-1-i] : t
        let cpd_color= exists("g:_colorv['mark'][-1-i]") &&
                    \g:_colorv['mark'][-1-i]=~'\x\{6}' ? g:_colorv['mark'][-1-i] : t
        call add(clr_list,cpd_color)
    endfor
    call colorv#draw_rects(g:_colorv['mark_rect'],clr_list)
endfun "}}}

fun! colorv#mark#add(...) "{{{
    if a:0
        let g:_colorv['mark'][a:1] = g:colorv.HEX
        call colorv#mark#draw()
        call colorv#mark#save()
        call colorv#echo("add color to mark list rect :".g:colorv.HEX)
        return
    endif
    if string(get(g:_colorv['mark'],-1))!=string(g:colorv.HEX)
        call add(g:_colorv['mark'],g:colorv.HEX)
        if g:_colorv['size']=="max"
            call colorv#mark#draw()
            call colorv#mark#save()
        endif
        call colorv#echo("add color to mark list:".g:colorv.HEX)
    endif
endfun "}}}
fun! colorv#mark#del(n) "{{{
    let h = g:_colorv['mark'][a:n]
    let g:_colorv['mark'][a:n] = 0
    if g:_colorv['size']=="max"
        call colorv#mark#draw()
        call colorv#mark#save()
    endif
    call colorv#echo("del color in mark list:".h)
endfun "}}}

let &cpo = s:cpo_save
unlet s:cpo_save
