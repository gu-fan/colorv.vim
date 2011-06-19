"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: autoload/ColorV.vim
" Summary: A Color Viewer and Color Picker for Vim
"  Author: Rykka.Krin <rykka.krin@gmail.com>
"    Home: 
" Version: 2.0.0 
" Last Update: 2011-06-19
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if !has("gui_running") || v:version < 700 || exists("g:colorV_loaded")
    finish
endif
let g:colorV_loaded = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GVAR: "{{{1 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ColorV={}
let g:ColorV.name="[ColorV]"
let g:ColorV.ver="2.0.0.1"

let g:ColorV.HEX="ff0000"
let g:ColorV.RGB={}
let g:ColorV.HSV={}
let g:ColorV.rgb=[]
let g:ColorV.hsv=[]

if !exists('g:ColorV_silent_set')
    let g:ColorV_silent_set=0
endif
if !exists('g:ColorV_set_register')
    let g:ColorV_set_register=0
endif
if !exists('g:ColorV_dynamic_hue')
    let g:ColorV_dynamic_hue=0
endif
if !exists('g:ColorV_dynamic_hue_step')
    let g:ColorV_dynamic_hue_step=6
endif
if !exists('g:ColorV_show_tips')
    let g:ColorV_show_tips=1
endif
if !exists('g:ColorV_show_star')
    let g:ColorV_show_star=1
endif
if !exists('g:ColorV_word_mini')
    let g:ColorV_word_mini=1
endif
if !exists('g:ColorV_echo_tips')
    let g:ColorV_echo_tips=0
endif
if !exists('g:ColorV_tune_step')
    let g:ColorV_tune_step=5
endif

if !exists('g:ColorV_win_pos')
    let g:ColorV_win_pos="bot"
endif
if !exists('g:ColorV_uppercase')
    let g:ColorV_uppercase=1
endif

"}}}
"SVAR: {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:ColorV={}
let s:mode= exists("s:mode") ? s:mode : "max"
let [s:max_h,s:mid_h,s:min_h]=[11,6,3]

let [s:pal_W,s:pal_H]=[20,10]
let [s:poff_x,s:poff_y]=[0,1]

let s:his_set_rect=[42,2,5,4]
let s:his_cpd_rect=[24,7,2,1]
let s:line_width=60
let s:mid_pos=[["Hex:",2,24,10],
            \["R:",3,24,5],["G:",4,24,5],["B:",5,24,5],
            \["H:",3,32,5],["S:",4,32,5],["V:",5,32,5],
            \["N:",1,42,15]
            \]
let s:min_pos=[["Hex:",1,22,10],
            \["R:",2,22,5],["G:",2,29,5],["B:",2,36,5],
            \["H:",3,22,5],["S:",3,29,5],["V:",3,36,5],
            \["N:",1,42,15]
            \]
let s:tips_list=[
            \'Choose: 2-Click/2-Space/Ctrl-K/Ctrl-J',
            \'Toggle: <TAB>/<C-N>/J   Back: <S-TAB>/<C-P>/K',
            \'Goto Parameter(RGB/HSV): r/gg/b/u/s/v/x    Name:nn',
            \'Edit Parameter(RGB/HSV): Enter/a/i',
            \'Colorname(W3C): na/ne      (X11):nx',
            \'Yank(reg"): yy/yr/ys/yn/... (reg+): cc/cr/cs/cn/...',
            \'Paste: <C-V>/p',
            \'Help: F1/H               Tips: ?',
            \'Quit: q/Q/<C-W>q/<C-W><C-Q>',
            \]

let s:t='fghDPijmrYFGtudBevwxklyzEIZOJLMnHsaKbcopqNACQRSTUVWX'

"X11 Standard
let s:clrnX11=[['Gray', 'BEBEBE'], ['Green', '00FF00']
            \, ['Maroon', 'B03060'], ['Purple', 'A020F0']]
"W3C Standard
let s:clrnW3C=[['Gray', '808080'], ['Green', '008000']
            \, ['Maroon', '800000'], ['Purple', '800080']]

let s:clrn=[
\  ['AliceBlue'           , 'f0f8ff'], ['AntiqueWhite'        , 'faebd7']
\, ['Aqua'                , '00ffff'], ['Aquamarine'          , '7fffd4']
\, ['Azure'               , 'f0ffff'], ['Beige'               , 'f5f5dc']
\, ['Bisque'              , 'ffe4c4'], ['Black'               , '000000']
\, ['BlanchedAlmond'      , 'ffebcd'], ['Blue'                , '0000ff']
\, ['BlueViolet'          , '8a2be2'], ['Brown'               , 'a52a2a']
\, ['BurlyWood'           , 'deb887'], ['CadetBlue'           , '5f9ea0']
\, ['Chartreuse'          , '7fff00'], ['Chocolate'           , 'd2691e']
\, ['Coral'               , 'ff7f50'], ['CornflowerBlue'      , '6495ed']
\, ['Cornsilk'            , 'fff8dc'], ['Crimson'             , 'dc143c']
\, ['Cyan'                , '00ffff'], ['DarkBlue'            , '00008b']
\, ['DarkCyan'            , '008b8b'], ['DarkGoldenRod'       , 'b8860b']
\, ['DarkGray'            , 'a9a9a9'], ['DarkGreen'           , '006400']
\, ['DarkKhaki'           , 'bdb76b'], ['DarkMagenta'         , '8b008b']
\, ['DarkOliveGreen'      , '556b2f'], ['Darkorange'          , 'ff8c00']
\, ['DarkOrchid'          , '9932cc'], ['DarkRed'             , '8b0000']
\, ['DarkSalmon'          , 'e9967a'], ['DarkSeaGreen'        , '8fbc8f']
\, ['DarkSlateBlue'       , '483d8b'], ['DarkSlateGray'       , '2f4f4f']
\, ['DarkTurquoise'       , '00ced1'], ['DarkViolet'          , '9400d3']
\, ['DeepPink'            , 'ff1493'], ['DeepSkyBlue'         , '00bfff']
\, ['DimGray'             , '696969'], ['DodgerBlue'          , '1e90ff']
\, ['FireBrick'           , 'b22222'], ['FloralWhite'         , 'fffaf0']
\, ['ForestGreen'         , '228b22'], ['Fuchsia'             , 'ff00ff']
\, ['Gainsboro'           , 'dcdcdc'], ['GhostWhite'          , 'f8f8ff']
\, ['Gold'                , 'ffd700'], ['GoldenRod'           , 'daa520']
\, ['GreenYellow'         , 'adff2f'], ['HoneyDew'            , 'f0fff0']
\, ['HotPink'             , 'ff69b4'], ['IndianRed'           , 'cd5c5c']
\, ['Indigo'              , '4b0082'], ['Ivory'               , 'fffff0']
\, ['Khaki'               , 'f0e68c'], ['Lavender'            , 'e6e6fa']
\, ['LavenderBlush'       , 'fff0f5'], ['LawnGreen'           , '7cfc00']
\, ['LemonChiffon'        , 'fffacd'], ['LightBlue'           , 'add8e6']
\, ['LightCoral'          , 'f08080'], ['LightCyan'           , 'e0ffff']
\, ['LightGoldenRodYellow', 'fafad2'], ['LightGrey'           , 'd3d3d3']
\, ['LightGreen'          , '90ee90'], ['LightPink'           , 'ffb6c1']
\, ['LightSalmon'         , 'ffa07a'], ['LightSeaGreen'       , '20b2aa']
\, ['LightSkyBlue'        , '87cefa'], ['LightSlateGray'      , '778899']
\, ['LightSteelBlue'      , 'b0c4de'], ['LightYellow'         , 'ffffe0']
\, ['Lime'                , '00ff00'], ['LimeGreen'           , '32cd32']
\, ['Linen'               , 'faf0e6'], ['Magenta'             , 'ff00ff']
\, ['MediumAquaMarine'    , '66cdaa']
\, ['MediumBlue'          , '0000cd'], ['MediumOrchid'        , 'ba55d3']
\, ['MediumPurple'        , '9370d8'], ['MediumSeaGreen'      , '3cb371']
\, ['MediumSlateBlue'     , '7b68ee'], ['MediumSpringGreen'   , '00fa9a']
\, ['MediumTurquoise'     , '48d1cc'], ['MediumVioletRed'     , 'c71585']
\, ['MidnightBlue'        , '191970'], ['MintCream'           , 'f5fffa']
\, ['MistyRose'           , 'ffe4e1'], ['Moccasin'            , 'ffe4b5']
\, ['NavajoWhite'         , 'ffdead'], ['Navy'                , '000080']
\, ['OldLace'             , 'fdf5e6'], ['Olive'               , '808000']
\, ['OliveDrab'           , '6b8e23'], ['Orange'              , 'ffa500']
\, ['OrangeRed'           , 'ff4500'], ['Orchid'              , 'da70d6']
\, ['PaleGoldenRod'       , 'eee8aa'], ['PaleGreen'           , '98fb98']
\, ['PaleTurquoise'       , 'afeeee'], ['PaleVioletRed'       , 'd87093']
\, ['PapayaWhip'          , 'ffefd5'], ['PeachPuff'           , 'ffdab9']
\, ['Peru'                , 'cd853f'], ['Pink'                , 'ffc0cb']
\, ['Plum'                , 'dda0dd'], ['PowderBlue'          , 'b0e0e6']
\, ['Red'                 , 'ff0000']
\, ['RosyBrown'           , 'bc8f8f'], ['RoyalBlue'           , '4169e1']
\, ['SaddleBrown'         , '8b4513'], ['Salmon'              , 'fa8072']
\, ['SandyBrown'          , 'f4a460'], ['SeaGreen'            , '2e8b57']
\, ['SeaShell'            , 'fff5ee'], ['Sienna'              , 'a0522d']
\, ['Silver'              , 'c0c0c0'], ['SkyBlue'             , '87ceeb']
\, ['SlateBlue'           , '6a5acd'], ['SlateGray'           , '708090']
\, ['Snow'                , 'fffafa'], ['SpringGreen'         , '00ff7f']
\, ['SteelBlue'           , '4682b4'], ['Tan'                 , 'd2b48c']
\, ['Teal'                , '008080'], ['Thistle'             , 'd8bfd8']
\, ['Tomato'              , 'ff6347'], ['Turquoise'           , '40e0d0']
\, ['Violet'              , 'ee82ee'], ['Wheat'               , 'f5deb3']
\, ['White'               , 'ffffff'], ['WhiteSmoke'          , 'f5f5f5']
\, ['Yellow'              , 'ffff00'], ['YellowGreen'         , '9acd32']
\]
let s:clrf=[   ['FF0000', '00FF00', '0000FF', 'Uryyb Jbeyq']
            \, ['0000FF', '00FF00', 'FF0000', 'qyebj byyrU']
            \, ['000000', 'C00000', '009A00', 'Nstunavfgna~']
            \, ['370095', 'FCE015', 'D81B3E', 'Naqbeen~']
            \, ['00257E', 'FFC725', '00257E', 'Oneonqbf~']
            \, ['000000', 'FFDA0C', 'F3172F', 'Orytvhz']
            \, ['007A5E', 'CE1125', 'FCD115', 'Pnzrebba~']
            \, ['FF0000', 'ffffff', 'FF0000', 'Pnanqn~']
            \, ['002468', 'FFCE00', 'D21033', 'Punq']
            \, ['F87F00', 'FFFFFF', '009F60', 'Pbgr q`Vibver']
            \, ['0C1B8B', 'FFFFFF', 'EF2A2C', 'Senapr']
            \, ['87C8E4', 'FFFFFF', '87C8E4', 'Thngrznyn~']
            \, ['CE1125', '00935F', 'FCD115', 'Thvarn']
            \, ['009D5F', 'FFFFFF', 'F77E00', 'Verynaq']
            \, ['008E46', 'FFFFFF', 'D3232C', 'Vgnyl']
            \, ['13B439', 'FCD115', 'CE1125', 'Znyv']
            \, ['016549', 'FFFFFF', 'CD132A', 'Zrkvpb~']
            \, ['0000B2', 'F7D900', '0000B2', 'Zbyqbin~']
            \, ['008851', 'FFFFFF', '008851', 'Avtrevn']
            \, ['188100', 'FFFFFF', '188100', 'Norfolk Island']
            \, ['CC0000', 'FFFFFF', 'CC0000', 'Erchoyvp b Creh']
            \, ['002A7E', 'FCD115', 'CE1125', 'Ebznavn']
            \, ['009246', 'F8F808', 'DD171D', 'Frartny~']
            \]

let s:fmt={}
let s:fmt.RGB='rgb(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3})'
let s:fmt.RGBA='rgba(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3}\,\s*\d\{1,3}%\=)'
let s:fmt.RGBP='rgb(\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%)'
let s:fmt.RGBAP='rgba(\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%\=)'
"ffffff
let s:fmt.HEX='[#\x]\@<!\x\{6}\x\@!'
"0xffffff
let s:fmt.HEX0='0x\x\{6}\x\@!'
"number sign 6 #ffffff
let s:fmt.NS6='#\x\{6}\x\@!'
"#fff 
let s:fmt.NS3='#\x\{3}\x\@!'

let s:fmt.HSV='hsv(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3})'
" let s:fmt.NAMW=''
" for [nam,hex] in s:clrnW3C+s:clrn
"     let s:fmt.NAMW .='\<'.nam.'\>\|'
" endfor
" 
" let s:fmt.NAMX=''
" for [nam,hex] in s:clrnX11+s:clrn
"     let s:fmt.NAMX .='\<'.nam.'\>\|'
" endfor
" 
" let s:fmt.NAMW =substitute(s:fmt.NAMW,'\\|$','','')
" let s:fmt.NAMX =substitute(s:fmt.NAMX,'\\|$','','')

let s:a='Elxxn'
let s:e='stuQCvwzeLSTghqOrijkxylmRVMBWYZaUfnXopbcdANPDEFGHIJK'

let s:aprx_rate=5
let s:aprx_name=exists("g:ColorV_name_approx") ? g:ColorV_name_approx :
            \ s:aprx_rate
let s:tune_step=exists("g:ColorV_tune_step") && g:ColorV_tune_step >0
            \ ? g:ColorV_tune_step : 5
"}}}
"CORE: "{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: Can be called directly with other plugins
" in [r,g,b] 0~255
" out [H,S,V] 0~360 0~100
function! ColorV#rgb2hsv(rgb)  "{{{
    let [r,g,b]=[a:rgb[0],a:rgb[1],a:rgb[2]] 
    " if r>255||g>255||b>255
    "         call s:warning("RGB input error")
    " 	return -1
    " endif
    let r=type(r)==type("0") ? str2nr(r) : r
    let g=type(g)==type("0") ? str2nr(g) : g
    let b=type(b)==type("0") ? str2nr(b) : b
    let r=fmod(r,256.0)
    let g=fmod(g,256.0)
    let b=fmod(b,256.0)
    "WKRND: 110601  weird with float input
    let r=type(r)==type(0.0) ? float2nr(r) : r
    let g=type(g)==type(0.0) ? float2nr(g) : g
    let b=type(b)==type(0.0) ? float2nr(b) : b


    let max=max([r,g,b])+0.0
    let min=min([r,g,b])+0.0
    let sub=max-min
    let V=round(max/2.55)
    let S=round(((V==0) ? 0 : (sub/max)*100.0))
    let H = max==min ? 0 : max==r ? 60.0*(g-b)/sub : 
          \(max==g ? 120+60.0*(b-r)/sub : 240+60.0*(r-g)/sub)
    let H=round(H<0?fmod(H,360.0)+360:(H>360?fmod(H,360.0) : H))
    let H=float2nr(H)
    let S=float2nr(S)
    let V=float2nr(V)
    return [H,S,V]
endfunction "}}}
" in [h,s,v] 0~360 0~100
" out [R,G,B] 0~255      "Follow info from wikipedia"
function! ColorV#hsv2rgb(hsv) "{{{
    let [h,s,v]=[a:hsv[0]+0.0,a:hsv[1]+0.0,a:hsv[2]+0.0]
    " if s>100||v>100||s<0||v<0
    "         call s:warning("HSV input error")
    "         return -1
    " endif
    if s>100
        let s=fmod(s,100.0)
    endif
    if v>100
        let v=fmod(v,100.0)
    endif
    let h=fmod(h,360.0)
    let v=v*2.55
    if s==0
    	let [R,G,B]=[v,v,v]
    else 
        let s=s/100.0
        let hi=floor(abs(h/60.0))+0.0
        let f=h/60.0 - hi
        let p=round(v*(1-s))
        let q=round(v*(1-f*s))
        let t=round(v*(1-(1-f)*s))
        let v=round(v)
        if hi==0
            let [R,G,B]=[v,t,p]
        elseif hi==1
            let [R,G,B]=[q,v,p]
        elseif hi==2
            let [R,G,B]=[p,v,t]
        elseif hi==3
            let [R,G,B]=[p,q,v]
        elseif hi==4
            let [R,G,B]=[t,p,v]
        elseif hi==5
            let [R,G,B]=[v,p,q]
        endif
    endif
    let R=float2nr(R)
    let G=float2nr(G)
    let B=float2nr(B)
    return [R,G,B]
endfunction "}}}
" in [r,g,b] num/str
" out ffffff
function! ColorV#rgb2hex(rgb)   "{{{
   let [r,g,b] = [a:rgb[0],a:rgb[1],a:rgb[2]]
    if r>255||g>255||b>255
            call s:warning("RGB input error")
    	return -1
    endif
    try 
        let r= float2nr(r)
        let g= float2nr(g)
        let b= float2nr(b)
    catch /^Vim\%((\a\+)\)\=:E808/
        " call s:debug("error E808")
    endtry
    let hex=printf("%06x",r*0x10000+g*0x100+b*0x1)
    if exists("g:ColorV_uppercase") && g:ColorV_uppercase == 1
    	let hex=substitute(hex,'\l','\u\0','g')
    endif
    
   return hex
endfunction "}}}
" in ffffff
" out [r,g,b]
function! ColorV#hex2rgb(hex) "{{{
   let hex=printf("%06x",'0x'.a:hex)
   let [r,g,b] = ["0x".hex[0:1],"0x".hex[2:3],"0x".hex[4:5]]
   return [printf("%d",r),printf("%d",g),printf("%d",b)]
endfunction "}}}
"}}}
"HELP: "{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:echo_tips() "{{{
    let txt_list=s:tips_list
    if exists("g:ColorV_echo_tips") && g:ColorV_echo_tips ==1
        call s:seq_echo(txt_list)
    elseif exists("g:ColorV_echo_tips") && g:ColorV_echo_tips ==2
        call s:rnd_echo(txt_list)
    else
        call s:all_echo(txt_list)
    endif
endfunction "}}}
function! s:all_echo(txt_list) "{{{
    let txt_list=a:txt_list
    call s:caution("[Tips of Keyboard Shortcuts]")
    let idx=0
    for txt in txt_list
        echo "[".idx."]" txt
        let idx+=1
    endfor
endfunction "}}}
function! s:rnd_echo(txt_list) "{{{
    let txt_list=a:txt_list
    let idx=0
    let rnd=s:roll(0,len(txt_list)-1)
    for txt in txt_list
    	if  rnd == idx
            echo "[".idx."]" txt
            break
        endif
        let idx+=1
    endfor
endfunction "}}}
function! s:seq_echo(txt_list) "{{{
    let txt_list=a:txt_list
    let s:seq_num= exists("s:seq_num") ? s:seq_num : 0
    let idx=0
    for txt in txt_list
        if fmod(s:seq_num,len(txt_list)) == idx
            echo "[".idx."]" txt
            break
        endif
        let idx+=1
    endfor
    let s:seq_num+=1
endfunction "}}}

function! s:caution(msg) "{{{
    echohl Modemsg
    exe "echom \"[Caution] ".escape(a:msg,'"')."\""
    echohl Normal
endfunction "}}}
function! s:warning(msg) "{{{
    echohl Warningmsg
    exe "echom \"[Warning] ".escape(a:msg,'"')."\""
    echohl Normal
endfunction "}}}
function! s:error(msg) "{{{
    echohl Errormsg
    exe "echom \"[Error] ".escape(a:msg,'"')."\""
    echohl Normal
endfunction "}}}
function! s:echo(msg) "{{{
    if g:ColorV_silent_set==0
        exe "echom \"[Note] ".escape(a:msg,'"')."\""
    else
    	echom ""
    endif
endfunction "}}}
function! s:debug(msg) "{{{
    if exists("g:ColorV_debug") && g:ColorV_debug==1
        echoe "[Debug] ".escape(a:msg,'"')
    endif
endfunction "}}}
function! s:roll(min,max) "{{{
    let init= str2nr(strftime("%S%m"))*9+
             \str2nr(strftime("%Y"))*3+
             \str2nr(strftime("%M%S"))*5+
             \str2nr(strftime("%H%d"))*1+19
    let s:seed=exists("s:seed") ? s:seed : init
    let s:seed=fmod((20907*s:seed+17343),104530)
    return fmod(s:seed,a:max-a:min+1)+a:min
endfunction "}}}
function! s:approx2(hex1,hex2,...) "{{{
    let [h1,s1,v1] = ColorV#rgb2hsv(ColorV#hex2rgb(a:hex1))
    let [h2,s2,v2] = ColorV#rgb2hsv(ColorV#hex2rgb(a:hex2))
    let r=exists("a:1") ? a:1 : s:aprx_rate
    if h2+r>=h1 && h1>=h2-r && s2+r>=s1 && s1>=s2-r
                \&& v2+r>=v1 && v1>=v2-r
    	return 1
    else
    	return 0
    endif

endfunction "}}}

function! s:update_his_set(hex) "{{{
    let hex= printf("%06x",'0x'.a:hex) 
    " update history_set
    let g:ColorV.history_set=exists("g:ColorV.history_set") ? g:ColorV.history_set : ['ff0000']
    
    if exists("s:skip_his_block") && s:skip_his_block==1
    	let s:skip_his_block=0
    else
        if get(g:ColorV.history_set,-1)!=hex
            call add(g:ColorV.history_set,hex)
        endif
    endif
endfunction "}}}
function! s:update_global(hex) "{{{
    let hex= strpart(printf("%06x",'0x'.a:hex),0,6) 
    if exists("g:ColorV_uppercase") && g:ColorV_uppercase == 1
    	let hex=substitute(hex,'\l','\u\0','g')
    endif

    let g:ColorV.HEX=hex
    let [r,g,b]= ColorV#hex2rgb(hex)
    let [h,s,v]= ColorV#rgb2hsv([r,g,b])
    let g:ColorV.NAME=s:hex2nam(hex)
    let g:ColorV.HSV.H=h
    let g:ColorV.HSV.S=s
    let g:ColorV.HSV.V=v
    let g:ColorV.RGB.R=r
    let g:ColorV.RGB.G=g
    let g:ColorV.RGB.B=b
    let g:ColorV.rgb=[r,g,b]
    let g:ColorV.hsv=[h,s,v]
endfunction "}}}
"}}}
"DRAW: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Input: h,l,c,[loffset,coffset]
function! s:draw_palette(h,l,c,...) "{{{
    call s:clear_palmatch()
    let [h,height,width,hstep,wstep]=[a:h,a:l,a:c,100.0/(a:l),100.0/(a:c)]
    let h_off=exists("a:1") ? a:1 : 1
    let w_off=exists("a:2") ? a:2 : 0
    if height>100 || width>100 || height<0 || width<0
    	echoe "error palette input"
    	return -1
    endif
    let h=fmod(h,360.0)
    
    let b:pal_clr_list=[]

    let line=1
    while line<=height
        let v=100-(line-1)*hstep
        let v= v==0 ? 1 : v 
        let col =1
        while col<=width
            let s=100-(col-1)*wstep
            let s= s==0 ? 1 : s 
            let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
            let group="colorV".hex
            exec "hi ".group." guifg=#".hex." guibg=#".hex
            let pos="\\%".(line+h_off)."l\\%".(col+w_off)."c"
            call add(b:pal_clr_list,hex)
            
            " add hl match to pallet_dict
            if !exists("s:pallet_dict")|let s:pallet_dict={}|endif
            let s:pallet_dict[group]=matchadd(group,pos)

            let col+=1
        endwhile
        let line+=1
    endwhile
endfunction
"}}}
"Input: hex ffffff
function! s:draw_palette_hex(hex) "{{{
    let [r,g,b]=ColorV#hex2rgb(a:hex)
    let [h,s,v]=ColorV#rgb2hsv([r,g,b])
    let g:ColorV.HSV.H=h
    call s:draw_palette(h,
                \s:pal_H,s:pal_W,s:poff_y,s:poff_x)
endfunction "}}}
"Input: rectangle[x,y,w,h] hex_list[ffffff,ffffff]
function! s:draw_multi_block(rectangle,hex_list) "{{{
" TODO: draw multiple multi block
    let [x,y,w,h]=a:rectangle                  
    let block_clr_list=a:hex_list
    call s:clear_blockmatch()


    for idx in range(len(block_clr_list))
        let coxlor=block_clr_list[idx]
        let hi_grp="color".block_clr_list[idx]
        exec "hi ".hi_grp." guifg=#".coxlor." guibg=#".coxlor
        let Block_ptn="\\%>".(x+w*idx-1)."c\\%<".(x+w*(idx+1)).
                    \"c\\%>".(y-1)."l\\%<".(y+h)."l"
        if !exists("s:block_dict")|let s:block_dict={}|endif
        let s:block_dict[hi_grp]=matchadd(hi_grp,Block_ptn)
    endfor
endfunction "}}}
function! s:draw_history_block(hex) "{{{
    setl ma
    let hex= strpart(printf("%06x",'0x'.a:hex),0,6) 
    let len=len(g:ColorV.history_set)
    let s:his_color2= len >2 ? g:ColorV.history_set[len-3] : 'ffffff'
    let s:his_color1= len >1 ? g:ColorV.history_set[len-2] : 'ffffff'
    let s:his_color0= len >0 ? g:ColorV.history_set[len-1] : hex
    call s:draw_multi_block(s:his_set_rect,[s:his_color0,s:his_color1,s:his_color2])
    setl noma
endfunction "}}}

function! s:draw_hueLine(l,...) "{{{
   call  s:clear_hsvmatch()

   if exists("g:ColorV_dynamic_hue") && g:ColorV_dynamic_hue==1
        let h=g:ColorV.HSV.H
        let step=exists("a:2") ? a:2 : 6
    else 
        let h=0
        let step=exists("a:2") ? a:2 : exists("a:1") ? 
                \( a:1 != 0 ? (360/a:1) : 20 ) : 20
    endif
    let s=100
    let v=100
    let l=a:l
    let width=exists("a:1") ? a:1 : s:pal_W
    let x=0
    let s:hueline_list=[]
    while x < width
        let hi_grp="HueLine".x 
        let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        exec "hi ".hi_grp." guifg=#".hex." guibg=#".hex
        let pos="\\%".l."l\\%".(x+1+s:poff_x)."c"

        if !exists("s:hsv_dict")|let s:hsv_dict={}|endif
        let s:hsv_dict[hi_grp]=matchadd(hi_grp,pos)
        call add(s:hueline_list,hex)
        let h+=step
        let x+=1
    endwhile
endfunction "}}}
function! s:draw_satLine(l,...) "{{{
    let h=g:ColorV.HSV.H
    let s=100
    let v=100
    let l=a:l
    let width=exists("a:1") ? a:1 : s:pal_W
    let step=exists("a:2") ? a:2 : exists("a:1") ? 
                \( a:1 != 0 ? (100/a:1) : 5 ) : 5
    let x=0
    let s:satline_list=[]
    while x < width
        
        let hi_grp="SatLine".x 
        let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        exec "hi ".hi_grp." guifg=#".hex." guibg=#".hex
        let pos="\\%".l."l\\%".(x+1+s:poff_x)."c"

        if !exists("s:hsv_dict")|let s:hsv_dict={}|endif
        let s:hsv_dict[hi_grp]=matchadd(hi_grp,pos)
        call add(s:satline_list,hex)

        let s-=step
        if s<=0
            let s=1
        endif
        let x+=1

    endwhile
endfunction "}}}
function! s:draw_valLine(l,...) "{{{
    let h=g:ColorV.HSV.H
    let s=g:ColorV.HSV.S
    let v=100
    let l=a:l
    let width=exists("a:1") ? a:1 : s:pal_W
    let step=exists("a:2") ? a:2 : exists("a:1") ? 
                \( a:1 != 0 ? (100/a:1) : 5 ) : 5
    let x=0
    let s:valline_list=[]
    while x < width
        
        let hi_grp="ValLine".x 
        let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        exec "hi ".hi_grp." guifg=#".hex." guibg=#".hex
        let pos="\\%".l."l\\%".(x+1+s:poff_x)."c"

        if !exists("s:hsv_dict")|let s:hsv_dict={}|endif
        let s:hsv_dict[hi_grp]=matchadd(hi_grp,pos)
        call add(s:valline_list,hex)

        let v-=step
        if v<=0
            let v=0
        endif
        let x+=1

    endwhile
endfunction "}}}

function! s:clear_palmatch() "{{{
    if !exists("s:pallet_dict")|let s:pallet_dict={}|endif
    for [key,var] in items(s:pallet_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:pallet_dict,key)
        catch /^Vim\%((\a\+)\)\=:E803/
            " call s:debug("error E803")
            continue
        endtry
    endfor
    let s:pallet_dict={}
endfunction "}}}
function! s:clear_blockmatch() "{{{
    if !exists("s:block_dict")|let s:block_dict={}|endif

    for [key,var] in items(s:block_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:block_dict,key)
        catch /^Vim\%((\a\+)\)\=:E803/
            " call s:debug("error E803")
            continue
        endtry
    endfor
    let s:block_dict={}
endfunction "}}}
function! s:clear_miscmatch() "{{{
    if !exists("s:misc_dict")|let s:misc_dict={}|endif

    for [key,var] in items(s:misc_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:misc_dict,key)
        catch /^Vim\%((\a\+)\)\=:E803/
            " call s:debug("error E803")
            continue
        endtry
    endfor
    let s:misc_dict={}
endfunction "}}}
function! s:clear_hsvmatch() "{{{
    if !exists("s:hsv_dict")|let s:hsv_dict={}|endif

    for [key,var] in items(s:hsv_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:hsv_dict,key)
        catch /^Vim\%((\a\+)\)\=:E803/
            " call s:debug("error E803")
            continue
        endtry
    endfor
    let s:hsv_dict={}
endfunction "}}}

function! s:draw_misc() "{{{
    call s:clear_miscmatch()

    "arrow chose
    hi arrowChose guibg=bg guifg=fg gui=Bold,reverse
    if s:mode=="max" || s:mode=="mid"
        let chose_ptn='\%<6l\%>2l_\zs.\{5}
                    \\|\%1l\%(_N:\)\zs.\{15}
                    \\|\%2l\%<35c_\zs.\{10}
                    \\|\%1l\%>52c?'
    elseif s:mode=="min"
        let chose_ptn='\%<6l\%>1l_\zs.\{5}
                    \\|\%1l\%>35c\%(_N:\)\zs.\{15}
                    \\|\%1l\%<35c_\zs.\{10}
                    \\|\%1l\%>52c?'
    endif
    if !exists("s:misc_dict")|let s:misc_dict={}|endif
    let s:misc_dict["arrowChose"]=matchadd("arrowChose",chose_ptn)
    
    "invisible arrow
    hi arrow_invis guibg=bg guifg=bg 
    let arrow_ptn='\%<6l_
                \\|N:'
    let s:misc_dict["arrow_invis"]=matchadd("arrow_invis",arrow_ptn)

    if g:ColorV_show_star==1
        let fg= g:ColorV.HSV.V<50 ?  "cccccc" : "222222"
        let bg= g:ColorV.HEX
        exe "hi starPos guibg=#".bg." guifg=#".fg." gui=Bold"
        let star_ptn='\%<'.(s:pal_H+1+s:poff_y).'l\%<'.
                    \(s:pal_W+1+s:poff_x).'c\*'
        let s:misc_dict["starPos"]=matchadd("starPos",star_ptn,20)
    endif
endfunction "}}}

function! s:draw_text(...) "{{{
    setl ma
    let cur=s:clear_text()
    let hex=exists("a:1") ? printf("%06x",'0x'.a:1) : 
                \exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
    if exists("g:ColorV_uppercase") && g:ColorV_uppercase == 1
    	let hex=substitute(hex,'\l','\u\0','g')
    endif
    let [r,g,b]=ColorV#hex2rgb(hex)
    let [h,s,v]=ColorV#rgb2hsv([r,g,b])
    let [r,g,b]=[printf("%3d",r),printf("%3d",g),printf("%3d",b)]
    let [h,s,v]=[printf("%3d",h),printf("%3d",s),printf("%3d",v)]
    
    if s:mode=="max"
    	let height=s:max_h
    elseif s:mode=="min"
        let height=s:min_h
    elseif s:mode=="mid"
        let height=s:mid_h
    endif
    
    let line=[] 
    for i in range(height)
        let m=repeat(' ',s:line_width)
        call add(line,m)
    endfor

    "parameters
    if s:mode=="max" || s:mode=="mid"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"N:",40)
        let line[1]=s:line("Hex:".hex,24)
        let line[2]=s:line("R:".r."   H:".h,24)
        let line[3]=s:line("G:".g."   S:".s,24)
        let line[4]=s:line("B:".b."   V:".v,24)
    elseif s:mode=="min"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"Hex:".hex,22)
        let line[0]=s:line_sub(line[0],"N:",40)
        let line[1]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[2]=s:line("H:".h."  S:".s."  V:".v,22)
    endif
     
    " tips mark (Question mark)
    if exists("g:ColorV_show_tips") && g:ColorV_show_tips==1
        let line[0]=s:line_sub(line[0],"?",54)
    endif
    
    " colorname
    let nam=s:hex2nam(hex)
    if !empty(nam)
        if s:mode=="min"
        let line[0]=s:line_sub(line[0],nam,42)
        " let line[1]=s:line_sub(line[1],nam,3)
        else
        let line[0]=s:line_sub(line[0],nam,42)
        endif
    endif

    " hello world
    let [h1,h2,h3]=[s:his_color0,s:his_color1,s:his_color2]
    for [x,y,z,t] in s:clrf
        "if [h1,h2,h3] == [x,y,z]
        " slower?
        if s:approx2(h1,x) && s:approx2(h2,y) && s:approx2(h3,z)
            let t=tr(t,s:t,s:e)
            let a=tr(s:a,s:t,s:e)
            if s:mode=="min"
                let line[1]=s:line_sub(line[1],t,42)
                let line[2]=s:line_sub(line[2],a,52)
            else
                let line[2]=s:line_sub(line[2],t,42)
                let line[4]=s:line_sub(line[4],a,52)
            endif
            break
        endif
    endfor
   

    "draw star mark(asterisk) at pos
    for i in range(height)
    	let line[i]=substitute(line[i],'\*',' ','g')
    endfor
    let [l,c]=s:get_star_pos()
    let line[l-1]=s:line_sub(line[l-1],"*",c)
    if g:ColorV_show_star==1
        let fg= g:ColorV.HSV.V<50 ?  "cccccc" : "222222"
        let bg= g:ColorV.HEX
        exe "hi starPos guibg=#".bg." guifg=#".fg." gui=Bold"
    endif

    for i in range(height)
    	call setline(i+1,line[i])
    endfor

    if !exists("b:arrowck_pos")|let b:arrowck_pos=0|endif
    call s:draw_arrow(b:arrowck_pos)

    "put cursor back
    call setpos('.',cur)

    setl noma
endfunction "}}}
function! s:get_star_pos() "{{{
    let HSV=g:ColorV.HSV
    let [h,s,v]=[HSV.H,HSV.S,HSV.V]
    
    if s:mode=="max" || s:mode=="mid"
        let h_step=100.0/(s:pal_H)
        let w_step=100.0/(s:pal_W)
        let l=float2nr(round((100.0-v)/h_step))+1+s:poff_y
        let c=float2nr(round((100.0-s)/w_step))+1+s:poff_x
        if l>=s:pal_H+s:poff_y
            let l= s:pal_H+s:poff_y
        endif
        if c>=s:pal_W+s:poff_x
            let c= s:pal_W+s:poff_x
        endif
    
    elseif s:mode=="min"
        " XXX: there should be 3(or 2 if with dynamic hueline) stars here , 
        " but the saturation star background is different .
        " So NOT do this .
        let l=3
        let w_step=5
        let c=float2nr(round((100.0-v)/w_step))+1+s:poff_x
        if c>=s:pal_W+s:poff_x
            let c= s:pal_W+s:poff_x
        endif
    endif
    return [l,c]
endfunction "}}}
function! s:clear_text() "{{{
    if expand('%') !=g:ColorV.name
        call s:warning("Not [ColorV] buffer")
        return
    endif
    let cur=getpos('.')
    " silent! normal! ggVG"_x
    silent %delete _
    return cur
endfunction "}}}
"return text in blank line
function! s:line(text,pos) "{{{
    let suf_len= s:line_width-a:pos-len(a:text)+1
    let suf_len= suf_len <= 0 ? 1 : suf_len
    return repeat(' ',a:pos-1).a:text.repeat(' ',suf_len)
endfunction "}}}
"return substitute line at pos in input line
"could not use doublewidth text
function! s:line_sub(line,text,pos) "{{{
    let [line,text,pos]=[a:line,a:text,a:pos]
    if len(line) < len(text)+pos
    	let line = line.repeat(' ',len(text)+pos-len(line))
    endif
    if pos!=1
        let pat='^\(.\{'.(pos-1).'}\)\%(.\{'.len(text).'}\)'
        return substitute(line,pat,'\1'.text,'')
    else
    	let pat='^\%(.\{'.len(text).'}\)'
        return substitute(line,pat,text,'')
    endif
endfunction "}}}

function! s:draw_arrow(...) "{{{
    setl ma
    if !exists("b:arrowck_pos")|let b:arrowck_pos=0|endif
    if s:mode=="max" || s:mode=="mid"
        let l:cur_pos=s:mid_pos
    elseif s:mode=="min"
        let l:cur_pos = s:min_pos
    endif
    let len=len(l:cur_pos)
    " rmv all
    for i in range(len)
        let old= l:cur_pos[i]
        let o=substitute(getline(old[1]),"_".old[0]," ".old[0],"")
        call setline(old[1],o)
    endfor

    let goto=exists("a:1") ? a:1 : -1
    if goto>=0 && goto < len
        let b:arrowck_pos=goto
        let new= l:cur_pos[goto]
    elseif goto==-1
        let b:arrowck_pos+=1
        if  b:arrowck_pos>(len-1)|let b:arrowck_pos=0|endif
        let new = l:cur_pos[b:arrowck_pos]

    elseif goto==-2
        let b:arrowck_pos-=1
        if  b:arrowck_pos<0|let b:arrowck_pos=(len-1)|endif
        let new = l:cur_pos[b:arrowck_pos]
    else 
    	return -1
    endif
    " change by matching text ptn (x_pos[0])
    let n=substitute(getline(new[1])," ".new[0],"_".new[0],"")
    call setline(new[1],n)

    redraw
    setl noma
endfunction "}}}
"}}}
"CWIN: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ColorV#Win(...) "{{{
    " window check "{{{
    if bufexists(g:ColorV.name) 
    	let nr=bufnr('\[ColorV\]')
    	let winnr=bufwinnr(nr)
        if winnr>0 && bufname(nr)==g:ColorV.name
            if bufwinnr('%') ==winnr
                if expand('%') !=g:ColorV.name
                    call s:warning("Not [ColorV] buffer")
                    return
                else
                call s:echo("All ready in [ColorV] window.")
                endif
            else
            	"Becareful
                exec winnr."wincmd w"
                if expand('%') !=g:ColorV.name
                    call s:warning("Not [ColorV] buffer")
                    return
                else
                    call s:echo("[ColorV] all ready exists.")
                endif
            endif
        else
            " call s:echo("Open a new [ColorV]")
            " execute "botright" 'new' 
            if g:ColorV_win_pos =~ 'vert\%[ical]\|lefta\%[bove]\|abo\%[veleft]
                \\|rightb\%[elow]\|bel\%[owright]\|to\%[pleft]\|bo\%[tright]'
                execute  g:ColorV_win_pos 'new' 
            else
                execute  'bo' 'new' 
            endif
            silent! file [ColorV]
        endif
    else
        " call s:echo("Open a new [ColorV]")
        " execute  "botright" 'new' 
        if g:ColorV_win_pos =~ 'vert\%[ical]\|lefta\%[bove]\|abo\%[veleft]
             \\|rightb\%[elow]\|bel\%[owright]\|to\%[pleft]\|bo\%[tright]'
            execute  g:ColorV_win_pos 'new' 
        else
            execute  'bo' 'new' 
        endif
        silent! file [ColorV]
    endif "}}}
    " local setting "{{{
    setl nocursorline nocursorcolumn
    setl tw=0
    setl buftype=nofile
    setl bufhidden=delete
    setl nolist
    setl noswapfile
    setl nobuflisted
    setl nowrap
    setl nofoldenable
    setl nomodeline
    setl nonumber
    setl foldcolumn=0
    setl sidescrolloff=0
    if v:version >= 703
        setl cc=
    endif
    call s:aug_init()
    call s:map_define() "}}}
    " hex set "{{{
    if exists("a:2") 
    	"skip history if no new hex 
        let hex_list=s:txt2hex(a:2)
        let clr_hex=s:nam2hex(a:2)
        if exists("hex_list[0][0]")
            let hex=s:fmt_hex(hex_list[0][0])
            call s:caution("Use [".hex."] Format:".hex_list[0][3]) 
        elseif !empty(clr_hex)
            let hex=clr_hex
            call s:caution("Use color name [".hex."]") 
        else
            let hex = exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
            let s:skip_his_block=1
            call s:caution("Use default [".hex."]") 
        endif
    else 
        let hex = exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
        let s:skip_his_block=1
    endif "}}}

    " draw window "{{{
    if exists("a:1") && a:1== "min" 
    	let s:mode="min"
        setl ft=ColorV_min 
        let l:win_h=s:min_h
    elseif  exists("a:1") && a:1== "max"
    	let s:mode="max" 
        setl ft=ColorV_max 
    	let s:pal_H=s:max_h-1
        let l:win_h=s:max_h
    else
    	let s:mode="mid" 
        setl ft=ColorV_mid 
    	let s:pal_H=s:mid_h-1
        let l:win_h=s:mid_h
    endif 
    if winnr('$') != 1
        execute 'resize' l:win_h
        redraw
    endif
    call s:draw_buf_hex(hex)
    "}}}
endfunction "}}}
function! s:draw_buf_hex(hex) "{{{

    if expand('%') != g:ColorV.name
        call s:warning("Not [ColorV] buffer")
        return
    endif

    
    setl ma
    setl lz
    let hex= printf("%06x",'0x'.a:hex) 
    
    call s:update_his_set(hex)
    call s:update_global(hex)
    call s:draw_hueLine(1)
    if s:mode == "min"
        call s:draw_satLine(2)
        call s:draw_valLine(3)
    else
        call s:draw_palette_hex(hex)
    endif

    call s:draw_misc()
    call s:draw_history_block(hex)
    call s:draw_text(hex)
    setl nolz
    setl noma
endfunction "}}}
function! s:draw_bufandpos_hex(hex) "{{{
    call s:draw_bufandpos_rgb(ColorV#hex2rgb(a:hex))
endfunction "}}}
function! s:draw_bufandpos_rgb(rgb) "{{{
    setl ma
    let [h,s,v]=ColorV#rgb2hsv(a:rgb)
    let [h,s,v]=[h+0.0,s+0.0,v+0.0]
    let hex=ColorV#rgb2hex(a:rgb)

    let h_step=100.0/(s:pal_H-1)
    let w_step=100.0/(s:pal_W-1)
    let l=float2nr(round((100.0-v)/h_step))+1+s:poff_y
    let c=float2nr(round((100.0-s)/w_step))+1+s:poff_x
    if l>=s:pal_H+s:poff_y
    	let l= s:pal_H+s:poff_y
    endif
    if l>=s:pal_W+s:poff_x
    	let c= s:pal_W+s:poff_x
    endif

    call s:draw_buf_hex(hex)
    call cursor(l,c)
    setl noma
endfunction "}}}
function! s:aug_init() "{{{
    "hi cursor guibg=#000 guifg=#000 
    "hi visual guibg=NONE guibg=NONE
    aug colorV_hide
    au!
    "au! WINENTER <buffer> hi cursor guibg=#000 guifg=#000 
    "au! WINENTER <buffer> hi cursorIM guibg=#000 guifg=#000 
    "au! winleave <buffer> hi cursor guibg=#999 guifg=#000 
    "au! winleave <buffer> hi cursorIM guibg=#999 guifg=#000 
    
    "au! WINENTER <buffer> hi visual guibg=NONE guibg=NONE
    "au! winleave <buffer> hi visual guibg=#333 guifg=NONE 
    aug END
endfun
"}}}
function! s:map_define() "{{{
    nmap <silent><buffer> <c-k> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <space> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <space><space> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <leader>ck :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <2-leftmouse> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <3-leftmouse> :call <SID>set_in_pos()<cr>

    nmap <silent><buffer> <tab> :call <SID>draw_arrow()<cr>
    nmap <silent><buffer> <c-n> :call <SID>draw_arrow()<cr>
    nmap <silent><buffer> J :call <SID>draw_arrow()<cr>
    nmap <silent><buffer> K :call <SID>draw_arrow(-2)<cr>
    nmap <silent><buffer> <c-p> :call <SID>draw_arrow(-2)<cr>
    nmap <silent><buffer> <s-tab> :call <SID>draw_arrow(-2)<cr>
    
    "xrgbhsv
    nmap <silent><buffer> x :call <SID>draw_arrow(0)<cr>
    nmap <silent><buffer> r :call <SID>draw_arrow(1)<cr>
    nmap <silent><buffer> g :call <SID>draw_arrow(2)<cr>
    nmap <silent><buffer> gg :call <SID>draw_arrow(2)<cr>
    nmap <silent><buffer> b :call <SID>draw_arrow(3)<cr>

    nmap <silent><buffer> u :call <SID>draw_arrow(4)<cr>
    nmap <silent><buffer> s :call <SID>draw_arrow(5)<cr>
    nmap <silent><buffer> v :call <SID>draw_arrow(6)<cr>

    "edit
    nmap <silent><buffer> a :call <SID>edit_at_arrow()<cr>
    nmap <silent><buffer> i :call <SID>edit_at_arrow()<cr>
    nmap <silent><buffer> <Enter> :call <SID>edit_at_arrow()<cr>
    nmap <silent><buffer> <kEnter> :call <SID>edit_at_arrow()<cr>
    nmap <silent><buffer> <kEnter> :call <SID>edit_at_arrow()<cr>
    nmap <silent><buffer> = :call <SID>edit_at_arrow(-1,"+")<cr>
    nmap <silent><buffer> + :call <SID>edit_at_arrow(-1,"+")<cr>
    nmap <silent><buffer> - :call <SID>edit_at_arrow(-1,"-")<cr>
    nmap <silent><buffer> _ :call <SID>edit_at_arrow(-1,"-")<cr>

    "edit name
    nmap <silent><buffer> nn :call <SID>draw_arrow(7)<cr>
    nmap <silent><buffer> na :call <SID>input_colorname()<cr>
    nmap <silent><buffer> ne :call <SID>input_colorname()<cr>
    nmap <silent><buffer> nx :call <SID>input_colorname("X11")<cr>
    nmap <silent><buffer> nt :call <SID>tune_colorname()<cr>

    " WONTFIX:quick quit without wait for next key after q
    nmap <silent><buffer> q :call ColorV#exit()<cr>
    nmap <silent><buffer> Q :call ColorV#exit()<cr>
    "nmap <silent><buffer> <esc> :call ColorV#exit()<cr>
    nmap <silent><buffer> <c-w>q :call ColorV#exit()<cr>
    nmap <silent><buffer> <c-w><c-q> :call ColorV#exit()<cr>
    nmap <silent><buffer> ? :call <SID>echo_tips()<cr>
    nmap <silent><buffer> H :h ColorV<cr>
    nmap <silent><buffer> <F1> :h ColorV<cr>

    "Copy color 
    "map <silent><buffer> <c-c> :call <SID>copy("","+")<cr>
    map <silent><buffer> C :call <SID>copy("","+")<cr>
    map <silent><buffer> cc :call <SID>copy("","+")<cr>
    map <silent><buffer> cx :call <SID>copy("HEX0","+")<cr>
    map <silent><buffer> cs :call <SID>copy("NS6","+")<cr>
    map <silent><buffer> c# :call <SID>copy("NS6","+")<cr>
    map <silent><buffer> cr :call <SID>copy("RGB","+")<cr>
    map <silent><buffer> cp :call <SID>copy("RGBP","+")<cr>
    map <silent><buffer> caa :call <SID>copy("RGBA","+")<cr>
    map <silent><buffer> cap :call <SID>copy("RGBAP","+")<cr>
    map <silent><buffer> cn :call <SID>copy("NAME","+")<cr>
    map <silent><buffer> ch :call <SID>copy("HSV","+")<cr>

    map <silent><buffer> Y :call <SID>copy()<cr>
    map <silent><buffer> yy :call <SID>copy()<cr>
    map <silent><buffer> yx :call <SID>copy("HEX0")<cr>
    map <silent><buffer> ys :call <SID>copy("NS6")<cr>
    map <silent><buffer> y# :call <SID>copy("NS6")<cr>
    map <silent><buffer> yr :call <SID>copy("RGB")<cr>
    map <silent><buffer> yp :call <SID>copy("RGBP")<cr>
    map <silent><buffer> yaa :call <SID>copy("RGBA")<cr>
    map <silent><buffer> yap :call <SID>copy("RGBAP")<cr>
    map <silent><buffer> yn :call <SID>copy("NAME")<cr>
    map <silent><buffer> yh :call <SID>copy("HSV")<cr>
    
    "paste color
    map <silent><buffer> <c-v> :call <SID>paste("+")<cr>
    map <silent><buffer> p :call <SID>paste()<cr>
    map <silent><buffer> P :call <SID>paste()<cr>
    map <silent><buffer> <middlemouse> :call <SID>paste("+")<cr>
    
    "show all text
    " noremap <silent><buffer> <c-a> ggVG
    " noremap <silent><buffer> A ggVG

    "easy moving
    noremap <silent><buffer>j gj
    noremap <silent><buffer>k gk

    " command! -buffer -nargs=1 Debug call s:debug(<q-args>)
endfunction "}}}
"}}}
"EDIT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:set_in_pos(...) "{{{
    setl ma

    let l=exists("a:1") ? a:1 : line('.')
    let c=exists("a:1") ? a:1 : col('.')
    let [L,C]=[s:pal_H,s:pal_W]
    
    let clr=g:ColorV
    let hex=clr.HEX
    let [r,g,b]=[clr.RGB.R,clr.RGB.G,clr.RGB.B]
    let [h,s,v]=[clr.HSV.H,clr.HSV.S,clr.HSV.V]
    "pallet "{{{
    if s:mode=="max" || s:mode=="mid" && l > s:poff_y && l<= s:pal_H+s:poff_y && c<= s:pal_W
        let idx=(l-s:poff_y-1)*s:pal_W+c-s:poff_x-1
        let hex=b:pal_clr_list[idx]
        call s:echo("HEX(Pallet): ".hex)
        call s:draw_buf_hex(hex)
    "}}}
    "hue line "{{{
    elseif l==1 &&  c<=s:pal_W 
        let [h1,s1,v1]=ColorV#rgb2hsv(ColorV#hex2rgb(s:hueline_list[(c-1)]))
        call s:echo("Hue(Hue Line): ".h1)
        let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h1,s,v]))
        call s:draw_buf_hex(hex)
    elseif s:mode=="min" && l==2 && ( c<=s:pal_W  )
        let [h1,s1,v1]=ColorV#rgb2hsv(ColorV#hex2rgb(s:satline_list[(c-1)]))
        call s:echo("SAT(Saturation Line): ".s1)

        let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h,s1,v]))
        call s:draw_buf_hex(hex)
    elseif s:mode=="min" && l==3 && ( c<=s:pal_W  )
        let [h1,s1,v1]=ColorV#rgb2hsv(ColorV#hex2rgb(s:valline_list[(c-1)]))
        call s:echo("VAL(Value Line): ".v1)

        let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v1]))
        call s:draw_buf_hex(hex)
    "}}}
    "history_block section "{{{
    elseif l<=(s:his_set_rect[3]+s:his_set_rect[1]-1)
                \ && l>=s:his_set_rect[1] &&
                \ c>=s:his_set_rect[0] && c<=(s:his_set_rect[0]+s:his_set_rect[2]*3-1)  
        if c<=(s:his_set_rect[0]+s:his_set_rect[2]*1-1)
            let hex=s:his_color0
            call s:echo("HEX(history 0): ".hex)
        elseif c<=(s:his_set_rect[0]+s:his_set_rect[2]*2-1)
            let hex=s:his_color1
            call s:echo("HEX(history 1): ".hex)
        elseif c<=(s:his_set_rect[0]+s:his_set_rect[2]*3-1)
            let hex=s:his_color2
            call s:echo("HEX(history 2): ".hex)
        endif
        call s:draw_buf_hex(hex)
    "}}}
    elseif l==1 && c==54 && strpart(getline(1),53,1)=~'?'
        call s:echo_tips()
        setl noma
        return -1
    else 
    	"arrow check "{{{
    	if s:mode=="min" 
            let l:pos=s:min_pos
        elseif s:mode=="max" || s:mode=="mid" 
            let l:pos=s:mid_pos
        endif

        let idx=0
        if exists("l:pos")
            for [name,y,x,width] in l:pos
                if l==y && c>=x && c<(x+width)
                    call s:draw_arrow(idx)
                    return
                endif
                let idx+=1
            endfor
        endif "}}}

        call s:warning("Not Proper Position.")
        setl noma
        return -1

    endif

    if exists("g:ColorV_set_register") && g:ColorV_set_register==1
    	call <SID>copy()
    elseif exists("g:ColorV_set_register") && g:ColorV_set_register==2
    	call <SID>copy("","+")
    endif

    setl noma
endfunction "}}}
function! s:edit_at_arrow(...) "{{{
    "setl ma
    let postition=exists("a:1") && a:1!=-1 ? a:1 : b:arrowck_pos
    let tune=exists("a:2") ? a:2 == "+" ? 1 : a:2 == "-" ? -1  : 0  : 0
    call s:draw_arrow(postition)
    let clr=g:ColorV
    let hex=clr.HEX
    let [r,g,b]=[clr.RGB.R,clr.RGB.G,clr.RGB.B]
    let [h,s,v]=[clr.HSV.H,clr.HSV.S,clr.HSV.V]
    if postition==0 "{{{
    	if tune==0
            let hex=input("Hex(000000~ffffff,000~fff):")
            if hex =~ '^\x\{6}$'
                "do nothing then
            elseif hex =~ '^\x\{3}$'
                let hex=substitute(hex,'.','&&','g')
            else 
                let l:error_input=1
            endif
        else
            return
        endif
    elseif postition==1
        if tune==0
            let r=input("RED(0~255):")
            if r =~ '^\d\{,3}$' && r<256 && r>=0
                let hex = ColorV#rgb2hex([r,g,b])
            else 
                let l:error_input=1
            endif
        else
            let r+=tune*s:tune_step
            let r= r<0 ? 0 : r> 255 ? 255 :r
            let hex=ColorV#rgb2hex([r,g,b])
        endif
    elseif postition==2
        if tune==0
            let g=input("GREEN(0~255):")
            if g =~ '^\d\{,3}$' && g<256 && g>=0
                let hex = ColorV#rgb2hex([r,g,b])
            else 
                let l:error_input=1
            endif
        else
            let g+=tune*s:tune_step
            let g= g<0 ? 0 : g> 255 ? 255 :g
            let hex=ColorV#rgb2hex([r,g,b])
        endif
    elseif postition==3
        if tune==0
            let b=input("BLUE(0~255):")
            if b =~ '^\d\{,3}$' && b<256 && b>=0
                let hex = ColorV#rgb2hex([r,g,b])
            else 
                let l:error_input=1
            endif
        else
            let b+=tune*s:tune_step
            let b= b<0 ? 0 : b> 255 ? 255 :b
            let hex=ColorV#rgb2hex([r,g,b])
        endif
    elseif postition==4
        if tune==0
            let h=input("Hue(0~360):")
            if h =~ '^\d\{,3}$' && h<=360 && h>=0
                let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
            else 
                let l:error_input=1
            endif
        else
            let h+=tune*s:tune_step
            let h= h<0 ? 0 : h> 360 ? 360 :h
            let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        endif
    elseif postition==5
        if tune==0
            let s=input("Saturation(0~100):") 
            if s =~ '^\d\{,3}$' && s<=100 && s>=0
                let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
            else 
                let l:error_input=1
            endif
        else
            let s+=tune*s:tune_step
            let s= s<0 ? 0 : s> 100 ? 100 :s
            let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        endif
    elseif postition==6
        if tune==0
            let v=input("Value:(0~100):") 
            if v =~ '^\d\{,3}$' && v<=100 && v>=0
                let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
            else 
                let l:error_input=1
            endif
        else
            let v+=tune*s:tune_step
            let v= v<0 ? 0 : v> 100 ? 100 :v
            let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        endif
    elseif postition==7
        call s:input_colorname()
        return
    else 
            return -1
    setl noma
    endif "}}}

    if exists("l:error_input") && l:error_input==1
    	call s:warning("Error input. Nothing changed.")
        return
    endif
    call s:draw_buf_hex(hex)

endfunction "}}}
function! s:input_colorname(...) "{{{
    if exists("a:1") && a:1=="X11"
        let text = input("Input color name(X11:Blue/Green/Red):")
        let hex=s:nam2hex(text,a:1)
    else
        let text = input("Input color name(W3C:Blue/Lime/Red):")
        let hex=s:nam2hex(text)
    endif
    
    if !empty(hex)
        call s:draw_buf_hex(hex)
    else
        let t=tr(text,s:t,s:e)
        let flg_l=s:flag_clr(t)
        if type(flg_l)!=type(0)
            call s:update_his_set(flg_l[2])
            call s:update_his_set(flg_l[1])
            call s:draw_buf_hex(flg_l[0])
            let n=tr(flg_l[3],s:t,s:e)
            call s:caution("Hello! ".n."!")
        else
            call s:warning("Not correct colorname. Nothing changed.")
        endif
    endif
endfunction "}}}
function! s:flag_clr(nam) "{{{
    if empty(a:nam)
    	return 0
    endif
    let clr_list=s:clrf
    for [c1,c2,c3,flg] in clr_list
        if flg =~?  a:nam.'\~\='
            return [c1,c2,c3,flg]
            break
        endif
    endfor
    return 0
endfunction "}}}
function! s:change_word_hue(step) "{{{
    setl ma
    if !exists("g:ColorV.HSV.H")|let g:ColorV.HSV.H=0|endif
    let g:ColorV.HSV.H= (g:ColorV.HSV.H+a:step)<0 ?  
                \(g:ColorV.HSV.H+a:step) % 360 + 360 : 
                \(g:ColorV.HSV.H+a:step) % 360
    echo "Hue:" g:ColorV.HSV.H
    call s:clear_palmatch()
    call s:draw_palette(g:ColorV.HSV.H,
                \s:pal_H,s:pal_W,s:poff_y,s:poff_x)
    setl noma
endfun "}}}
function! s:tune_colorname() "{{{
    if !empty(g:ColorV.NAME)
    	let text=substitute(g:ColorV.NAME,'\~\+$',"","")
        let hex=s:nam2hex(text)
        if !empty(hex)
            call s:draw_buf_hex(hex)
        endif
    else
        call s:warning("No Colorname Currently. Nothing changed.")
    endif
endfunction "}}}
"}}}
"TEXT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" input: text
" return: hexlist [[hex,idx,len,fmt],[hex,idx,len,fmt],...]
function! s:txt2hex(txt) "{{{
    let text = a:txt
    let hex_dict={}
    let o_dict={}

    let round=10

    while round
        let o_dict=copy(hex_dict)

        for [fmt,pat] in items(s:fmt)
            if text=~ pat
                let pat_idx=match(text,pat)
                let pat_str=matchstr(text,pat)
                let pat_len=len(pat_str)
                let text=strpart(text,0,pat_idx).strpart(text,pat_len+pat_idx)
                exec "let hex_dict.".fmt."=exists(\"hex_dict.".fmt."\") ? hex_dict.".fmt." : []"
                exec "call add(hex_dict.".fmt.
                            \",[pat_str,pat_idx,pat_len])"
            endif
        endfor
        if o_dict==hex_dict          
            break
        endif
        let round-=1
    endwhile
    "hex_dict {fmt:[str,idx,len],...}
    "hex_list [[hex,idx,len,fmt],...]
    
    let hex_list=[]
    for [fmt,var] in items(hex_dict)
        if fmt=="HEX"
            for clr in var
                call add(clr,fmt)
                call add(hex_list,clr)
            endfor
        elseif fmt=="HEX0"
            for clr in var
                let clr[0]=substitute(clr[0],'0x','','')
                call add(clr,fmt)
                call add(hex_list,clr)
            endfor
        elseif fmt=="NS6"
            call s:debug("fmt is NS6 in hex_list")
            for clr in var
                let clr[0]=substitute(clr[0],'#','','')
                call add(clr,fmt)
                call add(hex_list,clr)
            endfor
            call s:debug(clr[0]." ".clr[1]." ".clr[2]." ".clr[3]." ")
        elseif fmt=="NS3"
            for clr in var
                let clr[0]=substitute(clr[0],'#','','')
                let clr[0]=substitute(clr[0],'.','&&','g')
                call add(clr,fmt)
                call add(hex_list,clr)
            endfor
        elseif fmt=="RGB" || fmt =="RGBA"
            for clr in var
                let list=split(clr[0],',')
                let r=matchstr(list[0],'\d\{1,3}')
                let g=matchstr(list[1],'\d\{1,3}')
                let b=matchstr(list[2],'\d\{1,3}')
                let clr[0] = ColorV#rgb2hex([r,g,b])
                call add(clr,fmt)
                call add(hex_list,clr)
            endfor
        elseif fmt=="RGBP" || fmt =="RGBAP"
            for clr in var
                let list=split(clr[0],',')
                let r=matchstr(list[0],'\d\{1,3}')
                let g=matchstr(list[1],'\d\{1,3}')
                let b=matchstr(list[2],'\d\{1,3}')
                let clr[0] = ColorV#rgb2hex([r*2.55,g*2.55,b*2.55])
                call add(clr,fmt)
                call add(hex_list,clr)
            endfor
        elseif fmt=="HSV"
            for clr in var
                let list=split(clr[0],',')
                let h=matchstr(list[0],'\d\{1,3}')
                let s=matchstr(list[1],'\d\{1,3}')
                let v=matchstr(list[2],'\d\{1,3}')
                let clr[0] = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
                call add(clr,fmt)
                call add(hex_list,clr)
            endfor
        " "NAMW and NAMX format ;not a <cword> here
        " elseif fmt=="NAMW"
        "     for clr in var
        "     	let clr[0]=s:nam2hex(clr[0])
        "         call add(clr,fmt)
        "         call add(hex_list,clr)
        "     endfor
        endif
    endfor

    return hex_list
endfunction "}}}
function! s:hex2txt(hex,fmt,...) "{{{
    
    let hex=printf("%06x","0x".a:hex)
    if exists("g:ColorV_uppercase") && g:ColorV_uppercase == 1
    	let hex=substitute(hex,'\l','\u\0','g')
    endif

    let [r,g,b] = ColorV#hex2rgb(hex)
    
    if a:fmt=="RGB"
        let text="rgb(".r.",".g.",".b.")"
    elseif a:fmt=="HSV"
        let [h,s,v]=ColorV#rgb2hsv([r,g,b])
        let text="hsv(".h.",".s.",".v.")"
    elseif a:fmt=="RGBP"
        let text="rgb(".float2nr(r/2.55)."%,"
                    \.float2nr(g/2.55)."%,"
                    \.float2nr(b/2.55)."%)"
    elseif a:fmt=="RGBA" 
        let text="rgba(".r.",".g.",".b.",255)"
    elseif a:fmt=="RGBAP" 
        let text="rgba(".float2nr(r/2.55)."%,"
                    \.float2nr(g/2.55)."%,"
                    \.float2nr(b/2.55)."%,100%)"
    elseif a:fmt=="HEX"
        let text=hex
    elseif a:fmt=="NS6"
        let text="#".hex
    elseif a:fmt=="HEX0"
        let text="0x".hex
    elseif a:fmt=="NAME"
        if exists("a:1") 
            let text=s:hex2nam(hex,a:1)
        else
            let text=s:hex2nam(hex)
        endif
    else
        let text=hex
    endif

    return text
endfunction "}}}
function! s:fmt_hex(hex) "{{{
    return strpart(printf("%06x",'0x'.a:hex),0,6) 
endfunction "}}}
function! s:nam2hex(nam,...) "{{{
    if empty(a:nam)
    	return 0
    endif
    if exists("a:1") && a:1 == "X11"
    	let clr_list=s:clrn+s:clrnX11
    else
    	let clr_list=s:clrn+s:clrnW3C
    endif
    for [nam,clr] in clr_list
        if a:nam ==? nam   
            return clr
            break
        endif
    endfor
    return 0
endfunction "}}}
function! s:hex2nam(hex,...) "{{{
    if exists("a:1") && a:1 == "X11"
    	let clr_list=s:clrn+s:clrnX11
    else
    	let clr_list=s:clrn+s:clrnW3C
    endif
    for [nam,clr] in clr_list
        if a:hex ==? clr
            return nam
        endif
    endfor
    for [nam,clr] in clr_list
        if s:approx2(a:hex,clr,s:aprx_name)
            return nam.'~'
        endif
    endfor
    for [nam,clr] in clr_list
        if s:approx2(a:hex,clr,2*s:aprx_name)
            return nam.'~~'
        endif
    endfor
    return ""
endfunction "}}}

function! s:paste(...) "{{{
    if  exists("a:1") && a:1=="\""
        let l:cliptext = @"
        call s:echo("Paste with Clipboard(reg\"): ".l:cliptext)
    elseif exists("a:1") && a:1=="+"
        let l:cliptext = @+
        call s:echo("Paste with Clipboard(reg+): ".l:cliptext)
    else
        let l:cliptext = @"
        call s:echo("Paste with Clipboard(reg\"): ".l:cliptext)
    endif
    let hex_list=s:txt2hex(l:cliptext)
    let clr_hex=s:nam2hex(l:cliptext)
    if len(hex_list)>0
        let hex=hex_list[0][0]
    elseif !empty(clr_hex)
        let hex=clr_hex
        "let nam=s:hex2nam
    else
    	call s:warning("Could not find color in the text") 
    	return
    endif
    call s:echo("Set with first color in clipboard. HEX: [".hex."]")
    call s:draw_buf_hex(hex)

endfunction "}}}
function! s:copy(...) "{{{
    let fmt=exists("a:1") ? a:1 : "HEX"
    let l:cliptext=s:hex2txt(g:ColorV.HEX,fmt)
    
    " g:ColorV.history_copy
    let g:ColorV.history_copy=exists("g:ColorV.history_copy") ? g:ColorV.history_copy : []
    "no duplicated color to history
    if get(g:ColorV.history_copy,-1)!=g:ColorV.HEX
        call add(g:ColorV.history_copy,g:ColorV.HEX)
    endif

    if  exists("a:2") && a:2=="\""
        echo "Copied to Clipboard(reg\"):" l:cliptext
        let @" = l:cliptext
    elseif exists("a:2") && a:2=="+"
        echo "Copied to Clipboard(reg+):" l:cliptext
        let @+ = l:cliptext
    else
        echo "Copied to Clipboard(reg\"):" l:cliptext
        let @" = l:cliptext
    endif
endfunction "}}}
function! s:changing() "{{{
    if exists("s:ColorV.change_word") && s:ColorV.change_word ==1
        let cur_pos=getpos('.')
        let cur_bufwinnr=bufwinnr('%')
        " go to the word_buf
        exe s:ColorV.word_bufwinnr."wincmd w"
        call setpos('.',s:ColorV.word_pos)

        if s:ColorV.word_bufnr==bufnr('%') && s:ColorV.word_pos==getpos('.')
                    \ && s:ColorV.word_bufname==bufname('%')

            let pat = expand('<cWORD>')
            silent normal! B
            let pat_idx=col('.')

            "Not the origin word
            if pat!= s:ColorV.word_pat
                call s:warning("Not the same with the word to change.")
                return -1
            endif
            
            "XXX: wrong substitute while change2 NAME with "#"
            " because of '~'!
            if exists("s:ColorV.word_list[0]")
                let hex=g:ColorV.HEX
                let fmt=s:ColorV.word_list[3]
                if exists("s:ColorV.change2")
                    let fmt=s:ColorV.change2
                endif
                if &filetype=="vim"
                    let str=s:hex2txt(hex,fmt,"X11")
                else
                    let str=s:hex2txt(hex,fmt)
                endif
                let str=substitute(str,'\~','','g')
                call s:debug(fmt." str:".str)
            else
                call s:warning("Could not find a color under cursor.")
                let s:ColorV.change_word=0
                let s:ColorV.change_all=0
                return 
            endif
            
            " error with '#fff' '#ffffff' if put cursor on '#'
            " if (exists("s:ColorV.word_pre") && s:ColorV.word_pre=="#")
            " " \||( exists("s:ColorV.word_cur") && s:ColorV.word_cur=="#")
            "     let idx=s:ColorV.word_list[1]-1
            "     let len=s:ColorV.word_list[2]+1
            "     call s:debug("have #")
            " else
                let idx=s:ColorV.word_list[1]
                let len=s:ColorV.word_list[2]
            " endif
            let new_pat=substitute(pat,'\%'.(idx+1).'c.\{'.len.'}',str,'')

            if exists("s:ColorV.change_all") && s:ColorV.change_all ==1
            	try
                    exec '%s/'.pat.'/'.new_pat.'/gc'
                catch /^Vim\%((\a\+)\)\=:E486/
                    " call s:debug("error E486")
                endtry
            else
            	try
                    exec '.s/\%>'.(pat_idx-1).'c'.pat.'/'.new_pat.'/'
                catch /^Vim\%((\a\+)\)\=:E486/
                    " call s:debug("error E486")
                endtry
            endif
        endif
        let s:ColorV.change_word=0
        let s:ColorV.change_all=0
        "back to origin pos
        "WORKAROUND: not correct back position
        "exe cur_bufwinnr."wincmd w"
        "call setpos('.',cur_pos)
        let cur_winnr = bufwinnr(s:ColorV.word_bufname)
        exe cur_winnr."wincmd w"
        call setpos('.',s:ColorV.word_pos)
    else
        let s:ColorV.change_word=0
        let s:ColorV.change_all=0
        return 0
    endif
endfunction
"}}}

function! ColorV#clear_all() "{{{
    call s:clear_blockmatch()
    call s:clear_hsvmatch()
    call s:clear_miscmatch()
    call s:clear_palmatch()
    call clearmatches()
endfunction "}}}
function! ColorV#open_word() "{{{
    let s:ColorV.word_bufnr=bufnr('%')
    let s:ColorV.word_bufname=bufname('%')
    let s:ColorV.word_bufwinnr=bufwinnr('%')
    let s:ColorV.word_pos=getpos('.')
    let pat = expand('<cWORD>')
    let word=expand('<cword>')
    let hex_list=s:txt2hex(pat)
    let clr_hex=s:nam2hex(word)
    if exists("hex_list[0][0]")
        let hex=s:fmt_hex(hex_list[0][0])
        "let s:ColorV.word_list=hex_list[0]
    elseif !empty(clr_hex)
        if &filetype=="vim"
            let hex=s:nam2hex(word,"X11")
        else
            let hex=clr_hex
        endif
    else
        call s:warning("Could not find a color under cursor.")
        return -1
    endif
    if g:ColorV_word_mini==1
        call ColorV#Win("min",hex)
    else
        call ColorV#Win(s:mode,hex)
    endif
    " wrong pos if open at top sometimes? if it's [No Name]
    let cur_winnr = bufwinnr(s:ColorV.word_bufname)
    exe cur_winnr."wincmd w"
    call setpos('.',s:ColorV.word_pos)
    " if s:ColorV.word_bufnr==bufnr('%') && s:ColorV.word_pos==getpos('.')
    "             \ && s:ColorV.word_bufname==bufname('%')
    " endif
endfunction "}}}
function! ColorV#change_word(...) "{{{
    let s:ColorV.word_bufnr=bufnr('%')
    let s:ColorV.word_bufname=bufname('%')
    let s:ColorV.word_bufwinnr=bufwinnr('%')
    let s:ColorV.word_pos=getpos('.')
    let pat = expand('<cWORD>')
    let word= expand('<cword>')

    " "check '#' before
    " silent normal! b
    " if word=~'\x\{6}\|\x\{3}' &&
    "             \matchstr(getline('.'), '\%' . 
    "             \(col('.')>1 ? col('.')-1 :col('.')). 'c' . '.') =="#"
    "     " let word='#'.word
    "     let s:ColorV.word_pre="#"
    " else
    "     let s:ColorV.word_pre=""
    " endif
    " if word=~'#'
    "     let s:ColorV.word_cur="#"
    " else
    "     let s:ColorV.word_cur=""
    " endif
    
    "could not change '#ffffff'
    let s:ColorV.word_pat=pat
    let clr_hex=s:nam2hex(word)
    let hex_list=s:txt2hex(pat)
    if exists("hex_list[0][0]")
        let hex=s:fmt_hex(hex_list[0][0])
        let s:ColorV.word_list=hex_list[0]
    elseif !empty(clr_hex)
        if &filetype=="vim"
            let hex=s:nam2hex(word,"X11")
        else
            let hex=clr_hex
        endif
        " let str=s:hex2nam(hex)
        let str=word
        let str_idx=match(pat,str)
        let str_len=len(str)
        let s:ColorV.word_list=[hex,str_idx,str_len,"NAME"]
    else 
        call s:warning("Could not find a color under cursor.")
        return
    endif

    let s:ColorV.change_word=1
    if exists("a:1") && a:1=="all"
    	let s:ColorV.change_all=1
        call s:caution("Will Substitute ALL [".pat."] after ColorV closed.")
    else
    	let s:ColorV.change_all=0
    	call s:caution("Will Change [".pat."] after ColorV closed.")
    endif

    if exists("a:2")
            \ && a:2=~'RGB\|RGBA\|RGBP\|RGBAP\|HEX\|HEX0\|NAME\|NS6'
        let s:ColorV.change2=a:2
    elseif exists("s:ColorV.change2")
        unlet s:ColorV.change2
    endif

    if g:ColorV_word_mini==1
        call ColorV#Win("min",hex)
    else
        call ColorV#Win(s:mode,hex)
    endif
endfunction "}}}
function! ColorV#exit() "{{{
    " if expand('%') !=g:ColorV.name
    "     call s:echo("Not the [ColorV] buffer")
    "     return
    " endif
    if bufexists(g:ColorV.name) 
    	let nr=bufnr('\[ColorV\]')
    	let winnr=bufwinnr(nr)
        if winnr>0 && bufname(nr)==g:ColorV.name
            if bufwinnr('%') == winnr && expand('%') ==g:ColorV.name
                call s:echo("Close current [ColorV].")
                " call s:warning("Not [ColorV] buffer")
                " return
                bd
            else
            	"Becareful
                exec winnr."wincmd w"
                if expand('%') ==g:ColorV.name
                    call s:echo("Close existing [ColorV].")
                    " call s:warning("Not [ColorV] buffer")
                    " return
                    bd
                endif
            endif
        endif    
    endif
    " bd 
    if exists("s:ColorV.change_word") && s:ColorV.change_word ==1
        call s:changing()
    endif
endfunction "}}}
"}}}
"PGTK: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"python pyGTK needed 
function! ColorV#Dropper() "{{{
call s:caution("Using GTK color picker.")
python << EOF
import pygtk,gtk,vim
pygtk.require('2.0')

color_dlg = gtk.ColorSelectionDialog("[ColorV] colorpicker")
c_set = gtk.gdk.color_parse("#"+vim.eval("g:ColorV.HEX"))
color_dlg.colorsel.set_current_color(c_set)

if color_dlg.run() == gtk.RESPONSE_OK:
    c_get = color_dlg.colorsel.get_current_color()
    c_hex = "%02x%02x%02x" % (c_get.red/257,c_get.green/257,c_get.blue/257)
    vim.command("ColorV "+c_hex)

color_dlg.destroy()

EOF
endfunction "}}}
"}}}
" LIST: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ColorV.listname="[ColorV List]"
function! ColorV#list_win(...) "{{{
    if bufexists(g:ColorV.listname) "{{{
    	let nr=bufnr('\[ColorV List\]')
    	let winnr=bufwinnr(nr)
        if winnr>0 && bufname(nr)==g:ColorV.listname
            if bufwinnr('%') ==winnr
                if expand('%') !=g:ColorV.listname
                    call s:warning("Not [ColorV List] buffer")
                    return
                else
                call s:echo("All ready in [ColorV List] window.")
                endif
            else
            	"Becareful
                exec winnr."wincmd w"
                if expand('%') !=g:ColorV.listname
                    call s:warning("Not [ColorV List] buffer")
                return
                else
                    call s:echo("[ColorV List] all ready exists.")
                endif
            endif
        else
            execute  'bo' 'vnew' 
            silent! file [ColorV List]
        endif
    else
        execute  'bo' 'vnew' 
        silent! file [ColorV List]
    endif "}}}
    
    " local setting "{{{
    setl nocursorline nocursorcolumn
    setl tw=0
    setl buftype=nofile
    setl bufhidden=delete
    setl nolist
    setl noswapfile
    setl nobuflisted
    setl nowrap
    setl nofoldenable
    setl nomodeline
    setl nonumber
    setl foldcolumn=0
    setl sidescrolloff=0
    if v:version >= 703
        setl cc=
    endif

    setl ft=ColorV_list 
    
    nmap <silent><buffer> q :q<cr>
    nmap <silent><buffer> Q :q<cr>
    " call s:aug_init()
    " call s:map_define() "}}}

    if winnr('$') != 1
        execute 'vertical resize' 30
        redraw
    endif

    let list=exists("a:1") ? a:1 : s:clrn+s:clrnW3C
    call s:draw_list_buf(list)
endfunction "}}}
function! s:draw_list_buf(list) "{{{
    setl ma
    let list=a:list
    call s:draw_list_text(list)
    call s:color_preview()
    setl noma
endfunction "}}}
function! s:draw_list_text(list) "{{{
    let list=a:list
    for i in range(len(list))
        let name=list[i][0]
        let hex="#".list[i][1]
        let line=s:line_sub(name,hex,22)
        call setline(i+1,line)
    endfor
endfunction "}}}

function! ColorV#gen_win(hex,...) "{{{
    let hex=a:hex
    let type=exists("a:1") ? a:1 : "hue"
    let nums=exists("a:2") ? a:2 : 10
    let step=exists("a:3") ? a:3 : 10
    let list=s:generate_list(hex,type,nums,step)
    call ColorV#list_win(list)
endfunction "}}}
function! ColorV#word_gen(...) "{{{
    if ColorV#open_word()==-1
    	return -1
    endif
    let hex=g:ColorV.HEX
    let type=exists("a:1") ? a:1 : "hue"
    let nums=exists("a:2") ? a:2 : 10
    let step=exists("a:3") ? a:3 : 10
    let list=s:generate_list(hex,type,nums,step)
    call ColorV#list_win(list)
    call ColorV#exit()
    call ColorV#Win(hex)
endfunction "}}}
function! s:generate_list(hex,...) "{{{
    let hex=a:hex
    let type=exists("a:1") ? a:1 : "Hue"
    let nums=exists("a:2") ? a:2 : 10
    let step=exists("a:3") ? a:3 : 10
    let [h,s,v]=ColorV#rgb2hsv(ColorV#hex2rgb(hex))
    let list=[]
    for i in range(nums)
    	if type=="Hue" 
    	    "h+
            let h{i}=h+step*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Saturation"
            "s+
            let s{i}=s+step*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h,s{i},v]))
        elseif type=="Value"
            "v+
            let v{i}=v+step*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v{i}]))
        elseif type=="Monochromatic"
            "s+step v+step
            let v{i}=v+step*i
            let s{i}=s+step*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h,s{i},v{i}]))
        elseif type=="Analogous"
            "h+30
            let h{i}=h+30*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Triadic"
            "h+120
            let h{i}=h+120*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Tetradic" || type=="Rectangle"
            "h+60,h+120,...
            if i==0
            	let h{i}=h
            else
                let h{i}=fmod(i,2)==1 ? h{i-1}+60 : h{i-1}+120
            endif
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Neutral"
            "h+15
            let h{i}=h+15*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Clash"
            "h+90,h+180,...
            if i==0
            	let h{i}=h
            else
                let h{i}=fmod(i,2)==1 ? h{i-1}+90 : h{i-1}+180
            endif
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Square"
            "h+90
            let h{i}=h+90*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Five-Tone"
            "h+115,+40,+50,+40,+115
            if i==0
            	let h{i}=h
            else
                let h{i}=fmod(i,5)==1 ? h{i-1}+115 : 
                        \fmod(i,5)==2 ? h{i-1}+40 : 
                        \fmod(i,5)==3 ? h{i-1}+50 : 
                        \fmod(i,5)==4 ? h{i-1}+40 :
                        \h{i-1}+115
            endif
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Six-Tone"
            "h+30,90,...
            if i==0
            	let h{i}=h
            else
                let h{i}=fmod(i,2)==1 ? h{i-1}+30 : h{i-1}+90
            endif
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Complementary"
            "h+180
            let h{i}=h+180*i
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        elseif type=="Split-Complementary"
            "h+150,h+60,... 
            if i==0
            	let h{i}=h
            else
                let h{i}=fmod(i,2)==1 ? h{i-1}+150 : h{i-1}+60
            endif
            let hex{i}=ColorV#rgb2hex(ColorV#hsv2rgb([h{i},s,v]))
        else
            call s:warning("Not a Correct color generator Type.")
            return [['ERROR','-1']]
        endif
    	call add(list,[type.i,hex{i}])
    endfor
    return list
endfunction "}}}

function! ColorV#color_preview() "{{{
    "parse each line with color format text
    "then highlight the color text
    let file_lines=readfile(expand('%'))
    for line in file_lines
        let hex_list=s:txt2hex(line)
        echo hex_list
    endfor
    " hl txt hex
    " matchadd list_dict
endfunction "}}}
"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tw=78:fdm=marker:
