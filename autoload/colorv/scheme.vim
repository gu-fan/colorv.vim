"=============================================
"    Name: web.vim
"    File: web.vim
" Summary: Web color schemes
"  Author: Rykka G.F
"  Update: 2012-12-29
"=============================================
let s:cpo_save = &cpo
set cpo-=C

" Var {{{1
call colorv#default("g:colorv_url_colourlover", 'http://www.colourlovers.com/api/palettes')
call colorv#default("g:colorv_url_kuler_get", 'https://kuler-api.adobe.com/rss/get.cfm')
call colorv#default("g:colorv_url_kuler_search", 'https://kuler-api.adobe.com/rss/search.cfm')
call colorv#default("g:colorv_kuler_key", '5F0FC8D34554B6556221689C8BA5CFBC')
call colorv#default("g:colorv_default_api" , 'colour')

let s:win = {'name':'_ColorV_Schemes_','shift':9}
let s:win['rect']= [1+s:win.shift,2,7,5]
let g:_colorv = exists("g:_colorv") ? g:_colorv : {}
let g:_colorv['scheme'] = {'j':[],'idx':0,'type':'NUL','win':s:win}
let s:scheme = g:_colorv['scheme']
" track the text used for fetching online
let s:fetch = ''

" Fetch {{{1
fun! s:parse_colors(content) "{{{
    if a:content =~ 'Hex:'
        return split(matchstr(a:content,'Hex:\_s*\zs.*'), ', ')
    else
        return []
    endif
endfun "}}}
fun! colorv#scheme#fetch_k(...) "{{{ 
    try
        if a:0 && !empty(a:1)
            let txt = a:1
        else
            let txt = 'random'
        endif
        if txt =~ '^\x\{6}$'
            let objs = webapi#feed#parseURL(g:colorv_url_kuler_search.'?searchQuery=hex:'.txt.'&key='.g:colorv_kuler_key)
        else
            if txt is 'top'
                let txt = 'rating'
            elseif txt is 'hot'
                let txt = 'popular&timespan=30'
            elseif txt is 'new'
                let txt = 'recent'
            endif
            let objs = webapi#feed#parseURL(g:colorv_url_kuler_get.'?listtype='.txt.'&key='.g:colorv_kuler_key)
        endif

        for j in objs
            let j['colors'] = s:parse_colors(j['content'])
            if j['title'] =~ 'Theme Title:'
                let j['title'] = matchstr(j['title'], 'Theme Title:\s*\zs.*')
            endif
        endfor
        return objs
    catch
        call colorv#debug(v:exception)
        return -1
    endtry
endfun "}}}
fun! colorv#scheme#fetch_l(...) "{{{
    try 
        if a:0 && !empty(a:1)
            let txt = a:1
        else
            let txt = 'random'
        endif

        if txt =~ '^\x\{6}$'
            let r_obj = webapi#http#get(
                        \g:colorv_url_colourlover,
                        \{"format": 'json',"hex": txt,}
                        \)
        else
            if txt is 'hot' | let txt = 'top' | endif
            let r_obj = webapi#http#get(
                        \g:colorv_url_colourlover.'/'.txt,
                        \{"format": 'json',}
                        \)
        endif

        let j = webapi#json#decode(r_obj.content)
        return j
    catch
        call colorv#debug( v:exception)
        return -1
    endtry
endfun "}}}

fun! s:fetch_j(type,...) "{{{

    if a:type is 'kuler'
        let func = 'fetch_k'
    else
        let func = 'fetch_l'
    endif

    let s = a:0 ? a:1 : ''

    call colorv#echo('Search '. s .' scheme from '.a:type.'. Please wait...')
    let j = colorv#scheme#{func}(s)
    let s:fetch = s is 'Random' ? 'Rnd' : s

    if type(j) == type(1) 
        call colorv#error("ERROR FETCHING SCHEME:\nCheck webapi.vim installation and web connection. ")
        return []
    elseif empty(j)
        call colorv#warning("No scheme found.")
        return []
    endif
    echon 'Done'
    return j
endfun "}}}
" Win {{{1
fun! colorv#scheme#win(...) "{{{
    " Create a window for fetched colors
    if a:0 && !empty(a:1) || !exists("s:scheme.j") || empty(s:scheme.j)
        let j = s:fetch_j(g:colorv_default_api, a:1 )
    else
        let j = s:scheme.j
        call colorv#echo("Show previous schemes")
    endif

    call s:new_win(j)

endfun "}}}
fun! s:cur_color(idx) "{{{
    return s:scheme.j[s:scheme.idx].colors[a:idx]
endfun "}}}
fun! colorv#scheme#draw(idx) "{{{
    " draw text and scheme with index in all fetched schemes
    
    " clear previous scheme
    call colorv#clear('scheme')

    let m_idx = len(s:scheme.j)
    if a:idx >= m_idx
        let idx = 0
    elseif a:idx < 0
        let idx = m_idx-1
    else
        let idx = a:idx
    endif

    let j = s:scheme.j[idx]
    let s:scheme.idx = idx
    
    let w_line = repeat(" ",len(j.colors)*7+s:win.shift)
    let lines = map(range(7),'w_line')


    let lines[0] = j.title
    let lines[6] = '['.s:scheme.type.']   Top New Rnd   ' ."< ".printf('%2s',(idx+1)).'/'.printf('%-2s',len(s:scheme.j)).' >'

    call map(lines, 'repeat(" ",s:win.shift).v:val')
    
    " let lines[1] = repeat(" ",9).join(map(copy(j.colors),'"#".v:val'),'')

    let sav_cur = getpos('.')
    setl ma
        silent! %delete _
        call setline(1,lines)
    setl noma
    call colorv#draw_rects(s:win.rect, j.colors, 'scheme')
    call setpos('.',sav_cur)
    call s:hi_misc()

endfun "}}}
fun! s:hi_misc() "{{{
    " execute '3match' "Keyword".' /\%1l[<>]/'
    " execute '2match' "Keyword".' /\%7l\[.\{3}\]/'
    cal colorv#hi('scheme','cv_s_nav','\%7l[<>]',['','','underline'])
    cal colorv#hi('scheme','cv_s_type2','\%7l\s\h\{3}',['SpecialComment'])
    cal colorv#hi('scheme','cv_s_type','\%7l\[.*\]',['Keyword'],35)
endfun "}}}
fun! s:set_map() "{{{
    nnor <buffer><silent> q :call colorv#scheme#exit()<CR>
    nnor <buffer><silent> <Enter> :call colorv#scheme#act()<CR>
    nnor <buffer><silent> <2-LeftMouse> :call colorv#scheme#act()<CR>
    nnor <buffer><silent> <space><space> :call colorv#scheme#act()<CR>
    nnor <buffer><silent> n :call colorv#scheme#draw(g:_colorv.scheme.idx+1)<CR>
    nnor <buffer><silent> N :call colorv#scheme#draw(g:_colorv.scheme.idx-1)<CR>
    nnor <buffer><silent> p :call colorv#scheme#draw(g:_colorv.scheme.idx-1)<CR>
    nnor <buffer><silent> f :call colorv#scheme#fav()<CR>
    nnor <buffer><silent> F :call colorv#scheme#unfav()<CR>
    nnor <buffer><silent> s :call colorv#scheme#show_fav()<CR>
    nnor <buffer><silent> e :call colorv#scheme#edit()<CR>
    nnor <buffer><silent> sn :call colorv#scheme#new()<CR>
    nnor <buffer><silent> K :call colorv#scheme#up('kuler')<CR>
    nnor <buffer><silent> C :call colorv#scheme#up('colour')<CR>
endfun "}}}

fun! s:set_var(objs, ...) "{{{
    unlet! s:scheme.j
    if type(a:objs) == type({})
        let s:scheme.j = [a:objs]
    else
        let s:scheme.j = a:objs
    endif

    if a:0 && !empty(a:1)
        let s:scheme.type = a:1
    else
        if g:colorv_default_api is 'kuler'
            let s:scheme.type = 'KUL'
        else
            let s:scheme.type = 'COL'
        endif
    endif

    if !empty(s:fetch)
        if s:scheme.type =~ 'FAV\|NEW'
            let s:fetch = ''
        endif
        let s:scheme.type = s:scheme.type . " " . s:fetch
    endif

endfun "}}}

let g:_colorv['sbufinfo'] = []
fun! s:new_win(list, ...) "{{{

    if !colorv#win#is_same(s:win.name)
        let g:_colorv['sbufinfo'] = [bufnr('%'),bufname('%'),winnr(),getpos('.')]
    endif
    call colorv#win#new(s:win.name ,['', 'top',7])

    call s:set_map()
    if a:0
        call s:set_var(a:list,a:1)
    else
        call s:set_var(a:list)
    endif
    call colorv#scheme#draw(0)
    
endfun "}}}
fun! colorv#scheme#exit() "{{{
    if colorv#win#get(s:win.name)
        call colorv#clear('scheme')
        close
        " call colorv#win#get(g:_colorv.name)
    else
        return -1
    endif
    if !empty(g:_colorv['sbufinfo'])
        call colorv#win#back(g:_colorv['sbufinfo'])
    endif
endfun "}}}
" Fav {{{1
fun! colorv#scheme#show_fav() "{{{
    call colorv#scheme#load()
    if empty(s:fav_list)
        call colorv#warning("Fav List is Empty.")
    else
        call s:new_win(s:fav_list,'FAV')
    endif
endfun "}}}
fun! colorv#scheme#fav() "{{{
    " add to fav list
    if s:scheme.type is 'FAV' 
        call colorv#warning("Already Faved this scheme")
        return 
    endif
    let t={'title': s:scheme.j[s:scheme.idx]['title'], 'colors':s:scheme.j[s:scheme.idx]['colors'] }
    for j in s:fav_list
        if j.title is t.title && j.colors == t.colors
            call colorv#warning("Already Faved this scheme")
            return 
        endif
    endfor
    call add(s:fav_list, t)
    call colorv#scheme#save()
    call colorv#echo("Fav ".t['title'])
endfun "}}}
fun! colorv#scheme#unfav() "{{{
    " rmv from fav list
    if s:scheme.type != 'FAV'
        let t = s:scheme.j[s:scheme.idx]

        for i in range(len(s:fav_list))
            if s:fav_list[i].title is t.title && s:fav_list[i].colors == t.colors
                unlet s:fav_list[i]
                call colorv#scheme#save()
                call colorv#warning("Unfaved this scheme.")
                return 
            endif
        endfor
        call colorv#warning("No such scheme in Fav list")
        return 
    endif
    if input("Unfav current scheme?(yes/no):") is 'yes'
        call colorv#echo("Unfav ".s:fav_list[s:scheme.idx]['title'])
        unlet s:fav_list[s:scheme.idx]
        call colorv#scheme#save()
        if empty(s:fav_list)
            call colorv#warning("Fav List is Empty. Exit.")
            call colorv#scheme#exit()
        else
            " call s:set_var(s:fav_list,'Fav')
            call colorv#scheme#draw(0) " it's using s:fav_list already
        endif
    endif
endfun "}}}

" Cache {{{1
fun! colorv#scheme#save() "{{{
    call colorv#cache#write(g:colorv_cache_fav, s:fav_list)
endfun "}}}
fun! colorv#scheme#load() "{{{
    let s:fav_list = colorv#cache#read(g:colorv_cache_fav)
endfun "}}}

" Action {{{1
fun! s:get_color_idx(col) "{{{
    if a:col > s:win.shift
        let idx = float2nr(trunc((a:col-s:win.shift-1)/7))
        let max = len(s:scheme.j[s:scheme.idx].colors)
        return  idx >= max ? -1 : idx
    else
        return -1
    endif
endfun "}}}
fun! colorv#scheme#act() "{{{
    let [row,col] = getpos('.')[1:2]
    if row == 7
        let char = getline(row)[col-1]
        if char is '>'
            call colorv#scheme#draw(s:scheme.idx+1)
        elseif char is '<'
            call colorv#scheme#draw(s:scheme.idx-1)
        else
            call colorv#scheme#up(g:colorv_default_api)
        endif
    elseif row > 1 && row < 7
        let idx = s:get_color_idx(col)
        if idx != -1
            call colorv#win("", s:scheme.j[s:scheme.idx].colors[idx])
        endif
    endif
endfun "}}}
fun! colorv#scheme#up(type) "{{{
    
    let s =''
    let [row,col] = getpos('.')[1:2]
    if row > 1 && row < 7
        let idx = s:get_color_idx(col)
        let s = idx != -1 ? s:cur_color(idx) : ''
    elseif row == 7
        let word = expand('<cword>')
        let s = word =~ 'Top\|New\|Rnd' ? word : ''
        let s = s =~ 'Rnd' ? 'Random' : s
    endif

    if empty(s)
        return
    endif

    let j = s:fetch_j(a:type, s)
    if !empty(j) 
        call s:set_var(j, a:type is 'kuler' ? 'KUL' : 'COL')
        call colorv#scheme#draw(0)
    endif

endfun "}}}
" Edit scheme
fun! colorv#scheme#edit() "{{{
    let [row,col] = getpos('.')[1:2]
    if row > 1 && row < 7
        let idx = s:get_color_idx(col)
        if idx != -1
            let title = s:scheme.j[s:scheme.idx].title
            let color = s:scheme.j[s:scheme.idx].colors[idx]
            call colorv#win("", color,['exit','colorv#scheme#edit_cb',[idx,title]])
        endif
    else
        call colorv#echo("Put cursor on pallete to change color")
    endif
endfun "}}}

fun! colorv#scheme#edit_cb(idx,title) "{{{
    " callback func
    if !colorv#win#back(g:_colorv['bufinfo'])  
        \ || !colorv#win#is_same(s:win.name)
        call colorv#error("Not right buffer.")
        return
    endif

    if s:scheme.j[s:scheme.idx].title != a:title
        call colorv#error("Not the same scheme.")
        return 
    endif

    let s:scheme.j[s:scheme.idx].colors[a:idx] = g:colorv.HEX
    call colorv#scheme#draw(s:scheme.idx)
    if s:scheme.type is 'FAV'
        call colorv#scheme#save()
    endif
    
endfun "}}}
" Create new scheme
fun! colorv#scheme#new(...) "{{{
    " Input: a:1 the colors length of the scheme.
    let len = a:0 && !empty(a:1) ? a:1 : 5

    let name = input('Please input a title for your scheme:')
    if empty(name)
        let name = 'New'
    endif
    let new_scheme = {'title':name, 'colors': map(range(1, len),'repeat(string(v:val),6)')}

    call s:new_win(new_scheme, 'NEW')
endfun "}}}

" TODO
" upload scheme

let &cpo = s:cpo_save
unlet s:cpo_save
