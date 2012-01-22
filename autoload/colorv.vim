"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV
"    File: autoload/colorv.vim
" Summary: A Color tool in Vim.
"  Author: Rykka <Rykka10(at)gmail.com>
"    Home: https://github.com/Rykka/ColorV
" Version: 2.5.4
" Last Update: 2012-01-22
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if version < 700
    finish
else
    let g:ColorV_loaded = 1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GVAR: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ColorV={}
let g:ColorV.ver="2.5.4"

"debug
if !exists("g:ColorV_debug")
    let g:ColorV_debug=0
endif
"debug vim func
if !exists('g:ColorV_no_python')
    let g:ColorV_no_python=0
endif
if !exists('g:ColorV_cache_File')
    let g:ColorV_cache_File = expand('$HOME') . '/.vim_colorv_cache'
endif
if !exists('g:ColorV_load_cache')
    let g:ColorV_load_cache=1
endif
if !exists('g:ColorV_win_pos')
    let g:ColorV_win_pos="bot"
endif
if !exists('g:ColorV_view_name')
    let g:ColorV_view_name=1
endif
if !exists('g:ColorV_view_block')
    let g:ColorV_view_block=0
endif
if !exists('g:ColorV_win_space')
    let g:ColorV_win_space="hsv"
endif
if !exists('g:ColorV_gen_space')
    let g:ColorV_gen_space="hsv"
endif
if has("python")
    if !exists('g:ColorV_prev_css')
        let g:ColorV_prev_css=1
    endif
else
    if !exists('g:ColorV_prev_css')
        let g:ColorV_prev_css=0
    endif
endif

let g:ColorV.name="_ColorV_"
let g:ColorV.listname="_ColorV-List_"
let g:ColorV.HEX="ff0000"
let g:ColorV.RGB={'R':255,'G':0,'B':0}
let g:ColorV.HSV={'H':0,'S':100,'V':100}
let g:ColorV.HLS={'H':0,'L':50,'S':100}
let g:ColorV.YIQ={'Y':30,'I':60,'Q':21}
let g:ColorV.rgb=[255,0,0]
let g:ColorV.hls=[0,50,100]
let g:ColorV.yiq=[30,60,21]
let g:ColorV.hsv=[0,100,100]
let g:ColorV.NAME="Red"
"}}}
"SVAR: {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:ColorV={}
if !exists("s:mode")|let s:mode="mid"|endif
"{{{ misc
let s:gen_def_nums=20
let s:gen_def_step=10
let s:gen_def_type="Hue"

let s:his_cpd_list=exists("s:his_cpd_list")
            \ ? s:his_cpd_list : []
let s:his_set_list=exists("s:his_set_list")
            \ ? s:his_set_list : ['ff0000']

let [s:max_h,s:mid_h,s:min_h]=[9,6,3]

let [s:pal_W,s:pal_H]=[20,5]
let [s:poff_x,s:poff_y]=[0,1]
let s:his_set_rect=[43,2,5,4]
let s:his_cpd_rect=[22,7,2,1]
let s:line_width=57
let s:max_pos=[["Hex:",1,22,10],
            \["R:",2,22,5],["G:",2,29,5],["B:",2,36,5],
            \["H:",3,22,5],["S:",3,29,5],["V:",3,36,5],
            \["N:",1,43,15],
            \["H:",4,22,5],["L:",4,29,5],["S:",4,36,5],
            \["Y ",5,22,5],["I ",5,29,5],["Q ",5,36,5],
            \]
let s:mid_pos=[["Hex:",2,22,10],
            \["R:",3,22,5],["G:",3,29,5],["B:",3,36,5],
            \["H:",4,22,5],["S:",4,29,5],["V:",4,36,5],
            \["N:",1,43,15],
            \["H ",5,22,5],["L ",5,29,5],["S ",5,36,5],
            \]
let s:min_pos=[["Hex:",1,22,10],
            \["R:",2,22,5],["G:",2,29,5],["B:",2,36,5],
            \["H:",3,22,5],["S:",3,29,5],["V:",3,36,5],
            \["N:",1,43,15]
            \]

" the status col pos in colorv window
let s:stat_pos = 53
let s:tip_pos = 22
"}}}
" hlp txt "{{{
let s:hlp_d = {
            \"r":["RED",0,255],
            \"g":["GREEN",0,255],
            \"b":["Blue",0,255],
            \"H":["[HLS]Hue",0,360],
            \"L":["[HLS]Lightness",0,100],
            \"S":["[HLS]Saturation",0,100],
            \"h":["[HSV]Hue",0,360],
            \"s":["[HSV]Saturation",0,100],
            \"v":["[HSV]Value",0,100],
            \"Y":["[YIQ]Luma",0,100],
            \"I":["[YIQ]I-Channel",-60,60],
            \"Q":["[YIQ]Q-Channel",-52,52],
            \}

let s:tips_list=[
            \'Move:Click/<Tab>/hjkl...',
            \'Edit:<2-Click>/<2-Space>/Ctrl-K/Ctrl-J/<Enter>/<KEnter>',
            \'Yank(reg"): yy:HEX yr:RGB yl:HSL ym:CMYK ...  Copy(reg+) cc:...',
            \'Paste:<Ctrl-V>/p (Show pasted color in ColorV window)',
            \'Colorname(W3C):na/ne       (X11):nx',
            \'Colorlist: g1:Hue/g2/g3/g4/g5/g6/gh/gs/gv...',
            \'Preview Buffer: :ColorVview (<leader>cpp) ',
            \'Edit color in Buffer: :ColorVsub (<leader>ce) ',
            \'Dropper: :ColorVdropper (<leader>cd, pygtk2 needed) ',
            \'Help:<F1>/H                ',
            \'Quit:q/Q/<C-W>q/<C-W><C-Q>',
            \]
"}}}
" fmt "{{{
let s:fmt={}
let s:fmt.RGB='rgb(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3})'
let s:fmt.RGBA='rgba(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3}\,'
            \.'\s*\d\{1,3}\%(\.\d*\)\=%\=)'
let s:fmt.RGBP='rgb(\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%)'
let s:fmt.RGBAP='rgba(\s*\d\{1,3}%,\s*\d\{1,3}%,\s*\d\{1,3}%,'
            \.'\s*\d\{1,3}\%(\.\d*\)\=%\=)'
"ffffff
let s:fmt.HEX='\%(0x\|#\|\x\)\@<!\x\{6}\x\@!'
"0xffffff
let s:fmt.HEX0='0x\x\{6}\x\@!'
"number sign 6 #ffffff
let s:fmt.NS6='#\x\{6}\x\@!'
"#fff
let s:fmt.NS3='#\x\{3}\x\@!'

let s:fmt.HSV='hsv(\s*\d\{1,3},\s*\d\{1,3},\s*\d\{1,3})'
let s:fmt.HSL='hsl(\s*\d\{1,3},\s*\d\{1,3}%,\s*\d\{1,3}%)'
let s:fmt.HSLA='hsla(\s*\d\{1,3},\s*\d\{1,3}%,\s*\d\{1,3}%,'
                \.'\s*\d\{1,3}\%(\.\d*\)\=%\=)'
let s:fmt.CMYK='cmyk(\s*\d\.\d*,\s*\d\.\d*,\s*\d\.\d*,'
                \.'\s*\d\.\d*)'

let s:a='Uryyb'
let s:t='fghDPijmrYFGtudBevwxklyzEIZOJLMnHsaKbcopqNACQRSTUVWX'
let s:e='stuQCvwzeLSTghqOrijkxylmRVMBWYZaUfnXopbcdANPDEFGHIJK'

let s:aprx_rate=5
let s:tune_step=4
"colorname list "{{{
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
"}}}
let s:fmt.NAME=''
for [nam,hex] in s:clrnW3C+s:clrn
    let s:fmt.NAME .='\<'.nam.'\>\|'
endfor
let s:fmt.NAME =substitute(s:fmt.NAME,'\\|$','','')
"}}}
"{{{ term colorlist
let s:term8_dict= {
            \0:"000000",1:"800000",2:"008000",
            \3:"808000",4:"000080",5:"800080",
            \6:"008080",7:"c0c0c0",
            \8:"808080",9:"ff0000",10:"00ff00",
            \11:"ffff00",12:"0000ff",13:"ff00ff",
            \14:"00ffff",15:"ffffff"
            \}
"terminal color 256
let s:term_dict = {
            \0:  '000000', 1:  '000080', 2:  '008000',
            \3:  '008080', 4:  '800000', 5:  '800080',
            \6:  '808000', 7:  'c0c0c0', 8:  '808080',
            \9:  'ff0000', 10: '00ff00', 11: '00ffff',
            \12: 'ff0000', 13: 'ff00ff', 14: 'ffff00',
            \15: 'ffffff',
           \}

"}}}
" for match dict "{{{
if !exists("s:misc_dict")|let s:misc_dict={}|endif
if !exists("s:rect_dict")|let s:rect_dict={}|endif
if !exists("s:hsv_dict") |let s:hsv_dict={} |endif
if !exists("s:prev_dict")|let s:prev_dict={}|endif
if !exists("s:pal_dict") |let s:pal_dict={} |endif
"}}}
"}}}
"CORE: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:py_core_load() "{{{
    if exists("s:py_core_load")
        return
    endif
    let s:py_core_load=1
python << EOF
from math import fmod
import math
import vim
import colorsys
def number(x):
    return int(round(float(x)))

#{{{ rgb hex
def hex2rgb(hex):
    if hex.startswith("#"): hex = hex[1:]
    elif hex[0:2].lower() == '0x': hex = hex[2:]
    hex=int("".join(["0X"+hex]),16)
    rgb = [(hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff ]
    return  rgb
def rgb2hex(rgb):
    r,g,b=number(rgb[0]),number(rgb[1]),number(rgb[2])
    if r>255 or g>255 or b>255 or r<0 or g<0 or b<0:
        r=(r,255)[r>255]
        r=(r,0)[r<0]
        g=(g,255)[g>255]
        g=(g,0)[g<0]
        b=(b,255)[b>255]
        b=(b,0)[b<0]
    return '%02X%02X%02X' % (r,g,b)
#}}}
#{{{ hsv
def rgb2hsv(rgb):
    r,g,b=rgb
    h,s,v=colorsys.rgb_to_hsv(r/255.0,g/255.0,b/255.0)
    return [int(round(h*360.0)),int(round(s*100.0)),int(round(v*100.0))]
def hsv2rgb(hsv):
    h,s,v=hsv
    r,g,b=colorsys.hsv_to_rgb(h/360.0,s/100.0,v/100.0)
    return [int(round(r*255.0)),int(round(g*255.0)),int(round(b*255.0))]
    #}}}
 #{{{ yiq
def rgb2yiq(rgb):
    r,g,b=rgb
    y,i,q=colorsys.rgb_to_yiq(r/255.0,g/255.0,b/255.0)
    return [int(round(y*100.0)),int(round(i*100.0)),int(round(q*100.0))]
def yiq2rgb(yiq):
    y,i,q=yiq
    r,g,b=colorsys.yiq_to_rgb(y/100.0,i/100.0,q/100.0)
    return [int(round(r*255.0)),int(round(g*255.0)),int(round(b*255.0))]
    #}}}
#{{{hls
def rgb2hls(rgb):
    r,g,b=rgb
    h,l,s=colorsys.rgb_to_hls(r/255.0,g/255.0,b/255.0)
    return [int(round(h*360.0)),int(round(l*100.0)),int(round(s*100.0))]
def hls2rgb(hls):
    h,l,s=hls
    r,g,b=colorsys.hls_to_rgb(h/360.0,l/100.0,s/100.0)
    return [int(round(r*255.0)),int(round(g*255.0)),int(round(b*255.0))]
#}}}
    
#{{{hls
def rgb2hls(rgb):
    r,g,b=rgb
    h,l,s=colorsys.rgb_to_hls(r/255.0,g/255.0,b/255.0)
    return [int(round(h*360.0)),int(round(l*100.0)),int(round(s*100.0))]
def hls2rgb(hls):
    h,l,s=hls
    r,g,b=colorsys.hls_to_rgb(h/360.0,l/100.0,s/100.0)
    return [int(round(r*255.0)),int(round(g*255.0)),int(round(b*255.0))]
#}}}

#{{{
def rgb2cmyk(rgb):
    r,g,b = rgb
    [R,G,B]=[r/255.0,g/255.0,b/255.0]
    [C,M,Y]=[1.0-R,1.0-G,1.0-B]
    vk=1.0
    if C < vk : vk =C 
    if M < vk : vk =M 
    if Y < vk : vk =Y 
    if vk==1:
        [C,M,Y]=[0,0,0]
    else:
        C=(C-vk)/(1.0-vk)
        M=(M-vk)/(1.0-vk)
        Y=(Y-vk)/(1.0-vk)
    K =vk
    return [C,M,Y,K]
def cmyk2rgb(cmyk):
    C,M,Y,K = cmyk
    C=C*(1-K)+K
    M=M*(1-K)+K
    Y=Y*(1-K)+K
    return [number(round((1-C)*255)),
            number(round((1-M)*255)),
            number(round((1-Y)*255))]
#}}}

EOF
endfunction "}}}

function! colorv#rgb2hex(rgb)   "{{{
    let [r,g,b]=s:number(a:rgb)
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
   return printf("%02X%02X%02X",r,g,b)
endfunction "}}}
function! colorv#hex2rgb(hex) "{{{
   let hex=s:fmt_hex(a:hex)
   return [str2nr(hex[0:1],16),str2nr(hex[2:3],16),str2nr(hex[4:5],16)]
endfunction "}}}

function! colorv#rgb2hsv(rgb)  "{{{
    let [r,g,b]=s:float(a:rgb)
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    if has("python") && g:ColorV_no_python!=1
        call s:py_core_load()
        py rgb=[float(vim.eval("r")),float(vim.eval("g")),float(vim.eval("b"))]
        py vim.command("return "+str(rgb2hsv(rgb)))
    else
        let [r,g,b]=[r/255.0,g/255.0,b/255.0]
        let max=s:fmax([r,g,b])
        let min=s:fmin([r,g,b])
        let df=max-min

        let V=max
        let S= V==0 ? 0 : df/max
        let H = max==min ? 0 : max==r ? 60.0*(g-b)/df :
            \(max==g ? 120+60.0*(b-r)/df : 240+60.0*(r-g)/df)
        let H=round(H<0?s:fmod(H,360.0)+360:(H>=360?s:fmod(H,360.0) : H))
        return s:number([H,round(S*100),round(V*100)])
    endif
endfunction "}}}
function! colorv#hsv2rgb(hsv) "{{{
    let [h,s,v]=s:float(a:hsv)
    let h = h>=360 ? s:fmod(h,360.0) : h<0 ? 360-s:fmod(abs(h),360.0) : h
    let s = s>100 ? 100 : s < 0 ? 0 : s
    let v = v>100 ? 100 : v < 0 ? 0 : v
    if has("python") && g:ColorV_no_python!=1
        call s:py_core_load()
        py hsv=[float(vim.eval("h")),float(vim.eval("s")),float(vim.eval("v"))]
        py vim.command("return "+str(hsv2rgb(hsv)))
    else
        let v=v*2.55
        if s==0
            let [R,G,B]=[v,v,v]
        else
            let s=s/100.0
            let hi=floor(abs(h/60.0))
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
        return s:number([round(R),round(G),round(B)])
    endif
endfunction "}}}
function! colorv#hex2hsv(hex) "{{{
   let hex=s:fmt_hex(a:hex)
   return colorv#rgb2hsv(colorv#hex2rgb(hex))
endfunction "}}}
function! colorv#hsv2hex(hsv) "{{{
    return colorv#rgb2hex(colorv#hsv2rgb(a:hsv))
endfunction "}}}

function! colorv#rgb2hls(rgb) "{{{
    let [r,g,b]=s:float(a:rgb)
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    if has("python") && g:ColorV_no_python!=1
        call s:py_core_load()
        py rgb=[float(vim.eval("r")),float(vim.eval("g")),float(vim.eval("b"))]
        py vim.command("return "+str(rgb2hls(rgb)))
    else
        let [r,g,b]=[r/255.0,g/255.0,b/255.0]
        let max=s:fmax([r,g,b])
        let min=s:fmin([r,g,b])
        let df=max-min

        let L=(max+min)/2.0
        if L==0 || max==min
            let S=0
        elseif L>0 && L<=0.5
            let S= df/(max+min)
        else
            let S=df/(2-max-min)
        endif

        let H = max==min ? 0 : max==r ? 60.0*(g-b)/df :
            \(max==g ? 120+60.0*(b-r)/df : 240+60.0*(r-g)/df)
        let H=round(H<0?s:fmod(H,360.0)+360:(H>360?s:fmod(H,360.0) : H))
        return s:number([H,round(L*100),round(S*100)])
    endif
endfunction "}}}
function! colorv#hls2rgb(hls) "{{{
    let [h,l,s]=s:float(a:hls)
    let s = s>100 ? 100 : s < 0 ? 0 : s
    let l = l>100 ? 100 : l < 0 ? 0 : l
    if h>=360
        let h=s:fmod(h,360.0)
    elseif h<0
        let h=360-s:fmod(abs(h),360.0)
    endif
    if has("python") && g:ColorV_no_python!=1
        call s:py_core_load()
        py hls=[float(vim.eval("h")),float(vim.eval("l")),float(vim.eval("s"))]
        py vim.command("return "+str(hls2rgb(hls)))
    else
        let [h,s,l]=[h/360.0,s/100.0,l/100.0]
        if s==0
            let [r,g,b]=[l,l,l]
        else
            if l<0.5
                let var_2= l *(1+s)
            else
                let var_2= (l+s)-(s*l)
            endif
            let var_1=2*l-var_2
            function! s:vh2rgb(v1,v2,vh) "{{{
                let [v1,v2,vh]=[a:v1,a:v2,a:vh]
                if vh<0
                    let vh+=1
                endif
                if vh>1
                    let vh-=1
                endif
                if 6*vh<1
                    return v1+(v2-v1)*6*vh
                endif
                if 2*vh<1
                    return v2
                endif
                if 3*vh<2
                    return v1+(v2-v1)*((2.0/3.0)-vh)*6
                endif
                return v1
            endfunction "}}}
            let r= s:vh2rgb(var_1,var_2,(h+1.0/3))
            let g= s:vh2rgb(var_1,var_2,h)
            let b= s:vh2rgb(var_1,var_2,(h-1.0/3))
        endif
        return s:number([round(r*255),round(g*255),round(b*255)])
    endif
endfunction "}}}
function! colorv#hex2hls(hex) "{{{
   return colorv#rgb2hls(colorv#hex2rgb(a:hex))
endfunction "}}}
function! colorv#hls2hex(hls) "{{{
    return colorv#rgb2hex(colorv#hls2rgb(a:hls))
endfunction "}}}

"YUV color space (PAL)
function! colorv#rgb2yuv(rgb) "{{{
    let [r,g,b]=s:float(a:rgb)
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    let [r,g,b]=[r/255.0,g/255.0,b/255.0]
    let Y=0.299*r+0.587*g+0.114*b
    let U=-0.147*r-0.289*g+0.436*b
    let V=0.615*r-0.515*g-0.100*b
    return s:number([round(Y*100),round(U*100),round(V*100)])
endfunction "}}}
function! colorv#yuv2rgb(yuv) "{{{
    let [Y,U,V]=s:float(a:yuv)
    let [Y,U,V]=[Y/100.0,U/100.0,V/100.0]
    let Y= Y>100 ? 100 : Y<0 ? 0 : Y
    let U= U>100 ? 100 : U<-100 ? -100 : U
    let V= V>100 ? 100 : V<-100 ? -100 : V
    let R = Y + 1.14 *V
    let G = Y - 0.395*U - 0.581*V
    let B = Y + 2.032*U
    let R = R>1 ? 1 : R<0 ? 0 : R
    let G = G>1 ? 1 : G<0 ? 0 : G
    let B = B>1 ? 1 : B<0 ? 0 : B
    return s:number([round(R*255.0),round(G*255.0),round(B*255.0)])
endfunction "}}}

"YIQ color space (NTSC)
function! colorv#rgb2yiq(rgb) "{{{
    let [r,g,b]=s:float(a:rgb)
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
if has("python") && g:ColorV_no_python!=1
    call s:py_core_load()
    py rgb=[float(vim.eval("r")),float(vim.eval("g")),float(vim.eval("b"))]
    py vim.command("return "+str(rgb2yiq(rgb)))
else
    let [r,g,b]=[r/255.0,g/255.0,b/255.0]
    let Y=  0.299 *r + 0.587 *g+ 0.114 *b
    let I=  0.5957*r +-0.2745*g+-0.3213*b
    let Q=  0.2115*r +-0.5226*g+ 0.3111*b
    return s:number([round(Y*100),round(I*100), round(Q*100)])
endif
endfunction "}}}
function! colorv#yiq2rgb(yiq) "{{{
    let [y,i,q]=s:float(a:yiq)
    let y= y>100 ? 100 : y<0 ? 0 : y
    let i= i>100 ? 100 : i<-100 ? -100 : i
    let q= q>100 ? 100 : q<-100 ? -100 : q
    if has("python") && g:ColorV_no_python!=1
        call s:py_core_load()
        py yiq=[float(vim.eval("y")),float(vim.eval("i")),float(vim.eval("q"))]
        py vim.command("return "+str(yiq2rgb(yiq)))
    else
        let [y,i,q]=[y/100.0,i/100.0,q/100.0]
        let r = y + 0.9563*i+ 0.6210*q
        let g = y - 0.2721*i- 0.6474*q
        let b = y - 1.1070*i+ 1.7046*q
        let r = r>1 ? 1 : r<0 ? 0 : r
        let g = g>1 ? 1 : g<0 ? 0 : g
        let b = b>1 ? 1 : b<0 ? 0 : b
        return s:number([round(r*255.0),round(g*255.0),round(b*255.0)])
    endif
endfunction "}}}
function! colorv#hex2yiq(hex) "{{{
   let hex=s:fmt_hex(a:hex)
   return colorv#rgb2yiq(colorv#hex2rgb(hex))
endfunction "}}}
function! colorv#yiq2hex(yiq) "{{{
    return colorv#rgb2hex(colorv#yiq2rgb(a:yiq))
endfunction "}}}

function! colorv#rgb2lab(rgb) "{{{
    let [r,g,b]=s:float(a:rgb)
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b

    let [r,g,b]=[r/255.0,g/255.0,b/255.0]
    if r > 0.04045
      let r = pow(((r + 0.055) / 1.055) , 2.4)
    else
      let r = r / 12.92
    endif
    if g > 0.04045
      let g = pow(((g + 0.055) / 1.055) , 2.4)
    else
      let g = g / 12.92
    endif
    if b > 0.04045
      let b = pow(((b + 0.055) / 1.055) , 2.4)
    else
      let b = b / 12.92
    endif
    
    let [r,g,b] =[r*100,g*100,b*100]

    let X = r * 0.4124 + g * 0.3576 + b * 0.1805
    let Y = r * 0.2126 + g * 0.7152 + b * 0.0722
    let Z = r * 0.0193 + g * 0.1192 + b * 0.9505

    " XYZ to Lab
    " http://www.easyrgb.com/index.php?X=MATH&H=07#text7
    let X = X/95.047
    let Y = Y/100.000
    let Z = Z/108.883

    if (X > 0.008856)
      let X = pow(X ,(0.3333333))
    else
      let X = (7.787 * X) + (16 / 116.0)
    endif
    if (Y > 0.008856)
      let Y = pow(Y ,(0.3333333))
    else
      let Y = (7.787 * Y) + (16 / 116.0)
    endif
    if (Z > 0.008856)
      let Z = pow(Z ,(0.3333333))
    else
      let Z = (7.787 * Z) + (16 / 116.0)
    endif

    let L = (116 * Y) - 16
    let a = 500 * (X - Y)
    let b = 200 * (Y - Z)

    return [L, a, b]

endfunction "}}}

"CMYK (Cyan,Magenta,Yellow and Black)
function! colorv#rgb2cmyk(rgb) "{{{
    let [r,g,b]=s:float(a:rgb)
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    let [R,G,B]=[r/255.0,g/255.0,b/255.0]
    let [C,M,Y]=[1.0-R,1.0-G,1.0-B]
    let vk=1.0
    if C < vk | let vk =C | endif
    if M < vk | let vk =M | endif
    if Y < vk | let vk =Y | endif
    if vk==1
        let [C,M,Y]=[0,0,0]
    else
        let C=(C-vk)/(1.0-vk)
        let M=(M-vk)/(1.0-vk)
        let Y=(Y-vk)/(1.0-vk)
    endif
    let K =vk
    return s:printf("%.2f",[C,M,Y,K])
endfunction "}}}
function! colorv#cmyk2rgb(cmyk) "{{{
    let [C,M,Y,K]=s:float(a:cmyk)
    let C=C*(1-K)+K
    let M=M*(1-K)+K
    let Y=Y*(1-K)+K
    return s:number([round((1-C)*255),round((1-M)*255),round((1-Y)*255)])
endfunction "}}}

"TERMINAL
function! s:py_term_load() "{{{
    if exists("s:py_term_loaded")
        return
    endif
    let s:py_term_loaded=1
    call s:py_core_load()

python << EOF
#{{{dicts
tmclr8_dict = {
               0:"000000",1:"800000",2:"008000",
               3:"808000",4:"000080",5:"800080",
               6:"008080",7:"c0c0c0",
               8:"808080",9:"ff0000",10:"00ff00",
               11:"ffff00",12:"0000ff",13:"ff00ff",
               14:"00ffff",15:"ffffff"
}
tmclr_dict = {
            0:"000000", 1:"000080", 2:"008000",
            3:"008080", 4:"800000", 5:"800080",
            6:"808000", 7:"c0c0c0", 8:"808080",
            9:"ff0000", 10:"00ff00", 11:"00ffff",
            12:"ff0000", 13:"ff00ff", 14:"ffff00",
            15:"ffffff",
            }
#}}}
def hex2term16(hex1): #{{{
    best_match = 0
    dist = 10000000
    r1,g1,b1 =hex2rgb(hex1)
    for c in range(16):
        r2,g2,b2 = hex2rgb(tmclr_dict[c])
        d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < dist:
            dist = d
            best_match = c
    return best_match #}}}
def hex2term8(hex1): #{{{
    best_match = 0
    dist = 10000000
    r1,g1,b1 =hex2rgb(hex1)
    for c in range(16):
        r2,g2,b2 = hex2rgb(tmclr8_dict[c])
        d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < dist:
            dist = d
            best_match = c
    return best_match #}}}

def term_n(x): #{{{
    n_lst = [0,95,135,175,215,255]
    for i in range(1,6):
        if  n_lst[i] >= x and x >= n_lst[i-1]:
            if x-n_lst[i-1] >=  n_lst[i]-x:
                return i
            else:
                return i-1
    return -1 #}}}
def hex2term(hex1): #{{{
    r,g,b=hex2rgb(hex1)
    
    if abs(r-g) <=16 and  abs(g-b) <=16 and abs(r-b) <=16:
        if r<=4:
            t_num = 16
        elif r>= 92 and r<=96:
            t_num = 59
        elif r>= 132 and r<=136:
            t_num = 106
        elif r>= 172 and r<= 176:
            t_num = 145
        elif r>= 212 and r<=216:
            t_num = 188
        elif r>= 247:
            t_num = 231
        else:
            if r%10>= 3:
                div = r/10
            else:
                div = r/10-1
            t_num = div + 232
    else:
        t_num = term_n(r)*36 + term_n(g)*6 + term_n(b) + 16
    return t_num

    #}}}

EOF
endfunction "}}}
function! colorv#hex2term(hex,...) "{{{
" in: hex, a:1 "CHECK"
    if has("python") && g:ColorV_no_python!=1
        call s:py_term_load()
        if exists("a:1")
            if (&t_Co<=8 && a:1==#"CHECK") || a:1==8
                py vim.command("return "+str(hex2term8(vim.eval("a:hex"))))
            elseif (&t_Co<=16 && a:1=="CHECK") || a:1==16
                py vim.command("return "+str(hex2term16(vim.eval("a:hex"))))
            endif
            py vim.command("return "+str(hex2term(vim.eval("a:hex"))))
        endif
    else
        if exists("a:1")
            if (&t_Co<=8 && a:1==#"CHECK") || a:1==8
                return s:v_hex2term8(a:hex)
            elseif (&t_Co<=16 && a:1=="CHECK") || a:1==16
                return s:v_hex2term16(a:hex)
            endif
            return s:hex2term(a:hex)
        endif
    endif
endfunction "}}}

function! s:term_n(x) "{{{
    let n_lst = [0,95,135,175,215,255]
    for i in range(1,5) 
        if  n_lst[i] >= a:x && a:x >= n_lst[i-1]
            if a:x-n_lst[i-1] >=  n_lst[i]-a:x
                return i
            else
                return i-1
            endif
        endif
    endfor
    return -1
endfunction "}}}
function! s:hex2term(hex) "{{{
    let [r,g,b]=colorv#hex2rgb(a:hex)
    if abs(r-g) <=16 &&  abs(g-b) <=16 && abs(r-b) <=16 
        if r<=4 
            let t_num = 16
        elseif r>= 92 && r<=96
            let t_num = 59
        elseif r>= 132 && r<=136
            let t_num = 106
        elseif r>= 172 && r<= 176
            let t_num = 145
        elseif r>= 212 && r<=216
            let t_num = 188
        elseif r>= 247
            let t_num = 231
        else
            let div = r%10>=3 ? r/10 : r/10-1 
            let t_num = div + 232
        endif
    else
        let t_num = s:term_n(r)*36 + s:term_n(g)*6 + s:term_n(b) + 16
    endif
    return t_num
endfunction "}}}
function! s:v_hex2term8(hex) "{{{
    let best_match=0
    let smallest_distance = 100000000
    let [r1,g1,b1] = colorv#hex2rgb(a:hex)
    for c in range(16)
        let [r2,g2,b2] = colorv#hex2rgb(s:term8_dict[c])
        let d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < smallest_distance
            let smallest_distance = d
            let best_match = c
        endif
    endfor
    return best_match
endfunction "}}}
function! s:v_hex2term16(hex) "{{{
    let best_match=0
    let smallest_distance = 100000000
    let [r1,g1,b1] = colorv#hex2rgb(a:hex)
    for c in range(16)
        let [r2,g2,b2] = colorv#hex2rgb(s:term_dict[c])
        let d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < smallest_distance
            let smallest_distance = d
            let best_match = c
        endif
    endfor
    return best_match
endfunction "}}}

"}}}
"DRAW: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:py_draw_load() "{{{
    if exists("s:py_draw_loaded")
        return
    endif
    let s:py_draw_loaded=1
    call s:py_core_load()
python << EOF
def draw_palette(h,height,width): #{{{
    vim.command("call s:clear_match('pal')")
    space = vim.eval("s:space")
    if h>=360:
        h =fmod(h,360)
    elif h<0:
        h = 360-fmod(abs(h),360)
    h_off,w_off=1,0
    pal_clr_list=[]
    cmd_list=[]
    for line in range(1,height+1):
        # L or V.
        if space=="hls":
            v=100.0-(line-1)*100.0/(height+2)
        else:
            v=100.0-(line-1)*100.0/(height)
        if v==0: v=1
        col_list=[]
        for col in range(1,width+1):
            if space=="hls":
                s=90.0-(col-1)*100.0/(width+2)
                if s==0:s=1
                hex=rgb2hex(hls2rgb([h,s,v]))
            else:
                s=100.0-(col-1)*100.0/(width-1)
                if s==0:s=1
                hex=rgb2hex(hsv2rgb([h,s,v]))

            hi_grp="".join(["cv_pal_",hex])
            hi_cmd="".join(["call colorv#hi_color('",hi_grp,"','",hex,"','",hex,"')"])
            cmd_list.append(hi_cmd)
            pos_ptn="".join(["\\%",str(line+h_off),"l\\%",str(col+w_off),"c"])
            match_cmd="".join(["let s:pal_dict['",hi_grp,"']=s:matchadd('",hi_grp,"','",pos_ptn,"')"])
            cmd_list.append(match_cmd)
            col_list.append(hex)
        pal_clr_list.append(col_list)

    for cmd in cmd_list:
        vim.command(cmd)
    vim.command("".join(["let s:pal_clr_list=",str(pal_clr_list)]))
#}}}
def draw_pallete_hex(hex): #{{{
    h,s,v=rgb2hsv(hex2rgb(hex))
    y,x=int(vim.eval("s:pal_H")),int(vim.eval("s:pal_W"))
    draw_palette(h,y,x)
#}}}
EOF
endfunction "}}}

function! s:draw_palette(h,l,c) "{{{
"Input: h,l,c,[loffset,coffset]
    call s:clear_match("pal")
    let [h,height,width]=[a:h,a:l,a:c]
    let h_off=s:poff_y
    let w_off=s:poff_x

    let h = h>=360 ? s:fmod(h,360.0) : h<0 ? 360-s:fmod(abs(h),360.0) : h
    
    let pal_list=[]
    for line in range(1,height)
        if s:space=="hls"
            let v= 100-(line-1)*100.0/(height+2)
        else
            let v= 100-(line-1)*100.0/height
        endif
        let v= v==0 ? 1 : v
        let col_list = []
        for col in range(1,width)
            if s:space=="hls"
                let s=90-(col-1)*100.0/(width+2)
                let s= s==0 ? 1 : s
                let hex=colorv#hls2hex([h,s,v])
            else
                let s=100-(col-1)*100.0/(width-1)
                let s= s==0 ? 1 : s
                let hex=colorv#hsv2hex([h,s,v])
            endif
            let hi_grp="cv_pal_".hex
            let pos_ptn="\\%".(line+h_off)."l\\%".(col+w_off)."c"
            
            call colorv#hi_color(hi_grp,hex,hex)
            let s:pal_dict[hi_grp]=s:matchadd(hi_grp,pos_ptn)
            call add(col_list,hex)
        endfor
        call add(pal_list,col_list)
    endfor
    let s:pal_clr_list = pal_list
endfunction
"}}}
function! s:draw_palette_hex(hex,...) "{{{
    if has("python") && g:ColorV_no_python!=1
        call s:py_draw_load()
        py draw_pallete_hex(vim.eval("a:hex"))
    else
        let [h,s,v]=colorv#hex2hsv(a:hex)
        let g:ColorV.HSV.H=h
        if exists("a:1") && len(a:1) == 2
            call s:draw_palette(h,
                        \a:1[0],a:1[1])
        else
            call s:draw_palette(h,
                        \s:pal_H,s:pal_W)
        endif
    endif
endfunction "}}}
function! s:draw_multi_rect(rect,hex_list) "{{{
"Input: rectangle[x,y,w,h] hex_list[ffffff,ffffff]
    let [x,y,w,h]=a:rect
    let rect_hex_list=a:hex_list

    for idx in range(len(rect_hex_list))
        let hex=rect_hex_list[idx]
        let hi_grp="cv_rct".rect_hex_list[idx]
        let rect_ptn="\\%>".(x+w*idx-1)."c\\%<".(x+w*(idx+1)).
                    \"c\\%>".(y-1)."l\\%<".(y+h)."l"
        call colorv#hi_color(hi_grp,hex,hex)
        let s:rect_dict[hi_grp]=s:matchadd(hi_grp,rect_ptn)
    endfor
endfunction "}}}
function! s:draw_history_set(hex) "{{{
    let hex= s:fmt_hex(a:hex)
    let len=len(s:his_set_list)
    let s:his_color2= len >2 ? s:his_set_list[len-3] : 'ffffff'
    let s:his_color1= len >1 ? s:his_set_list[len-2] : 'ffffff'
    let s:his_color0= len >0 ? s:his_set_list[len-1] : hex
    call s:draw_multi_rect(s:his_set_rect,[s:his_color0,s:his_color1,s:his_color2])
endfunction "}}}
function! s:draw_history_copy() "{{{
    let len=len(s:his_cpd_list)
    let clr_list=[]
    for i in range(18)
        if &background=="light"
            let t="333333"
        else
            let t="AAAAAA"
        endif
        let cpd_color= len>i ? s:his_cpd_list[-1-i] : t
        call add(clr_list,cpd_color)
    endfor
    call s:draw_multi_rect(s:his_cpd_rect,clr_list)
endfunction "}}}

function! s:draw_hueline(l,...) "{{{
    call s:clear_match("hsv")

    let width=exists("a:1") ? a:1 : s:pal_W
    let step=exists("a:2") ? a:2 : 360/20

    if g:ColorV.HSV.S==0
        let h = !exists("s:prv_H") ? 0 : s:prv_H
    else
        let s:prv_H = g:ColorV.HSV.H
        let h = s:prv_H
    endif

    " show hue color in the center
    if s:space=="hls" && s:mode !="min"
        let step = 8
        let h += 36*step
    endif
    let [s,v] =[100,100]

    let l=a:l
    
    let hue_list=[]
    for x in range(width)
        let hi_grp="cv_hue_".x
        " echom h s v
        let hex=colorv#hsv2hex([h,s,v])
        let pos="\\%".l."l\\%".(x+1+s:poff_x)."c"

        call colorv#hi_color(hi_grp,hex,hex)
        let s:hsv_dict[hi_grp]=s:matchadd(hi_grp,pos)
        call add(hue_list,hex)
        let h+=step
    endfor
    let s:hueline_list = hue_list
endfunction "}}}
function! s:draw_satline(l,...) "{{{
    if g:ColorV.HSV.S==0
        let h=!exists("s:prv_H") ? 0 : s:prv_H
    else
        let h =g:ColorV.HSV.H
    endif
    let [s,v] =[100,100]

    let l=a:l
    let width=exists("a:1") ? a:1 : s:pal_W
    let step=exists("a:2") ? a:2 : exists("a:1") ?
                \( a:1 != 0 ? (100/a:1) : 5 ) : 5
    let sat_list=[]
    for col in range(width)
        let s =  100 - col * step
        let s = s<=0 ? 1 : s
        let hi_grp="cv_sat_".col
        let hex=colorv#hsv2hex([h,s,v])
        let pos="\\%".l."l\\%".(col+1+s:poff_x)."c"

        call colorv#hi_color(hi_grp,hex,hex)
        let s:hsv_dict[hi_grp]=s:matchadd(hi_grp,pos)
        call add(sat_list,hex)

    endfor
    let s:satline_list=sat_list
endfunction "}}}
function! s:draw_valline(l,...) "{{{
    if g:ColorV.HSV.S==0
        let h=!exists("s:prv_H") ? 0 : s:prv_H
        let s=!exists("s:prv_S") ? 100 : s:prv_S
    else
        let s:prv_S= g:ColorV.HSV.S
        let h =g:ColorV.HSV.H
        let s =s:prv_S
    endif

    let v=100
    let l=a:l
    let width=exists("a:1") ? a:1 : s:pal_W
    let step= 100.0/(width-1)
    let val_list = []
    for col in range(width)
        let v=100.0-col*step
        let v = v<=0 ? 0 : v

        let hi_grp="cv_val_".col
        if s:space=="hls"
            let hex=colorv#rgb2hex(colorv#hls2rgb([h,v,s]))
        else
            let hex=colorv#hsv2hex([h,s,v])
        endif

        let pos="\\%".l."l\\%".(col+1+s:poff_x)."c"

        call colorv#hi_color(hi_grp,hex,hex)
        let s:hsv_dict[hi_grp]=s:matchadd(hi_grp,pos)

        call add(val_list,hex)
    endfor
    let s:valline_list=val_list
endfunction "}}}

function! colorv#hi_color(hl_grp,hl_fg,hl_bg,...) "{{{
    let [hl_grp,hl_fg,hl_bg]=[a:hl_grp,a:hl_fg,a:hl_bg]
    if has("gui_running")
        let hl_fg = hl_fg=~ '^\x\{6}$' ? "#".hl_fg : hl_fg
        let hl_bg = hl_bg=~ '^\x\{6}$' ? "#".hl_bg : hl_bg
        if exists("a:1")
            let hl_fmt=" gui=".a:1
        else
            let hl_fmt=""
        endif
        let hl_fg = hl_fg=="" ? "" : " guifg=".hl_fg
        let hl_bg = hl_bg=="" ? "" : " guibg=".hl_bg
    else
        if hl_fg=~'\x\{6}'
            let hl_fg=colorv#hex2term(hl_fg,"CHECK")
        endif
        if hl_bg=~'\x\{6}'
            let hl_bg=colorv#hex2term(hl_bg,"CHECK")
        endif
        let aa_txt = exists("a:1") ? ",".a:1 : ""
        let na_txt = exists("a:1") ? " cterm=".a:1 : ""
        if &t_Co==8
            if hl_fg >=8
                let hl_fmt=" cterm=bold,".aa_txt
                let hl_fg-=8
            else
                let hl_fmt=na_txt
            endif
            if hl_bg>=8
                let hl_bg-=8
            endif
        else
            let hl_fmt=na_txt
        endif
        let hl_fg = string(hl_fg)=="" ? "" : " ctermfg=".hl_fg
        let hl_bg = string(hl_bg)=="" ? "" : " ctermbg=".hl_bg
    endif
    try
        exec "hi ".hl_grp.hl_fg.hl_bg.hl_fmt
    catch /^Vim\%((\a\+)\)\=:E/	 
        call s:debug("hi ".v:exception)
    endtry
endfunction "}}}
function! s:hi_link(from,to) "{{{
    exe "hi link ". a:from . " " . a:to
endfunction "}}}
function! s:update_his_set(hex) "{{{
    let hex= s:fmt_hex(a:hex)
    " update history_set

    if exists("s:skip_his_block") && s:skip_his_block==1
        let s:skip_his_block=0
    else
        if get(s:his_set_list,-1)!=hex
            call add(s:his_set_list,hex)
        endif
    endif
endfunction "}}}
function! s:update_global(hex) "{{{
    let hex= s:fmt_hex(a:hex)
    let g:ColorV.HEX=hex
    let [r,g,b]= colorv#hex2rgb(hex)
    let [h,s,v]= colorv#rgb2hsv([r,g,b])
    let [H,L,S]= colorv#rgb2hls([r,g,b])
    let [Y,I,Q]= colorv#rgb2yiq([r,g,b])
    let g:ColorV.NAME=s:hex2nam(hex)
    let [g:ColorV.RGB.R,g:ColorV.RGB.G,g:ColorV.RGB.B] =[r,g,b]
    let [g:ColorV.HSV.H,g:ColorV.HSV.S,g:ColorV.HSV.V] =[h,s,v]
    let [g:ColorV.HLS.H,g:ColorV.HLS.S,g:ColorV.HLS.L] =[H,L,S]
    let [g:ColorV.YIQ.Y,g:ColorV.YIQ.I,g:ColorV.YIQ.Q] =[Y,I,Q]
    let g:ColorV.rgb=[r,g,b]
    let g:ColorV.hsv=[h,s,v]
    let g:ColorV.hls=[H,L,S]
    let g:ColorV.hsl=[H,S,L]
    let g:ColorV.yiq=[Y,I,Q]
    
    " update callback
    if exists("s:update_call") && s:update_call ==1 && exists("s:update_func")
        if exists("s:update_arg")
            call call(s:update_func,s:update_arg)
        else
            call call(s:update_func,[])
        endif
        " BACK to COLORV window
        if !s:go_buffer_win(g:ColorV.name)
            call s:error("ColorV window.NO update_call")
            if exists("s:update_call")
                unlet s:update_call
                unlet s:update_func
                if exists("s:update_arg")
                    unlet s:update_arg
                endif
            endif
            return -1
        endif
    endif
endfunction "}}}
function! s:hi_misc() "{{{
    call s:clear_match("misc")

    let [l,c]=s:get_star_pos()
    if s:mode=="min"
        let bg= s:space == "hls" ? s:satline_list[c-1] 
                    \ : s:valline_list[c-1]
    else
        let bg=s:pal_clr_list[l-s:poff_y-1][c-s:poff_x-1]
    endif
    let fg= s:rlt_clr(bg)
    call colorv#hi_color("cv_star",fg,bg,"Bold")
    let star_ptn='\%<'.(s:pal_H+1+s:poff_y).'l\%<'.
                \(s:pal_W+1+s:poff_x).'c\*'
    let s:misc_dict["cv_star"]=s:matchadd("cv_star",star_ptn,40)

    if s:mode=="min"
        let [l,c]=s:get_bar_pos()
        let bg= s:space == "hls" ? s:valline_list[c-1] 
                    \ : s:satline_list[c-1]
        let fg= s:rlt_clr(bg)

        let bar_ptn='\%2l\%<'.
                    \(s:pal_W+1+s:poff_x).'c+'
        call colorv#hi_color("cv_plus",fg,bg,"Bold")
        let s:misc_dict["cv_plus"]=s:matchadd("cv_plus",bar_ptn,20)
    endif

    " tip text highlight
    if s:mode!="min"
        let tip_ptn='\%'.(s:pal_H+1).'l\%>21c\%<60c'
        call s:hi_link("cv_tip","SpecialComment")
        let s:misc_dict["cv_tip"]=s:matchadd("cv_tip",tip_ptn)
        let stat_ptn='\%'.(s:pal_H+1).'l\%>'.(s:stat_pos-1).'c\%<60c[mMYHVL]'
        call s:hi_link("cv_stat","Title")
        let s:misc_dict["cv_stat"]=s:matchadd("cv_stat",stat_ptn,25)
    endif
endfunction "}}}

function! s:draw_text(...) "{{{
    let cur=s:clear_text()
    let cv = g:ColorV
    let hex= cv.HEX
    let [r,g,b]= s:printf("%3d",cv.rgb)
    let [h,s,v]= s:printf("%3d",cv.hsv)
    let [H,L,S]= s:printf("%3d",cv.hls)
    let [Y,I,Q]= s:printf("%3d",s:number(cv.yiq))

    let height = s:mode=="max" ? s:max_h : s:mode=="mid" ? s:mid_h :
                \ s:min_h

    let line=[]
    for i in range(height)
        let m=repeat(' ',s:line_width)
        call add(line,m)
    endfor

    " para and help, stat:
    let help_txt = "?:tips yy:yank g1:list H:help  "
    
    let stat_g = g:ColorV_gen_space==?"hsv" ? "H" : "Y"
    let stat_w = g:ColorV_win_space==?"hsv" ? "V" : "L"
    let stat_m = s:mode=="max" ? "M" : s:mode=="mid" ? "m" : "-"
    let stat_txt = stat_g." ".stat_w." ".stat_m
    if s:mode=="max"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"Hex:".hex,22)
        let line[1]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[2]=s:line("H:".h."  S:".s."  V:".v,22)
        let line[3]=s:line("H:".H."  L:".L."  S:".S,22)
        let line[4]=s:line("Y:".Y."  I:".I."  Q:".Q,22)
        let line[8]=s:line(help_txt,22)
        let line[8]=s:line_sub(line[8],stat_txt,s:stat_pos)
    elseif s:mode=="mid"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[1]=s:line("Hex:".hex,22)
        let line[2]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[3]=s:line("H:".h."  S:".s."  V:".v,22)
        let line[4]=s:line("H:".H."  L:".L."  S:".S,22)
        let line[5]=s:line(help_txt,22)
        let line[5]=s:line_sub(line[5],stat_txt,s:stat_pos)
    elseif s:mode=="min"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"Hex:".hex,22)
        let line[1]=s:line("R:".r."  G:".g."  B:".b,22)
        if s:space=="hls"
            let line[2]=s:line("H:".H."  L:".L."  S:".S,22)
        else
            let line[2]=s:line("H:".h."  S:".s."  V:".v,22)
        endif
        let line[2]=s:line_sub(line[2],stat_txt,s:stat_pos)
    endif

    " colorname
    let nam=g:ColorV.NAME
    if !empty(nam)
        if s:mode=="min"
        let line[0]=s:line_sub(line[0],nam,43)
        else
        let line[0]=s:line_sub(line[0],nam,43)
        endif
    endif

    " hello world
    let [h1,h2,h3]=[s:his_color0,s:his_color1,s:his_color2]
    for [x,y,z,t] in s:clrf
        " slow?
        if s:approx2(h1,x) && s:approx2(h2,y) && s:approx2(h3,z)
            let [t,a]=[tr(t,s:t,s:e),tr(s:a,s:t,s:e)]
            if s:mode=="min"
                let line[1]=s:line_sub(line[1],t,43)
                let line[2]=s:line_sub(line[2],a,43)
            else
                let line[2]=s:line_sub(line[2],t,43)
                let line[4]=s:line_sub(line[4],a,43)
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

    "draw BAR for saturation
    if s:mode=="min"
        for i in range(height)
            let line[i]=substitute(line[i],'+',' ','g')
        endfor
        let [l,c]=s:get_bar_pos()
        let line[l-1]=s:line_sub(line[l-1],"+",c)
    endif

    setl ma
    for i in range(height)
        call setline(i+1,line[i])
    endfor
    setl noma

    "put cursor back
    call setpos('.',cur)

endfunction "}}}
function! s:get_bar_pos() "{{{
    let HSV=g:ColorV.HSV
    let HLS=g:ColorV.HLS
    let [h,s,v]=[HSV.H,HSV.S,HSV.V]
    let [H,L,S]=[HLS.H,HLS.L,HLS.S]
    if s:mode=="min"
        let l=2
        let w_step=100.0/(s:pal_W-1)
        if s:space=="hls"
            let c=float2nr(round((100.0-S)/w_step))+1+s:poff_x
        else
            let c=float2nr(round((100.0-s)/w_step))+1+s:poff_x
        endif
        if c>=s:pal_W+s:poff_x
            let c= s:pal_W+s:poff_x
        endif
        return [l,c]
    endif

endfunction "}}}
function! s:get_star_pos() "{{{
    let HSV=g:ColorV.HSV
    let HLS=g:ColorV.HLS
    let [h,s,v]=[HSV.H,HSV.S,HSV.V]
    let [H,L,S]=[HLS.H,HLS.L,HLS.S]

    if s:mode=="max" || s:mode=="mid"
        let h_step=100.0/(s:pal_H)
        let w_step=100.0/(s:pal_W-1)
        if s:space=="hls"
            let l=float2nr(round((100.0-L)/100.0*(s:pal_H+2)))+1+s:poff_y
            let c=float2nr(round((90.0-S)/100.0*(s:pal_W+2)))+1+s:poff_x
        else
            let l=float2nr(round((100.0-v)/h_step))+1+s:poff_y
            let c=float2nr(round((100.0-s)/w_step))+1+s:poff_x
        endif
        if l>=s:pal_H+s:poff_y
            let l= s:pal_H+s:poff_y
        endif
        if c>=s:pal_W+s:poff_x
            let c= s:pal_W+s:poff_x
        endif

    elseif s:mode=="min"
        let l=3
        let w_step=100.0/(s:pal_W-1)
        if s:space=="hls"
            let c=float2nr(round((100.0-L)/w_step))+1+s:poff_x
        else
            let c=float2nr(round((100.0-v)/w_step))+1+s:poff_x
        endif
        if c>=s:pal_W+s:poff_x
            let c= s:pal_W+s:poff_x
        endif
    endif
    return [l,c]
endfunction "}}}
function! s:clear_text() "{{{
    if !s:check_win('_ColorV_')
        call s:error("Not [ColorV] buffer.")
        return
    endif
    let cur=getpos('.')
    " silent! normal! ggVG"_x
    silent %delete _
    return cur
endfunction "}}}
function! s:line(text,pos) "{{{
"return text in blank line
    let suf_len= s:line_width-a:pos-len(a:text)+1
    let suf_len= suf_len <= 0 ? 1 : suf_len
    return repeat(' ',a:pos-1).a:text.repeat(' ',suf_len)
endfunction "}}}
function! s:line_sub(line,text,pos) "{{{
"return substitute line at pos in input line
"could not use doublewidth text
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

function! s:clear_match(c) "{{{
    for [key,var] in items(s:{a:c}_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:{a:c}_dict,key)
        catch /^Vim\%((\a\+)\)\=:E/
            call s:debug("E:".v:exception)
            continue
        endtry
    endfor
    let s:{a:c}_dict={}
endfunction "}}}

"}}}
"WINS: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorv#win(...) "{{{
    call s:open_win(g:ColorV.name)
    call s:win_setl()
    setl ft=ColorV
    call s:map_define()
    "{{{ get hex
    if exists("a:2")
        "skip history if no new hex
        let hex_list=s:txt2hex(a:2)
        if exists("hex_list[0][0]")
            let hex=s:fmt_hex(hex_list[0][0])
            call s:echo("Use [".hex."]")
        else
            let hex = exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
            let s:skip_his_block=1
            call s:echo("Use default [".hex."]")
        endif
    else
        let hex = exists("g:ColorV.HEX") ? g:ColorV.HEX : "ff0000"
        let s:skip_his_block=1
    endif "}}}
    " init mode"{{{
    if g:ColorV_win_space==?"hls" || g:ColorV_win_space==?"hsl"
        let s:space="hls"
    else
        let s:space="hsv"
    endif
    if exists("a:1") && a:1== "min"
        let s:mode="min"
    elseif  exists("a:1") && a:1== "max"
        let s:mode="max"
    elseif  exists("a:1") && a:1== "mid"
        let s:mode="mid"
    else
        if !exists("s:mode")
            let s:mode="mid"
        endif
    endif
    if s:mode=="min"
        let s:pal_H=s:min_h-1
    elseif s:mode=="max"
        let s:pal_H=s:max_h-1
    else
        let s:pal_H=s:mid_h-1
    endif
    "}}}
    "_funcs "{{{
    if exists("a:3") && a:3==1 && exists("a:4")
        let s:exit_call =1
        let s:exit_func =a:4
        if exists("a:5")
            let s:exit_arg =a:5
        endif
        " use update should toggle window
    elseif exists("a:3") && a:3==2 && exists("a:4")
        let s:update_call =1
        let s:update_func =a:4
        if exists("a:5")
            let s:update_arg =a:5
        endif
    endif
    "}}}
    call s:draw_win(hex)
    call s:aug_init()
endfunction "}}}
function! s:open_win(name,...) "{{{
    let spLoc= g:ColorV_win_pos == "top" ? "topleft " : "botright "
    let spSize= exists("a:1") && a:1 =="v" ? 29 :s:pal_H+1
    let spDirc= exists("a:1") && a:1 =="v" ? "v" : ""
    let exists_buffer= bufnr(a:name)
    if exists_buffer== -1
        silent! exec spLoc .' '.spSize.spDirc.'new '. a:name
    else
        let exists_window = bufwinnr(exists_buffer)
        if exists_window != -1
            if winnr() != exists_window
                silent! exe exists_window . "wincmd w"
            endif
        else
            call s:go_buffer_win(a:name)
            silent! exe spLoc ." ".spSize.spDirc."split +buffer" . exists_buffer
        endif
    endif
endfunction "}}}
function! s:go_buffer_win(name) "{{{
    if bufwinnr(bufnr(a:name)) != -1
        exe bufwinnr(bufnr(a:name)) . "wincmd w"
        return 1
    else
        return 0
    endif
endfunction "}}}
function! s:win_setl() "{{{
    " local setting
    setl buftype=nofile
    setl winfixwidth
    setl nocursorline nocursorcolumn
    setl bufhidden=delete
    setl nolist
    setl noswapfile
    setl nobuflisted
    setl nowrap
    setl nofoldenable
    setl nomodeline
    setl nonumber
    setl noea
    setl tw=0
    setl foldcolumn=0
    setl sidescrolloff=0
    if v:version >= 703
        setl cc=
    endif
endfunction "}}}
function! s:check_win(name) "{{{
    if bufnr('%') != bufnr(a:name)
        return 0
    else
        return 1
    endif
endfunction "}}}
function! s:draw_win(hex) "{{{
    if !s:check_win('_ColorV_')
        call s:error("Not [ColorV] buffer.")
        return
    endif

    let hex= s:fmt_hex(a:hex)

    setl ma
    setl lz
    if g:ColorV_debug==1 "{{{
        call colorv#timer("s:update_his_set",[hex])
        call colorv#timer("s:update_global",[hex])
        call colorv#timer("s:draw_hueline",[1])

        if s:mode == "min"
            if s:space == "hls"
                call colorv#timer("s:draw_satline",[3])
                call colorv#timer("s:draw_valline",[2])
            else
                call colorv#timer("s:draw_satline",[2])
                call colorv#timer("s:draw_valline",[3])
            endif
            let l:win_h=s:min_h
        else
            call colorv#timer("s:clear_match",["rect"])
            if s:mode == "max"
                call colorv#timer("s:draw_history_copy")
            endif
            if g:ColorV.HSV.S==0
                let prv_hex= !exists("s:prv_hex") ? "ff0000" : s:prv_hex
                call colorv#timer("s:draw_palette_hex",[prv_hex])
            else
                let s:prv_hex= hex
                call colorv#timer("s:draw_palette_hex",[hex])
            endif
            if s:mode == "max"
                let l:win_h=s:max_h
            else
                let l:win_h=s:mid_h
            endif
        endif

        call colorv#timer("s:hi_misc")
        call colorv#timer("s:draw_history_set",[hex])
        call colorv#timer("s:draw_text")
        "}}}
    else "{{{
        call s:update_his_set(hex)
        call s:update_global(hex)
        call s:draw_hueline(1)

        if s:mode == "min"
            if s:space =="hls"
                call s:draw_satline(3)
                call s:draw_valline(2)
            else
                call s:draw_satline(2)
                call s:draw_valline(3)
            endif
            let l:win_h=s:min_h
        else
            call s:clear_match("rect")
            if s:mode == "max"
                call s:draw_history_copy()
            endif
            if g:ColorV.HSV.S==0
                let prv_hex= !exists("s:prv_hex") ? "ff0000" : s:prv_hex
                call s:draw_palette_hex(prv_hex)
            else
                let s:prv_hex= hex
                call s:draw_palette_hex(hex)
            endif
            if s:mode == "max"
                let l:win_h=s:max_h
            else
                let l:win_h=s:mid_h
            endif
        endif

        call s:hi_misc()
        call s:draw_history_set(hex)
        call s:draw_text()
    endif "}}}
    if winnr('$') != 1
        execute 'resize' l:win_h
        redraw
    endif
    setl nolz
    setl noma
endfunction "}}}
function! s:aug_init() "{{{
    aug colorV_hide
        au!
        autocmd CursorMoved,CursorMovedI <buffer>  call s:on_cursor_moved()
    aug END
endfun
"}}}
function! s:map_define() "{{{

    let t = ["<C-j>","<C-k>","<CR>","<KEnter>","<Space>"
                \,"<Space><Space>","<2-Leftmouse>","<3-Leftmouse>"]

    let m_txt = "nmap <silent><buffer> "
    let c_txt = " :call <SID>set_in_pos()<CR>"
    
    for m in t
        exe m_txt.m.c_txt
    endfor

    nmap <silent><buffer> <tab> W
    nmap <silent><buffer> <S-tab> B

    "edit
    nmap <silent><buffer> = :call <SID>edit_at_cursor("+")<cr>
    nmap <silent><buffer> + :call <SID>edit_at_cursor("+")<cr>
    nmap <silent><buffer> <ScrollWheelUp> :call <SID>edit_at_cursor("+")<cr>
    nmap <silent><buffer> - :call <SID>edit_at_cursor("-")<cr>
    nmap <silent><buffer> _ :call <SID>edit_at_cursor("-")<cr>
    nmap <silent><buffer> <ScrollWheelDown> :call <SID>edit_at_cursor("-")<cr>

    "edit name
    nmap <silent><buffer> na :call <SID>input_colorname()<cr>
    nmap <silent><buffer> ne :call <SID>input_colorname()<cr>
    nmap <silent><buffer> nx :call <SID>input_colorname("X11")<cr>

    " WONTFIX:quick quit without wait for next key after q
    nmap <silent><buffer> m :call <SID>mode_toggle()<cr>
    nmap <silent><buffer> M :call <SID>mode_toggle()<cr>
    nmap <silent><buffer> q :call colorv#exit()<cr>
    nmap <silent><buffer> Q :call colorv#exit()<cr>
    nmap <silent><buffer> <c-w>q :call colorv#exit()<cr>
    nmap <silent><buffer> <c-w><c-q> :call colorv#exit()<cr>
    nmap <silent><buffer> ? :call <SID>echo_tips()<cr>
    nmap <silent><buffer> H :h colorv-quickstart<cr>
    nmap <silent><buffer> <F1> :h colorv-quickstart<cr>

    "Copy color
    map <silent><buffer> C :call <SID>copy("HEX","+")<cr>
    map <silent><buffer> cc :call <SID>copy("HEX","+")<cr>
    map <silent><buffer> cx :call <SID>copy("HEX0","+")<cr>
    map <silent><buffer> cs :call <SID>copy("NS6","+")<cr>
    map <silent><buffer> c# :call <SID>copy("NS5","+")<cr>
    map <silent><buffer> cr :call <SID>copy("RGB","+")<cr>
    map <silent><buffer> cp :call <SID>copy("RGBP","+")<cr>
    map <silent><buffer> caa :call <SID>copy("RGBA","+")<cr>
    map <silent><buffer> cap :call <SID>copy("RGBAP","+")<cr>
    map <silent><buffer> cn :call <SID>copy("NAME","+")<cr>
    map <silent><buffer> ch :call <SID>copy("HSV","+")<cr>
    map <silent><buffer> cl :call <SID>copy("HSL","+")<cr>
    map <silent><buffer> cm :call <SID>copy("CMYK","+")<cr>

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
    map <silent><buffer> yl :call <SID>copy("HSL")<cr>
    map <silent><buffer> ym :call <SID>copy("CMYK")<cr>

    "paste color
    map <silent><buffer> <c-v> :call <SID>paste("+")<cr>
    map <silent><buffer> p :call <SID>paste()<cr>
    map <silent><buffer> P :call <SID>paste()<cr>
    map <silent><buffer> <middlemouse> :call <SID>paste("+")<cr>

    "generator with current color
    nmap <silent><buffer> gh :call colorv#gen_win(g:ColorV.HEX,"Hue",20,15)<cr>
    nmap <silent><buffer> g1 :call colorv#gen_win(g:ColorV.HEX,"Hue",20,15)<cr>
    nmap <silent><buffer> gs :call colorv#gen_win(g:ColorV.HEX,"Saturation",20,5,1)<cr>
    nmap <silent><buffer> gv :call colorv#gen_win(g:ColorV.HEX,"Value",20,5,1)<cr>
    nmap <silent><buffer> ga :call colorv#gen_win(g:ColorV.HEX,"Analogous")<cr>
    nmap <silent><buffer> gq :call colorv#gen_win(g:ColorV.HEX,"Square")<cr>
    nmap <silent><buffer> gn :call colorv#gen_win(g:ColorV.HEX,"Neutral")<cr>
    nmap <silent><buffer> gc :call colorv#gen_win(g:ColorV.HEX,"Clash")<cr>
    nmap <silent><buffer> gp :call colorv#gen_win(g:ColorV.HEX,"Split-Complementary")<cr>
    nmap <silent><buffer> gm :call colorv#gen_win(g:ColorV.HEX,"Monochromatic")<cr>
    nmap <silent><buffer> g2 :call colorv#gen_win(g:ColorV.HEX,"Complementary")<cr>
    nmap <silent><buffer> gt :call colorv#gen_win(g:ColorV.HEX,"Triadic")<cr>
    nmap <silent><buffer> g3 :call colorv#gen_win(g:ColorV.HEX,"Triadic")<cr>
    nmap <silent><buffer> g4 :call colorv#gen_win(g:ColorV.HEX,"Tetradic")<cr>
    nmap <silent><buffer> g5 :call colorv#gen_win(g:ColorV.HEX,"Five-Tone")<cr>
    nmap <silent><buffer> g6 :call colorv#gen_win(g:ColorV.HEX,"Six-Tone")<cr>

    "easy moving
    noremap <silent><buffer>j gj
    noremap <silent><buffer>k gk

endfunction "}}}
function! s:on_cursor_moved() "{{{
    let [l,c] = getpos('.')[1:2]
    let pos_list = s:mode=="max" ? s:max_pos :
                \ s:mode=="min" ? s:min_pos : s:mid_pos
    for [str,line,column,length] in pos_list
        if l==line && c>=column && c<column+length
            execute '2match' "ErrorMsg".' /\%'.(line)
                        \.'l\%>'.(column-1)
                        \.'c\%<'.(column+length).'c/'
            return
        endif
    endfor
    execute '2match ' "none"
endfunction "}}}

function! s:exec(cmd) "{{{
    let old_ei = &ei
    set ei=all
    exec a:cmd
    let &ei = old_ei
endfunction "}}}

function! colorv#exit_list_win() "{{{
    if s:go_buffer_win(g:ColorV.listname)
        close
    endif
endfunction "}}}
function! colorv#exit() "{{{
    if s:go_buffer_win(g:ColorV.name)
        close
    else
        return -1
    endif

    "_call "{{{
    if exists("s:exit_call") && s:exit_call ==1 && exists("s:exit_func")
        if exists("s:exit_arg")
            call call(s:exit_func,s:exit_arg)
            unlet s:exit_arg
        else
            call call(s:exit_func,[])
        endif
        unlet s:exit_call
        unlet s:exit_func
    endif

    if exists("s:update_call")
        if exists("s:update_arg")
            unlet s:update_arg
        endif
        unlet s:update_call
        unlet s:update_func
    endif
    "}}}
endfunction "}}}
function! colorv#dropper() "{{{
    "terminal error?
    if !has("gui_running")
        call s:error("pygtk have Error in Terminal. So not Supported.")
        return
    endif
    if !has("python")
        call s:error("Only support vim compiled with python.")
        return
    endif
    call s:caution("pyGTK ColorPicker:")
    call s:py_core_load()
    call s:warning("Select a color and press OK to Return to Vim.")
python << EOF
try:
    import gtk
    import pygtk
    pygtk.require('2.0')
except ImportError:
    vim.command("call s:error('Python:Could not find gtk or pygtk module.Stop using dropper.')")
    gtk=None

if gtk:
    color_dlg = gtk.ColorSelectionDialog("[ColorV] Pygtk colorpicker")
    c_set = gtk.gdk.color_parse("#"+vim.eval("g:ColorV.HEX"))
    color_dlg.colorsel.set_current_color(c_set)

    if color_dlg.run() == gtk.RESPONSE_OK:
        clr = color_dlg.colorsel.get_current_color()
        c_hex = rgb2hex([clr.red/257,clr.green/257,clr.blue/257])
        vim.command("ColorV "+c_hex)

    color_dlg.destroy()
EOF
endfunction "}}}

"}}}
"MATH: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:fmod(x,y) "{{{
    "no fmod() in 702
    if v:version < 703
        if a:y == 0
            let tmp = 0
        else
            let tmp = a:x - a:y * floor(a:x/a:y)
        endif
            return tmp
    else
        return fmod(s:float(a:x),s:float(a:y))
    endif

endfunction "}}}
function! s:number(x) "{{{
" return a num or a num list
    if type(a:x) == type([])
        if !empty(a:x)
            let x=[]
            for i in a:x
                call add(x,s:number(i))
            endfor
            return x
        else
            call s:error("Empty List for s:number()")
            return 0
        endif
    elseif type(a:x) == type({})
        if !empty(a:x)
            let x=[]
            for i in values(a:x)
                call add(x,s:number(i))
            endfor
            return x
        else
            call s:error("Empty Dict for s:number()")
            return 0
        endif
    elseif  type(a:x) == type(function("tr"))
        return 0
    elseif type(a:x) == type("")
        return str2nr(a:x)
    elseif  type(a:x) == type(0.0)
        return float2nr(a:x)
    elseif  type(a:x) == type(0)
        return a:x
    endif
endfunction "}}}
function! s:float(x) "{{{
    if type(a:x) == type([])
        if !empty(a:x)
            let x=[]
            for i in a:x
                call add(x,s:float(i))
            endfor
            return x
        else
            call s:error("Empty List for s:float()")
            return 0.0
        endif
    elseif type(a:x) == type({})
        if !empty(a:x)
            let x=[]
            for i in values(a:x)
                call add(x,s:float(i))
            endfor
            return x
        else
            call s:error("Empty Dict for s:float()")
            return 0.0
        endif
    elseif  type(a:x) == type(function("tr"))
        return 0.0
    elseif type(a:x) == type("")
        return str2float(a:x)
    elseif  type(a:x) == type(0.0)
        return a:x
    elseif  type(a:x) == type(0)
        return a:x+0.0
    endif
endfunction "}}}
function! s:fmax(list) "{{{
    let list=a:list
    if len(list) == 0
        return 0
    endif
    let tmp=list[0]
    for i in list
        if i > tmp
            let tmp = i
        endif
    endfor
    return tmp
endfunction "}}}
function! s:fmin(list) "{{{
    let list=a:list
    if len(list) == 0
        return 0
    endif
    let tmp=list[0]
    for i in list
        if i < tmp
            let tmp = i
        endif
    endfor
    return tmp
endfunction "}}}
function! s:degrees(radian) "{{{
    return a:radian * 180 / 3.1415926
endfunction "}}}
function! s:radians(degree) "{{{
    return a:degree / 180 * 3.1415926
endfunction "}}}
function! s:random(min,max) "{{{
    let init= str2nr(strftime("%S%m"))*9+
             \str2nr(strftime("%Y"))*3+
             \str2nr(strftime("%M%S"))*5+
             \str2nr(strftime("%H%d"))*1+19
    let s:seed=exists("s:seed") ? s:seed : init
    let s:seed=s:fmod((20907*s:seed+17343),104530)
    return s:fmod(s:seed,a:max-a:min+1)+a:min
endfunction "}}}
"1}}}
"HELP: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:matchadd(grp,ptn,...) "{{{
    try
        if exists("a:1") && !empty(a:1)
            let c = matchadd(a:grp,a:ptn,a:1)
        else
            let c = matchadd(a:grp,a:ptn)
        endif
    catch /^Vim\%((\a\+)\)\=:E/	" catch all Vim errors
            let c = 0
    endtry
    return c
endfunction "}}}
function! s:fmt_hex(hex) "{{{
" return "FFFFFF" and return "000000" for invalid hex.
   let hex = a:hex
   if hex=~ '#'
       let hex=substitute(hex,"#",'','')
   endif
   if hex=~ '0x'
       let hex=substitute(hex,'0x','','')
   endif
   if hex=~ '\x\@<!\x\{3}\x\@!'
       let hex=substitute(hex,'.','&&','g')
   endif
   if len(hex) > 6
        call s:error("Formated Hex > ffffff. Truncated")
        let hex = hex[:5]
   endif
   return printf("%06X","0x".hex)
endfunction "}}}
function! s:printf(fmt,s) "{{{
    if type(a:s) == type([])
        if !empty(a:s)
            let s = []
            for i in a:s
                call add(s,s:printf(a:fmt,i))
            endfor
            return s
        else
            call s:error("Empty Dict for s:printf()")
            return ""
        endif
    elseif type(a:s) == type({})
        if !empty(a:s)
            let s=[]
            for i in values(a:s)
                call add(s,s:printf(a:fmt,i))
            endfor
            return s
        else
            call s:error("Empty Dict for s:printf()")
            return ""
        endif
    elseif  type(a:s) == type(function("tr"))
        return ""
    else
        try
            return printf(a:fmt,a:s)
		catch /^Vim\%((\a\+)\)\=:E/	" catch all Vim errors
		    call s:error(v:exception)
        endtry
    endif
endfunction "}}}

function! s:echo_tips() "{{{
    call s:seq_echo(s:tips_list)
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
    let rnd=s:random(0,len(txt_list)-1)
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
        if s:fmod(s:seq_num,len(txt_list)) == idx
            call s:echo(idx.": ".txt)
            break
        endif
        let idx+=1
    endfor
    let s:seq_num+=1
endfunction "}}}

function! s:caution(msg) "{{{
    echohl Modemsg
    redraw
    exe "echon '[Caution]' "
    echohl Normal
    echon " ".escape(a:msg,'"')." "
endfunction "}}}
function! s:warning(msg) "{{{
    echohl Warningmsg
    redraw
    exe "echon '[Warning]' "
    echohl Normal
    echon " ".escape(a:msg,'"')." "
endfunction "}}}
function! s:error(msg) "{{{
    echohl Errormsg
    redraw
    echom "[Error] ".escape(a:msg,'"')
    echohl Normal
endfunction "}}}
function! s:echo(msg) "{{{
    try
        echohl Comment
        redraw
        exe "echon '[Note]' "
        echohl Normal
        exe "echon \" ".escape(a:msg,'"')."\""
    catch /^Vim\%((\a\+)\)\=:E488/
        call s:debug("Trailing character.")
    endtry
endfunction "}}}

function! s:debug(msg) "{{{
    if g:ColorV_debug!=1
        return
    endif
    echohl Errormsg
    echom "[Debug] ".escape(a:msg,'"')
    echohl Normal
endfunction "}}}

function! s:approx2(hex1,hex2,...) "{{{
    let t = exists("a:1") ? a:1 : s:aprx_rate*4
    let [r1,g1,b1] = colorv#hex2rgb(a:hex1)
    let [r2,g2,b2] = colorv#hex2rgb(a:hex2)
    if r2+t>=r1 && r1>=r2-t
            \ && g2+t>=g1 && g1>=g2-t
            \ && b2+t>=b1 && b1>=b2-t
        return 1
    else
        return 0
    endif
endfunction "}}}
function! s:rlt_clr(hex) "{{{
    if has("python") && g:ColorV_no_python!=1
        call s:py_core_load()
python << EOF
y,i,q=rgb2yiq(hex2rgb(vim.eval("a:hex")))
if y >= 30 and y < 50:
    y = 80
elif y >= 50 and y < 70:
    y = 20
elif y>=70 :
    y = 100-y+5
else:
    y = 100-y-5

if i > 0: i -= 10
else: i += 10

if q > 0: q -= 10
else: q += 10
vim.command("return '"+rgb2hex(yiq2rgb([y,i,q]))+"'")
EOF
    else
        let hex=s:fmt_hex(a:hex)
        let [y,i,q]=colorv#hex2yiq(hex)
        if y>=30 && y < 50
            let y = 80
        elseif y >=50 && y < 70
            let y = 20
        elseif y>=70
            let y = 100-y+5
        else
            let y = 100-y-5
        endif
        if i >0
            let i -= 10
        else
            let i += 10
        endif
        if q >0
            let q -= 10
        else
            let q += 10
        endif
        return colorv#yiq2hex([y,i,q])
    endif
endfunction "}}}
function! s:opz_clr(hex) "{{{
    let hex=s:fmt_hex(a:hex)
    let [y,i,q]=colorv#hex2yiq(hex)
    if y>=30 && y < 50
        let y = 70
    elseif y >=50 && y < 70
        let y = 30
    else
        let y = 100-y
    endif
    return colorv#yiq2hex([y,-i,-q])
endfunction "}}}

function! s:time() "{{{
    if has("python")
        py import time
        py import vim
        py vim.command("return "+str(time.time()))
    else
        return localtime()
    endif
endfunction "}}}
function! colorv#timer(func,...) "{{{
    if !exists("*".a:func)
        call s:debug("[TIMER]: ".a:func." does not exists. stopped")
        return
    endif
    let farg = exists("a:1") ? a:1 : []
    let num = exists("a:2") ? a:2 : 1

    let o_t=s:time()

    for i in range(num)
        silent! let rtn=call(a:func,farg)
    endfor

    echom "[TIMER]:" string(s:time()-o_t) "seconds for exec" a:func num "times. "

    return rtn
endfunction "}}}
"}}}
"EDIT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:set_in_pos() "{{{
    let [l,c] = getpos('.')[1:2]

    let clr=g:ColorV
    let hex=clr.HEX
    let [r,g,b]=clr.rgb
    let [h,s,v]=clr.hsv
    let [H,L,S]=clr.hls
    let s= s==0 ? 1 : s
    let v= v==0 ? 1 : v
    let S= S==0 ? 1 : S
    let L= L==0 ? 1 : L==100 ? 99 : L
    let [rs_x,rs_y,rs_w,rs_h]=s:his_set_rect
    let [rc_x,rc_y,rc_w,rc_h]=s:his_cpd_rect

    "pallette "{{{
    if (s:mode=="max" || s:mode=="mid" ) && l > s:poff_y && l<= s:pal_H+s:poff_y && c<= s:pal_W
        let hex=s:pal_clr_list[l-s:poff_y-1][c-s:poff_x-1]
        call s:echo("HEX(Pallet): ".hex)
        call s:draw_win(hex)
    "}}}
     "{{{ hsv line
    elseif l==1 &&  c<=s:pal_W
        "hue line
        let [h1,s1,v1]=colorv#hex2hsv(s:hueline_list[(c-1)])
        call s:echo("Hue(Hue Line): ".h1)
        let hex=colorv#hsv2hex([h1,s,v])
        call s:draw_win(hex)
        return
    elseif s:mode=="min" && (l=~'^[23]$') && ( c<=s:pal_W  )

        if (l==2 && s:space=="hls") 
            let chr = "L"
            let e_txt ="let hex=colorv#hls2hex([H,L,S])"
        elseif (l==2 && s:space=="hsv")
            let chr = "s"
            let e_txt ="let hex=colorv#hsv2hex([h,s,v])"
        elseif (l==3 && s:space=="hls")
            let chr = "S"
            let e_txt ="let hex=colorv#hls2hex([H,L,S])"
        elseif (l==3 && s:space=="hsv")
            let chr = "v"
            let e_txt ="let hex=colorv#hsv2hex([h,s,v])"
        endif
        let h_txt = s:hlp_d[chr][0]

        let {chr}=float2nr(100.0-100.0/(s:pal_W-1.0)*(c-1))
        let {chr}= {chr}==0 ? 1 : {chr}
        call s:echo(h_txt.":".{chr})
        exe e_txt
        call s:draw_win(hex)
        return
        
    "}}}
    "cpd_history section "{{{
    elseif s:mode=="max" && l==rc_y &&  c>=rc_x  && c<=(rc_x+rc_w*18-1)
        for i in range(18)
            if c<rc_x+rc_w*(i+1)
                if len(s:his_cpd_list)>i
                    let hex_h=s:his_cpd_list[-1-i]
                else
                    let hex_h="0"
                endif
                if hex_h!="0"
                    call s:echo("HEX(Copied history ".(i)."): ".hex_h)
                    call s:draw_win(hex_h)
                    return
                else
                    call s:echo("No Copied Color here.")
                    return
                endif
            endif
        endfor
    "}}}
    elseif s:mode != "min" && l==s:pal_H+1 && c < s:stat_pos && c>=s:tip_pos
        if 22 <= c && c <= 27
            call s:echo_tips()
        elseif 29 <= c && c <= 35
            call s:copy()
        elseif 37 <= c && c <= 43
            call colorv#gen_win(g:ColorV.HEX,"Hue",20,15)
        elseif 45 <= c && c <= 50
            h colorv-usage
        endif

    " STAT control "{{{
    elseif l==s:pal_H+1 && c >= s:stat_pos
        let char = getline(l)[c-1]
        if char =~ "Y"
            let g:ColorV_gen_space = "hsv"
            setl ma
            call s:draw_text()
            setl noma
        elseif char =~ 'H'
            let g:ColorV_gen_space = "yiq"
            setl ma
            call s:draw_text()
            setl noma
        elseif char =~ 'V'
            let g:ColorV_win_space = "hls"
            call colorv#win()
        elseif char =~ 'L'
            let g:ColorV_win_space = "hsv"
            call colorv#win()
        elseif char =~ '[Mm-]'
            call s:mode_toggle()
        endif "}}}
    "set_history section "{{{
    elseif l<=(rs_h+rs_y-1)  && l>=rs_y &&  c>=rs_x && c<=(rs_x+rs_w*3-1)
        for i in range(3)
            if c<=(rs_x+rs_w*(1+i)-1)
                let hex=s:his_color{i}
                call s:echo("HEX(history ".i."): ".hex)
                break
            endif
        endfor
        call s:draw_win(hex)
        return
        "}}}
    else
        "cursoredit check "{{{
        let pos_list = s:mode=="max" ? s:max_pos :
                \ s:mode=="min" ? s:min_pos : s:mid_pos
        for [name,y,x,width] in pos_list
            if l==y && c>=x && c<=(x+width-1)
                call s:edit_at_cursor()
                return
            endif
        endfor

        call s:warning("Not Proper Position.")
        return -1
    endif "}}}

endfunction "}}}
function! s:mode_toggle() "{{{
    if s:mode=="min"
        call colorv#win("max")
    elseif s:mode=="max"
        call colorv#win("mid")
    else
        call colorv#win("min")
    endif
endfunction "}}}
function! s:edit_at_cursor(...) "{{{
    let tune=exists("a:1") ? a:1 == "+" ? 1 : a:1 == "-" ? -1  : 0  : 0
    let clr=g:ColorV
    let hex=clr.HEX
    let [r,g,b]=clr.rgb
    let [h,s,v]=clr.hsv
    let [H,L,S]=clr.hls
    let [Y,I,Q]=clr.yiq
    let [l,c] = getpos('.')[1:2]
    let pos_list = s:mode=="max" ? s:max_pos :
                \ s:mode=="min" ? s:min_pos : s:mid_pos
    let position=-1
    for idx in range(len(pos_list))
        let [str,line,column,length]=pos_list[idx]
        if l==line && c>=column && c<column+length
            let position=idx
            break
        endif
    endfor
    if position==0 "{{{
        if tune==0
            let hex=input("Hex(000000~ffffff,000~fff):")
            if hex =~ '^\x\{6}$'
                call s:draw_win(hex)
            elseif hex =~ '^\x\{3}$'
                let hex=substitute(hex,'.','&&','g')
                call s:draw_win(hex)
            endif
        endif
    elseif position==7
        call s:input_colorname()
    elseif position =~ '^[1-6]$' || (position>=8 && position<=13 )
        if position =~ '^[1-3]$'
            let c = ["r","g","b"][position-1]
            let e_txt = "let hex = colorv#rgb2hex([r,g,b])"
        elseif position =~ '^[4-6]$'
            if s:mode =="min" && s:space == "hls"
                let c = ["H","L","S"][position-4]
                let e_txt = "let hex = colorv#hls2hex([H,L,S])"
            else
                let c = ["h","s","v"][position-4]
                let e_txt = "let hex = colorv#hsv2hex([h,s,v])"
            endif
        elseif position =~ '^\(8\|9\|10\)$' 
            let c = ["H","L","S"][position-8]
            let e_txt = "let hex = colorv#hls2hex([H,L,S])"
        elseif position =~ '^\(11\|12\|13\)$' 
            let c = ["Y","I","Q"][position-11]
            let e_txt = "let hex = colorv#yiq2hex([Y,I,Q])"
        endif

        let h_txt = s:hlp_d[c][0]
        let r_min = s:hlp_d[c][1]
        let r_max = s:hlp_d[c][2]

        if tune == 0
            let {c} = input(h_txt."(".r_min."~".r_max."):")
        else
            let {c} += tune * s:tune_step
        endif
        if {c} =~ '^-\=\d\{1,3}$' && {c} <= r_max && {c} >= r_min
            exe e_txt
            call s:draw_win(hex)
        endif
    endif "}}}

endfunction "}}}
function! s:input_colorname(...) "{{{
    let pre_colorname = substitute(g:ColorV.NAME,'\~',"","g")
    if exists("a:1") && a:1=="X11"
        let text = input("Input color name(X11:Blue/Green/Red):",pre_colorname)
        let hex=s:nam2hex(text,a:1)
    else
        let text = input("Input color name(W3C:Blue/Lime/Red):",pre_colorname)
        let hex=s:nam2hex(text)
    endif

    if !empty(hex)
        call s:draw_win(hex)
    else
        let t=tr(text,s:t,s:e)
        let flg_l=s:flag_clr(t)
        if type(flg_l)!=type(0)
            call s:update_his_set(flg_l[2])
            call s:update_his_set(flg_l[1])
            call s:draw_win(flg_l[0])
            let n=tr(flg_l[3],s:t,s:e)
            call s:caution("Hello! ".n."!")
        else
            call s:warning("Not a W3C colorname. Nothing changed.")
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
"}}}
"TEXT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:py_text_load() "{{{
    if exists("s:py_text_load")
        return
    endif
    let s:py_text_load=1
    call s:py_core_load()
python << EOF
import re
fmt={} #{{{
# XXX \s is weird that can not be captured sometimes. use [ \t] instead
# XXX '\( \)' will cause unbalance
# XXX and the \( \\) can not catch the ')' . use [(] and [)] instead

fmt['RGB']=re.compile(r'''
        (?<!\w)rgb[(]                    #wordbegin
        [ \t]*(?P<R>\d{1,3})               #group2 R
        ,[ \t]*(?P<G>\d{1,3})              #group3 G
        ,[ \t]*(?P<B>\d{1,3})              #group4 B
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                      ''')
fmt['RGBA']=re.compile(r'''
        (?<!\w)rgba[(]                   #wordbegin
        [ \t]*(?P<R>\d{1,3})               #group2 R
        ,[ \t]*(?P<G>\d{1,3})              #group3 G
        ,[ \t]*(?P<B>\d{1,3})              #group4 B
        ,[ \t]*(?P<A>\d{1,3}(?:\.\d*)?)%?
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                      ''')
fmt['RGBX']=re.compile(r'''
        (?<!\w)rgb(a)?[(]                #wordbegin
        [ \t]*(?P<R>\d{1,3})               #group2 R
        ,[ \t]*(?P<G>\d{1,3})              #group3 G
        ,[ \t]*(?P<B>\d{1,3})              #group4 B
        (?(1),[ \t]*(?P<A>\d{1,3}(?:\.\d*)?)%?)
                                        #group5 A exists if 'a' exists
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                      ''')
fmt['RGBP']=re.compile(r'''
        (?<!\w)rgb[(]                    #wordbegin
        [ \t]*(?P<R>\d{1,3})%              #group2 R
        ,[ \t]*(?P<G>\d{1,3})%             #group3 G
        ,[ \t]*(?P<B>\d{1,3})%             #group4 B
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                        ''')
fmt['RGBAP']=re.compile(r'''
        (?<!\w)rgba[(]                   #wordbegin
        [ \t]*(?P<R>\d{1,3})%              #group2 R
        ,[ \t]*(?P<G>\d{1,3})%             #group3 G
        ,[ \t]*(?P<B>\d{1,3})%             #group4 B
        ,[ \t]* (?P<A>\d{1,3} (?:\.\d*)?) %?
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                        ''')

fmt['HSL']=re.compile(r'''
        (?<!\w)hsl[(]                    #wordbegin
        [ \t]*(?P<H>\d{1,3})               #group2 H
        ,[ \t]*(?P<S>\d{1,3})%             #group3 S
        ,[ \t]*(?P<L>\d{1,3})%             #group4 L
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                        ''')
fmt['HSLA']=re.compile(r'''
        (?<!\w)hsla[(]                   #wordbegin
        [ \t]*(?P<H>\d{1,3})               #group2 H
        ,[ \t]*(?P<S>\d{1,3})%             #group3 S
        ,[ \t]*(?P<L>\d{1,3})%             #group4 L
        ,[ \t]* (?P<A>\d{1,3} (?:\.\d*)?) %?
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                        ''')
fmt['CMYK']=re.compile(r'''
        (?<!\w)cmyk[(]                   #wordbegin
        [ \t]*(?P<C>\d\.\d*)        #group2 C
        ,[ \t]*(?P<M>\d\.\d*)       #group3 M
        ,[ \t]*(?P<Y>\d\.\d*)       #group4 Y
        ,[ \t]* (?P<K>\d\.\d*)      #group4 K
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                        ''')
fmt['HSV']=re.compile(r'''
        (?<!\w)hsv[(]                    #wordbegin
        [ \t]*(?P<H>\d{1,3})               #group2 H
        ,[ \t]*(?P<S>\d{1,3})              #group3 S
        ,[ \t]*(?P<V>\d{1,3})              #group4 L
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                        ''')
fmt['HSVA']=re.compile(r'''
        (?<!\w)hsva[(]                   #wordbegin
        [ \t]*(?P<H>\d{1,3})               #group2 H
        ,[ \t]*(?P<S>\d{1,3})              #group3 S
        ,[ \t]*(?P<V>\d{1,3})              #group4 L
        ,[ \t]* (?P<A>\d{1,3} (?:\.\d*)?) %?
        [)](?!\w)                        #wordend
        (?ix)                           #[iLmsux] i:igone x:verbose
                        ''')
# (?<![0-9a-fA-F]|0[xX]) is wrong!
# (?<![0-9a-fA-F])|(?<!0[xX]) is wrong
# use (?<!([\w#]))
fmt['HEX']=re.compile(r'''
        (?<!([\w#]))                    #no preceding [0~z] # 0x
        (?P<HEX>[0-9a-fA-F]{6})         #group HEX
        (?!\w)                 #no following [0~z]
        (?ix)
                        ''')
fmt['HEX0']=re.compile(r'''
        0x                              # 0xffffff
        (?P<HEX>[0-9a-fA-F]{6})         #group HEX
        (?!\w)                 #no following [0~f]
        (?ix)
                        ''')
fmt['NS6']=re.compile(r'''
        [#]                             # #ffffff
        (?P<HEX>[0-9a-fA-F]{6})         #group HEX
        (?!\w)                 #no following [0~f]
        (?ix)
                        ''')
fmt['NS3']=re.compile(r'''
        [#]                             # #ffffff
        (?P<HEX>[0-9a-fA-F]{3})         #group HEX
        (?!\w)                 #no following [0~f]
        (?ix)
                        ''')

# clr_lst {{{
#X11 Standard
clrnX11=[['Gray', 'BEBEBE'], ['Green', '00FF00']
            , ['Maroon', 'B03060'], ['Purple', 'A020F0']]
#W3C Standard
clrnW3C=[['Gray', '808080'], ['Green', '008000']
            , ['Maroon', '800000'], ['Purple', '800080']]
clrn=[
  ['AliceBlue'           , 'f0f8ff'], ['AntiqueWhite'        , 'faebd7']
, ['Aqua'                , '00ffff'], ['Aquamarine'          , '7fffd4']
, ['Azure'               , 'f0ffff'], ['Beige'               , 'f5f5dc']
, ['Bisque'              , 'ffe4c4'], ['Black'               , '000000']
, ['BlanchedAlmond'      , 'ffebcd'], ['Blue'                , '0000ff']
, ['BlueViolet'          , '8a2be2'], ['Brown'               , 'a52a2a']
, ['BurlyWood'           , 'deb887'], ['CadetBlue'           , '5f9ea0']
, ['Chartreuse'          , '7fff00'], ['Chocolate'           , 'd2691e']
, ['Coral'               , 'ff7f50'], ['CornflowerBlue'      , '6495ed']
, ['Cornsilk'            , 'fff8dc'], ['Crimson'             , 'dc143c']
, ['Cyan'                , '00ffff'], ['DarkBlue'            , '00008b']
, ['DarkCyan'            , '008b8b'], ['DarkGoldenRod'       , 'b8860b']
, ['DarkGray'            , 'a9a9a9'], ['DarkGreen'           , '006400']
, ['DarkKhaki'           , 'bdb76b'], ['DarkMagenta'         , '8b008b']
, ['DarkOliveGreen'      , '556b2f'], ['Darkorange'          , 'ff8c00']
, ['DarkOrchid'          , '9932cc'], ['DarkRed'             , '8b0000']
, ['DarkSalmon'          , 'e9967a'], ['DarkSeaGreen'        , '8fbc8f']
, ['DarkSlateBlue'       , '483d8b'], ['DarkSlateGray'       , '2f4f4f']
, ['DarkTurquoise'       , '00ced1'], ['DarkViolet'          , '9400d3']
, ['DeepPink'            , 'ff1493'], ['DeepSkyBlue'         , '00bfff']
, ['DimGray'             , '696969'], ['DodgerBlue'          , '1e90ff']
, ['FireBrick'           , 'b22222'], ['FloralWhite'         , 'fffaf0']
, ['ForestGreen'         , '228b22'], ['Fuchsia'             , 'ff00ff']
, ['Gainsboro'           , 'dcdcdc'], ['GhostWhite'          , 'f8f8ff']
, ['Gold'                , 'ffd700'], ['GoldenRod'           , 'daa520']
, ['GreenYellow'         , 'adff2f'], ['HoneyDew'            , 'f0fff0']
, ['HotPink'             , 'ff69b4'], ['IndianRed'           , 'cd5c5c']
, ['Indigo'              , '4b0082'], ['Ivory'               , 'fffff0']
, ['Khaki'               , 'f0e68c'], ['Lavender'            , 'e6e6fa']
, ['LavenderBlush'       , 'fff0f5'], ['LawnGreen'           , '7cfc00']
, ['LemonChiffon'        , 'fffacd'], ['LightBlue'           , 'add8e6']
, ['LightCoral'          , 'f08080'], ['LightCyan'           , 'e0ffff']
, ['LightGoldenRodYellow', 'fafad2'], ['LightGrey'           , 'd3d3d3']
, ['LightGreen'          , '90ee90'], ['LightPink'           , 'ffb6c1']
, ['LightSalmon'         , 'ffa07a'], ['LightSeaGreen'       , '20b2aa']
, ['LightSkyBlue'        , '87cefa'], ['LightSlateGray'      , '778899']
, ['LightSteelBlue'      , 'b0c4de'], ['LightYellow'         , 'ffffe0']
, ['Lime'                , '00ff00'], ['LimeGreen'           , '32cd32']
, ['Linen'               , 'faf0e6'], ['Magenta'             , 'ff00ff']
, ['MediumAquaMarine'    , '66cdaa']
, ['MediumBlue'          , '0000cd'], ['MediumOrchid'        , 'ba55d3']
, ['MediumPurple'        , '9370d8'], ['MediumSeaGreen'      , '3cb371']
, ['MediumSlateBlue'     , '7b68ee'], ['MediumSpringGreen'   , '00fa9a']
, ['MediumTurquoise'     , '48d1cc'], ['MediumVioletRed'     , 'c71585']
, ['MidnightBlue'        , '191970'], ['MintCream'           , 'f5fffa']
, ['MistyRose'           , 'ffe4e1'], ['Moccasin'            , 'ffe4b5']
, ['NavajoWhite'         , 'ffdead'], ['Navy'                , '000080']
, ['OldLace'             , 'fdf5e6'], ['Olive'               , '808000']
, ['OliveDrab'           , '6b8e23'], ['Orange'              , 'ffa500']
, ['OrangeRed'           , 'ff4500'], ['Orchid'              , 'da70d6']
, ['PaleGoldenRod'       , 'eee8aa'], ['PaleGreen'           , '98fb98']
, ['PaleTurquoise'       , 'afeeee'], ['PaleVioletRed'       , 'd87093']
, ['PapayaWhip'          , 'ffefd5'], ['PeachPuff'           , 'ffdab9']
, ['Peru'                , 'cd853f'], ['Pink'                , 'ffc0cb']
, ['Plum'                , 'dda0dd'], ['PowderBlue'          , 'b0e0e6']
, ['Red'                 , 'ff0000']
, ['RosyBrown'           , 'bc8f8f'], ['RoyalBlue'           , '4169e1']
, ['SaddleBrown'         , '8b4513'], ['Salmon'              , 'fa8072']
, ['SandyBrown'          , 'f4a460'], ['SeaGreen'            , '2e8b57']
, ['SeaShell'            , 'fff5ee'], ['Sienna'              , 'a0522d']
, ['Silver'              , 'c0c0c0'], ['SkyBlue'             , '87ceeb']
, ['SlateBlue'           , '6a5acd'], ['SlateGray'           , '708090']
, ['Snow'                , 'fffafa'], ['SpringGreen'         , '00ff7f']
, ['SteelBlue'           , '4682b4'], ['Tan'                 , 'd2b48c']
, ['Teal'                , '008080'], ['Thistle'             , 'd8bfd8']
, ['Tomato'              , 'ff6347'], ['Turquoise'           , '40e0d0']
, ['Violet'              , 'ee82ee'], ['Wheat'               , 'f5deb3']
, ['White'               , 'ffffff'], ['WhiteSmoke'          , 'f5f5f5']
, ['Yellow'              , 'ffff00'], ['YellowGreen'         , '9acd32']
]
# }}}
NAME_txt=r'\bGray\b|\bGreen\b|\bMaroon\b|\bPurple\b'
for [nam,hex] in clrn:
    NAME_txt=r"|".join([NAME_txt,r'\b'+nam+r'\b'])

fmt['NAME']=re.compile(NAME_txt,re.I|re.X)

                        #}}}
def name2hex(name,*rule):
    if len(name):
        if len(rule) and rule[0]=="X11":
            lst=clrn+clrnX11
        else:
            lst=clrn+clrnW3C
        for [nam,clr] in lst:
            # ignore the case
            if name.lower()==nam.lower():
                return clr
    return 0
def txt2hex(txt):
    hex_list=[]
    for key,var in fmt.iteritems():
        r_list=list(var.finditer(txt))
        if len(r_list)>0:
            for x in r_list:
                if key=="HEX" or key=="NS6" or key=="HEX0":
                    hx=x.group('HEX')
                elif key=="NS3":
                    hx3=x.group('HEX')
                    hx=hx3[0]*2+hx3[1]*2+hx3[2]*2
                elif key=="RGBA" or key=="RGB":
                    hx=rgb2hex([x.group('R'),x.group('G'),x.group('B')])
                elif key=="RGBP" or key=="RGBAP":
                    r,g,b=int(x.group('R')),int(x.group('G')),int(x.group('B'))
                    hx=rgb2hex([r*2.55,g*2.55,b*2.55])
                elif key=="HSL" or key=="HSLA" :
                    h,s,l=int(x.group('H')),int(x.group('S')),int(x.group('L'))
                    hx=rgb2hex(hls2rgb([h,l,s]))
                elif key=="CMYK" :
                    c,m,y,k=[float(x.group('C')),float(x.group('M')) 
                          ,float(x.group('Y')),float(x.group('K'))]
                    hx=rgb2hex(cmyk2rgb([c,m,y,k]))
                elif key=="HSV" or key=="HSVA" :
                    h,s,v=int(x.group('H')),int(x.group('S')),int(x.group('V'))
                    hx=rgb2hex(hls2rgb([h,s,v]))
                elif key=="NAME":
                    hx=name2hex(x.group())
                else:
                    continue
                hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
    return hex_list

def hex2nam(hex,lst="W3C"): #{{{
    best_match = 0
    smallest_distance = 10000000

    t= int(vim.eval("s:aprx_rate"))
    if lst=="X11":clr_list=clrn+clrnX11
    else:clr_list=clrn+clrnW3C
    r1,g1,b1 = hex2rgb(hex)

    for lst in clr_list:
        r2,g2,b2 = hex2rgb(lst[1])
        d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < smallest_distance:
            smallest_distance = d
            best_match = lst[0]

    if smallest_distance == 0:
        return best_match
    elif smallest_distance <= t*5:
        return best_match+"~"
    elif smallest_distance <= t*10:
        return best_match+"~~"
    else:
        return "" #}}}
EOF
endfunction "}}}
function! s:txt2hex(txt) "{{{
    if has("python") && g:ColorV_no_python!=1
        call s:py_text_load()
        py vim.command("return "+str(txt2hex(vim.eval("a:txt"))))
    endif

    let text = a:txt
    let textorigin = a:txt
    let old_list=[]

    "max search depth
    let hex_list=[]
    for rnd in range(20)
        for [fmt,pat] in items(s:fmt)
            if text=~ pat
                let p_idx=match(text,pat)
                let p_str=matchstr(text,pat)
                " error with same hex in one line?
                " it will match the first one
                let p_oidx=match(textorigin,p_str)
                let p_len=len(p_str)
                let text=strpart(text,0,p_idx)
                        \.strpart(text,p_len+p_idx)

                if fmt=~ 'HEX\|NS'
                    let hex=s:fmt_hex(p_str)
                elseif fmt=="RGB" || fmt =="RGBA" || fmt =="HSV"
                            \ || fmt=="HSL" || fmt =="HSLA"
                    if fmt =~ 'RGB'
                        let [x1,x2,x3] = ["r","g","b"]
                        let func="colorv#rgb2hex"
                    elseif fmt == "HSV"
                        let [x1,x2,x3] = ["h","s","v"]
                        let func="colorv#hsv2hex"
                    elseif fmt=="HSL" || fmt =="HSLA"
                        let [x1,x2,x3] = ["H","L","S"]
                        let func="colorv#hls2hex"
                    endif

                    let n_str=matchstr(p_str,'(\zs.*\ze)')
                    let [{x1},{x2},{x3}]=split(n_str,'\s*%\=,\s*')[0:2]
                    if {x1} > s:hlp_d[x1][2] 
                    \ || {x2} > s:hlp_d[x2][2] 
                    \ || {x3} > s:hlp_d[x3][2] 
                        call s:error("Out Of Boundary")
                        continue
                    endif
                    let hex = {func}([{x1},{x2},{x3}])
                elseif fmt=="RGBP" || fmt =="RGBAP"
                    let n_str=matchstr(p_str,'(\zs.*\ze)')
                    let [r,g,b]=split(n_str,'\s*%\=,\s*')[0:2]
                    if r > 100 || g >100 || b > 100
                        call s:error("RGB out of boundary")
                        continue
                    endif
                    let hex= colorv#rgb2hex([r*2.55,g*2.55,b*2.55])
                elseif fmt=="NAME"
                    let hex=s:nam2hex(p_str)
                elseif fmt=="CMYK"
                    let [x1,x2,x3,x4] = ["c","m","y","k"]
                    let func="colorv#cmyk2rgb"
                    let n_str=matchstr(p_str,'(\zs.*\ze)')
                    let [{x1},{x2},{x3},{x4}]=split(n_str,'\s*%\=,\s*')[0:3]
                    if {x1} > 1  || {x2} > 1  || {x3} > 1  || {x4} > 1
                        call s:error("Out Of Boundary")
                        continue
                    endif
                    let rgb = {func}([{x1},{x2},{x3},{x4}])
                    let hex = colorv#rgb2hex(rgb)
                else
                    continue
                endif
                let list=[hex,p_oidx,p_len,p_str,fmt]
                call add(hex_list,list)
            endif
        endfor
        if old_list==hex_list
            break
        else
            let old_list=deepcopy(hex_list,1)
        endif
    endfor

    return hex_list
endfunction "}}}
function! s:hex2txt(hex,fmt,...) "{{{

    let hex = s:fmt_hex(a:hex)
    let [r,g,b]= s:printf("%3d",colorv#hex2rgb(hex))
    let [rp,gp,bp]= s:printf("%3d",s:number([r/2.55,g/2.55,b/2.55]))
    let [h,s,v] = s:printf("%3d",colorv#rgb2hsv([r,g,b]))
    let [H,L,S]= s:printf("%3d",colorv#rgb2hls([r,g,b]))

    if a:fmt=="RGB"
        let text="rgb(".r.",".g.",".b.")"
    elseif a:fmt=="HSV"
        let text="hsv(".h.",".s.",".v.")"
    elseif a:fmt=="HSL"
        let text="hsl(".H.",".S."%,".L."%)"
    elseif a:fmt=="HSLA"
        let text="hsla(".H.",".S."%,".L."%,1.0)"
    elseif a:fmt=="RGBP"
        let text="rgb(".rp."%,".gp."%,".bp."%)"
    elseif a:fmt=="RGBA"
        let text="rgba(".r.",".g.",".b.",1.0)"
    elseif a:fmt=="RGBAP"
        let text="rgba(".rp."%,".gp."%,".bp."%,1.0)"
    elseif a:fmt=="HEX"
        let text=hex
    elseif a:fmt=="NS6"
        let text="#".hex
    elseif a:fmt=="NS3"
        let text="#".hex
    elseif a:fmt=="HEX0"
        let text="0x".hex
    elseif a:fmt=="CMYK"
        let [c,m,y,k]= colorv#rgb2cmyk([r,g,b])
        let text="cmyk(".c.",".m.",".y.",".k.")"
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
    if has("python") && g:ColorV_no_python!=1
        call s:py_text_load()
        let lst = exists("a:1") && a:1 == "X11" ? "X11" : "W3C"
        py vim.command("return "+"\""+
                    \hex2nam(vim.eval("a:hex"),vim.eval("lst"))+"\"")
    else
        if exists("a:1") && a:1 == "X11"
            let clr_list=s:clrn+s:clrnX11
        else
            let clr_list=s:clrn+s:clrnW3C
        endif
        let best_name=""
        let dist = 20000
        let [r1,g1,b1] = colorv#hex2rgb(a:hex)
        for lst in clr_list
            let [r2,g2,b2] = colorv#hex2rgb(lst[1])
            let d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
            if d < dist
                let dist = d
                let best_name = lst[0]
            endif
        endfor
        if dist == 0
            return best_name
        elseif dist <= s:aprx_rate*5
            return best_name."~"
        elseif dist <= s:aprx_rate*10
            return best_name."~~"
        else
            return ""
        endif
    endif
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
    if len(hex_list)>0
        let hex=hex_list[0][0]
    else
        call s:warning("Could not find color in the text")
        return
    endif
    call s:echo("Set with first color in clipboard. HEX: [".hex."]")
    call s:draw_win(hex)

endfunction "}}}
function! s:copy(...) "{{{
    let fmt=exists("a:1") ? a:1 : "HEX"
    let l:cliptext=s:hex2txt(g:ColorV.HEX,fmt)
    "no duplicated color to history
    if string(get(s:his_cpd_list,-1))!=string(g:ColorV.HEX)
        call add(s:his_cpd_list,g:ColorV.HEX)
        if s:mode=="max"
            call s:draw_history_copy()
        endif
    endif

    if  exists("a:2") && a:2=="\""
        call s:echo("Copied to Clipboard(reg\"):".l:cliptext)
        let @" = l:cliptext
    elseif exists("a:2") && a:2=="+"
        call s:echo("Copied to Clipboard(reg+):".l:cliptext)
        let @+ = l:cliptext
    else
        call s:echo("Copied to Clipboard(reg\"):".l:cliptext)
        let @" = l:cliptext
    endif
endfunction "}}}

function! s:changing() "{{{
    if exists("s:ColorV.change_word") && s:ColorV.change_word ==1
        let cur_pos=getpos('.')
        let cur_bufname=bufname('%')

        " go to the word_buf if not in it
        if bufname('%') != s:ColorV.word_bufname
                    \|| bufnr('%') != s:ColorV.word_bufnr
            exe s:ColorV.word_bufwinnr."wincmd w"
        endif
        call setpos('.',s:ColorV.word_pos)

        if s:ColorV.word_bufnr==bufnr('%') && s:ColorV.word_pos==getpos('.')
                    \ && s:ColorV.word_bufname==bufname('%')

            let word = expand('<cword>')
            let lword = expand('<cWORD>')
            let line = getline('.')

            "get the from_pattern "{{{
            if s:ColorV.is_in=="word"
                silent normal! b
                let bgn_idx=col('.')
                let from_pat=word
            elseif s:ColorV.is_in=="lword"
                silent normal! B
                let bgn_idx=col('.')
                let from_pat=lword
            elseif s:ColorV.is_in=="line"
                silent normal! 0
                let bgn_idx=col('.')
                let from_pat=line
            else
                call s:error("Don't know what to change from.")
                let s:ColorV.change_word=0
                let s:ColorV.change_all=0
                return -1
            endif "}}}

            "check if Not the origin word "{{{
            if from_pat!= s:ColorV.word_pat
                call s:error("Doesn't get the right word to change.")
                return -1
            endif "}}}

            "get the to_str "{{{
            if exists("s:ColorV.word_list[0]")
                let to_hex=g:ColorV.HEX
                let to_fmt=s:ColorV.word_list[4]
                if exists("s:ColorV.change2")
                    let to_fmt=s:ColorV.change2
                endif
                if &filetype=="vim"
                    let to_str=s:hex2txt(to_hex,to_fmt,"X11")
                else
                    let to_str=s:hex2txt(to_hex,to_fmt)
                endif
                let to_str=substitute(to_str,'\~','','g')
                if empty(to_str)
                    call s:error("You have choose a color with no
                                \W3C colorname. Stopped.")
                    return
                endif
            else
                call s:error("Don't know what to change to.")
                let s:ColorV.change_word=0
                let s:ColorV.change_all=0
                return
            endif "}}}

            let idx=s:ColorV.word_list[1]
            let len=s:ColorV.word_list[2]
            let to_pat=substitute(from_pat,'\%'.(idx+1).'c.\{'.len.'}',to_str,'')

            if exists("s:ColorV.change_noma")&& s:ColorV.change_noma ==1
                setl ma
            endif
            if exists("s:ColorV.change_all") && s:ColorV.change_all ==1
                let e_txt = '%s/'.from_pat.'/'.to_pat.'/gc'
            else
                "  XXX: ptn not found if from_pat=line
                let e_txt = '.s/\%>'.(bgn_idx-1).'c'.from_pat.'/'.to_pat.'/'
            endif
            try
                exec e_txt
            catch /^Vim\%((\a\+)\)\=:E486/
                call s:debug(from_pat." to:".to_fmt.to_str.to_pat)
                call s:error("E486: Pattern not found.")
            catch /^Vim\%((\a\+)\)\=:E/
                call s:error(v:exception)
            endtry
            if exists("s:ColorV.change_noma") && s:ColorV.change_noma ==1
                setl noma
                unlet s:ColorV.change_noma
            endif
        endif

        if exists("s:ColorV.change_func")
            call call(s:ColorV.change_func,[g:ColorV.HEX])
            unlet s:ColorV.change_func
        endif
        "Back to origin pos
        if bufwinnr(cur_bufname)!=winnr()
            let cur_bufwinnr=bufwinnr('%')
            exe cur_bufwinnr."wincmd w"
            call setpos('.',s:ColorV.word_pos)
        endif
    endif
    let s:ColorV.change_word=0
    let s:ColorV.change_all=0
endfunction
"}}}
function! colorv#cursor_win(...) "{{{
    let s:ColorV.word_bufnr=bufnr('%')
    let s:ColorV.word_bufname=bufname('%')
    let s:ColorV.word_bufwinnr=bufwinnr('%')
    let s:ColorV.word_pos=getpos('.')
    let s:ColorV.word_col=col('.')
    let lword= expand('<cWORD>')
    let word= expand('<cword>')
    let line= getline('.')
    if word !~ '^\s*$'
        let word_list=s:txt2hex(word)
    else
        let word_list=0
    endif
    if lword !~ '^\s*$'
        let lword_list=s:txt2hex(lword)
    else
        let lword_list=0
    endif
    if line !~ '^\s*$'
        let line_list=s:txt2hex(line)
    else
        let line_list=0
    endif
    if !empty(word_list)
        let s:ColorV.is_in="word"
        let pat = word
        let s:ColorV.word_pat=pat
        let hex_list= word_list
        silent normal! b
    elseif !empty(lword_list)
        let s:ColorV.is_in="lword"
        let pat = lword
        let s:ColorV.word_pat=pat
        let hex_list= lword_list
        silent normal! B
    elseif !empty(line_list)
        let s:ColorV.is_in="line"
        let pat = line
        let s:ColorV.word_pat=pat
        let hex_list= line_list
        silent normal! 0
    else
        let s:ColorV.is_in=""
        let pat = ""
        let s:ColorV.word_pat=pat
        call s:error("Color-text not found under cursor line.")
        return -1
    endif
    let bgn_idx=col('.')
    if len(hex_list) >1 "{{{
        let i=0
        for [lhex,idx,len,str,fmt] in hex_list
            if  s:ColorV.word_col > bgn_idx+idx
                        \ &&  s:ColorV.word_col < bgn_idx+idx+len
                let hex=s:fmt_hex(lhex)
                let s:ColorV.word_list=hex_list[i]
            endif
            let i+=1
        endfor
        if !exists("hex")
            let hex=s:fmt_hex(hex_list[0][0])
            let s:ColorV.word_list=hex_list[0]
        endif
    else
        let hex=s:fmt_hex(hex_list[0][0])
        let s:ColorV.word_list=hex_list[0]
    endif "}}}

    if exists("a:1") && a:1==1
        let s:ColorV.change_word=1
        let s:ColorV.change_all=0
        call s:caution("Will Change [".pat."] after ColorV closed.")
    elseif exists("a:1") && a:1==2
        let s:ColorV.change_word=1
        let s:ColorV.change_all=1
        call s:caution("Will Change ALL [".pat."] after ColorV closed.")
    elseif exists("a:1") && a:1==3
        let type=exists("a:2") ? a:2 : ""
        let nums=exists("a:3") ? a:3 : ""
        let step=exists("a:4") ? a:4 : ""
        call s:echo("Will Generate color list with [".pat."].")
        call colorv#gen_win(hex,type,nums,step)
        return
    elseif exists("a:1") && a:1==4
        let s:ColorV.change_word=1
    else
        let s:ColorV.change_word=0
        let s:ColorV.change_all=0
        call colorv#win(s:mode,hex)
        return
    endif

    "change2
    if exists("a:1") && (a:1==2 || a:1==1) && exists("a:2")
                \ && a:2=~'RGB\|RGBA\|RGBP\|RGBAP\|HEX\|HEX0\|NAME\|NS6\|HSV\|HSL\|CMYK'
        let s:ColorV.change2=a:2
    elseif exists("s:ColorV.change2")
        unlet s:ColorV.change2
    endif

    "change with nomodifiable
    if exists("a:1") && a:1==4 && exists("a:2")
        let s:ColorV.change_noma=1
        let s:ColorV.change_func=a:2
    else
        if exists("s:ColorV.change_noma")
            unlet s:ColorV.change_noma
        endif
        if exists("s:ColorV.change_func")
            unlet s:ColorV.change_func
        endif
    endif

    "pass "s:changing" as exit_func to colorv#win()
    call colorv#win(s:mode,hex,1,"s:changing")

endfunction "}}}
function! colorv#clear_all() "{{{
    call s:clear_match("rect")
    call s:clear_match("hsv")
    call s:clear_match("misc")
    call s:clear_match("pal")
    call s:clear_match("prev")
    call clearmatches()
endfunction "}}}
"}}}
"LIST: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorv#list_win(...) "{{{
    call s:open_win(g:ColorV.listname,"v")

    " local setting "{{{
    call s:win_setl()
    setl ft=ColorV_list

    nmap <silent><buffer> q :call colorv#exit_list_win()<cr>
    nmap <silent><buffer> Q :call colorv#exit_list_win()<cr>
    nmap <silent><buffer> <c-w>q :call colorv#exit_list_win()<cr>
    nmap <silent><buffer> <c-w><c-q> :call colorv#exit_list_win()<cr>
    nmap <silent><buffer> H :h colorv-colorname<cr>
    nmap <silent><buffer> <F1> :h colorv-colorname<cr>
    if winnr('$') != 1
        execute 'vertical resize' 29
        redraw
    endif

    let list=exists("a:1") && !empty(a:1) ? a:1 :
                \ [['Color Name List','=======']]+ s:clrn
                \+[['W3C_Standard','=======']]+s:clrnW3C
                \+[['X11_Standard','=======']]+s:clrnX11
    call s:draw_list_buf(list)
endfunction "}}}
function! colorv#list_and_colorv(...) "{{{
    let list=exists("a:1") && !empty(a:1) ? a:1 : ""
    call colorv#exit()
    call colorv#list_win(list)
    call colorv#win(s:mode)
    call s:go_buffer_win(g:ColorV.listname)
endfunction "}}}
function! s:draw_list_buf(list) "{{{
    let list=a:list
    setl ma
    call s:clear_list_text()
    call s:draw_list_text(list)
    setl noma
    "preview without highlight colorname
    call colorv#preview("Nc")
endfunction "}}}
function! s:draw_list_text(list) "{{{
    let list=a:list
    for i in range(len(list))
        let name=list[i][0]
        let hex= list[i][1]
        let txt= hex =~'\x\{6}' ? "#".hex : hex
        let line=s:line_sub(name,txt,22)
        call setline(i+1,line)
    endfor
endfunction "}}}

function! s:circle_coord_gen(x,y,num) "{{{
    " in    x,y,num
    " out   [[x0,y0],[x1,y1]..]
    let circle_list = []
    let [x,y,num]= s:float([a:x,a:y,a:num])
    let radus = sqrt(pow(x,2)+pow(y,2))
    let radan = atan(y/x)
    if y>0 && x>0
        let radan = radan
    elseif y<0 && x>0
        let radan = radan + 3.14159*2
    elseif y<0 && x<0
        let radan = radan + 3.14159
    elseif y>0 && x<0
        let radan = radan + 3.14159
    endif
    for i in range(a:num)
        let radian{i} =radan+2*3.14159/num*i
        let nx{i} = cos(radian{i})*radus
        let ny{i} = sin(radian{i})*radus
        call add(circle_list,[nx{i},ny{i}])
    endfor
    return circle_list
endfunction "}}}
function! colorv#yiq_list_gen(hex,...) "{{{
    let hex=a:hex
    let hex_list=[]
    let type=exists("a:1") && !empty(a:1) ? a:1 : s:gen_def_type
    let nums=exists("a:2") && !empty(a:2) ? a:2 : s:gen_def_nums
    let step=exists("a:3") && !empty(a:3) ? a:3 : s:gen_def_step
    let circle=exists("a:4") ? a:4 : 1
    let [y,i,q] = colorv#rgb2yiq(colorv#hex2rgb(hex))
    let [h,s,v] = colorv#hex2hsv(hex)
    let [h0,s0,v0] = [h,s,v]
    let [y0,i0,q0] = [y,i,q]
    let hex0 = hex
    if type==?"Hue"
        for i in range(1,nums)
            let h{i}=h+i*step
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Luma"
        "y+
        for i in range(1,nums)
            let y{i}=y{i-1}+step
            if circle==1
                let y{i} = y{i} >=100 ? 1 : y{i} <= 0 ? 100 : y{i}
            else
                let y{i} = y{i} >=100 ? 100 : y{i} <= 0 ? 1 : y{i}
            endif
            let hex=colorv#yiq2hex([y{i},i,q])
            call add(hex_list,hex)
        endfor
    elseif type=="Value"
        "v+
        " let v{i}= v+step*i<=100 ? v+step*i : 100
        for i in range(1,nums)
            let y{i}=y{i-1}+step
            if circle==1
                let y{i} = y{i} >=100 ? 1 : y{i} <= 0 ? 100 : y{i}
            else
                let y{i} = y{i} >=100 ? 100 : y{i} <= 0 ? 1 : y{i}
            endif
            let hex=colorv#yiq2hex([y{i},i,q])
            call add(hex_list,hex)
        endfor
    elseif type=="Saturation"
        for i in range(1,nums)
            let s{i}=s{i-1}+step
            if circle==1
                let s{i} = s{i} >=100 ? 1 : s{i} <= 0 ? 100 : s{i}
            else
                let s{i} = s{i} >=100 ? 100 : s{i} <= 0 ? 1 : s{i}
            endif
            let hex{i}=colorv#hsv2hex([h,s{i},v])
            let [y{i},i{i},q{i}]=colorv#hex2yiq(hex{i})
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type=="Monochromatic"
        let hex_list=colorv#list_gen(hex,"Monochromatic",nums,step)
    elseif type=="Analogous"
        let hex_list=colorv#yiq_list_gen(hex,"Hue",nums,30)
    elseif type==?"Neutral"
        let hex_list=colorv#yiq_list_gen(hex,"Hue",nums,15)
    elseif type==?"Complementary"
        let hex_list=colorv#yiq_list_gen(hex,"Hue",nums,180)
    elseif type=="Split-Complementary"
        for i in range(1,nums)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+150 : h{i-1}+60
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Triadic"
        let hex_list=colorv#yiq_list_gen(hex,"Hue",nums,120)
    elseif type=="Clash"
        for i in range(1,nums)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+90 : h{i-1}+180
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type=="Square"
        let hex_list=colorv#yiq_list_gen(hex,"Hue",nums,90)
    elseif type=="Tetradic" || type=="Rectangle"
        "h+60,h+120,...
        for i in range(1,nums)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+60 : h{i-1}+120
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Five-Tone"
        "h+115,+40,+50,+40,+115
        for i in range(1,nums)
            let h{i}=s:fmod(i,5)==1 ? h{i-1}+115 :
                    \ s:fmod(i,5)==2 ? h{i-1}+40 :
                    \ s:fmod(i,5)==3 ? h{i-1}+50 :
                    \ s:fmod(i,5)==4 ? h{i-1}+40 :
                    \ h{i-1}+115
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Six-Tone"
        for i in range(1,nums)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+30 : h{i-1}+90
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    else
            call s:warning("No fitting Color Generator Type.")
            return []
    endif
    return hex_list
endfunction "}}}
function! colorv#yiq_winlist_gen(hex,...) "{{{
    let hex=a:hex
    let type=exists("a:1") ? a:1 : ""
    let nums=exists("a:2") ? a:2 : ""
    let step=exists("a:3") ? a:3 : ""
    let genlist=colorv#yiq_list_gen(hex,type,nums,step)
    let list=[]
    call add(list,["YIQ ".type,'======='])
    let i=0
    for hex in genlist
        call add(list,[type.i,hex])
        let i+=1
    endfor
    return list
endfunction "}}}

function! s:clear_list_text() "{{{
    if !s:check_win('_ColorV-List_')
        call s:error("Not [ColorV-List] buffer.")
        return [0,0,0,0]
    endif
    let cur=getpos('.')
    silent! %delete _
    return cur
endfunction "}}}
function! colorv#list_gen(hex,...) "{{{
    let hex=a:hex
    let hex_list=[]
    let type=exists("a:1") && !empty(a:1) ? a:1 : s:gen_def_type
    let nums=exists("a:2") && !empty(a:2) ? a:2 : s:gen_def_nums
    let step=exists("a:3") && !empty(a:3) ? a:3 : s:gen_def_step

    " set to 1 .the value will became 0 if exceed max.
    let circle=exists("a:4") ? a:4 : 1


    let [h,s,v] = colorv#hex2hsv(hex)
    let [h0,s0,v0] = [h,s,v]
    let hex0 = hex
    for i in range(1,nums)
        if type==?"Hue"
            "h+
            let h{i} = h + step*i
            let hex{i} = colorv#hsv2hex([h{i} ,s ,v])
        elseif type==?"Saturation"
            "s+
            let s{i} = s{i-1} + step
            if ( circle )
                let s{i} = s{i} >= 100 ? 1   : s{i} <= 0 ? 100 : s{i}
            else
                let s{i} = s{i} >= 100 ? 100 : s{i} <= 0 ? 1   : s{i}
            endif
            let hex{i}=colorv#hsv2hex([h,s{i},v])
        elseif type==?"Value"
            "v+
            let v{i} = v{i-1} + step
            if circle==1
                let v{i} = v{i} >=100 ? 1 : v{i} <= 0 ? 100 : v{i}
            else
                let v{i} = v{i} >=100 ? 100 : v{i} <= 0 ? 1 : v{i}
            endif
            let hex{i}=colorv#hsv2hex([h,s,v{i}])
        elseif type==?"Monochromatic"
            "s+step v+step
            let step=step>0 ? 5 : step<0 ? -5 : 0
            let s{i}=s{i-1}+step
            let v{i}=v{i-1}+step
            if circle==1
                let s{i} = s{i} >=100 ? 1 : s{i} <= 0 ? 100 : s{i}
                let v{i} = v{i} >=100 ? 1 : v{i} <= 0 ? 100 : v{i}
            else
                let s{i} = s{i} >=100 ? 100 : s{i} <= 0 ? 1 : s{i}
                let v{i} = v{i} >=100 ? 100 : v{i} <= 0 ? 1 : v{i}
            endif
            let hex{i}=colorv#hsv2hex([h,s{i},v{i}])
        elseif type==?"Analogous"
            "h+30
            let h{i}=h+30*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Neutral"
            "h+15
            let h{i}=h+15*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Complementary"
            "h+180
            let h{i}=h+180*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Split-Complementary"
            "h+150,h+60,...
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+150 : h{i-1}+60
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Triadic"
            "h+120
            let h{i}=h+120*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Clash"
            "h+90,h+180,...
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+90 : h{i-1}+180
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Square"
            "h+90
            let h{i}=h+90*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Tetradic" || type==?"Rectangle"
            "h+60,h+120,...
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+60 : h{i-1}+120
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Five-Tone"
            "h+115,+40,+50,+40,+115
            let h{i}=s:fmod(i,5)==1 ? h{i-1}+115 :
                    \ s:fmod(i,5)==2 ? h{i-1}+40  :
                    \ s:fmod(i,5)==3 ? h{i-1}+50  :
                    \ s:fmod(i,5)==4 ? h{i-1}+40  :
                    \ h{i-1}+115
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type==?"Six-Tone"
            "h+30,90,...
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+30 : h{i-1}+90
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        else
            call s:warning("No fitting Color Generator Type.")
            return []
        endif
        call add(hex_list,hex{i})
    endfor
    return hex_list
endfunction "}}}
function! s:winlist_generate(hex,...) "{{{
    let hex=a:hex
    let type=exists("a:1") ? a:1 : ""
    let nums=exists("a:2") ? a:2 : ""
    let step=exists("a:3") ? a:3 : ""
    let genlist=colorv#list_gen(hex,type,nums,step)

    let list=[]
    call add(list,[type.' List','======='])
    let i=0
    for hex in genlist
        call add(list,[type.i,hex])
        let i+=1
    endfor

    return list
endfunction "}}}
function! colorv#gen_win(hex,...) "{{{
    let hex=a:hex
    let type=exists("a:1") ? a:1 : ""
    let nums=exists("a:2") ? a:2 : ""
    let step=exists("a:3") ? a:3 : ""
    if g:ColorV_gen_space ==? "yiq"
        let list=colorv#yiq_winlist_gen(hex,type,nums,step)
    else
        let list=s:winlist_generate(hex,type,nums,step)
    endif
    " call colorv#exit()
    call colorv#list_win(list)
    " call colorv#win(s:mode)
    call s:go_buffer_win(g:ColorV.listname)
endfunction "}}}
"1}}}
"PREV: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorv#prev_txt(txt) "{{{
    let bufnr=bufnr('%')

    let view_name  = exists("b:view_name")  && b:view_name==1 ? 1 : 0
    let view_block = exists("b:view_block") && b:view_block==1 ? 1 : 0

    let hex_list=s:txt2hex(a:txt)

    for prv_item in hex_list
        let [hex,idx,len,str,fmt] = prv_item
        if fmt == "NAME"
            if view_name == 1
                let hi_ptn='\<'.str.'\>'
            else
                continue
            endif
        elseif fmt =~ 'NS6\|NS3\|HEX\|HEX0'
            let hi_ptn = str.'\x\@!'
        else
            let hi_ptn = str
        endif

        " cv_prv3_ff0000_NS6
        let hi_grp="cv_prv".bufnr."_".hex."_".fmt
        let hi_fg = view_block==1 ? hex : s:rlt_clr(hex)

        " if does not exists in dict. then hi and add.
        " if exists , not hi it again.
        try
            let hi_ptn_a=substitute(hi_ptn,'\W',"_","g")
            if !exists("s:prev_dict['".hi_ptn_a."']")
                call colorv#hi_color(hi_grp,hi_fg,hex)
                let s:prev_dict[hi_ptn_a]= s:matchadd(hi_grp,hi_ptn)
            endif
        catch /^Vim\%((\a\+)\)\=:E/
            call s:debug("E254: Could not hi color:".str)
            continue
        endtry

    endfor
endfunction "}}}
function! colorv#preview(...) "{{{

    let b:view_name=g:ColorV_view_name
    let b:view_block=g:ColorV_view_block
    let silent=0
    if exists("a:1")
        " N-> noname B->noblock S->nosilence
        " n-> name_ b->block s->silence
        let b:view_name = a:1=~#"N" ? 0 : a:1=~#"n" ? 1 : b:view_name
        let b:view_block = a:1=~#"B" ? 0 : a:1=~#"b" ? 1 : b:view_block
        let silent = a:1=~#"S" ? 0 : a:1=~#"s" ? 1 : silent
        if a:1 =~# "c"
            call s:clear_match("prev")
        endif
    endif

    let o_time = s:time()
    " if file > 300 line, preview 200 line around cursor.
    let cur = line('.')
    let lst = line('$')
    if lst >= 300
        let [begin,end] = cur<200 ? [1,200] :
                    \ cur>lst-200 ? [lst-200,lst] : [cur-100,cur+100]
    else
        let [begin,end] =[1,lst]
    endif
    let file_lines = getline(begin,end)
    for i in range(len(file_lines))
        let line = file_lines[i]
        call colorv#prev_txt(line)
    endfor

    if !silent
        call s:echo( (end-begin)." lines previewed."
            \."Takes ". string(s:time() - o_time). " sec." )
    endif
endfunction "}}}
function! colorv#preview_line(...) "{{{

    let b:view_name=g:ColorV_view_name
    let b:view_block=g:ColorV_view_block
    if exists("a:1")
        " N-> noname B->noblock C->noclear
        " n-> name b->block c->clear
        let b:view_name = a:1=~#"N" ? 0 : a:1=~#"n" ? 1 : b:view_name
        let b:view_block = a:1=~#"B" ? 0 : a:1=~#"b" ? 1 : b:view_block
        if a:1 =~# "c"
            call s:clear_match("prev")
        endif
    endif

    " a:2 the line num to parse
    if exists("a:2") && a:2 > 0  && a:2 <= line('$')
        let line = getline(a:2)
    else
        let line = getline('.')
    endif

    call colorv#prev_txt(line)
endfunction "}}}
"}}}
"INIT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:write_cache() "{{{
    let CacheStringList = []
    let file = g:ColorV_cache_File
    if len(s:his_cpd_list) < 18
        let list = deepcopy(s:his_cpd_list[0:-1])
    else
        let list = deepcopy(s:his_cpd_list[-18:-1])
    endif
    let his_txt="HISTORY_COPY\t"
    for hex in list
        let his_txt .= " ".hex
    endfor
    call add(CacheStringList,his_txt)
    call writefile(CacheStringList,file)
endfunction "}}}
function! s:load_cache() "{{{
    let file = g:ColorV_cache_File
    if !filereadable(file)
        call s:error("Could NOT read cache file. Stopped.")
    else
        let CacheStringList = readfile(file)
        for i in CacheStringList
            if i =~ 'HISTORY_COPY'
                let txt=matchstr(i,'HISTORY_COPY\s*\zs.*\ze$')
                let his_list = split(txt,'\s')
            endif
        endfor
        if exists("his_list") && !empty(his_list)
            let s:his_cpd_list=deepcopy(his_list)
        endif
    endif
endfunction "}}}

if g:ColorV_load_cache==1 "{{{
    call <SID>load_cache()
    aug colorv_cache
        au! VIMLEAVEPre * call <SID>write_cache()
    aug END
endif "}}}
if g:ColorV_prev_css==1 "{{{
    aug colorv_auto_prev
        au!  BufWinEnter *.css call colorv#preview()
        au!  bufwritepost *.css call colorv#preview()
    aug END
endif "}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"}}}
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tw=78:fdm=marker:
