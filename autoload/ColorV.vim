"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: autoload/ColorV.vim
" Summary: A color manager with color toolkits
"  Author: Rykka.Krin <rykka.krin@gmail.com>
"    Home: 
" Version: 1.1.8.0 
" Last Update: 2011-05-24
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 "{{{
let s:save_cpo = &cpo
set cpo&vim
if !has("gui_running")
    " "GUI MODE ONLY"
    finish
endif
if v:version < 700
    finish
endif 

if exists("g:colorV_loaded")
  finish
endif
let g:colorV_loaded = 1
"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SVAR: {{{
let s:mode= exists("s:mode") ? s:mode : "normal"
let [s:pal_W,s:pal_H]=[20,10]
let [s:poff_x,s:poff_y]=[0,1]

let s:hue_width=30
let s:sat_width=30
let s:val_width=30
let s:block_rect=[40,2,5,4]
let s:line_width=60
let s:norm_pos=[["Hex:",2,24,11],
    \["R:",3,24,5],["G:",4,24,5],["B:",5,24,5],
    \["H:",3,32,5],["S:",4,32,5],["V:",5,32,5]
    \]
let s:mini_pos=[["Hex:",1,42,11],
    \["R:",1,24,5],["G:",2,24,5],["B:",3,24,5],
    \["H:",1,32,5],["S:",2,32,5],["V:",3,32,5]
    \]
let s:norm_height=11
let s:mini_height=3
let s:fmt={}
let s:fmt.RGB='rgb(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3})'
let s:fmt.RGBA='rgba(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3}\,\s*\d\{1,3}%\=)'
let s:fmt.RGBP='rgb(\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%)'
let s:fmt.RGBAP='rgba(\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%\=)'
let s:fmt.HEX='\x\@<!\x\{6}\x\@!'
"#fff only
let s:fmt.HEX3='#\zs\x\{3}\x\@!'
let s:t='fghDPijmrYFGtudBevwxklyzEIZOJLMnHsaKbcopqNACQRSTUVWX'
let s:clrn=[
\['AliceBlue'           ,'f0f8ff'] ,['AntiqueWhite'        ,'faebd7']
\,['Aqua'                ,'00ffff'] ,['Aquamarine'          ,'7fffd4']
\,['Azure'               ,'f0ffff'] ,['Beige'               ,'f5f5dc']
\,['Bisque'              ,'ffe4c4'] ,['Black'               ,'000000']
\,['BlanchedAlmond'      ,'ffebcd'] ,['Blue'                ,'0000ff']
\,['BlueViolet'          ,'8a2be2'] ,['Brown'               ,'a52a2a']
\,['BurlyWood'           ,'deb887'] ,['CadetBlue'           ,'5f9ea0']
\,['Chartreuse'          ,'7fff00'] ,['Chocolate'           ,'d2691e']
\,['Coral'               ,'ff7f50'] ,['CornflowerBlue'      ,'6495ed']
\,['Cornsilk'            ,'fff8dc'] ,['Crimson'             ,'dc143c']
\,['Cyan'                ,'00ffff'] ,['DarkBlue'            ,'00008b']
\,['DarkCyan'            ,'008b8b'] ,['DarkGoldenRod'       ,'b8860b']
\,['DarkGray'            ,'a9a9a9'] ,['DarkGreen'           ,'006400']
\,['DarkKhaki'           ,'bdb76b'] ,['DarkMagenta'         ,'8b008b']
\,['DarkOliveGreen'      ,'556b2f'] ,['Darkorange'          ,'ff8c00']
\,['DarkOrchid'          ,'9932cc'] ,['DarkRed'             ,'8b0000']
\,['DarkSalmon'          ,'e9967a'] ,['DarkSeaGreen'        ,'8fbc8f']
\,['DarkSlateBlue'       ,'483d8b'] ,['DarkSlateGray'       ,'2f4f4f']
\,['DarkTurquoise'       ,'00ced1'] ,['DarkViolet'          ,'9400d3']
\,['DeepPink'            ,'ff1493'] ,['DeepSkyBlue'         ,'00bfff']
\,['DimGray'             ,'696969'] ,['DodgerBlue'          ,'1e90ff']
\,['FireBrick'           ,'b22222'] ,['FloralWhite'         ,'fffaf0']
\,['ForestGreen'         ,'228b22'] ,['Fuchsia'             ,'ff00ff']
\,['Gainsboro'           ,'dcdcdc'] ,['GhostWhite'          ,'f8f8ff']
\,['Gold'                ,'ffd700'] ,['GoldenRod'           ,'daa520']
\,['Gray'                ,'808080'] ,['Green'               ,'008000']
\,['GreenYellow'         ,'adff2f'] ,['HoneyDew'            ,'f0fff0']
\,['HotPink'             ,'ff69b4'] ,['IndianRed'           ,'cd5c5c']
\,['Indigo'              ,'4b0082'] ,['Ivory'               ,'fffff0']
\,['Khaki'               ,'f0e68c'] ,['Lavender'            ,'e6e6fa']
\,['LavenderBlush'       ,'fff0f5'] ,['LawnGreen'           ,'7cfc00']
\,['LemonChiffon'        ,'fffacd'] ,['LightBlue'           ,'add8e6']
\,['LightCoral'          ,'f08080'] ,['LightCyan'           ,'e0ffff']
\,['LightGoldenRodYellow','fafad2'] ,['LightGrey'           ,'d3d3d3']
\,['LightGreen'          ,'90ee90'] ,['LightPink'           ,'ffb6c1']
\,['LightSalmon'         ,'ffa07a'] ,['LightSeaGreen'       ,'20b2aa']
\,['LightSkyBlue'        ,'87cefa'] ,['LightSlateGray'      ,'778899']
\,['LightSteelBlue'      ,'b0c4de'] ,['LightYellow'         ,'ffffe0']
\,['Lime'                ,'00ff00'] ,['LimeGreen'           ,'32cd32']
\,['Linen'               ,'faf0e6'] ,['Magenta'             ,'ff00ff']
\,['Maroon'              ,'800000'] ,['MediumAquaMarine'    ,'66cdaa']
\,['MediumBlue'          ,'0000cd'] ,['MediumOrchid'        ,'ba55d3']
\,['MediumPurple'        ,'9370d8'] ,['MediumSeaGreen'      ,'3cb371']
\,['MediumSlateBlue'     ,'7b68ee'] ,['MediumSpringGreen'   ,'00fa9a']
\,['MediumTurquoise'     ,'48d1cc'] ,['MediumVioletRed'     ,'c71585']
\,['MidnightBlue'        ,'191970'] ,['MintCream'           ,'f5fffa']
\,['MistyRose'           ,'ffe4e1'] ,['Moccasin'            ,'ffe4b5']
\,['NavajoWhite'         ,'ffdead'] ,['Navy'                ,'000080']
\,['OldLace'             ,'fdf5e6'] ,['Olive'               ,'808000']
\,['OliveDrab'           ,'6b8e23'] ,['Orange'              ,'ffa500']
\,['OrangeRed'           ,'ff4500'] ,['Orchid'              ,'da70d6']
\,['PaleGoldenRod'       ,'eee8aa'] ,['PaleGreen'           ,'98fb98']
\,['PaleTurquoise'       ,'afeeee'] ,['PaleVioletRed'       ,'d87093']
\,['PapayaWhip'          ,'ffefd5'] ,['PeachPuff'           ,'ffdab9']
\,['Peru'                ,'cd853f'] ,['Pink'                ,'ffc0cb']
\,['Plum'                ,'dda0dd'] ,['PowderBlue'          ,'b0e0e6']
\,['Purple'              ,'800080'] ,['Red'                 ,'ff0000']
\,['RosyBrown'           ,'bc8f8f'] ,['RoyalBlue'           ,'4169e1']
\,['SaddleBrown'         ,'8b4513'] ,['Salmon'              ,'fa8072']
\,['SandyBrown'          ,'f4a460'] ,['SeaGreen'            ,'2e8b57']
\,['SeaShell'            ,'fff5ee'] ,['Sienna'              ,'a0522d']
\,['Silver'              ,'c0c0c0'] ,['SkyBlue'             ,'87ceeb']
\,['SlateBlue'           ,'6a5acd'] ,['SlateGray'           ,'708090']
\,['Snow'                ,'fffafa'] ,['SpringGreen'         ,'00ff7f']
\,['SteelBlue'           ,'4682b4'] ,['Tan'                 ,'d2b48c']
\,['Teal'                ,'008080'] ,['Thistle'             ,'d8bfd8']
\,['Tomato'              ,'ff6347'] ,['Turquoise'           ,'40e0d0']
\,['Violet'              ,'ee82ee'] ,['Wheat'               ,'f5deb3']
\,['White'               ,'ffffff'] ,['WhiteSmoke'          ,'f5f5f5']
\,['Yellow'              ,'ffff00'] ,['YellowGreen'         ,'9acd32']
\]
let s:ap_rate=5
let s:clrf=[['ff0000','00ff00','0000ff','Uryyb Jbeyq']
            \,['000000','c00000','009a00','Nstunavfgna~']
            \,['370095','FCE015','D81B3E','Naqbeen~']
            \,['00257E','FFC725','00257E','Oneonqbf~']
            \,['000000','FFDA0C','F3172F','Orytvhz']
            \,['007A5E','CE1125','FCD115','Pnzrebba~']
            \,['FF0000','ffffff','FF0000','Pnanqn~']
            \,['002468','FFCE00','D21033','Punq']
            \,['F87F00','FFFFFF','009F60','Pbgr q`Vibver']
            \,['0C1B8B','FFFFFF','EF2A2C','Senapr']
            \,['87C8E4','FFFFFF','87C8E4','Thngrznyn~']
            \,['CE1125','00935F','FCD115','Thvarn']
            \,['009D5F','FFFFFF','F77E00','Verynaq']
            \,['008E46','FFFFFF','D3232C','Vgnyl']
            \,['13B439','FCD115','CE1125','Znyv']
            \,['016549','FFFFFF','CD132A','Zrkvpb~']
            \,['0000B2','F7D900','0000B2','Zbyqbin~']
            \,['008851','FFFFFF','008851','Avtrevn']
            \,['188100','FFFFFF','188100','Abesbyx Vfynaq']
            \,['CC0000','FFFFFF','CC0000','Creh']
            \,['002A7E','FCD115','CE1125','Ebznavn']
            \,['009246','F8F808','DD171D','Frartny~']
            \]
let s:a='Elxxn'
let s:e='stuQCvwzeLSTghqOrijkxylmRVMBWYZaUfnXopbcdANPDEFGHIJK'


"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CORE: "{{{
" NOTE: Can be called directly with other plugins
" in [r,g,b] 0~255
" out [H,S,V] 0~360 0~100
function! ColorV#rgb2hsv(rgb)  "{{{
    "XXX: weird with float input
    let [r,g,b]=[a:rgb[0],a:rgb[1],a:rgb[2]] 
    if r>255||g>255||b>255
            call s:warning("RGB input error")
    	return -1
    endif
    
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
    if s>100||v>100||s<0||v<0
            call s:warning("HSV input error")
            return -1
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
    endtry
   return printf("%06x",r*0x10000+g*0x100+b*0x1)
endfunction "}}}
" in ffffff
" out [r,g,b]
function! ColorV#hex2rgb(hex) "{{{
   let hex=printf("%06x",'0x'.a:hex)
   let [r,g,b] = ["0x".hex[0:1],"0x".hex[2:3],"0x".hex[4:5]]
   return [printf("%d",r),printf("%d",g),printf("%d",b)]
endfunction "}}}
"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"DRAW: "{{{1
"Input: h,l,c,[loffset,coffset]
function! s:draw_pallet(h,l,c,...) "{{{
    call s:clear_palmatch()
    let [h,height,width,hstep,wstep]=[a:h,a:l,a:c,100.0/(a:l-1),100.0/(a:c-1)]
    let h_off=exists("a:1") ? a:1 : 1
    let w_off=exists("a:2") ? a:2 : 1
    if height>100 || width>100 || height<0 || width<0
    	echoe "error palette input"
    	return -1
    endif
    let h=fmod(h,360.0)
    
    let b:pal_list=[]

    let line=1
    while line<=height
        let v=100-(line-1)*hstep
        let col =1
        while col<=width
            let s=100-(col-1)*wstep
            let s= s==0 ? 1 : s 
            let hex=ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
            let group="colorV".hex
            exec "hi ".group." guifg=#".hex." guibg=#".hex
            let pos="\\%".(line+h_off)."l\\%".(col+w_off)."c"
            
            call add(b:pal_list,hex)
            
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
function! s:draw_pallet_hex(hex) "{{{
    let [r,g,b]=ColorV#hex2rgb(a:hex)
    let [h,s,v]=ColorV#rgb2hsv([r,g,b])
    let g:ColorV.HSV.H=h
    call s:draw_pallet(h,
                \s:pal_H,s:pal_W,s:poff_y,s:poff_x)
endfunction "}}}
"Input: rectangle[x,y,w,h] hex_list[ffffff,ffffff]
function! s:draw_multi_block(rectangle,hex_list) "{{{
    let [x,y,w,h]=a:rectangle                  
    let block_clr_list=a:hex_list
    "let colr="ff0000"                                
    
    call s:clear_blockmatch()

    for idx in range(len(block_clr_list))
        "let hi_grp="color".colr
        let coxlor=block_clr_list[idx]
        let hi_grp="color".block_clr_list[idx]
        "echo idx
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
    let g:ColorV.history_set=exists("g:ColorV.history_set") ? g:ColorV.history_set : []
    
    if exists("s:skip_his_block") && s:skip_his_block==1
    	let s:skip_his_block=0
    else
        call add(g:ColorV.history_set,hex)
    endif

    let len=len(g:ColorV.history_set)
    let s:his_color2= len >2 ? g:ColorV.history_set[len-3] : 'ffffff'
    let s:his_color1= len >1 ? g:ColorV.history_set[len-2] : 'ffffff'
    let s:his_color0= len >0 ? g:ColorV.history_set[len-1] : a:hex
    call s:draw_multi_block(s:block_rect,[s:his_color0,s:his_color1,s:his_color2])
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
    " FIXED: 110520  error color toggling while set with pos
    " Because have not set the  g:ColorV.HSV.H while call set_buf
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
function! ColorV#clear_all()
    call s:clear_blockmatch()
    call s:clear_hsvmatch()
    call s:clear_miscmatch()
    call s:clear_palmatch()
    call clearmatches()
endfunction
function! s:clear_palmatch() "{{{
    if !exists("s:pallet_dict")|let s:pallet_dict={}|endif
    for [key,var] in items(s:pallet_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:pallet_dict,key)
        catch /^Vim\%((\a\+)\)\=:E803/
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
            continue
        endtry
    endfor
    let s:hsv_dict={}
endfunction "}}}

function! s:draw_misc() "{{{
    hi arrowCheck guibg=#770000 guifg=#aaaaaa gui=Bold
    if s:mode=="normal"
        let arrow_ptn='\(\%<6l\%>2l>.\{6}\|\%2l>.\{12}
                    \\|\%1l\%>53c[\.?x]\)'
    elseif s:mode=="mini"
        let arrow_ptn='\(\%<6l\%<39c>.\{6}\|\%1l\%>39c>.\{12}
                    \\|\%1l\%>53c[\.?x]\)'
    endif
    if !exists("b:misc_color")|let b:misc_color={}|endif
    let b:misc_color["arrowCheck"]=matchadd("arrowCheck",arrow_ptn)
    
    if g:ColorV_show_star==1
        let fg= g:ColorV.HSV.V<50 ?  "cccccc" : "222222"
        let bg= g:ColorV.HEX
        exe "hi starPos guibg=#".bg." guifg=#".fg." gui=Bold"
        let star_ptn='\%<'.(s:pal_H+1+s:poff_y).'l\%<'.
                    \(s:pal_W+1+s:poff_x).'c\*'
        let b:misc_color["starPos"]=matchadd("starPos",star_ptn,20)
    endif
endfunction "}}}

function! s:update_g_hsv(hex) "{{{
    let hex= printf("%06x",'0x'.a:hex) 
    let g:ColorV.HEX=hex
    let [r,g,b]= ColorV#hex2rgb(hex)
    let [h,s,v]= ColorV#rgb2hsv([r,g,b])
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"DRAW_TEXT:{{{1
function! s:init_text(...) "{{{
    setl ma
     let cur=s:clear_text()
    let hex=exists("a:1") ? printf("%06x",'0x'.a:1) : 
                \exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
    let [r,g,b]=ColorV#hex2rgb(hex)
    let [h,s,v]=ColorV#rgb2hsv([r,g,b])
    let [r,g,b]=[printf("%3d",r),printf("%3d",g),printf("%3d",b)]
    let [h,s,v]=[printf("%3d",h),printf("%3d",s),printf("%3d",v)]
    
    if s:mode=="normal"
    	let height=s:norm_height
    elseif s:mode=="mini"
        let height=s:mini_height
    endif
    
    let line=[] 
    for i in range(height)
        let m=repeat(' ',s:line_width)
        call add(line,m)
    endfor

    if s:mode=="normal"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[1]=s:line("Hex:#".hex,24)
        let line[2]=s:line("R:".r."   H:".h,24)
        let line[3]=s:line("G:".g."   S:".s,24)
        let line[4]=s:line("B:".b."   V:".v,24)
    elseif s:mode=="mini"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"R:".r."   H:".h,24)
        let line[0]=s:line_sub(line[0],"Hex:#".hex,42)
        let line[1]=s:line("G:".g."   S:".s,24)
        let line[2]=s:line("B:".b."   V:".v,24)
    endif
 
    if exists("g:ColorV_show_quit") && g:ColorV_show_quit==1 
        let line[0]=s:line_sub(line[0],"x",55)
    endif

    if exists("g:ColorV_show_tips") && g:ColorV_show_tips==1
    	let l:show_Qo=0
        let l:show_tips=1
    elseif exists("g:ColorV_show_tips") && g:ColorV_show_tips==2
    	let l:show_Qo=1
        let l:show_tips=0
    elseif  
    	let l:show_Qo=0
        let l:show_tips=0
    endif
    if exists("s:toggle_tips") && s:toggle_tips==0
        let l:show_tips=0
    elseif exists("s:toggle_tips") && s:toggle_tips==1
        let l:show_tips=1
    endif
    if s:mode=="normal"
        if l:show_tips 
            let line[6]=s:line("Set Color:2-Click/2-Space",24)
            let line[7]=s:line("Toggle:TAB      Edit:Enter",24)
            let line[8]=s:line("Yank:<C-C>/yy   Paste:<C-V>/p",24)
            let line[9]=s:line("Help:F1/H       Quit:qq/Esc",24)
            if l:show_Qo==1
                let line[0]=s:line_sub(line[0],".",54)
            endif
        endif
        if l:show_Qo && !l:show_tips
            let line[0]=s:line_sub(line[0],"?",54)
        endif
        elseif s:mode=="mini"
        if l:show_tips
            let line[0]=s:line_sub(line[0],"Edit:Enter",59)
            let line[1]=s:line_sub(line[1],"Help:F1/H",59)
            let line[2]=s:line_sub(line[2],"Quit:q/Esc",59)
            if l:show_Qo
                let line[0]=s:line_sub(line[0],".",54)
            endif
        endif
        if l:show_Qo && !l:show_tips
            let line[0]=s:line_sub(line[0],"?",54)
        endif
    endif

    let [h1,h2,h3]=[s:his_color0,s:his_color1,s:his_color2]
    for [x,y,z,t] in s:clrf
        if [h1,h2,h3] == [x,y,z]
            let t=tr(t,s:t,s:e)
            let a=tr(s:a,s:t,s:e)
            if s:mode=="mini"
                let line[1]=s:line_sub(line[1],t,40)
                let line[2]=s:line_sub(line[2],a,47)
            else
                let line[2]=s:line_sub(line[2],t,40)
                let line[4]=s:line_sub(line[4],a,47)
            endif
            break
        endif
    endfor

    let nam=s:hex2nam(hex)
    if !empty(nam)
        if s:mode=="mini"
        let line[1]=s:line_sub(line[1],nam,3)
        else
        let line[0]=s:line_sub(line[0],nam,40)
        endif
    endif
    "star mark pos
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
    call ColorV#toggle_arrow(b:arrowck_pos)
     call setpos('.',cur)
    setl noma
endfunction "}}}

function! s:text_tips() "{{{
    if s:mode=="normal"
    	let height=s:norm_height
    elseif s:mode=="mini"
        let height=s:mini_height
    endif
    let line=[]
    for i in range(height)
            call add(line,getline(i+1))
    endfor
    
    if exists("g:ColorV_show_tips") && g:ColorV_show_tips==1
    	let l:show_Qo=0
        let l:show_tips=1
    elseif exists("g:ColorV_show_tips") && g:ColorV_show_tips==2
    	let l:show_Qo=1
        let l:show_tips=0
    elseif  
    	let l:show_Qo=0
        let l:show_tips=0
    endif
    if exists("s:toggle_tips") && s:toggle_tips==0
        let l:show_tips=0
    elseif exists("s:toggle_tips") && s:toggle_tips==1
        let l:show_tips=1
    endif
    if s:mode=="normal"
    if l:show_tips 
        let line[6]=s:line("Set Color:2-Click/2-Space",24)
        let line[7]=s:line("Toggle:TAB      Edit:Enter",24)
        let line[8]=s:line("Yank:<C-C>/yy   Paste:<C-V>/p",24)
        let line[9]=s:line("Help:F1/H       Quit:qq/Esc",24)
        if l:show_Qo==1
            let line[0]=s:line_sub(line[0],".",54)
        endif
    endif
    if l:show_Qo && !l:show_tips
        let line[0]=s:line_sub(line[0],"?",54)
    endif
    elseif s:mode=="mini"
    if l:show_tips
        let line[0]=s:line_sub(line[0],"Edit:Enter",59)
        let line[1]=s:line_sub(line[1],"Help:F1/H",59)
        let line[2]=s:line_sub(line[2],"Quit:q/Esc",59)
    if l:show_Qo
        let line[0]=s:line_sub(line[0],".",54)
    endif
    endif
    if l:show_Qo && !l:show_tips
        let line[0]=s:line_sub(line[0],"?",54)
    endif
endif
    for i in range(height)
    	call setline(i+1,line[i])
    endfor
endfunction "}}}
function! s:get_star_pos() "{{{
    let HSV=g:ColorV.HSV
    let [h,s,v]=[HSV.H,HSV.S,HSV.V]
    if s:mode=="normal"
        let h_step=100.0/(s:pal_H-1)
        let w_step=100.0/(s:pal_W-1)
        let l=float2nr(round((100.0-v)/h_step))+1+s:poff_y
        let c=float2nr(round((100.0-s)/w_step))+1+s:poff_x
        if l>=s:pal_H+s:poff_y
            let l= s:pal_H+s:poff_y
        endif
        if c>=s:pal_W+s:poff_x
            let c= s:pal_W+s:poff_x
        endif
    
    elseif s:mode=="mini"
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

function! s:update_text(hex) "{{{
    setl ma

    let hex=printf("%06x",'0x'.a:hex)
    let [r,g,b]=ColorV#hex2rgb(hex)
    let [h,s,v]=ColorV#rgb2hsv([r,g,b])
    let [r,g,b]=[printf("%3d",r),printf("%3d",g),printf("%3d",b)]
    let [h,s,v]=[printf("%3d",h),printf("%3d",s),printf("%3d",v)]
    if s:mode=="normal"
    	let height=s:norm_height
    elseif s:mode=="mini"
        let height=s:mini_height
    endif
    let line=[]
    for i in range(height)
            call add(line,getline(i+1))
    endfor
    "let line=[] 
    "for i in range(height)
        "let m=repeat(' ',s:line_width)
        "call add(line,m)
    "endfor
   
    if s:mode=="normal"
        let line[0]=s:line_sub(line[0],"ColorV ".g:ColorV.ver,3)
        let line[1]=s:line_sub(line[1],"Hex:#".hex,24)
        let line[2]=s:line_sub(line[2],"R:".r."   H:".h,24)
        let line[3]=s:line_sub(line[3],"G:".g."   S:".s,24)
        let line[4]=s:line_sub(line[4],"B:".b."   V:".v,24)
    elseif s:mode=="mini"
        let line[0]=s:line_sub(line[0],"ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"Hex:#".hex,42)
        let line[0]=s:line_sub(line[0],"R:".r."   H:".h,24)
        let line[1]=s:line_sub(line[1],"G:".g."   S:".s,24)
        let line[2]=s:line_sub(line[2],"B:".b."   V:".v,24)
    endif
    
    
    "color star pos
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
    call ColorV#toggle_arrow(b:arrowck_pos)
    setl noma
endfunction "}}}

function! s:clear_text() "{{{
    if expand('%') !=g:ColorV.name
        call s:warning("Not [ColorV] buffer")
        return
    endif
    let cur=getpos('.')
    normal! ggVG"_x
    return cur
endfunction "}}}
"return text in blank line
function! s:line(text,pos) "{{{
    let suf_len= s:line_width-a:pos-len(a:text)+1
    let suf_len= suf_len <= 0 ? 1 : suf_len
    return repeat(' ',a:pos-1).a:text.repeat(' ',suf_len)
endfunction "}}}
"return substitute line at pos in input line
function! s:line_sub(line,text,pos) "{{{
    let [line,text,pos]=[a:line,a:text,a:pos]
    if len(line) < len(text)+pos
    	let line = line.repeat(' ',len(text)+pos-len(line))
    endif
    let pat='^\(.\{'.(pos-1).'}\)\%(.\{'.len(text).'}\)'
    return substitute(line,pat,'\1'.text,'')
endfunction "}}}
"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"BUFF: "{{{1
function! s:set_buf_hex(hex) "{{{

    if expand('%') != g:ColorV.name
        call s:warning("Not [ColorV] buffer")
        return
    endif
    
    setl ma

    let hex= printf("%06x",'0x'.a:hex) 


    call s:update_g_hsv(hex)

    call s:draw_hueLine(1)
    
    if s:mode == "mini"
        call s:draw_satLine(2)
        call s:draw_valLine(3)
    else
        call s:draw_pallet_hex(hex)
    endif
    
    call s:draw_history_block(hex)
    call s:init_text(hex)


    setl noma
endfunction "}}}

function! s:set_bufandpos_hex(hex) "{{{
    call s:set_bufandpos_rgb(ColorV#hex2rgb(a:hex))
endfunction "}}}

function! s:set_bufandpos_rgb(rgb) "{{{
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

    call s:set_buf_hex(hex)
    call cursor(l,c)
    setl noma
endfunction "}}}

"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"EDIT: "{{{1
function! ColorV#set_in_pos(...) "{{{
    setl ma

    let l=exists("a:1") ? a:1 : line('.')
    let c=exists("a:1") ? a:1 : col('.')
    let [L,C]=[s:pal_H,s:pal_W]
    
    "pallet
    if s:mode=="normal" && l > s:poff_y && l<= s:pal_H+s:poff_y && c<= s:pal_W
        let idx=(l-s:poff_y-1)*s:pal_W+c-s:poff_x-1
        let hex=b:pal_list[idx]
        call s:update_g_hsv(hex)
        call s:draw_history_block(hex)
        "call s:update_text(hex)
        call s:init_text(hex)
    " WORKAROUND: 110519  error while between s:pal_w and hue_width
    " delete hue_width to avoid this
    elseif l==1 && ( c<=s:pal_W  )
        let hex=s:hueline_list[(c-1)]
        call s:echo("HEX(Line): ".hex)

        call s:set_buf_hex(hex)
    elseif s:mode=="mini" && l==2 && ( c<=s:pal_W  )
        let hex=s:satline_list[(c-1)]
        call s:echo("HEX(Saturation Line): ".hex)

        call s:set_buf_hex(hex)
    elseif s:mode=="mini" && l==3 && ( c<=s:pal_W  )
        let hex=s:valline_list[(c-1)]
        call s:echo("HEX(Value Line): ".hex)
        call s:set_buf_hex(hex)

    "history_block section "{{{
    elseif l<=(s:block_rect[3]+4-1) && l>=s:block_rect[1] &&
                \c>=s:block_rect[0] && c<=(40+s:block_rect[2]*3-1)  
        if c<=(40+s:block_rect[2]*1-1)
            let hex=s:his_color0
            call s:echo("HEX(history 0): ".hex)
        elseif c<=(40+s:block_rect[2]*2-1)
            let hex=s:his_color1
            call s:echo("HEX(history 1): ".hex)
        elseif c<=(40+s:block_rect[2]*3-1)
            let hex=s:his_color2
            call s:echo("HEX(history 2): ".hex)
        endif
        call s:update_g_hsv(hex)
        call s:draw_history_block(hex)
        "call s:update_text(hex)
        call s:init_text(hex)
    "}}}
    " Arrow section "{{{
    " WORKAROUND: add mini mode
    elseif s:mode=="normal" && l<=5 && l>=2 && c>=24 && c<37
        let idx=0
        let l:in_pos=0
        for [name,y,x,width] in s:norm_pos
            if l==y && c>=x && c<(x+width)
                call ColorV#toggle_arrow(idx)
                let l:in_pos=1
                break
            endif
            let idx+=1
        endfor
        if l:in_pos != 1
            call s:warning("Not Proper Position.")
            setl noma
            return -1
        endif
    elseif s:mode=="mini" && l<=3 && c>=24 && c<=52
        let idx=0
        let l:in_pos=0
        for [name,y,x,width] in s:mini_pos
            if l==y && c>=x && c<(x+width)
                call ColorV#toggle_arrow(idx)
                let l:in_pos=1
                break
            endif
            let idx+=1
        endfor
        if l:in_pos != 1
            call s:warning("Not Proper Position.")
            setl noma
            return -1
        endif
    "}}}
    elseif l==1 && c==54 &&  strpart(getline(1),53)=~'[?\.]'
        call ColorV#switching_tips()
        setl noma
        return -1
    elseif l==1 && c==55  && strpart(getline(1),54)=~'x'
        call ColorV#exit()
        return -1
    else 
    	call s:warning("Not Proper Position.")
        setl noma
        return -1
    endif

    if exists("g:ColorV_set_register") && g:ColorV_set_register==1
    	call ColorV#copy()
    endif

    setl noma
endfunction "}}}
function! ColorV#toggle_arrow(...) "{{{
    setl ma
    if !exists("b:arrowck_pos")|let b:arrowck_pos=0|endif
    if s:mode=="normal"
        let l:cur_pos=s:norm_pos
    elseif s:mode=="mini"
        let l:cur_pos = s:mini_pos
    endif
    let len=len(l:cur_pos)
    for i in range(len)
        let old= l:cur_pos[i]
        let o=substitute(getline(old[1]),"> ".old[0],"  ".old[0],"")
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
    let n=substitute(getline(new[1]),"  ".new[0],"> ".new[0],"")
    call setline(new[1],n)

    redraw
    setl noma
endfunction "}}}
function! ColorV#edit_at_arrow(...) "{{{
    setl ma
    let postition=exists("a:1")? a:1 : b:arrowck_pos
    call ColorV#toggle_arrow(postition)
    let ColorV=g:ColorV
    let hex=ColorV.HEX
    let [r,g,b]=[ColorV.RGB.R,ColorV.RGB.G,ColorV.RGB.B]
    let [h,s,v]=[ColorV.HSV.H,ColorV.HSV.S,ColorV.HSV.V]
    if postition==0 "{{{
        let hex=input("Hex(000000~ffffff):")
        if hex =~ '^\x\{6}$'
            "do nothing then
        else 
            let l:error_input=1
        endif
    elseif postition==1
        let r=input("RED(0~255):")
        if r =~ '^\d\{,3}$' && r<256 && r>=0
            let hex = ColorV#rgb2hex([r,g,b])
        else 
            let l:error_input=1
        endif
    elseif postition==2
        let g=input("GREEN(0~255):")
        if g =~ '^\d\{,3}$' && g<256 && g>=0
            let hex = ColorV#rgb2hex([r,g,b])
        else 
            let l:error_input=1
        endif
    elseif postition==3
        let b=input("BLUE(0~255):")
        if b =~ '^\d\{,3}$' && b<256 && b>=0
            let hex = ColorV#rgb2hex([r,g,b])
        else 
            let l:error_input=1
        endif
    elseif postition==4
        let h=input("Hue(0~360):")
        if h =~ '^\d\{,3}$' && h<=360 && h>=0
            let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        else 
            let l:error_input=1
        endif
    elseif postition==5
        let s=input("Saturation(0~100):") 
        if s =~ '^\d\{,3}$' && s<=100 && s>=0
            let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        else 
            let l:error_input=1
            echom "Error input." 
        endif
    elseif postition==6
        let v=input("Value:(0~100)") 
        if v =~ '^\d\{,3}$' && v<=100 && v>=0
            let hex = ColorV#rgb2hex(ColorV#hsv2rgb([h,s,v]))
        else 
            let l:error_input=1
        endif
    else 
            return -1
    setl noma
    endif "}}}

    if exists("l:error_input") && l:error_input==1
    	call s:warning("Error input. Don't change color")
    	let hex=g:ColorV.HEX
    	let s:skip_his_block=1
    endif
    call s:set_buf_hex(hex)

    "call s:set_bufandpos_hex(hex)
    setl noma
endfunction "}}}

function! ColorV#switching_tips() "{{{
    if exists("s:toggle_tips") && s:toggle_tips==1
    	let s:toggle_tips=0
    	call s:init_text()
    elseif !exists("s:toggle_tips") || s:toggle_tips==0
    	let s:toggle_tips=1
    	call s:init_text()
    endif
endfunction "}}}

function! ColorV#change_hue(step) "{{{
    setl ma
    if !exists("g:ColorV.HSV.H")|let g:ColorV.HSV.H=0|endif
    let g:ColorV.HSV.H= (g:ColorV.HSV.H+a:step)<0 ?  
                \(g:ColorV.HSV.H+a:step) % 360 + 360 : 
                \(g:ColorV.HSV.H+a:step) % 360
    echo "Hue:" g:ColorV.HSV.H
    call s:clear_palmatch()
    call s:draw_pallet(g:ColorV.HSV.H,
                \s:pal_H,s:pal_W,s:poff_y,s:poff_x)
    setl noma
endfun "}}}
"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"INIT: "{{{1
function! ColorV#init_normal(hex) "{{{
    let hex= printf("%06x",'0x'.a:hex) 

    call s:update_g_hsv(hex)

    call s:draw_hueLine(1)

    call s:draw_pallet_hex(hex)

    call s:draw_history_block(hex)

    call s:draw_misc()

    call s:init_text(hex)

endfunction "}}}
function! ColorV#init_mini(hex) "{{{
    let hex= s:fmt_hex(a:hex)
    call s:update_g_hsv(hex)
    call s:draw_hueLine(1)
    call s:draw_satLine(2)
    call s:draw_valLine(3)
    call s:draw_history_block(hex)
    call s:draw_misc()
    call s:init_text(hex)
endfunction
"}}}
" window buffer and autoload
function! ColorV#Win(...) "{{{
    "window check
    if bufexists(g:ColorV.name)
    	"FIXED: 110522 bufnr() not buf number if with [""]
    	let nr=bufnr('\[ColorV\]')
    	let winnr=bufwinnr(nr)
        " FIXED: 110522  weird open in current buffer sometimes 
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
            call s:echo("Open a new [ColorV]")
            execute "botright" 'new' 
            silent! file [ColorV]
        endif
    else
        call s:echo("Open a new [ColorV]")
        execute  "botright" 'new' 
        silent! file [ColorV]
    endif
    setl ft=ColorV
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
    call s:init_hide()
    call s:map_define()

    if exists("a:2")
    	"skip history if no new hex 
        let hex_list=s:txt2hex(a:2)
        if exists("hex_list[0][0]")
            let hex=s:fmt_hex(hex_list[0][0])
        "elseif !len("a:2")
            "let hex = exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
            "let s:skip_his_block=1
        elseif !empty(s:nam2hex(a:2))
            let hex=s:nam2hex(a:2)[1]
        else
            let hex = exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
            let s:skip_his_block=1
            call s:echo("Could not find any color in the text 
                        \,use default [".hex."]") 
        endif
    else 
        let hex = exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
        let s:skip_his_block=1
    endif

    if exists("a:1") && a:1== "mini"
    	let s:mode="mini"
        if winnr('$') != 1
            execute 'resize' s:mini_height
        endif
    	call ColorV#init_mini(hex)
    else
    	let s:mode="normal"
        if winnr('$') != 1
            execute 'resize' s:norm_height
        endif
        call ColorV#init_normal(hex)
    endif

endfunction "}}}
"
function! s:init_hide() "{{{
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
    nmap <silent><buffer> <c-k> :call ColorV#set_in_pos()<cr>
    nmap <silent><buffer> <space> :call ColorV#set_in_pos()<cr>
    nmap <silent><buffer> <space><space> :call ColorV#set_in_pos()<cr>
    nmap <silent><buffer> <leader>ck :call ColorV#set_in_pos()<cr>
    nmap <silent><buffer> <2-leftmouse> :call ColorV#set_in_pos()<cr>
    nmap <silent><buffer> <3-leftmouse> :call ColorV#set_in_pos()<cr>
    nmap <silent><buffer> <tab> :call ColorV#toggle_arrow()<cr>
    nmap <silent><buffer> <c-n> :call ColorV#toggle_arrow()<cr>
    nmap <silent><buffer> J :call ColorV#toggle_arrow()<cr>
    nmap <silent><buffer> K :call ColorV#toggle_arrow(-2)<cr>
    nmap <silent><buffer> <c-p> :call ColorV#toggle_arrow(-2)<cr>
    nmap <silent><buffer> <s-tab> :call ColorV#toggle_arrow(-2)<cr>
    
    "xrgbhsv
    nmap <silent><buffer> x :call ColorV#toggle_arrow(0)<cr>
    nmap <silent><buffer> r :call ColorV#toggle_arrow(1)<cr>
    nmap <silent><buffer> g :call ColorV#toggle_arrow(2)<cr>
    nmap <silent><buffer> gg :call ColorV#toggle_arrow(2)<cr>
    nmap <silent><buffer> b :call ColorV#toggle_arrow(3)<cr>

    nmap <silent><buffer> u :call ColorV#toggle_arrow(4)<cr>
    nmap <silent><buffer> s :call ColorV#toggle_arrow(5)<cr>
    nmap <silent><buffer> v :call ColorV#toggle_arrow(6)<cr>


    nmap <silent><buffer> a :call ColorV#edit_at_arrow()<cr>
    nmap <silent><buffer> i :call ColorV#edit_at_arrow()<cr>
    nmap <silent><buffer> <Enter> :call ColorV#edit_at_arrow()<cr>
    nmap <silent><buffer> <kEnter> :call ColorV#edit_at_arrow()<cr>

    " WONTFIX:quick quit without wait for next key after q
    nmap <silent><buffer> q :call ColorV#exit()<cr>
    nmap <silent><buffer> <esc> :call ColorV#exit()<cr>
    nmap <silent><buffer> ? :call ColorV#switching_tips()<cr>
    nmap <silent><buffer> H :h ColorV<cr>
    nmap <silent><buffer> <F1> :h ColorV<cr>

    "Copy color 
    map <silent><buffer> <c-c> :call ColorV#copy("","+")<cr>
    map <silent><buffer> C :call ColorV#copy("","+")<cr>
    map <silent><buffer> cc :call ColorV#copy("","+")<cr>
    map <silent><buffer> cx :call ColorV#copy("0x","+")<cr>
    map <silent><buffer> cs :call ColorV#copy("#","+")<cr>
    map <silent><buffer> c# :call ColorV#copy("#","+")<cr>
    map <silent><buffer> cr :call ColorV#copy("RGB","+")<cr>
    map <silent><buffer> cp :call ColorV#copy("RGBP","+")<cr>
    map <silent><buffer> caa :call ColorV#copy("RGBA","+")<cr>
    map <silent><buffer> cap :call ColorV#copy("RGBAP","+")<cr>
    map <silent><buffer> cn :call ColorV#copy("NAM","+")<cr>

    map <silent><buffer> Y :call ColorV#copy()<cr>
    map <silent><buffer> yy :call ColorV#copy()<cr>
    map <silent><buffer> yx :call ColorV#copy("0x")<cr>
    map <silent><buffer> ys :call ColorV#copy("#")<cr>
    map <silent><buffer> y# :call ColorV#copy("#")<cr>
    map <silent><buffer> yr :call ColorV#copy("RGB")<cr>
    map <silent><buffer> yp :call ColorV#copy("RGBP")<cr>
    map <silent><buffer> yaa :call ColorV#copy("RGBA")<cr>
    map <silent><buffer> yap :call ColorV#copy("RGBAP")<cr>
    map <silent><buffer> yn :call ColorV#copy("NAM")<cr>
    
    "paste color
    map <silent><buffer> <c-v> :call ColorV#paste("+")<cr>
    map <silent><buffer> p :call ColorV#paste()<cr>
    map <silent><buffer> P :call ColorV#paste()<cr>
    map <silent><buffer> <middlemouse> :call ColorV#paste("+")<cr>
endfunction "}}}
"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"TEXT: "{{{1
" input: text
" return: hexlist [[hex,idx,len,fmt],[hex,idx,len,fmt],...]
function! s:txt2hex(txt) "{{{
    let text = a:txt
    let hex_dict={}
    let o_dict={}

    "let idx=0
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
                "let idx+=1
            endif
        endfor
        if o_dict==hex_dict          
            break
        endif
        let round-=1
    endwhile
    unlet o_dict

    let hex_list=[]
    for [key,var] in items(hex_dict)
        if key=="HEX"
                for clr in var
                    call add(clr,key)
                    call add(hex_list,clr)
                endfor
        elseif key=="HEX3"
                for clr in var
                    let clr[0]=substitute(clr[0],'.','&&','g')
                    call add(clr,key)
                call add(hex_list,clr)
                endfor
        elseif key=="RGB" || key =="RGBA"
                for clr in var
                    let list=split(clr[0],',')
                    let r=matchstr(list[0],'\d\{1,3}')
                    let g=matchstr(list[1],'\d\{1,3}')
                    let b=matchstr(list[2],'\d\{1,3}')
                    let clr[0] = ColorV#rgb2hex([r,g,b])
                    call add(clr,key)
                call add(hex_list,clr)
                endfor
        elseif key=="RGBP" || key =="RGBAP"
                for clr in var
                    let list=split(clr[0],',')
                    let r=matchstr(list[0],'\d\{1,3}')
                    let g=matchstr(list[1],'\d\{1,3}')
                    let b=matchstr(list[2],'\d\{1,3}')
                    let clr[0] = ColorV#rgb2hex([r*2.55,g*2.55,b*2.55])
                    call add(clr,key)
                call add(hex_list,clr)
                endfor
        endif
    endfor
    
    return hex_list
endfunction "}}}
function! s:hex2txt(hex,fmt) "{{{
    
    let hex=printf("%06x","0x".a:hex)
    let [r,g,b] = ColorV#hex2rgb(hex)
    if a:fmt=="RGB"
        let text="rgb(".r.",".g.",".b.")"
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
        let text=g:ColorV.HEX
    elseif a:fmt=="#"
        let text="#".g:ColorV.HEX
    elseif a:fmt=="0x"
        let text="0x".g:ColorV.HEX
    elseif a:fmt=="NAM"
        let text=s:hex2nam(hex)
    else
        let text=g:ColorV.HEX
    endif

    return text
endfunction "}}}
function! s:fmt_hex(hex) "{{{
    return strpart(printf("%06x",'0x'.a:hex),0,6) 
endfunction "}}}
function! ColorV#paste(...) "{{{
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
    if len(hex_list)>0
        let hex=hex_list[0][0]
    elseif !empty(s:nam2hex(pat))
        let hex=s:nam2hex(pat)[1]
    else
    	call s:warning("Could not find color in the text") 
    	return
    endif
    call s:echo("Set with first color in clipboard. HEX: [".hex."]")
    call s:set_buf_hex(hex)

endfunction "}}}
function! ColorV#copy(...) "{{{
    let fmt=exists("a:1") ? a:1 : "HEX"
    let l:cliptext=s:hex2txt(g:ColorV.HEX,fmt)
    let g:ColorV.history_copy=exists("g:ColorV.history_copy") ? g:ColorV.history_copy : []
    call add(g:ColorV.history_copy,g:ColorV.HEX)
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
function! ColorV#open_word(...) "{{{
    let pat = expand('<cWORD>')
    let hex_list=s:txt2hex(pat)
    if exists("hex_list[0][0]")
        let hex=s:fmt_hex(hex_list[0][0])
        "let g:ColorV.word_list=hex_list[0]
    elseif !empty(s:nam2hex(pat))
        let hex=s:nam2hex(pat)[1]
    else
        call s:warning("Could not find a color under cursor.")
        return -1
    endif
    
    if exists("a:1") && a:1=="mini" || g:ColorV_word_mini==1
        call ColorV#Win("mini",hex)
    else
        call ColorV#Win(hex)
    endif
endfunction "}}}
function! s:nam2hex(nam) "{{{
    for [nam,clr] in s:clrn
        if a:nam ==? nam   
            "return string(clr)
            return [nam,clr]
            break
        endif
    endfor
    "echo clr nam a:nam
    return 0
endfunction "}}}
function! s:hex2nam(hex) "{{{
    for [nam,clr] in s:clrn
        if s:approx2(a:hex,clr)
            return nam
        endif
    endfor
    for [nam,clr] in s:clrn
        if s:approx2(a:hex,clr,10)
            return nam.'~'
        endif
    endfor
    return ""
endfunction "}}}
function! s:approx2(hex1,hex2,...) "{{{
    let [h1,s1,v1] = ColorV#rgb2hsv(ColorV#hex2rgb(a:hex1))
    let [h2,s2,v2] = ColorV#rgb2hsv(ColorV#hex2rgb(a:hex2))
    let r=exists("a:1") ? a:1 : s:ap_rate
    if h2+r>=h1 && h1>=h2-r && s2+r>=s1 && s1>=s2-r
                \&& v2+r>=v1 && v1>=v2-r
    	return 1
    else
    	return 0
    endif

endfunction "}}}
function! ColorV#change(...) "{{{
    let g:ColorV.word_bufnr=bufnr('%')
    let g:ColorV.word_bufname=bufname('%')
    let g:ColorV.word_bufwinnr=bufwinnr('%')
    let g:ColorV.word_pos=getpos('.')

    let pat = expand('<cWORD>')
    let g:ColorV.word_pat=pat
    let hex_list=s:txt2hex(pat)
    if exists("hex_list[0][0]")
        let hex=s:fmt_hex(hex_list[0][0])
        let g:ColorV.word_list=hex_list[0]
    elseif !empty(s:nam2hex(pat))
        let hex=s:nam2hex(pat)[1]
        let str=s:nam2hex(pat)[0]
        let pat_idx=match(pat,str)
        let pat_len=len(str)
        let g:ColorV.word_list=[hex,pat_idx,pat_len,"NAM"]
    else 
        call s:warning("Could not find a color under cursor.")
        return
    endif

    if exists("a:1") && a:1=="mini" || g:ColorV_word_mini==1
        call ColorV#Win("mini",hex)
    else
        call ColorV#Win(hex)
    endif
    let g:ColorV.change_word=1
    if exists("a:2") && a:2=="all"
    	let g:ColorV.change_all=1
        call s:caution("Will Substitute ALL [".pat."] after ColorV closed.")
    else
    	call s:caution("Will Change [".pat."] after ColorV closed.")
    endif
endfunction "}}}
function! s:changing() "{{{
    if exists("g:ColorV.change_word") && g:ColorV.change_word ==1
    	let cur_pos=getpos('.')
        let cur_bufwinnr=bufwinnr('%')
        " go to the word_buf
        exe g:ColorV.word_bufwinnr."wincmd w"
        call setpos('.',g:ColorV.word_pos)

        if g:ColorV.word_bufnr==bufnr('%') && g:ColorV.word_pos==getpos('.')
                    \ && g:ColorV.word_bufname==bufname('%')

            let pat = expand('<cWORD>')
            
            "Not the origin word
            if pat!= g:ColorV.word_pat
                call s:warning("Not the same with the word to change.")
                return -1
            endif

            if exists("g:ColorV.word_list[0]")
                let hex=g:ColorV.HEX
                let fmt=g:ColorV.word_list[3]
                let str=s:hex2txt(hex,fmt)
            else
                call s:warning("Could not find a color under cursor.")
                let g:ColorV.change_word=0
                let g:ColorV.change_all=0
            	return 
            endif
            let idx=g:ColorV.word_list[1]
            let len=g:ColorV.word_list[2]
            let new_pat=substitute(pat,'\%'.(idx+1).'c.\{'.len.'}',str,'')
            if exists("g:ColorV.HEX")
                if exists("g:ColorV.change_all") && g:ColorV.change_all ==1
                    exec '%s/'.pat.'/'.new_pat.'/gc'
                else
                    exec '.s/'.pat.'/'.new_pat.'/gc'
                endif
            endif
        endif
        let g:ColorV.change_word=0
        let g:ColorV.change_all=0
        "back to origin pos
        "WORKAROUND: not correct back position
        "exe cur_bufwinnr."wincmd w"
        "call setpos('.',cur_pos)
    else
        let g:ColorV.change_word=0
        let g:ColorV.change_all=0
    	return 0
    endif
endfunction
"}}}
"
function! s:caution(msg) "{{{
    echohl Modemsg
    exe "echom \"[ColorV]:".escape(a:msg,'"')."\""
    echohl Normal
endfunction "}}}
function! s:warning(msg) "{{{
    echohl Warningmsg
    exe "echom \"[ColorV]:".escape(a:msg,'"')."\""
    echohl Normal
endfunction "}}}
function! s:echo(msg) "{{{
    if g:ColorV_silent_set==0
        exe "echom \"[ColorV]:".a:msg."\""
    else
    	echom ""
    endif
endfunction "}}}

function! ColorV#exit() "{{{
    if expand('%') !=g:ColorV.name
        call s:echo("Not the [ColorV] buffer")
        return
    endif
    bw
    call s:changing()
endfunction "}}}

function! ColorV#Dropper()
python << EOF
import pygtk,gtk,vim
pygtk.require('2.0')

color_sel = gtk.ColorSelectionDialog("[ColorV] colorpicker")
color_set = gtk.gdk.color_parse("#"+vim.eval("g:ColorV.HEX"))
color_sel.colorsel.set_current_color(color_set)


if color_sel.run() == gtk.RESPONSE_OK:
    color = color_sel.colorsel.get_current_color()
    #Convert to 8bit channels
    red = color.red * 255 / 65535
    green = color.green * 255 / 65535
    blue = color.blue * 255 / 65535
    #Convert to hexa strings
    red = str(hex(red))[2:]
    green = str(hex(green))[2:]
    blue = str(hex(blue))[2:]
    #Format
    if len(red) == 1:
        red = "0%s" % red
    if len(green) == 1:
        green = "0%s" % green
    if len(blue) == 1:
        blue = "0%s" % blue
    #Merge
    color = "%s%s%s" % (red, green, blue)
    vim.command("ColorV "+color)

#Close dialog
color_sel.destroy()

EOF
endfunction
"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tw=78:fdm=marker:
