"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: autoload/ColorV.vim
" Summary: A Color Viewer and Color Picker for Vim
"  Author: Rykka.Krin <rykka.krin@gmail.com>
"    Home: 
" Version: 2.5.1 
" Last Update: 2011-09-02
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

" if !has("gui_running") || v:version < 700 || exists("g:colorV_loaded")
if version < 700 || exists("g:ColorV_loaded")
    finish
endif
let g:ColorV_loaded = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GVAR: "{{{1 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ColorV={}
let g:ColorV.name="_ColorV_"
let g:ColorV.listname="_ColorV-List_"
let g:ColorV.ver="2.5.1.0"

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

"debug 
if !exists("g:ColorV_debug")
    let g:ColorV_debug=0
endif
"debug vim func
if !exists('g:ColorV_no_python')
    let g:ColorV_no_python=0
endif
if !exists('g:ColorV_cache_File')
let g:ColorV_cache_File = expand('$HOME') . '/.vim_ColorV_cache'
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
    let g:ColorV_gen_space="yiq"
endif

"}}}
"SVAR: {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:ColorV={}
let s:mode= exists("s:mode") ? s:mode : "mid"

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
" let s:pal_clr_list=[]
" let s:valline_list=[]
" let s:satline_list=[]
" let s:hueline_list=[]
let s:his_set_rect=[43,2,5,4]
let s:his_cpd_rect=[22,7,2,1]
let s:line_width=60
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
let s:tips_list=[
            \'Choose: Click/Space/Ctrl-K',
            \'Edit:  2-Click/e/a/<CR>',
            \'Colorname(W3C): na/ne      (X11):nx',
            \'Yank(reg"): yy/yr/ys/yn/... (reg+): cc/cr/cs/cn/...',
            \'Paste: <C-V>/p',
            \'Help: F1               Tips: ?',
            \'Quit: q/Q/<C-W>q/<C-W><C-Q>',
            \]

let s:t='fghDPijmrYFGtudBevwxklyzEIZOJLMnHsaKbcopqNACQRSTUVWX'
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
let s:fmt.HSLA='hsl(\s*\d\{1,3},\s*\d\{1,3}%,\s*\d\{1,3}%,'
                \.'\s*\d\{1,3}\%(\.\d*\)\=%\=)'


let s:a='Uryyb'
let s:e='stuQCvwzeLSTghqOrijkxylmRVMBWYZaUfnXopbcdANPDEFGHIJK'

let s:aprx_rate=5
let s:tune_step=5
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
"{{{ "terminal colorlist
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
            \16: '000000', 17: '00005f', 18: '000087',
            \19: '0000af', 20: '0000d7', 21: '0000ff',
            \22: '005f00', 23: '005f5f', 24: '005f87',
            \25: '005faf', 26: '005fd7', 27: '005fff',
            \28: '008700', 29: '00875f', 30: '008787',
            \31: '0087af', 32: '0087d7', 33: '0087ff',
            \34: '00af00', 35: '00af5f', 36: '00af87',
            \37: '00afaf', 38: '00afd7', 39: '00afff',
            \40: '00d700', 41: '00d75f', 42: '00d787',
            \43: '00d7af', 44: '00d7d7', 45: '00d7ff',
            \46: '00ff00', 47: '00ff5f', 48: '00ff87',
            \49: '00ffaf', 50: '00ffd7', 51: '00ffff',
            \52: '5f0000', 53: '5f005f', 54: '5f0087',
            \55: '5f00af', 56: '5f00d7', 57: '5f00ff',
            \58: '5f5f00', 59: '5f5f5f', 60: '5f5f87',
            \61: '5f5faf', 62: '5f5fd7', 63: '5f5fff',
            \64: '5f8700', 65: '5f875f', 66: '5f8787',
            \67: '5f87af', 68: '5f87d7', 69: '5f87ff',
            \70: '5faf00', 71: '5faf5f', 72: '5faf87',
            \73: '5fafaf', 74: '5fafd7', 75: '5fafff',
            \76: '5fd700', 77: '5fd75f', 78: '5fd787',
            \79: '5fd7af', 80: '5fd7d7', 81: '5fd7ff',
            \82: '5fff00', 83: '5fff5f', 84: '5fff87',
            \85: '5fffaf', 86: '5fffd7', 87: '5fffff',
            \88: '870000', 89: '87005f', 90: '870087',
            \91: '8700af', 92: '8700d7', 93: '8700ff',
            \94: '875f00', 95: '875f5f', 96: '875f87',
            \97: '875faf', 98: '875fd7', 99: '875fff',
            \100: '878700', 101: '87875f', 102: '878787',
            \103: '8787af', 104: '8787d7', 105: '8787ff',
            \106: '87af00', 107: '87af5f', 108: '87af87',
            \109: '87afaf', 110: '87afd7', 111: '87afff',
            \112: '87d700', 113: '87d75f', 114: '87d787',
            \115: '87d7af', 116: '87d7d7', 117: '87d7ff',
            \118: '87ff00', 119: '87ff5f', 120: '87ff87',
            \121: '87ffaf', 122: '87ffd7', 123: '87ffff',
            \124: 'af0000', 125: 'af005f', 126: 'af0087',
            \127: 'af00af', 128: 'af00d7', 129: 'af00ff',
            \130: 'af5f00', 131: 'af5f5f', 132: 'af5f87',
            \133: 'af5faf', 134: 'af5fd7', 135: 'af5fff',
            \136: 'af8700', 137: 'af875f', 138: 'af8787',
            \139: 'af87af', 140: 'af87d7', 141: 'af87ff',
            \142: 'afaf00', 143: 'afaf5f', 144: 'afaf87',
            \145: 'afafaf', 146: 'afafd7', 147: 'afafff',
            \148: 'afd700', 149: 'afd75f', 150: 'afd787',
            \151: 'afd7af', 152: 'afd7d7', 153: 'afd7ff',
            \154: 'afff00', 155: 'afff5f', 156: 'afff87',
            \157: 'afffaf', 158: 'afffd7', 159: 'afffff',
            \160: 'd70000', 161: 'd7005f', 162: 'd70087',
            \163: 'd700af', 164: 'd700d7', 165: 'd700ff',
            \166: 'd75f00', 167: 'd75f5f', 168: 'd75f87',
            \169: 'd75faf', 170: 'd75fd7', 171: 'd75fff',
            \172: 'd78700', 173: 'd7875f', 174: 'd78787',
            \175: 'd787af', 176: 'd787d7', 177: 'd787ff',
            \178: 'd7af00', 179: 'd7af5f', 180: 'd7af87',
            \181: 'd7afaf', 182: 'd7afd7', 183: 'd7afff',
            \184: 'd7d700', 185: 'd7d75f', 186: 'd7d787',
            \187: 'd7d7af', 188: 'd7d7d7', 189: 'd7d7ff',
            \190: 'd7ff00', 191: 'd7ff5f', 192: 'd7ff87',
            \193: 'd7ffaf', 194: 'd7ffd7', 195: 'd7ffff',
            \196: 'ff0000', 197: 'ff005f', 198: 'ff0087',
            \199: 'ff00af', 200: 'ff00d7', 201: 'ff00ff',
            \202: 'ff5f00', 203: 'ff5f5f', 204: 'ff5f87',
            \205: 'ff5faf', 206: 'ff5fd7', 207: 'ff5fff',
            \208: 'ff8700', 209: 'ff875f', 210: 'ff8787',
            \211: 'ff87af', 212: 'ff87d7', 213: 'ff87ff',
            \214: 'ffaf00', 215: 'ffaf5f', 216: 'ffaf87',
            \217: 'ffafaf', 218: 'ffafd7', 219: 'ffafff',
            \220: 'ffd700', 221: 'ffd75f', 222: 'ffd787',
            \223: 'ffd7af', 224: 'ffd7d7', 225: 'ffd7ff',
            \226: 'ffff00', 227: 'ffff5f', 228: 'ffff87',
            \229: 'ffffaf', 230: 'ffffd7', 231: 'ffffff',
            \232: '080808', 233: '121212', 234: '1c1c1c',
            \235: '262626', 236: '303030', 237: '3a3a3a',
            \238: '444444', 239: '4e4e4e', 240: '585858',
            \241: '626262', 242: '6c6c6c', 243: '767676',
            \244: '808080', 245: '8a8a8a', 246: '949494',
            \247: '9e9e9e', 248: 'a8a8a8', 249: 'b2b2b2',
            \250: 'bcbcbc', 251: 'c6c6c6', 252: 'd0d0d0',
            \253: 'dadada', 254: 'e4e4e4', 255: 'eeeeee',
            \}
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
#{{{ rgb hex
def hex2rgb(hex): 
    if hex.startswith("#"): hex = hex[1:]
    elif hex[0:2].lower() == '0x': hex = hex[2:]
    hex=int("".join(["0X"+hex]),16)
    rgb = [(hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff ]
    return  rgb 
def rgb2hex(rgb):
    r,g,b=rgb[0],rgb[1],rgb[2]
    if isinstance(r,str):
        r=int(float(r))
    if isinstance(r,float):
        r=int(r)
    if isinstance(g,str):
        g=int(float(g))
    if isinstance(g,float):
        g=int(g)
    if isinstance(b,str):
        b=int(float(b))
    if isinstance(b,float):
        b=int(b)

    return '{:06X}'.format(( (r & 0xff) << 16) \
            + ((g & 0xff) << 8) + (b & 0xff)) 
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
EOF
endfunction "}}}

function! colorv#rgb2hsv(rgb)  "{{{
" in [r,g,b] 0~255
" out [H,S,V] 0~360 0~100
    let [r,g,b]=[s:float(a:rgb[0]),s:float(a:rgb[1]),s:float(a:rgb[2])]
    if r>255||g>255||b>255
    	call s:error("rgb2hsv():RGB out of boundary.".string(a:rgb))
        let r= r>255 ? 255 : r
        let g= g>255 ? 255 : g
        let b= b>255 ? 255 : b
    endif
if has("python") && g:ColorV_no_python!=1
    call s:py_core_load()
python << EOF
rgb=[float(vim.eval("r")),float(vim.eval("g")),float(vim.eval("b"))]
h,s,v=rgb2hsv(rgb)
vim.command("return "+str([h,s,v]))
EOF
else
    let [r,g,b]=[r/255.0,g/255.0,b/255.0]
    let max=s:fmax([r,g,b])
    let min=s:fmin([r,g,b])
    let df=max-min

    let V=max
    let S= V==0 ? 0 : df/max
    let H = max==min ? 0 : max==r ? 60.0*(g-b)/df : 
          \(max==g ? 120+60.0*(b-r)/df : 240+60.0*(r-g)/df)
    let H=round(H<0?s:fmod(H,360.0)+360:(H>360?s:fmod(H,360.0) : H))
    let H=float2nr(H)
    let S=float2nr(round(S*100))
    let V=float2nr(round(V*100))
    return [H,S,V]
endif
endfunction "}}}
function! colorv#hsv2rgb(hsv) "{{{
" in [h,s,v] 0~360 0~100
" out [R,G,B] 0~255      "Follow info from wikipedia"
    let [h,s,v]=[s:float(a:hsv[0]),s:float(a:hsv[1]),s:float(a:hsv[2])]
    let s = s>100 ? 100 : s < 0 ? 0 : s
    let v = v>100 ? 100 : v < 0 ? 0 : v
    if h>=360
        let h=s:fmod(h,360.0)
    elseif h<0
        let h=360-s:fmod(abs(h),360.0)
    endif
if has("python") && g:ColorV_no_python!=1
    call s:py_core_load()
python << EOF
hsv=[float(vim.eval("h")),float(vim.eval("s")),float(vim.eval("v"))]
r,g,b=hsv2rgb(hsv)
vim.command("return "+str([r,g,b]))
EOF
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
    let R=float2nr(round(R))
    let G=float2nr(round(G))
    let B=float2nr(round(B))
    return [R,G,B]
endif
endfunction "}}}
function! colorv#hex2hsv(hex) "{{{
   let hex=s:fmt_hex(a:hex)
   return colorv#rgb2hsv(colorv#hex2rgb(hex))
endfunction "}}}
function! colorv#hsv2hex(hsv) "{{{
    return colorv#rgb2hex(colorv#hsv2rgb(a:hsv))
endfunction "}}}

function! colorv#rgb2hex(rgb)   "{{{
" in [r,g,b] num/str
" out ffffff
    let [r,g,b]=[s:number(a:rgb[0]),s:number(a:rgb[1]),s:number(a:rgb[2])]
    if r>255||g>255||b>255
    	call s:error("rgb2hex():RGB out of boundary.".string(a:rgb))
        let r= r>255 ? 255 : r
        let g= g>255 ? 255 : g
        let b= b>255 ? 255 : b
    endif
    let hex=printf("%06x",r*0x10000+g*0x100+b*0x1)
    let hex=substitute(hex,'\l','\u\0','g')
    
   return hex
endfunction "}}}
function! colorv#hex2rgb(hex) "{{{
" in ffffff
" out [r,g,b]
   let hex=s:fmt_hex(a:hex)
   return [str2nr(hex[0:1],16),str2nr(hex[2:3],16),str2nr(hex[4:5],16)]
endfunction "}}}

function! colorv#rgb2hls(rgb) "{{{
    let [r,g,b]=[s:float(a:rgb[0]),s:float(a:rgb[1]),s:float(a:rgb[2])]
    if r>255||g>255||b>255
    	call s:error("rgb2hls():RGB out of boundary.".string(a:rgb))
        let r= r>255 ? 255 : r
        let g= g>255 ? 255 : g
        let b= b>255 ? 255 : b
    endif
if has("python") && g:ColorV_no_python!=1
    call s:py_core_load()
python << EOF
rgb=[float(vim.eval("r")),float(vim.eval("g")),float(vim.eval("b"))]
h,l,s=rgb2hls(rgb)
vim.command("return "+str([h,l,s]))
EOF
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
    let H=float2nr(H)
    let S=float2nr(round(S*100))
    let L=float2nr(round(L*100))
    return [H,L,S]
endif
endfunction "}}}
function! colorv#hls2rgb(hls) "{{{
    let [h,l,s]=[s:float(a:hls[0]),s:float(a:hls[1]),s:float(a:hls[2])]
    let s = s>100 ? 100 : s < 0 ? 0 : s
    let l = l>100 ? 100 : l < 0 ? 0 : l
    if h>=360
        let h=s:fmod(h,360.0)
    elseif h<0
        let h=360-s:fmod(abs(h),360.0)
    endif
if has("python") && g:ColorV_no_python!=1
    call s:py_core_load()
python << EOF
hls=[float(vim.eval("h")),float(vim.eval("l")),float(vim.eval("s"))]
r,g,b=hls2rgb(hls)
vim.command("return "+str([r,g,b]))
EOF
else
    let [s,l]=[s/100.0,l/100.0]
    if s==0
    	let [r,g,b]=[l,l,l]
    else
    	if l<0.5
            let var_1= l *(1+s)
        else
            let var_1= l+s-(s*l)
        endif
        let var_2=2*l-var_1
        function! H2rgb(v1,v2,vh) "{{{
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
        let r= H2rgb(var_1,var_2,(h+1.0/3))
        let g= H2rgb(var_1,var_2,h)
        let b= H2rgb(var_1,var_2,(h-1.0/3))
    endif
    let r=float2nr(round(r*255))
    let g=float2nr(round(g*255))
    let b=float2nr(round(b*255))
    return [r,g,b]
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
    if r>255||g>255||b>255
    	call s:error("rgb2yuv():RGB out of boundary.".string(a:rgb))
        let r= r>255 ? 255 : r
        let g= g>255 ? 255 : g
        let b= b>255 ? 255 : b
    endif
    let [r,g,b]=[r/255.0,g/255.0,b/255.0]
    let Y=0.299*r+0.587*g+0.114*b
    let U=-0.147*r-0.289*g+0.436*b
    let V=0.615*r-0.515*g-0.100*b
    " return [Y*100,U*100,V*100]
    return [float2nr(round(Y*100)),float2nr(round(U*100)),
                \float2nr(round(V*100))]
endfunction "}}}
function! colorv#yuv2rgb(yuv) "{{{
    let [Y,U,V]=s:float(a:yuv)
    let [Y,U,V]=[Y/100.0,U/100.0,V/100.0]
    if Y>100||U>100||V>100 || Y<-100||U<-100||V<-100
        let Y= Y>100 ? 100 : Y<0 ? 0 : Y
        let U= U>100 ? 100 : U<-100 ? -100 : U
        let V= V>100 ? 100 : V<-100 ? -100 : V
    endif
    let R = Y + 1.14 *V
    let G = Y - 0.395*U - 0.581*V
    let B = Y + 2.032*U
    if R>1 || G>1 || B>1 || R<0 || G<0 || B<0
    	call s:error("Invalid RGB for with YUV".string(a:yuv))
        let R = R>1 ? 1 : R<0 ? 0 : R
        let G = G>1 ? 1 : G<0 ? 0 : G
        let B = B>1 ? 1 : B<0 ? 0 : B
    endif
    " return [R*255,G*255,B*255]
    return [float2nr(round(R*255.0)),float2nr(round(G*255.0)),
                \float2nr(round(B*255.0))]
endfunction "}}}

"YIQ color space (NTSC)
function! colorv#rgb2yiq(rgb) "{{{
    let [r,g,b]=s:float(a:rgb)
    if r>255||g>255||b>255
    	call s:error("rgb2yiq():RGB out of boundary.".string(a:rgb))
        let r= r>255 ? 255 : r
        let g= g>255 ? 255 : g
        let b= b>255 ? 255 : b
    endif
if has("python") && g:ColorV_no_python!=1
    call s:py_core_load()
python << EOF
rgb=[float(vim.eval("r")),float(vim.eval("g")),float(vim.eval("b"))]
y,i,q=rgb2yiq(rgb)
vim.command("return "+str([y,i,q]))
EOF
else
    let [r,g,b]=[r/255.0,g/255.0,b/255.0]
    let Y=  0.299 *r + 0.587 *g+ 0.114 *b
    let I=  0.5957*r +-0.2745*g+-0.3213*b
    let Q=  0.2115*r +-0.5226*g+ 0.3111*b
    " return [Y*100,U*100,V*100]
    return [round(Y*100),round(I*100),round(Q*100)]
endif
endfunction "}}}
function! colorv#yiq2rgb(yiq) "{{{
    let [y,i,q]=s:float(a:yiq)
    if y>100||i>100||q>100 ||i<-100||q<-100
        let y= y>100 ? 100 : y<0 ? 0 : y
        let i= i>100 ? 100 : i<-100 ? -100 : i
        let q= q>100 ? 100 : q<-100 ? -100 : q
    endif
if has("python") && g:ColorV_no_python!=1
    call s:py_core_load()
python << EOF
yiq=[float(vim.eval("y")),float(vim.eval("i")),float(vim.eval("q"))]
r,g,b=yiq2rgb(yiq)
vim.command("return "+str([r,g,b]))
EOF
else
    let [y,i,q]=[y/100.0,i/100.0,q/100.0]
    let r = y + 0.9563*i+ 0.6210*q
    let g = y - 0.2721*i- 0.6474*q
    let b = y - 1.1070*i+ 1.7046*q
    if r>1 || g>1 || b>1 || r<0 || g<0 || b<0
    	" call s:error("Invalid RGB for with YIQ".string(a:yiq))
        let r = r>1 ? 1 : r<0 ? 0 : r
        let g = g>1 ? 1 : g<0 ? 0 : g
        let b = b>1 ? 1 : b<0 ? 0 : b
    endif
    " return [R*255,G*255,B*255]
    return [float2nr(round(r*255.0)),float2nr(round(g*255.0)),
                \float2nr(round(b*255.0))]
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
" in [r,g,b]
" out [L,a,b]
    let [r,g,b]=[s:float(a:rgb[0]),s:float(a:rgb[1]),s:float(a:rgb[2])] 
    if r>255||g>255||b>255
            call s:error("rgb2lab():RGB out of boundary.".string(a:rgb))
            let r= r>255 ? 255 : r
            let g= g>255 ? 255 : g
            let b= b>255 ? 255 : b
    " 	return -1
    endif
    
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

    let r = r * 100
    let g = g * 100
    let b = b * 100

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
    let [R,G,B]=s:float(a:rgb)
    if R>255||G>255||B>255
        let R=s:fmod(R,256.0)
        let G=s:fmod(G,256.0)
        let B=s:fmod(B,256.0)
    endif
    let [R,G,B]=[R/255.0,G/255.0,B/255.0]
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
    return [C,M,Y,K]
endfunction "}}}
function! colorv#cmyk2rgb(cmyk) "{{{
    let [C,M,Y,K]=s:float(a:cmyk)
    let C=C*(1-K)+K
    let M=M*(1-K)+K
    let Y=Y*(1-K)+K
    let R=float2nr(round((1-C)*255))
    let G=float2nr(round((1-M)*255))
    let B=float2nr(round((1-Y)*255))
    return [R,G,B]
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
            16: '000000', 17: '00005f', 18: '000087',
            19: '0000af', 20: '0000d7', 21: '0000ff',
            22: '005f00', 23: '005f5f', 24: '005f87',
            25: '005faf', 26: '005fd7', 27: '005fff',
            28: '008700', 29: '00875f', 30: '008787',
            31: '0087af', 32: '0087d7', 33: '0087ff',
            34: '00af00', 35: '00af5f', 36: '00af87',
            37: '00afaf', 38: '00afd7', 39: '00afff',
            40: '00d700', 41: '00d75f', 42: '00d787',
            43: '00d7af', 44: '00d7d7', 45: '00d7ff',
            46: '00ff00', 47: '00ff5f', 48: '00ff87',
            49: '00ffaf', 50: '00ffd7', 51: '00ffff',
            52: '5f0000', 53: '5f005f', 54: '5f0087',
            55: '5f00af', 56: '5f00d7', 57: '5f00ff',
            58: '5f5f00', 59: '5f5f5f', 60: '5f5f87',
            61: '5f5faf', 62: '5f5fd7', 63: '5f5fff',
            64: '5f8700', 65: '5f875f', 66: '5f8787',
            67: '5f87af', 68: '5f87d7', 69: '5f87ff',
            70: '5faf00', 71: '5faf5f', 72: '5faf87',
            73: '5fafaf', 74: '5fafd7', 75: '5fafff',
            76: '5fd700', 77: '5fd75f', 78: '5fd787',
            79: '5fd7af', 80: '5fd7d7', 81: '5fd7ff',
            82: '5fff00', 83: '5fff5f', 84: '5fff87',
            85: '5fffaf', 86: '5fffd7', 87: '5fffff',
            88: '870000', 89: '87005f', 90: '870087',
            91: '8700af', 92: '8700d7', 93: '8700ff',
            94: '875f00', 95: '875f5f', 96: '875f87',
            97: '875faf', 98: '875fd7', 99: '875fff',
            100: '878700', 101: '87875f', 102: '878787',
            103: '8787af', 104: '8787d7', 105: '8787ff',
            106: '87af00', 107: '87af5f', 108: '87af87',
            109: '87afaf', 110: '87afd7', 111: '87afff',
            112: '87d700', 113: '87d75f', 114: '87d787',
            115: '87d7af', 116: '87d7d7', 117: '87d7ff',
            118: '87ff00', 119: '87ff5f', 120: '87ff87',
            121: '87ffaf', 122: '87ffd7', 123: '87ffff',
            124: 'af0000', 125: 'af005f', 126: 'af0087',
            127: 'af00af', 128: 'af00d7', 129: 'af00ff',
            130: 'af5f00', 131: 'af5f5f', 132: 'af5f87',
            133: 'af5faf', 134: 'af5fd7', 135: 'af5fff',
            136: 'af8700', 137: 'af875f', 138: 'af8787',
            139: 'af87af', 140: 'af87d7', 141: 'af87ff',
            142: 'afaf00', 143: 'afaf5f', 144: 'afaf87',
            145: 'afafaf', 146: 'afafd7', 147: 'afafff',
            148: 'afd700', 149: 'afd75f', 150: 'afd787',
            151: 'afd7af', 152: 'afd7d7', 153: 'afd7ff',
            154: 'afff00', 155: 'afff5f', 156: 'afff87',
            157: 'afffaf', 158: 'afffd7', 159: 'afffff',
            160: 'd70000', 161: 'd7005f', 162: 'd70087',
            163: 'd700af', 164: 'd700d7', 165: 'd700ff',
            166: 'd75f00', 167: 'd75f5f', 168: 'd75f87',
            169: 'd75faf', 170: 'd75fd7', 171: 'd75fff',
            172: 'd78700', 173: 'd7875f', 174: 'd78787',
            175: 'd787af', 176: 'd787d7', 177: 'd787ff',
            178: 'd7af00', 179: 'd7af5f', 180: 'd7af87',
            181: 'd7afaf', 182: 'd7afd7', 183: 'd7afff',
            184: 'd7d700', 185: 'd7d75f', 186: 'd7d787',
            187: 'd7d7af', 188: 'd7d7d7', 189: 'd7d7ff',
            190: 'd7ff00', 191: 'd7ff5f', 192: 'd7ff87',
            193: 'd7ffaf', 194: 'd7ffd7', 195: 'd7ffff',
            196: 'ff0000', 197: 'ff005f', 198: 'ff0087',
            199: 'ff00af', 200: 'ff00d7', 201: 'ff00ff',
            202: 'ff5f00', 203: 'ff5f5f', 204: 'ff5f87',
            205: 'ff5faf', 206: 'ff5fd7', 207: 'ff5fff',
            208: 'ff8700', 209: 'ff875f', 210: 'ff8787',
            211: 'ff87af', 212: 'ff87d7', 213: 'ff87ff',
            214: 'ffaf00', 215: 'ffaf5f', 216: 'ffaf87',
            217: 'ffafaf', 218: 'ffafd7', 219: 'ffafff',
            220: 'ffd700', 221: 'ffd75f', 222: 'ffd787',
            223: 'ffd7af', 224: 'ffd7d7', 225: 'ffd7ff',
            226: 'ffff00', 227: 'ffff5f', 228: 'ffff87',
            229: 'ffffaf', 230: 'ffffd7', 231: 'ffffff',
            232: '080808', 233: '121212', 234: '1c1c1c',
            235: '262626', 236: '303030', 237: '3a3a3a',
            238: '444444', 239: '4e4e4e', 240: '585858',
            241: '626262', 242: '6c6c6c', 243: '767676',
            244: '808080', 245: '8a8a8a', 246: '949494',
            247: '9e9e9e', 248: 'a8a8a8', 249: 'b2b2b2',
            250: 'bcbcbc', 251: 'c6c6c6', 252: 'd0d0d0',
            253: 'dadada', 254: 'e4e4e4', 255: 'eeeeee',
            }
#}}}
def hex2term16(hex1): #{{{
    best_match = 0
    smallest_distance = 10000000
    r1,g1,b1 =hex2rgb(hex1)
    for c in range(16):
        r2,g2,b2 = hex2rgb(tmclr_dict[c])
        d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < smallest_distance:
            smallest_distance = d
            best_match = c
    return best_match #}}}
def hex2term8(hex1): #{{{
    best_match = 0
    smallest_distance = 10000000
    r1,g1,b1 =hex2rgb(hex1)
    for c in range(16):
        r2,g2,b2 = hex2rgb(tmclr8_dict[c])
        d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < smallest_distance:
            smallest_distance = d
            best_match = c
    return best_match #}}}
def hex2term_d6(hex1): #{{{
    '''calculate the term clr index'''
    #The disadvantage is there is a colorful-line in low lightness colors.
    r1,g1,b1 = hex2rgb(hex1)
    m1=0
    if r1 <= 47    : n1=0
    elif r1 <= 115 : n1=1
    elif r1 <= 155 : n1=2
    elif r1 <= 195 : n1=3
    elif r1 <= 235 : n1=4
    else:            n1=5
    if   g1 <= 47  : n2=0 
    elif g1 <= 115 : n2=1
    elif g1 <= 155 : n2=2
    elif g1 <= 195 : n2=3
    elif g1 <= 235 : n2=4
    else:            n2=5
    if   b1 <= 47  : n3=0
    elif b1 <= 115 : n3=1
    elif b1 <= 155 : n3=2
    elif b1 <= 195 : n3=3
    elif b1 <= 235 : n3=4
    else:            n3=5
    if   n1==n2==n3 and 91<=r1<=96:
    	return 59
    elif n1==n2==n3 and 131<=r1<=136:
    	return 102
    elif n1==n2==n3 and 171<=r1<=176:
    	return 145
    elif n1==n2==n3 and 211<=r1<=216:
    	return 188
    elif n1==n2==n3 and 244<=r1:
    	return 231
    elif n1==n2==n3 and r1<=4:
    	return 16
    elif n1==n2==n3:
    	return (r1-5)/10+232
    else:
    	return 16+n1*36+n2*6+n3 #}}}
def hex2term_d4(hex1): #{{{
    best_match = 0
    smallest_distance = 10000000
    r1,g1,b1 = hex2rgb(hex1)
    if   r1 <= 47  : n1,m1=16,36
    elif r1 <= 115 : n1,m1=52,36
    elif r1 <= 155 : n1,m1=88,36
    elif r1 <= 195 : n1,m1=124,36
    elif r1 <= 235 : n1,m1=160,36
    else:            n1,m1=196,0
    if   g1 <= 47  : n2,m2=0,0 
    elif g1 <= 115 : n2,m2=6,24
    elif g1 <= 155 : n2,m2=12,18
    elif g1 <= 195 : n2,m2=18,12
    elif g1 <= 235 : n2,m2=24,6
    else: n2,m2=30,30
    if   b1 <= 47  : n3,m3=0,6
    elif b1 <= 115 : n3,m3=1,10
    elif b1 <= 155 : n3,m3=2,14
    elif b1 <= 195 : n3,m3=3,18
    elif b1 <= 235 : n3,m3=4,22
    else: n3,m3=5,24
    # for c in range(n1,n1)+range(232+n3*3,232+m3):
    for c in range(n1,n1+m1)+range(232+n3*3,232+m3):
    # for c in [n1+n2+n3]+range(232+n3*3,232+m3):
    # for c in range(16,256):
        r2,g2,b2 = hex2rgb(tmclr_dict[c])
        dr,dg,db=abs(r1-r2),abs(g1-g2),abs(b1-b2)
        if r2==g2==b2:
            d=dr+dg+db+35
        else:
            d=dr+dg+db
        if d < smallest_distance:
            smallest_distance = d
            best_match = c
    return best_match 
    #}}}

EOF
endfunction "}}}
function! colorv#hex2term(hex,...) "{{{
" in: hex, CHECK
"return term 256 color
"vim is much slower than python code.
"So use python by default.
    if exists("a:1") 
    	if (&t_Co<=8 && a:1==#"CHECK") || a:1==8
            if has("python") && g:ColorV_no_python!=1
                return s:p_hex2term8(a:hex)
            else
                return s:v_hex2term8(a:hex)
            endif
        elseif (&t_Co<=16 && a:1=="CHECK") || a:1==16
            if has("python") && g:ColorV_no_python!=1
                return s:p_hex2term16(a:hex)
            else
                return s:v_hex2term16(a:hex)
            endif
        endif
    endif
    "256
    if has("python") && g:ColorV_no_python!=1
        return s:p3_hex2term(a:hex)
    else
        return s:v3_hex2term(a:hex)
    endif
endfunction "}}}

function! s:p_hex2term8(hex) "{{{
    call s:py_term_load()
python << EOF
vim.command("return "+str(hex2term8(vim.eval("a:hex"))))
EOF
endfunction "}}}
function! s:p_hex2term16(hex) "{{{
    call s:py_term_load()
python << EOF
vim.command("return "+str(hex2term16(vim.eval("a:hex"))))
EOF
endfunction "}}}
function! s:p3_hex2term(hex) "{{{
    call s:py_term_load()
python <<EOF
vim.command("return "+str(hex2term_d4(vim.eval("a:hex"))))
EOF
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
function! s:v3_hex2term(hex) "{{{
    let best_match=0
    let smallest_distance = 10000000
    let [r1,g1,b1] = colorv#hex2rgb(a:hex)
    if r1 <= 45 | let n1=16 
    elseif r1 <= 115 | let n1=52
    elseif r1 <= 155 | let n1= 88
    elseif r1 <= 195 | let n1=124
    elseif r1 <= 235 | let n1=160
    else | let n1=196
    endif
    if   g1 <= 47  | let n2=0 
    elseif g1 <= 115 | let n2=6
    elseif g1 <= 155 | let n2=12
    elseif g1 <= 195 | let n2=18
    elseif g1 <= 235 | let n2=24
    else| let n2=30
    endif
    if   b1 <= 47  | let [n3,n4]=[0,6]
    elseif b1 <= 115 | let [n3,n4]=[1,10]
    elseif b1 <= 155 | let [n3,n4]=[2,14]
    elseif b1 <= 195 | let [n3,n4]=[3,18]
    elseif b1 <= 235 | let [n3,n4]=[4,22]
    else| let [n3,n4]=[5,24]
    endif
    for c in [n1+n2+n3]+range(232+n3*3,231+n4)
        let [r2,g2,b2] = colorv#hex2rgb(s:term_dict[c])
        let [dr,dg,db]=[abs(r1-r2),abs(g1-g2),abs(b1-b2)]
        if r2==g2 && g2==b2
            let d=dr+dg+db+35
        else
            let d=dr+dg+db
        endif
        
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
    "{{{
python << EOF
def draw_palette(H,he,wi,*off): #{{{
    vim.command("call s:clear_palmatch()")
    if len(off)>1: y_off=off[1]
    else:y_off=1
    if len(off)>0: x_off=off[0]; 
    else:x_off=0
    pal_clr_list=[]
    cmd_list=[]
    H=fmod(H,360)
    line = 1
    while line <= he:
        # L is V.
        L=100.0-(line-1)*100.0/(he)
        col=1
        while col<=wi:
            S=100.0-(col-1)*100.0/(wi-1)
            if vim.eval("s:space")=="hls":
                hex=rgb2hex(hls2rgb([H,S,L]))
            else:
                hex=rgb2hex(hsv2rgb([H,S,L]))
            pal_clr_list.append(hex)
            
            hi_grp="".join(["cv_pal_",hex])
            hi_cmd="".join(["call colorv#hi_color('",hi_grp,"','",hex,"','",hex,"')"])
            cmd_list.append(hi_cmd)
            pos_ptn="".join(["\\%",str(line+y_off),"l\\%",str(col+x_off),"c"])
            match_cmd="".join(["let s:pallet_dict['",hi_grp,"']=matchadd('",hi_grp,"','",pos_ptn,"')"])
            cmd_list.append(match_cmd)
            col+=1
        line+=1
    for cmd in cmd_list:
    	vim.command(cmd)
    vim.command("".join(["let s:pal_clr_list=",str(pal_clr_list)]))
#}}}
def draw_pallete_hex(hex): #{{{
    h,s,v=rgb2hsv(hex2rgb(hex))
    y,x=int(vim.eval("s:pal_H")),int(vim.eval("s:pal_W"))
    draw_palette(h,y,x)
#}}}

def draw_hueline(l,*stats): #{{{
    vim.command("call  s:clear_hsvmatch()")
    if vim.eval("g:ColorV.HSV.S")=="0":
        vim.command("if !exists('s:prv_H') | let s:prv_H=0 |endif ")
    	H=float(vim.eval("s:prv_H"))
    else:
        vim.command("let s:prv_H= g:ColorV.HSV.H")
        H=float(vim.eval("g:ColorV.HSV.H"))
    step = 18
    if vim.eval("s:space")=="hls" and vim.eval("s:mode")!="min":
        H+=11*step
    S=100
    V=100
    width=20
    x=0
    poff_x=0
    hueline_list=[]
    cmd_list=[]
    while x < width:
        hi_grp="cv_hue_"+str(x)
        hex=rgb2hex(hsv2rgb([H,S,V]))
        hueline_list.append(hex)
        hi_cmd="call colorv#hi_color(\""+hi_grp+"\",\""+hex+"\",\""+hex+"\")"
        cmd_list.append(hi_cmd)
        pos_ptn="\\%"+str(l)+"l\\%"+str(x+1+poff_x)+"c"
        match_cmd="let s:hsv_dict['"+hi_grp+"']=matchadd('"+hi_grp+"','"+pos_ptn+"')"
        cmd_list.append(match_cmd)
        H+=step
        x+=1
    for cmd in cmd_list:
    	vim.command(cmd)
    vim.command("let s:hueline_list="+str(hueline_list))
#}}}

class color: #{{{
    def __init__(self,hex):
        self.hex='{:06X}'.format(int("0X"+hex,16))
        self.rgb=hex2rgb(hex)
        self.r,self.g,self.b=self.rgb

    def getRGB(self):
        return self.rgb
    def getHEX(self):
        return self.hex
    def getHSV(self):
        return rgb2hsv(self.rgb)
    def getYIQ(self):
        return rgb2yiq(self.rgb)
    def getLAB(self):
        return rgb2hsv(self.rgb)
    def getXYZ(self):
        return rgb2hsv(self.rgb)
    def getYUV(self):
        return rgb2hsv(self.rgb)
#}}}
EOF
"}}}
endfunction "}}}
function! s:p_draw_hueline(l) "{{{
    call s:py_draw_load()
python << EOF
draw_hueline(vim.eval("a:l"))
EOF
endfunction "}}}
function! s:p_draw_palette_hex(hex) "{{{
    call s:py_draw_load()
python << EOF
draw_pallete_hex(vim.eval("a:hex"))
EOF
endfunction "}}}

function! s:draw_palette(h,l,c,...) "{{{
"Input: h,l,c,[loffset,coffset]
    call s:clear_palmatch()
    let [h,height,width]=[a:h,a:l,a:c]
    let h_off=exists("a:1") ? a:1 : s:poff_y
    let w_off=exists("a:2") ? a:2 : s:poff_x
    if height>100 || width>100 || height<0 || width<0
    	call s:error("error palette input")
    	return -1
    endif
    let h=s:fmod(h,360.0)
    
    let s:pal_clr_list=[]

    let line=1
    while line<=height
        let v=100-(line-1)*100.0/height
        let v= v==0 ? 1 : v 
        let col =1
        while col<=width
            let s=100-(col-1)*(100.0/width-1)
            let s= s==0 ? 1 : s 
            if s:space=="hls"
                let hex=colorv#rgb2hex(colorv#hls2rgb([h,s,v]))
            else
                let hex=colorv#hsv2hex([h,s,v])
            endif
            let hi_grp="cv_pal_".hex
            call colorv#hi_color(hi_grp,hex,hex)
            let pos_ptn="\\%".(line+h_off)."l\\%".(col+w_off)."c"
            call add(s:pal_clr_list,hex)
            
            " Add hl match to pallet_dict
            if !exists("s:pallet_dict")|let s:pallet_dict={}|endif
            let s:pallet_dict[hi_grp]=matchadd(hi_grp,pos_ptn)

            let col+=1
        endwhile
        let line+=1
    endwhile
endfunction
"}}}
function! s:draw_palette_hex(hex,...) "{{{
    if has("python") && g:ColorV_no_python!=1
    	call s:p_draw_palette_hex(a:hex)
    else
        let [h,s,v]=colorv#hex2hsv(a:hex)
        let g:ColorV.HSV.H=h
        if exists("a:1") && len(a:1) == 2
            call s:draw_palette(h,
                        \a:1[0],a:1[1],s:poff_y,s:poff_x)
        else
            call s:draw_palette(h,
                        \s:pal_H,s:pal_W,s:poff_y,s:poff_x)
        endif
    endif
endfunction "}}}
function! s:draw_multi_block(rectangle,hex_list) "{{{
"Input: rectangle[x,y,w,h] hex_list[ffffff,ffffff]
    let [x,y,w,h]=a:rectangle                  
    let block_clr_list=a:hex_list

    for idx in range(len(block_clr_list))
        let hex=block_clr_list[idx]
        let hi_grp="cv_blk".block_clr_list[idx]
        call colorv#hi_color(hi_grp,hex,hex)
        
        let Block_ptn="\\%>".(x+w*idx-1)."c\\%<".(x+w*(idx+1)).
                    \"c\\%>".(y-1)."l\\%<".(y+h)."l"
        if !exists("s:block_dict")|let s:block_dict={}|endif
        let s:block_dict[hi_grp]=matchadd(hi_grp,Block_ptn)
    endfor
endfunction "}}}
function! s:draw_history_set(hex) "{{{
    let hex= strpart(printf("%06x",'0x'.a:hex),0,6) 
    let len=len(s:his_set_list)
    let s:his_color2= len >2 ? s:his_set_list[len-3] : 'ffffff'
    let s:his_color1= len >1 ? s:his_set_list[len-2] : 'ffffff'
    let s:his_color0= len >0 ? s:his_set_list[len-1] : hex
    call s:draw_multi_block(s:his_set_rect,[s:his_color0,s:his_color1,s:his_color2])
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
    call s:draw_multi_block(s:his_cpd_rect,clr_list)
endfunction "}}}

function! s:draw_hueline(l,...) "{{{
    if has("python") && g:ColorV_no_python!=1
        call s:p_draw_hueline(a:l)
        return
    endif
    call  s:clear_hsvmatch()

   " if exists("g:ColorV_dynamic_hue") && g:ColorV_dynamic_hue==1
   "      let h=g:ColorV.HSV.H
   "      let step=exists("a:2") ? a:2 : 6
   "  else 
   "      let h=0
   "      let step=exists("a:2") ? a:2 : exists("a:1") ? 
   "              \( a:1 != 0 ? (360/a:1) : 20 ) : 20
   "  endif
    if g:ColorV.HSV.S==0
        let h=!exists("s:prv_H") ? 0 : s:prv_H
    else
        let s:prv_H= g:ColorV.HSV.H
        let h =s:prv_H
    endif
    let step=exists("a:2") ? a:2 : 360/20
    if s:space=="hls" && s:mode!="min"
        let h +=11*step
    endif

    let s=100
    let v=100
    let l=a:l
    let width=exists("a:1") ? a:1 : s:pal_W
    let x=0
    let s:hueline_list=[]
    while x < width
        let hi_grp="cv_hue_".x 
        let hex=colorv#hsv2hex([h,s,v])
        " exec "hi ".hi_grp." guifg=#".hex." guibg=#".hex
        call colorv#hi_color(hi_grp,hex,hex)
        let pos="\\%".l."l\\%".(x+1+s:poff_x)."c"

        if !exists("s:hsv_dict")|let s:hsv_dict={}|endif
        let s:hsv_dict[hi_grp]=matchadd(hi_grp,pos)
        call add(s:hueline_list,hex)
        let h+=step
        let x+=1
    endwhile
endfunction "}}}
function! s:draw_satline(l,...) "{{{
    if g:ColorV.HSV.S==0
        let h=!exists("s:prv_H") ? 0 : s:prv_H
    else
        let h =g:ColorV.HSV.H
    endif
    let s=100
    let v=100
    let l=a:l
    let width=exists("a:1") ? a:1 : s:pal_W
    let step=exists("a:2") ? a:2 : exists("a:1") ? 
                \( a:1 != 0 ? (100/a:1) : 5 ) : 5
    let x=0
    let s:satline_list=[]
    while x < width
        
        let hi_grp="cv_sat_".x 
        " if s:space=="hls"
        "     let hex=colorv#rgb2hex(colorv#hls2rgb([h,s,v]))
        " else
            let hex=colorv#hsv2hex([h,s,v])
        " endif
        " exec "hi ".hi_grp." guifg=#".hex." guibg=#".hex
        call colorv#hi_color(hi_grp,hex,hex)
        
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
    let col=1
    let s:valline_list=[]
    while col <= width
        let v=100.0-(col-1)*step
        
        let hi_grp="cv_val_".col 
        if s:space=="hls"
            let hex=colorv#rgb2hex(colorv#hls2rgb([h,v,s]))
        else
            let hex=colorv#hsv2hex([h,s,v])
        endif
        call colorv#hi_color(hi_grp,hex,hex)
        
        let pos="\\%".l."l\\%".(col+s:poff_x)."c"

        let s:hsv_dict[hi_grp]=matchadd(hi_grp,pos)
        call add(s:valline_list,hex)

        if v<=0
            let v=0
        endif
        let col+=1

    endwhile
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
        if exists("a:1")
            if &t_Co==8
            	if hl_fg >=8
                    let hl_fmt=" cterm=bold,".a:1
                    let hl_fg-=8
                else
                    let hl_fmt=" cterm=".a:1
                endif
                if hl_bg>=8
                    let hl_bg-=8
                endif
            else
                let hl_fmt=" cterm=".a:1
            endif
        else
            if &t_Co==8 
            	if hl_fg >=8
                    let hl_fmt=" cterm=bold"
                    let hl_fg-=8
                else
                    let hl_fmt=""
                endif
                if hl_bg>=8
                    let hl_bg-=8
                endif
            else
                let hl_fmt=""
            endif
        endif
        let hl_fg = string(hl_fg)=="" ? "" : " ctermfg=".hl_fg
        let hl_bg = string(hl_bg)=="" ? "" : " ctermbg=".hl_bg
    endif
    try
        exec "hi ".hl_grp.hl_fg.hl_bg.hl_fmt
    catch
        call s:debug("hi ".hl_grp.hl_fg.hl_bg.hl_fmt)
    endtry
endfunction "}}}
function! s:hi_link(from,to) "{{{
    exe "hi link ". a:from . " " . a:to
endfunction "}}}
function! s:update_his_set(hex) "{{{
    let hex= printf("%06x",'0x'.a:hex) 
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
    let hex= strpart(printf("%06x",'0x'.a:hex),0,6) 
    let hex=substitute(hex,'\l','\u\0','g')
    let g:ColorV.HEX=hex
    let [r,g,b]= colorv#hex2rgb(hex)
    let [h,s,v]= colorv#rgb2hsv([r,g,b])
    let [H,L,S]= colorv#rgb2hls([r,g,b])
    let [Y,I,Q]= colorv#rgb2yiq([r,g,b])
    let g:ColorV.NAME=s:hex2nam(hex)
    let g:ColorV.HSV.H=h
    let g:ColorV.HSV.S=s
    let g:ColorV.HSV.V=v
    let g:ColorV.HLS.H=H
    let g:ColorV.HLS.S=S
    let g:ColorV.HLS.L=L
    let g:ColorV.YIQ.Y=Y
    let g:ColorV.YIQ.I=I
    let g:ColorV.YIQ.Q=Q
    let g:ColorV.RGB.R=r
    let g:ColorV.RGB.G=g
    let g:ColorV.RGB.B=b
    let g:ColorV.rgb=[r,g,b]
    let g:ColorV.hsv=[h,s,v]
    let g:ColorV.hls=[H,L,S]
    let g:ColorV.hsl=[H,S,L]
    let g:ColorV.yiq=[Y,I,Q]

    if exists("s:update_call") && s:update_call ==1 && exists("s:update_func")
    	if exists("s:update_arg") 
            call call(s:update_func,s:update_arg)
        else
            call call(s:update_func,[])
        endif
        " BACK to COLORV window
        if !exists('t:ColorVBufName')
            call s:error("ColorV window.NO update_call")
            if exists("s:update_call") 
                if exists("s:update_arg") 
                    unlet s:update_arg
                endif
                unlet s:update_call
                unlet s:update_func
            endif
            return -1
        else
            if s:is_open()
                call s:exec(s:get_win_num() . " wincmd w")
            else
                silent! exec splitLocation . ' split'
                silent! exec "buffer " . t:ColorVBufName
            endif
        endif
    endif
endfunction "}}}
function! s:hi_misc() "{{{
    call s:clear_miscmatch()

    let [l,c]=s:get_star_pos()
    if s:mode=="min"
        let bg=s:valline_list[c-1]
    else
        let idx=(l-s:poff_y-1)*s:pal_W+c-s:poff_x-1
        let bg=s:pal_clr_list[idx]
    endif
    let fg= s:rlt_clr(bg)
    call colorv#hi_color("cv_star",fg,bg,"Bold")
    let star_ptn='\%<'.(s:pal_H+1+s:poff_y).'l\%<'.
                \(s:pal_W+1+s:poff_x).'c\*'
    let s:misc_dict["cv_star"]=matchadd("cv_star",star_ptn,40)
    if s:mode=="min"
        let [l,c]=s:get_bar_pos()
        let bg= s:satline_list[c-1]
        let fg= s:rlt_clr(bg)
        call colorv#hi_color("cv_bar",fg,bg,"Bold")
        let bar_ptn='\%2l\%<'.
                    \(s:pal_W+1+s:poff_x).'c+'
        let s:misc_dict["cv_bar"]=matchadd("cv_bar",bar_ptn,20)
    endif


    " tip text highlight
    if s:mode!="min" 
        let tip_ptn='\%'.(s:pal_H+1).'l\%>21c\%<60c'
        let q_ptn='\%'.(s:pal_H+1).'l\%>21c\%<60c[mM?]'
        call s:hi_link("cv_tip","SpecialComment")
        call s:hi_link("cv_q","TODO")
        let s:misc_dict["cv_tip"]=matchadd("cv_tip",tip_ptn)
        let s:misc_dict["cv_q"]=matchadd("cv_q",q_ptn,25)
    endif
endfunction "}}}

function! s:draw_text(...) "{{{
    setl ma
    let cur=s:clear_text()
    let hex=g:ColorV.HEX
    let [r,g,b]=g:ColorV.rgb
    let [r,g,b]=[printf("%3d",r),printf("%3d",g),printf("%3d",b)]
    let [h,s,v]=g:ColorV.hsv
    let [h,s,v]=[printf("%3d",h),printf("%3d",s),printf("%3d",v)]
    let [H,L,S]=g:ColorV.hls
    let [H,L,S]=[printf("%3d",H),printf("%3d",L),printf("%3d",S)]
    let [Y,I,Q]=s:number(g:ColorV.yiq)
    let [Y,I,Q]=[printf("%3d",Y),printf("%4d",I),printf("%4d",Q)]
    
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
    if s:mode=="max"  
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"Hex:".hex,22)
        let line[1]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[2]=s:line("H:".h."  S:".s."  V:".v,22)
        let line[3]=s:line("H:".H."  L:".L."  S:".S,22)
        let line[4]=s:line("Y ".Y."  I".I."  Q".Q,22)
        let line[8]=s:line("F1:help Enter:edit cc:copy q:exit M?",22)
    elseif s:mode=="mid"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[1]=s:line("Hex:".hex,22)
        let line[2]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[3]=s:line("H:".h."  S:".s."  V:".v,22)
        let line[4]=s:line("H:".H."  L:".L."  S:".S,22)
        let line[5]=s:line("F1:help Enter:edit cc:copy q:exit m?",22)
    elseif s:mode=="min"
        let line[0]=s:line("ColorV ".g:ColorV.ver,3)
        let line[0]=s:line_sub(line[0],"Hex:".hex,22)
        let line[1]=s:line("R:".r."  G:".g."  B:".b,22)
        if s:space=="hls"
            let line[2]=s:line("H:".H."  L:".L."  S:".S,22)
        else
            let line[2]=s:line("H:".h."  S:".s."  V:".v,22)
        endif
        let line[2]=s:line_sub(line[2],"_?",56)
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
    for i in range(height)
        call setline(i+1,line[i])
    endfor

    "put cursor back
    call setpos('.',cur)

    setl noma
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
    	if s:space=="HLS"
            let l=float2nr(round((100.0-S)/h_step))+1+s:poff_y
            let c=float2nr(round((100.0-L)/w_step))+1+s:poff_x
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
    	if s:space=="HLS"
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
    if expand('%') !=g:ColorV.name
        call s:warning("Not [ColorV] buffer")
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

function! s:clear_palmatch() "{{{
    if !exists("s:pallet_dict")|let s:pallet_dict={}|endif
    for [key,var] in items(s:pallet_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:pallet_dict,key)
        catch /^Vim\%((\a\+)\)\=:E803/
            call s:debug("E803:ID not found")
            continue
        catch /^Vim\%((\a\+)\)\=:E802/
            call s:debug("E802:Invalid ID:-1")
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
            call s:debug("E803:ID not found")
            continue
        catch /^Vim\%((\a\+)\)\=:E802/
            call s:debug("E802:Invalid ID:-1")
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
            call s:debug("E803:ID not found")
            continue
        catch /^Vim\%((\a\+)\)\=:E802/
            call s:debug("E802:Invalid ID:-1")
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
            call s:debug("E803:ID not found")
            continue
        catch /^Vim\%((\a\+)\)\=:E802/
            call s:debug("E802:Invalid ID:-1")
            continue
        endtry
    endfor
    let s:hsv_dict={}
endfunction "}}}
function! s:clear_prevmatch() "{{{
    if !exists("s:prev_dict")|let s:prev_dict={}|endif
    for [key,var] in items(s:prev_dict)
        try
            call matchdelete(var)
            exe "hi clear ".key
            call remove(s:prev_dict,key)
        catch /^Vim\%((\a\+)\)\=:E803/
            call s:debug("E803:ID not found")
            continue
        catch /^Vim\%((\a\+)\)\=:E802/
            call s:debug("E802:Invalid ID:-1")
            continue
        endtry
    endfor
    let s:prev_dict={}
endfunction "}}}
"}}}
"WINS: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorv#win(...) "{{{
    "{{{ open window
    let splitLocation = g:ColorV_win_pos == "top" ? "topleft " : "botright "

    if !exists('t:ColorVBufName')
        let t:ColorVBufName = g:ColorV.name
        silent! exec splitLocation .' new'
        silent! exec "edit ~/" . t:ColorVBufName
    else
    	if s:is_open()
            call s:exec(s:get_win_num() . " wincmd w")
        else
            silent! exec splitLocation . ' split'
            silent! exec "buffer " . t:ColorVBufName
        endif
    endif "}}}
    " local setting "{{{
    setl winfixwidth
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
    setl noea
    setl foldcolumn=0
    setl sidescrolloff=0
    setl ft=ColorV
    if v:version >= 703
        setl cc=
    endif
    call s:map_define() "}}}
    " get hex "{{{
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
function! s:draw_win(hex) "{{{
    if expand('%') != g:ColorV.name
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
        call colorv#timer("s:draw_satline",[2])
        call colorv#timer("s:draw_valline",[3])
        let l:win_h=s:min_h
    else
        call colorv#timer("s:clear_blockmatch")
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
        call s:draw_satline(2)
        call s:draw_valline(3)
        let l:win_h=s:min_h
    else
        call s:clear_blockmatch()
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
    nmap <silent><buffer> <c-k> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <CR> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <KEnter> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <space> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <space><space> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <leader>ck :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <2-leftmouse> :call <SID>set_in_pos()<cr>
    nmap <silent><buffer> <3-leftmouse> :call <SID>set_in_pos()<cr>

    nmap <silent><buffer> <tab> W
    nmap <silent><buffer> <S-tab> B

    "edit
    nmap <silent><buffer> a :call <SID>edit_at_cursor()<cr>
    nmap <silent><buffer> i :call <SID>edit_at_cursor()<cr>
    nmap <silent><buffer> = :call <SID>edit_at_cursor(-1,"+")<cr>
    nmap <silent><buffer> + :call <SID>edit_at_cursor(-1,"+")<cr>
    nmap <silent><buffer> - :call <SID>edit_at_cursor(-1,"-")<cr>
    nmap <silent><buffer> _ :call <SID>edit_at_cursor(-1,"-")<cr>

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
    map <silent><buffer> cl :call <SID>copy("HSL","+")<cr>

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
    
    "paste color
    map <silent><buffer> <c-v> :call <SID>paste("+")<cr>
    map <silent><buffer> p :call <SID>paste()<cr>
    map <silent><buffer> P :call <SID>paste()<cr>
    map <silent><buffer> <middlemouse> :call <SID>paste("+")<cr>
    
    "generator with current color
    nmap <silent><buffer> gh :call colorv#gen_win(g:ColorV.HEX,"Hue",20,15)<cr>
    nmap <silent><buffer> gs :call colorv#gen_win(g:ColorV.HEX,"Saturation",20,5,1)<cr>
    nmap <silent><buffer> gv :call colorv#gen_win(g:ColorV.HEX,"Value",20,5,1)<cr>
    nmap <silent><buffer> ga :call colorv#gen_win(g:ColorV.HEX,"Analogous")<cr>
    nmap <silent><buffer> gq :call colorv#gen_win(g:ColorV.HEX,"Square")<cr>
    nmap <silent><buffer> gn :call colorv#gen_win(g:ColorV.HEX,"Neutral")<cr>
    nmap <silent><buffer> gc :call colorv#gen_win(g:ColorV.HEX,"Clash")<cr>
    nmap <silent><buffer> gp :call colorv#gen_win(g:ColorV.HEX,"Split-Complementary")<cr>
    nmap <silent><buffer> g1 :call colorv#gen_win(g:ColorV.HEX,"Monochromatic")<cr>
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
    let c=col('.')
    let l=line('.')
    if s:mode=="max"
    	let pos_list = s:max_pos
    elseif s:mode=="min"
    	let pos_list = s:min_pos
    else
    	let pos_list = s:mid_pos
    endif
    for pos in pos_list
        let line=pos[1]
        let column=pos[2]
        let length=pos[3]
        if l==line && c>=column && c<column+length
            execute '2match' "ErrorMsg".' /\%'.(line)
                        \.'l\%>'.(column-1)
                        \.'c\%<'.(column+length).'c/'
            break
        else
            execute '2match ' "none"
        endif
    endfor
endfunction "}}}

function! s:exec(cmd) "{{{
    let old_ei = &ei
    set ei=all
    exec a:cmd
    let &ei = old_ei
endfunction "}}}
function! s:is_open(...) "{{{
    if exists("a:1")
        return s:get_win_num(a:1) != -1
    else
        return s:get_win_num() != -1
    endif
endfunction "}}}
function! s:get_win_num(...) "{{{
    if exists("a:1")
    	if exists(a:1)
            return bufwinnr(eval(a:1))
        else
            return -1
        endif
    else
        if exists("t:ColorVBufName")
            return bufwinnr(t:ColorVBufName)
        else
            return -1
        endif
    endif
endfunction "}}}

function! colorv#exit() "{{{
    "close "{{{
    if s:is_open()
        if winnr("$") != 1
            call s:exec(s:get_win_num() . " wincmd w")
            close
            call s:exec("wincmd p")
        else
            close
        endif
    endif
    
    if s:is_open("t:ColorVListBufName")
        if winnr("$") != 1
            call s:exec(s:get_win_num("t:ColorVListBufName") . " wincmd w")
            close
            call s:exec("wincmd p")
        else
            close
        endif
    endif "}}}
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
import pygtk,gtk
pygtk.require('2.0')

color_dlg = gtk.ColorSelectionDialog("[ColorV] Pygtk colorpicker")
c_set = gtk.gdk.color_parse("#"+vim.eval("g:ColorV.HEX"))
color_dlg.colorsel.set_current_color(c_set)

if color_dlg.run() == gtk.RESPONSE_OK:
    clr = color_dlg.colorsel.get_current_color()
    c_hex = rgb2hex([clr.red/257,clr.green/257,clr.blue/257])
    
color_dlg.destroy()
vim.command("ColorV "+c_hex)
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
    if type(a:x) == type([]) 
    	if !empty(a:x)
    	    let x=[]
    	    for i in a:x
                let z = s:number(i)
                call add(x,z)
            endfor
            return x
        else
            throw "Empty List for s:number()"
        endif
    else
        let x= type(a:x) == type("0.5") ? str2nr(a:x) : type(a:x) == type(0.5) ? float2nr(a:x) : a:x
        return x
    endif
endfunction "}}}
function! s:float(x) "{{{
    if type(a:x) == type([]) 
    	if !empty(a:x)
    	    let x=[]
    	    for i in a:x
                let z = s:float(i)
                call add(x,z)
            endfor
            return x
        else
            throw "Empty List for s:float()"
        endif
    else
        let x= type(a:x) == type("0.5") ? str2float(a:x) : type(a:x) == type(1) ? a:x+0.0 : a:x
        return x
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
function! s:fmt_hex(hex) "{{{
   let hex=a:hex
   if hex=~ '#\x\{6}'  || '#\x\{3}'
       let hex=substitute(hex,"#",'','')
   endif
   if hex=~ '0x\x\{6}' || '0x\x\{3}'
       let hex=substitute(hex,'0x','','')
   endif
   if hex=~ '\x\@<!\x\{3}\x\@!'
       let hex=substitute(hex,'.','&&','g')
   endif
   return printf("%06x","0x".hex)
endfunction "}}}

function! s:echo_tips() "{{{
    let txt_list=s:tips_list
    " if exists("g:ColorV_echo_tips") && g:ColorV_echo_tips ==1
        call s:seq_echo(txt_list)
    " elseif exists("g:ColorV_echo_tips") && g:ColorV_echo_tips ==2
    "     call s:rnd_echo(txt_list)
    " else
    "     call s:all_echo(txt_list)
    " endif
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
    exe "echo \"[Warning] ".escape(a:msg,'"')."\""
    echohl Normal
endfunction "}}}
function! s:error(msg) "{{{
    echohl Errormsg
    exe "echom \"[Error] ".escape(a:msg,'"')."\""
    echohl Normal
endfunction "}}}
function! s:echo(msg) "{{{
    try 
        exe "echo \"[Note] ".escape(a:msg,'\"')."\""
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
    let [r1,g1,b1] = colorv#hex2rgb(a:hex1)
    let [r2,g2,b2] = colorv#hex2rgb(a:hex2)
    let t=exists("a:1") ? a:1 : s:aprx_rate*4
    if r2+t>=r1 && r1>=r2-t && g2+t>=g1 && g1>=g2-t
                \&& b2+t>=b1 && b1>=b2-t
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
if y>=35 and y < 50:
    y = 80
elif y >=50 and y < 65:
    y = 20
else:
    y = 100-y

if i >0: 
    i = i-10
else:
    i+=10
if q >0: 
    q = q -10
else:
    q+=10
vim.command("return '"+rgb2hex(yiq2rgb([y,i,q]))+"'")
EOF
    else
        let hex=s:fmt_hex(a:hex)
        let [y,i,q]=colorv#hex2yiq(hex)
        if y>=35 && y < 50
            let y = 80
        elseif y >=50 && y < 65
            let y = 20
        else
            let y = 100-y
        endif
        if i >0 
            let  i = i-10
        else
            let i+=10
        endif
        if q >0 
            let  q = q -10
        else
            let q+=10
        endif
        return colorv#yiq2hex([y,i,q])
    endif
endfunction "}}}
function! s:opz_clr(hex) "{{{
    let hex=s:fmt_hex(a:hex)
    let [y,i,q]=colorv#hex2yiq(hex)
    if y>=35 && y < 50
    	let y = 80
    elseif y >=50 && y < 65
        let y = 20
    else
    	let y = 100-y
    endif
    return colorv#yiq2hex([y,-i,-q])
endfunction "}}}

function! colorv#timer(func,...) "{{{
if !exists("*".a:func)
    echom "[TIMER]: ".a:func." does not exists. stopped"
    return
endif
if exists("a:1") 
    let farg=a:1
else
    let farg=[]
endif
if exists("a:2") 
    let num=a:2
else
    let num=1
endif
if has("python") && g:ColorV_no_python!=1
python << EOF
import time
import vim
vim.command("let o_t = "+str(time.time()))
EOF
else
    let o_t=strftime("%j")*86400+strftime("%H")*3600
                \+strftime("%M")*60+strftime("%S")
endif


for i in range(num)
    silent!  let rtn=call(a:func,farg)
endfor

if has("python") && g:ColorV_no_python!=1
python << EOF
vim.command("let n_t = "+str(time.time()))
EOF
else
    let n_t=strftime("%j")*86400+strftime("%H")*3600
                    \+strftime("%M")*60+strftime("%S")
endif

echom "[TIMER]:" string(n_t-o_t) "seconds for exec" a:func num "times. "

return rtn
endfunction "}}}
"}}}
"EDIT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:set_in_pos(...) "{{{
    let l=exists("a:1") ? a:1 : line('.')
    let c=exists("a:1") ? a:1 : col('.')
    let [L,C]=[s:pal_H,s:pal_W]
    
    let clr=g:ColorV
    let hex=clr.HEX
    let [r,g,b]=[clr.RGB.R,clr.RGB.G,clr.RGB.B]
    let [h,s,v]=[clr.HSV.H,clr.HSV.S,clr.HSV.V]
    let [H,L,S]=[clr.HLS.H,clr.HLS.L,clr.HLS.S]
    let s= s==0 ? 1 : s
    let v= v==0 ? 1 : v
    let S= S==0 ? 1 : S
    let L= L==0 ? 1 : L==100 ? 99 : L
    "pallet "{{{
    if (s:mode=="max" || s:mode=="mid" ) && l > s:poff_y && l<= s:pal_H+s:poff_y && c<= s:pal_W
        let idx=(l-s:poff_y-1)*s:pal_W+c-s:poff_x-1
        let hex=s:pal_clr_list[idx]
        call s:echo("HEX(Pallet): ".hex)
        call s:draw_win(hex)
    "}}}
     "{{{
    elseif l==1 &&  c<=s:pal_W 
        "hue line
        let [h1,s1,v1]=colorv#hex2hsv(s:hueline_list[(c-1)])
        call s:echo("Hue(Hue Line): ".h1)
        let hex=colorv#hsv2hex([h1,s,v])
        call s:draw_win(hex)
        return
    elseif s:mode=="min" && l==2 && ( c<=s:pal_W  )
        " sat line
        if s:space=="hls"
            " let [H1,L1,S1]=colorv#hex2hls(s:satline_list[(c-1)])
            let S1=float2nr(100.0-100.0/(s:pal_W-1.0)*(c-1))
            call s:echo("SAT(Saturation Line): ".S1)
            let S1=S1==0 ? 1 : S1
            let hex=colorv#hls2hex([H,L,S1])
            call s:draw_win(hex)
        else
            " let [h1,s1,v1]=colorv#hex2hsv(s:satline_list[(c-1)])
            let s1=float2nr(100.0-100.0/(s:pal_W-1.0)*(c-1))
            call s:echo("SAT(Saturation Line): ".s1)
            let s1=s1==0 ? 1 : s1
            let hex=colorv#hsv2hex([h,s1,v])
            call s:draw_win(hex)
        endif
        return
    elseif s:mode=="min" && l==3 && ( c<=s:pal_W  )
        "value/light
        if s:space=="hls"
            " let [H1,L1,S1]=colorv#hex2hls(s:valline_list[(c-1)])
            let L1=float2nr(100.0-100.0/(s:pal_W-1.0)*(c-1))
            call s:echo("LIT(Lightness Line): ".L1)
            let L1= L1==0 ? 1 : L1
            let hex=colorv#hls2hex([H,L1,S])
        else
            " let [h1,s1,v1]=colorv#hex2hsv(s:valline_list[(c-1)])
            let v1=float2nr(100.0-100.0/(s:pal_W-1.0)*(c-1))
            call s:echo("VAL(Value Line): ".v1)
            let v1=v1==0 ? 1 : v1
            let hex=colorv#hsv2hex([h,s,v1])
        endif
        call s:draw_win(hex)
        return
    "}}}
    "cpd_history section "{{{
    elseif s:mode=="max" && l==s:his_cpd_rect[1] &&
                \ c>=s:his_cpd_rect[0] 
                \ && c<=(s:his_cpd_rect[0]+s:his_cpd_rect[2]*18-1)  
        for i in range(18)
            if c<s:his_cpd_rect[0]+s:his_cpd_rect[2]*(i+1)
            	" let hex=string(get(s:his_cpd_list,-1-i))
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
    elseif l==s:pal_H+1 && c==57 && matchstr(getline(s:pal_H+1),'.',56,1)=="?"
        call s:echo_tips()
        return
    elseif l==s:pal_H+1 && c==56 && matchstr(getline(s:pal_H+1),'.',55,1)=~?'[m_]'
        call s:mode_toggle()
        return
    "set_history section "{{{
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
        call s:draw_win(hex)
        return
        "}}}
    else 
    	"cursoredit check "{{{
        if s:mode=="max"
            let pos_list = s:max_pos
        elseif s:mode=="min"
            let pos_list = s:min_pos
        else
            let pos_list = s:mid_pos
        endif

        let idx=0
        if exists("pos_list")
            for [name,y,x,width] in pos_list
                if l==y && c>=x && c<(x+width)
                    call s:edit_at_cursor(idx)
                    return
                endif
                let idx+=1
            endfor
        endif "}}}

        call s:warning("Not Proper Position.")
        return -1

    endif

    setl noma
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
    let tune=exists("a:2") ? a:2 == "+" ? 1 : a:2 == "-" ? -1  : 0  : 0
    let clr=g:ColorV
    let hex=clr.HEX
    let [r,g,b]=[clr.RGB.R,clr.RGB.G,clr.RGB.B]
    let [h,s,v]=[clr.HSV.H,clr.HSV.S,clr.HSV.V]
    let [H,L,S]=[clr.HLS.H,clr.HLS.L,clr.HLS.S]
    let [y,i,q]=[clr.YIQ.Y,clr.YIQ.I,clr.YIQ.Q]
    let c=col('.')
    let l=line('.')
    if s:mode=="max"
    	let pos_list = s:max_pos
    elseif s:mode=="min"
    	let pos_list = s:min_pos
    else
    	let pos_list = s:mid_pos
    endif
    let position=-1
    for idx in range(len(pos_list))
        let line=pos_list[idx][1]
        let column=pos_list[idx][2]
        let length=pos_list[idx][3]
        if l==line && c>=column && c<=column+length
            let position=idx
            break
        endif
    endfor
    if position==0 "{{{
    	if tune==0
            let hex=input("Hex(000000~ffffff,000~fff):",g:ColorV.HEX)
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
    elseif position==1
        if tune==0
            let r=input("RED(0~255):",g:ColorV.RGB.R)
            if r =~ '^\d\{,3}$' && r<256 && r>=0 && r!=""
                let hex = colorv#rgb2hex([r,g,b])
            else 
                let l:error_input=1
            endif
        else
            let r+=tune*s:tune_step
            let r= r<0 ? 0 : r> 255 ? 255 :r
            let hex=colorv#rgb2hex([r,g,b])
        endif
    elseif position==2
        if tune==0
            let g=input("GREEN(0~255):",g:ColorV.RGB.G)
            if g =~ '^\d\{,3}$' && g<256 && g>=0 && g!=""
                let hex = colorv#rgb2hex([r,g,b])
            else 
                let l:error_input=1
            endif
        else
            let g+=tune*s:tune_step
            let g= g<0 ? 0 : g> 255 ? 255 :g
            let hex=colorv#rgb2hex([r,g,b])
        endif
    elseif position==3
        if tune==0
            let b=input("BLUE(0~255):",g:ColorV.RGB.B)
            if b =~ '^\d\{,3}$' && b<256 && b>=0 && b!=""
                let hex = colorv#rgb2hex([r,g,b])
            else 
                let l:error_input=1
            endif
        else
            let b+=tune*s:tune_step
            let b= b<0 ? 0 : b> 255 ? 255 :b
            let hex=colorv#rgb2hex([r,g,b])
        endif
    elseif position==4
        if s:mode=="min"  && s:space=="hls"
            if tune==0
                let H=input("Hue(0~360):",g:ColorV.HLS.H)
                if H =~ '^\d\{,3}$' && H<=360 && H>=0 && H!=""
                    let hex = colorv#hls2hex([H,L,S])
                else 
                    let l:error_input=1
                endif
            else
                let H+=tune*s:tune_step
                let H= H<0 ? 0 : H> 360 ? 360 :H
                let hex = colorv#hls2hex([H,L,S])
            endif
        else
            if tune==0
                let h=input("Hue(0~360):",g:ColorV.HSV.H)
                if h =~ '^\d\{,3}$' && h<=360 && h>=0 && h!=""
                    let hex = colorv#hsv2hex([h,s,v])
                else 
                    let l:error_input=1
                endif
            else
                let h+=tune*s:tune_step
                let h= h<0 ? 0 : h> 360 ? 360 :h
                let hex = colorv#hsv2hex([h,s,v])
            endif
        endif
    elseif position==5
    if s:mode=="min"  && s:space=="hls"
        if tune==0
            let L=input("Lightness:(0~100):",g:ColorV.HLS.L) 
            if L =~ '^\d\{,3}$' && L<=100 && L>=0 && L!=""
                let hex = colorv#hls2hex([H,L,S])
            else 
                let l:error_input=1
            endif
        else
            let L+=tune*s:tune_step
            let L= L<0 ? 0 : L> 100 ? 100 :L
            let hex = colorv#hls2hex([H,L,S])
        endif
    else
        if tune==0
            let s=input("Saturation(0~100):",g:ColorV.HSV.S) 
            if s =~ '^\d\{,3}$' && s<=100 && s>=0 && s!=""
                let hex = colorv#hsv2hex([h,s,v])
            else 
                let l:error_input=1
            endif
        else
            let s+=tune*s:tune_step
            let s= s<0 ? 0 : s> 100 ? 100 :s
            let hex = colorv#hsv2hex([h,s,v])
        endif
    endif
    elseif position==6
    if s:mode=="min"  && s:space=="hls"
        if tune==0
            let S=input("Saturation(0~100):",g:ColorV.HLS.S) 
            if S =~ '^\d\{,3}$' && S<=100 && S>=0 && S!=""
                let hex = colorv#hls2hex([H,L,S])
            else 
                let l:error_input=1
            endif
        else
            let S+=tune*s:tune_step
            let S= S<0 ? 0 : S> 100 ? 100 :S
            let hex = colorv#hls2hex([H,L,S])
        endif
    else
        if tune==0
            let v=input("Value:(0~100):",g:ColorV.HSV.V) 
            if v =~ '^\d\{,3}$' && v<=100 && v>=0 && v!=""
                let hex = colorv#hsv2hex([h,s,v])
            else 
                let l:error_input=1
            endif
        else
            let v+=tune*s:tune_step
            let v= v<0 ? 0 : v> 100 ? 100 :v
            let hex = colorv#hsv2hex([h,s,v])
        endif
    endif
    elseif position==7
        call s:input_colorname()
        return
    elseif position==11
        if tune==0
            let y=input("YIQ Luma:(0~100):",g:ColorV.YIQ.Y) 
            if y =~ '^\d\{,3}$' && y<=100 && y>=0 && y!=""
                let hex = colorv#yiq2hex([y,i,q])
            else 
                let l:error_input=1
            endif
        else
            let y+=tune*s:tune_step
            let y= y<0 ? 0 : y> 100 ? 100 :y
            let hex = colorv#yiq2hex([y,i,q])
        endif
    elseif position==12
        if tune==0
            let i=input("YIQ In-phase:(-100~100):",g:ColorV.YIQ.I) 
            if i =~ '^-\=\d\{,3}$' && i<=100 && i>=-100 && i!=""
                let hex = colorv#yiq2hex([y,i,q])
            else 
                let l:error_input=1
            endif
        else
            let i+=tune*s:tune_step
            let i= i<-100 ? -100 : i> 100 ? 100 :i
            let hex = colorv#yiq2hex([y,i,q])
        endif
    elseif position==13
        if tune==0
            let q=input("YIQ quadrature:(-100~100):",g:ColorV.YIQ.Q) 
            if q =~ '^-\=\d\{,3}$' && q<=100 && q>=-100 && q!=""
                let hex = colorv#yiq2hex([y,i,q])
            else 
                let l:error_input=1
            endif
        else
            let q+=tune*s:tune_step
            let q= q<-100 ? -100 : q> 100 ? 100 :q
            let hex = colorv#yiq2hex([y,i,q])
        endif
    elseif position==8
            if tune==0
                let H=input("Hue(0~360):",g:ColorV.HLS.H)
                if H =~ '^\d\{,3}$' && H<=360 && H>=0 && H!=""
                    let hex = colorv#hls2hex([H,L,S])
                else 
                    let l:error_input=1
                endif
            else
                let H+=tune*s:tune_step
                let H= H<0 ? 0 : H> 360 ? 360 :H
                let hex = colorv#hls2hex([H,L,S])
            endif
    elseif position==9
        if tune==0
            let L=input("Lightness:(0~100):",g:ColorV.HLS.L) 
            if L =~ '^\d\{,3}$' && L<=100 && L>=0 && L!=""
                let hex = colorv#hls2hex([H,L,S])
            else 
                let l:error_input=1
            endif
        else
            let L+=tune*s:tune_step
            let L= L<0 ? 0 : L> 100 ? 100 :L
            let hex = colorv#hls2hex([H,L,S])
        endif
    elseif position==10
        if tune==0
            let S=input("Saturation(0~100):",g:ColorV.HLS.S) 
            if S =~ '^\d\{,3}$' && S<=100 && S>=0 && S!=""
                let hex = colorv#hls2hex([H,L,S])
            else 
                let l:error_input=1
            endif
        else
            let S+=tune*s:tune_step
            let S= S<0 ? 0 : S> 100 ? 100 :S
            let hex = colorv#hls2hex([H,L,S])
        endif
    else 
            return -1
    setl noma
    endif "}}}

    if exists("l:error_input") && l:error_input==1
    	call s:warning("Error input. Nothing changed.")
        return
    endif
    call s:draw_win(hex)

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
                    hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
                elif key=="NS3":
                    hx3=x.group('HEX')
                    hx=hx3[0]*2+hx3[1]*2+hx3[2]*2
                    hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
                elif key=="RGBA" or key=="RGB":
                    hx=rgb2hex([x.group('R'),x.group('G'),x.group('B')])
                    hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
                elif key=="RGBP" or key=="RGBAP":
                    r,g,b=int(x.group('R')),int(x.group('G')),int(x.group('B'))
                    hx=rgb2hex([r*2.55,g*2.55,b*2.55])
                    hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
                elif key=="HSL" or key=="HSLA" :
                    h,s,l=int(x.group('H')),int(x.group('S')),int(x.group('L'))
                    hx=rgb2hex(hls2rgb([h,l,s]))
                    hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
                elif key=="HSV" or key=="HSVA" :
                    h,s,v=int(x.group('H')),int(x.group('S')),int(x.group('V'))
                    hx=rgb2hex(hls2rgb([h,l,s]))
                    hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
                elif key=="NAME":
                    hx=name2hex(x.group())
                    hex_list.append([hx,x.start(),x.end()-x.start(),x.group(),key])
    return hex_list

EOF
endfunction "}}}
function! s:txt2hex(txt) "{{{
    if has("python") && g:ColorV_no_python!=1
call s:py_text_load()
python << EOF
r=txt2hex(vim.eval("a:txt"))
vim.command("return "+str(r))
EOF
    endif
" input: text
" return: hexlist [[hex,idx,len,str,fmt],[hex,idx,len,str,fmt],...]
    let text = a:txt
    let textorigin = a:txt
    let old_list=[]
    
    "max search depth 
    "the max number of searched color text  
    let rnd=0
    let idx=0
    let hex_list=[]
    while rnd<=20
        for [fmt,pat] in items(s:fmt)
            if text=~ pat
                let p_idx{idx}=match(text,pat)
                let p_str{idx}=matchstr(text,pat)
                " error with same hex in one line?
                " it will match the first one
                let p_oidx{idx}=match(textorigin,p_str{idx})
                let p_len{idx}=len(p_str{idx})
                let text=strpart(text,0,p_idx{idx})
                            \.strpart(text,p_len{idx}+p_idx{idx})

                if fmt=="HEX"
                    let list=[p_str{idx},p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                elseif fmt=="HEX0"
                    let hex=substitute(p_str{idx},'0x','','')
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                elseif fmt=="NS6"
                    let hex=substitute(p_str{idx},'#','','')
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                elseif fmt=="NS3"
                    let hex=substitute(p_str{idx},'#','','')
                    let hex=substitute(hex,'.','&&','g')
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                elseif fmt=="RGB" || fmt =="RGBA"
                    let rgb=split(p_str{idx},',')
                    let r=matchstr(rgb[0],'\d\{1,3}')
                    let g=matchstr(rgb[1],'\d\{1,3}')
                    let b=matchstr(rgb[2],'\d\{1,3}')
                    if r>255 || g >255 || b > 255
                        call s:error("Input out of boundary")
                        return
                    endif
                    let hex = colorv#rgb2hex([r,g,b])
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                        " call add(clr,fmt)
                    call add(hex_list,list)
                elseif fmt=="RGBP" || fmt =="RGBAP"
                    let rgb=split(p_str{idx},',')
                    let r=matchstr(rgb[0],'\d\{1,3}')
                    let g=matchstr(rgb[1],'\d\{1,3}')
                    let b=matchstr(rgb[2],'\d\{1,3}')
                    let hex= colorv#rgb2hex([r*2.55,g*2.55,b*2.55])
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                elseif fmt=="HSV"
                    let hsv=split(p_str{idx},',')
                    let h=matchstr(hsv[0],'\d\{1,3}')
                    let s=matchstr(hsv[1],'\d\{1,3}')
                    let v=matchstr(hsv[2],'\d\{1,3}')
                    let hex= colorv#hsv2hex([h,s,v])
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                elseif fmt=="HSL" || fmt =="HSLA"
                    let hsl=split(p_str{idx},',')
                    let h=matchstr(hsl[0],'\d\{1,3}')
                    let s=matchstr(hsl[1],'\d\{1,3}')
                    let l=matchstr(hsl[2],'\d\{1,3}')
                    let hex= colorv#hls2hex([h,l,s])
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                " "NAME and NAMX format ;not a <cword> here
                elseif fmt=="NAME"
                    let hex=s:nam2hex(p_str{idx})
                    let list=[hex,p_oidx{idx},p_len{idx},p_str{idx},fmt]
                    call add(hex_list,list)
                endif
                let idx+=1
            endif
        endfor
        if old_list==hex_list        
            break
        else
            let old_list=deepcopy(hex_list,1)
        endif
        let rnd+=1
    endwhile

    "hex_list [[hex,idx,len,str,fmt],...]
    return hex_list
endfunction "}}}
function! s:hex2txt(hex,fmt,...) "{{{
    
    let hex=printf("%06x","0x".a:hex)
    let hex=substitute(hex,'\l','\u\0','g')

    let [r,g,b] = colorv#hex2rgb(hex)
    let [r,g,b]=[printf("%3d",r),printf("%3d",g),printf("%3d",b)]
    let [rp,gp,bp] = [float2nr(r/2.55),float2nr(g/2.55),float2nr(b/2.55)]
    let [rp,gp,bp]=[printf("%3d",rp),printf("%3d",gp),printf("%3d",bp)]
    let [h,s,v] = colorv#rgb2hsv([r,g,b])
    let [h,s,v]=[printf("%3d",h),printf("%3d",s),printf("%3d",v)]
    let [H,L,S] = colorv#rgb2hls([r,g,b])
    let [H,L,S]=[printf("%3d",H),printf("%3d",L),printf("%3d",S)]

    if a:fmt=="RGB"
        let text="rgb(".r.",".g.",".b.")"
    elseif a:fmt=="HSV"
        let text="hsv(".h.",".s.",".v.")"
    elseif a:fmt=="HSL"
        let text="hsl(".H.",".S."%,".L."%)"
    elseif a:fmt=="HSLA"
        let text="hsla(".H.",".S."%,".L."%,1.0)"
    elseif a:fmt=="RGBP"
        let text="rgb(".rp."%,"
                    \.gp."%,"
                    \.bp."%)"
    elseif a:fmt=="RGBA" 
        let text="rgba(".r.",".g.",".b.",1.0)"
    elseif a:fmt=="RGBAP" 
        let text="rgba(".rp."%,"
                    \.gp."%,"
                    \.bp."%,1.0)"
    elseif a:fmt=="HEX"
        let text=hex
    elseif a:fmt=="NS6"
        let text="#".hex
    elseif a:fmt=="NS3"
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
    if exists("a:1") && a:1 == "X11" 
    	let list="X11"
    else
    	let list="W3C"
    endif
call s:py_text_load()
python << EOF
best_match = 0
smallest_distance = 10000000

t= int(vim.eval("s:aprx_rate"))
if vim.eval("list")=="X11":clr_list=clrn+clrnX11
else:clr_list=clrn+clrnW3C
r1,g1,b1 = hex2rgb(vim.eval("a:hex"))

for lst in clr_list:
    r2,g2,b2 = hex2rgb(lst[1])
    d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
    if d < smallest_distance:
        smallest_distance = d
        best_match = lst[0]

if smallest_distance == 0:
    vim.command("return \""+best_match+"\"")
elif smallest_distance <= t*5:
    vim.command("return \""+best_match+"~\"")
elif smallest_distance <= t*10:
    vim.command("return \""+best_match+"~~\"")
else:
    vim.command("return \"\"")

EOF
else
    if exists("a:1") && a:1 == "X11"
    	let clr_list=s:clrn+s:clrnX11
    else
    	let clr_list=s:clrn+s:clrnW3C
    endif
    let best_match=0
    let smallest_distance = 2000000
    let [r1,g1,b1] = colorv#hex2rgb(a:hex)
    for lst in clr_list
        let [r2,g2,b2] = colorv#hex2rgb(lst[1])
        let d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
    	if d < smallest_distance
    	    let smallest_distance = d
    	    let best_match = lst[0]
        endif
    endfor
    if smallest_distance == 0
    	return best_match
    elseif smallest_distance <= s:aprx_rate*5
    	return best_match."~"
    elseif smallest_distance <= s:aprx_rate*10
    	return best_match."~~"
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
    " call <SID>write_cache()
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
            	try
                    exec '%s/'.from_pat.'/'.to_pat.'/gc'
                catch /^Vim\%((\a\+)\)\=:E486/
                    call s:debug(from_pat." to:".to_fmt.to_str.to_pat)
                    call s:error("E486: Pattern not found.")
                catch /^Vim\%((\a\+)\)\=:E21/
                    call s:error("No change to text.'Modifiable' is off.")
                endtry
            else
            	try
                    "change current line 
                    "  XXX: ptn not found if from_pat=line
                    exec '.s/\%>'.(bgn_idx-1).'c'.from_pat.'/'.to_pat.'/'
                catch /^Vim\%((\a\+)\)\=:E486/
                    call s:debug(from_pat." to:".to_fmt.to_str.to_pat)
                    call s:error("E486: Pattern not found.")
                catch /^Vim\%((\a\+)\)\=:E21/
                    call s:error("No change to text.'Modifiable' is off.")
                endtry
            endif

            if exists("s:ColorV.change_noma") && s:ColorV.change_noma ==1
            	setl noma
            	unlet s:ColorV.change_noma
            endif

        endif
        let s:ColorV.change_word=0
        let s:ColorV.change_all=0

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
    else
        let s:ColorV.change_word=0
        let s:ColorV.change_all=0
        return 0
    endif
endfunction
"}}}
function! colorv#cursor_win(...) "{{{
    let s:ColorV.word_bufnr=bufnr('%')
    let s:ColorV.word_bufname=bufname('%')
    let s:ColorV.word_bufwinnr=bufwinnr('%')
    let s:ColorV.word_pos=getpos('.')
    let s:ColorV.word_cpos=col('.')
    let lword= expand('<cWORD>')
    let word= expand('<cword>')
    let line= getline('.')
    
    let hex_list=s:txt2hex(word)
    if !empty(hex_list) "{{{
        let s:ColorV.is_in="word"
        let pat = word
        let s:ColorV.word_pat=pat

        silent normal! b
        let bgn_idx=col('.')
        if len(hex_list) >1 "{{{
            let i=0
            for [lhex,idx,len,str,fmt] in hex_list
            	if  s:ColorV.word_cpos > bgn_idx+idx 
                \ &&  s:ColorV.word_cpos < bgn_idx+idx+len 
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
    else
    	"avoid [] return? seems no necessary
    	" unlet hex_list
        let hex_list=s:txt2hex(lword)
        if !empty(hex_list) "{{{
            let s:ColorV.is_in="lword"
            let pat = lword
            let s:ColorV.word_pat=pat
            silent normal! B
            let bgn_idx=col('.')
            if len(hex_list) >1 "{{{
                let i=0
                
                for [lhex,idx,len,str,fmt] in hex_list
                    if  s:ColorV.word_cpos > bgn_idx+idx 
                    \ &&  s:ColorV.word_cpos < bgn_idx+idx+len 
                        let hex=s:fmt_hex(lhex)
                        let s:ColorV.word_list=hex_list[i]
                    endif
                    let i+=1
                endfor
                if !exists("hex")
                    let hex=s:fmt_hex(hex_list[0][0])
                    let s:ColorV.word_list=hex_list[0]
                    let clr_fmt=hex_list[0][4]
                endif
            else 
                let hex=s:fmt_hex(hex_list[0][0])
                let s:ColorV.word_list=hex_list[0]
                let clr_fmt=hex_list[0][4]
            endif "}}}
        else
            let hex_list=s:txt2hex(line)
            if !empty(hex_list) "{{{
                let s:ColorV.is_in="line"
                let pat = line
                let s:ColorV.word_pat=pat
                " silent normal! 0
                " let bgn_idx=col('.')
                if len(hex_list) >1 "{{{
                    let i=0
                    for [lhex,idx,len,str,fmt] in hex_list
                        if  s:ColorV.word_cpos > idx 
                        \ &&  s:ColorV.word_cpos < idx+len 
                            let hex=s:fmt_hex(lhex)
                            let s:ColorV.word_list=hex_list[i]
                        endif
                        let i+=1
                    endfor
                    if !exists("hex")
                        let hex=s:fmt_hex(hex_list[0][0])
                        let s:ColorV.word_list=hex_list[0]
                        let clr_fmt=hex_list[0][4]
                    endif
                else 
                    let hex=s:fmt_hex(hex_list[0][0])
                    let s:ColorV.word_list=hex_list[0]
                    let clr_fmt=hex_list[0][4]
                endif "}}}
            else
                let s:ColorV.is_in=""
                let pat = ""
                let s:ColorV.word_pat=pat
                call s:error("Color-text not found under cursor line.")
                " if g:ColorV_cursor_found==1
                    return -1
                " else
                "     let hex=g:ColorV.HEX
                "     let l:silent=1
                " endif
            endif "}}}
        endif "}}}
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
        let list=s:winlist_generate(hex,type,nums,step)
        call colorv#list_win(list)
    elseif exists("a:1") && a:1==4
        let s:ColorV.change_word=1
    else
        let s:ColorV.change_word=0
    	let s:ColorV.change_all=0
    endif
        " let s:exit_call=1
        " let s:exit_func="s:changing"
    
    "change2
    if exists("a:1") && (a:1==2 || a:1==1) && exists("a:2")
            \ && a:2=~'RGB\|RGBA\|RGBP\|RGBAP\|HEX\|HEX0\|NAME\|NS6\|HSV'
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

    call colorv#win(s:mode,hex,1,"s:changing")
    
endfunction "}}}
function! colorv#clear_all() "{{{
    call s:clear_blockmatch()
    call s:clear_hsvmatch()
    call s:clear_miscmatch()
    call s:clear_palmatch()
    call s:clear_prevmatch()
    " call clearmatches()
endfunction "}}}
"}}}
" LIST: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorv#list_win(...) "{{{
    let splitLocation = "botright "
    if !exists('t:ColorVListBufName')
        let t:ColorVListBufName = g:ColorV.listname
        silent! exec splitLocation . ' vnew'
        silent! exec "edit " . t:ColorVListBufName
    else
    	if s:is_open("t:ColorVListBufName")
            call s:exec(s:get_win_num("t:ColorVListBufName") . " wincmd w")
        else
            silent! exec splitLocation . ' vsplit'
            silent! exec "buffer " . t:ColorVListBufName
        endif
    endif

    
    " local setting "{{{
    setl winfixwidth
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
    setl noea
    setl foldcolumn=0
    setl sidescrolloff=0
    if v:version >= 703
        setl cc=
    endif

    setl ft=ColorV_list 
    
    nmap <silent><buffer> q :call colorv#exit()<cr>
    nmap <silent><buffer> Q :call colorv#exit()<cr>
    nmap <silent><buffer> <c-w>q :call colorv#exit()<cr>
    nmap <silent><buffer> <c-w><c-q> :call colorv#exit()<cr>
    nmap <silent><buffer> H :h colorv-colorname<cr>
    nmap <silent><buffer> <F1> :h colorv-colorname<cr>
    " call s:map_define() "}}}

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
endfunction "}}}
function! s:draw_list_buf(list) "{{{
    setl ma
    let list=a:list
    call s:clear_list_text()
    call s:draw_list_text(list)
    "preview without highlight colorname
    call colorv#preview("N")
    setl noma
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
" gen varius colors
" input hex, mode
" output hex_list
"
    " Use YIQ in stead of YUV (NTSC / PAL)
    let hex=a:hex
    let type=exists("a:1") && !empty(a:1) ? a:1 : s:gen_def_type
    let nums=exists("a:2") && !empty(a:2) ? a:2 : s:gen_def_nums 
    let step=exists("a:3") && !empty(a:3) ? a:3 : s:gen_def_step
    let circle=exists("a:4") && !empty(a:4) ? a:4 : 1
    let [y,i,q]=colorv#rgb2yiq(colorv#hex2rgb(hex))
    let [h,s,v]=colorv#hex2hsv(hex)
    let hex_list=[]
    if type==?"Hue"
        for i in range(nums)
            let h{i}=h+i*step
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Luma"
        "y+
        for i in range(nums)
            if i==0
                let y0=y
            else
                let y{i}=y{i-1}+step
                if circle==1
                    let y{i} = y{i} >=100 ? 1 : y{i} <= 0 ? 100 : y{i}
                else
                    let y{i} = y{i} >=100 ? 100 : y{i} <= 0 ? 1 : y{i}
                endif
            endif
            let hex=colorv#yiq2hex([y{i},i,q])
            call add(hex_list,hex)
        endfor
    elseif type=="Value"
        "v+
        " let v{i}= v+step*i<=100 ? v+step*i : 100
        for i in range(nums)
            if i==0
                let y0=y
            else
                let y{i}=y{i-1}+step
                if circle==1
                    let y{i} = y{i} >=100 ? 1 : y{i} <= 0 ? 100 : y{i}
                else
                    let y{i} = y{i} >=100 ? 100 : y{i} <= 0 ? 1 : y{i}
                endif
            endif
            let hex=colorv#yiq2hex([y{i},i,q])
            call add(hex_list,hex)
        endfor
    elseif type=="Saturation"
        for i in range(nums)
            if i==0
                let s0=s
            else
                let s{i}=s{i-1}+step
                if circle==1
                    let s{i} = s{i} >=100 ? 1 : s{i} <= 0 ? 100 : s{i}
                else
                    let s{i} = s{i} >=100 ? 100 : s{i} <= 0 ? 1 : s{i}
                endif
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
        for i in range(nums)
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+150 : h{i-1}+60
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Triadic"
        let hex_list=colorv#yiq_list_gen(hex,"Hue",nums,120)
    elseif type=="Clash"
        for i in range(nums)
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+90 : h{i-1}+180
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type=="Square"
        let hex_list=colorv#yiq_list_gen(hex,"Hue",nums,90)
    elseif type=="Tetradic" || type=="Rectangle"
        "h+60,h+120,...
        for i in range(nums)
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+60 : h{i-1}+120
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Five-Tone"
        "h+115,+40,+50,+40,+115
        for i in range(nums)
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,5)==1 ? h{i-1}+115 : 
                        \s:fmod(i,5)==2 ? h{i-1}+40 : 
                        \s:fmod(i,5)==3 ? h{i-1}+50 : 
                        \s:fmod(i,5)==4 ? h{i-1}+40 :
                        \h{i-1}+115
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Six-Tone"
        for i in range(nums)
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+30 : h{i-1}+90
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    else 
            call s:warning("Not Correct color generator Type.")
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
    if expand('%') !=g:ColorV.listname
        call s:warning("Not [ColorV List] buffer")
        return
    endif
    let cur=getpos('.')
    " silent! normal! ggVG"_x
    silent %delete _
    return cur
endfunction "}}}
function! colorv#list_gen(hex,...) "{{{
    let hex=a:hex
    let type=exists("a:1") && !empty(a:1) ? a:1 : s:gen_def_type
    let nums=exists("a:2") && !empty(a:2) ? a:2 : s:gen_def_nums 
    let step=exists("a:3") && !empty(a:3) ? a:3 : s:gen_def_step
    let circle=exists("a:4") && !empty(a:4) ? a:4 : 1
    let [h,s,v]=colorv#hex2hsv(hex)
    let hex_list=[]
    for i in range(nums)
    	if type=="Hue" 
    	    "h+
            let h{i}=h+step*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Saturation"
            "s+
            if i==0
                let s0=s
            else
                let s{i}=s{i-1}+step
                if circle==1
                    let s{i} = s{i} >=100 ? 1 : s{i} <= 0 ? 100 : s{i}
                else
                    let s{i} = s{i} >=100 ? 100 : s{i} <= 0 ? 1 : s{i}
                endif
            endif
            let hex{i}=colorv#hsv2hex([h,s{i},v])
        elseif type=="Value"
            "v+
            if i==0
                let v0=v
            else
                let v{i}=v{i-1}+step
                if circle==1
                    let v{i} = v{i} >=100 ? 1 : v{i} <= 0 ? 100 : v{i}
                else
                    let v{i} = v{i} >=100 ? 100 : v{i} <= 0 ? 1 : v{i}
                endif
            endif
            let hex{i}=colorv#hsv2hex([h,s,v{i}])
        elseif type=="Monochromatic"
            "s+step v+step
            let step=step>0 ? 5 : step<0 ? -5 : 0
            if i==0
                let s0=s
                let v0=v
            else
                let s{i}=s{i-1}+step
                let v{i}=v{i-1}+step
                if circle==1
                    let s{i} = s{i} >=100 ? 1 : s{i} <= 0 ? 100 : s{i}
                    let v{i} = v{i} >=100 ? 1 : v{i} <= 0 ? 100 : v{i}
                else
                    let s{i} = s{i} >=100 ? 100 : s{i} <= 0 ? 1 : s{i}
                    let v{i} = v{i} >=100 ? 100 : v{i} <= 0 ? 1 : v{i}
                endif
            endif
            let hex{i}=colorv#hsv2hex([h,s{i},v{i}])
        elseif type=="Analogous"
            "h+30
            let h{i}=h+30*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Neutral"
            "h+15
            let h{i}=h+15*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Complementary"
            "h+180
            let h{i}=h+180*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Split-Complementary"
            "h+150,h+60,... 
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+150 : h{i-1}+60
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Triadic"
            "h+120
            let h{i}=h+120*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Clash"
            "h+90,h+180,...
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+90 : h{i-1}+180
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Square"
            "h+90
            let h{i}=h+90*i
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Tetradic" || type=="Rectangle"
            "h+60,h+120,...
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+60 : h{i-1}+120
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Five-Tone"
            "h+115,+40,+50,+40,+115
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,5)==1 ? h{i-1}+115 : 
                        \s:fmod(i,5)==2 ? h{i-1}+40 : 
                        \s:fmod(i,5)==3 ? h{i-1}+50 : 
                        \s:fmod(i,5)==4 ? h{i-1}+40 :
                        \h{i-1}+115
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        elseif type=="Six-Tone"
            "h+30,90,...
            if i==0
            	let h{i}=h
            else
                let h{i}=s:fmod(i,2)==1 ? h{i-1}+30 : h{i-1}+90
            endif
            let hex{i}=colorv#hsv2hex([h{i},s,v])
        else
            call s:warning("Not Correct color generator Type.")
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
    if g:ColorV_gen_space=="yiq"
        let list=colorv#yiq_winlist_gen(hex,type,nums,step)
    else
        let list=s:winlist_generate(hex,type,nums,step)
    endif
    call colorv#list_win(list)
endfunction "}}}
"}}}
" PREV: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorv#prev_txt(txt) "{{{
    if !exists("s:prev_dict")|let s:prev_dict={}|endif
    let hex_list=s:txt2hex(a:txt)
    let bufnr=bufnr('%')
    for prv_item in hex_list
        if prv_item[4]=="NAME"
            if exists("s:ColorV_view_name") && s:ColorV_view_name==1
                let hi_ptn='\<'.prv_item[3].'\>'
            else
            	continue
            endif
        elseif prv_item[4]=="NS6" || prv_item[4]=="NS3" 
           \|| prv_item[4]=="HEX" || prv_item[4]=="HEX0"
            let hi_ptn=prv_item[3].'\x\@!'
        else
            let hi_ptn=prv_item[3]
        endif
        " cv_prv3_ff0000
        let hi_grp="cv_prv".bufnr."_".prv_item[0]

        if exists("s:ColorV_view_block") && s:ColorV_view_block==1
            let hi_fg=prv_item[0]
        else
            let hi_fg=s:rlt_clr(prv_item[0])
        endif
        try 
            let hi_ptn_a=substitute(hi_ptn,'\W',"_","g")
            if !exists("s:prev_dict['".hi_ptn_a."']")
                call colorv#hi_color(hi_grp,hi_fg,prv_item[0])
                let s:prev_dict[hi_ptn_a]= matchadd(hi_grp,hi_ptn)
            endif
        catch /^Vim\%((\a\+)\)\=:E254/
            call s:debug("E254:Unknow colorname")
        endtry
    endfor
endfunction "}}}
function! colorv#preview(...) "{{{
"parse each line with color format text
"then highlight the color text
    call s:clear_prevmatch()
    if exists("a:1") && a:1 =~ "N"
    	let s:ColorV_view_name=0
    else
    	let s:ColorV_view_name=g:ColorV_view_name
    endif
    if exists("a:1") && a:1 =~ "B"
        let s:ColorV_view_block=1
    else
        let s:ColorV_view_block=g:ColorV_view_block
    endif

"python timer.
if has("python") && g:ColorV_no_python!=1
python << EOF
import time
import vim
o_t=time.time()
EOF
endif
    let file_lines=getline(1,line('$'))
    for i in range(len(file_lines))
        let line=file_lines[i]
        call colorv#prev_txt(line)
    endfor
if has("python") && g:ColorV_no_python!=1
python << EOF
n_t=time.time()
vim.command("let t_t ="+str(n_t - o_t))
EOF
endif
    if exists("t_t")
        call s:echo(line('$')." lines processed."
                    \."Takes ". string(t_t) . " sec." )
    else
        call s:echo(line('$')." lines processed")
    endif


    let s:ColorV_view_block=g:ColorV_view_block
    let s:ColorV_view_name=g:ColorV_view_name
endfunction "}}}
function! colorv#preview_line(...) "{{{
    "if not clear then prev line in a previewed file will change nothing.
    if !exists("a:1") || a:1 !~ "C"
        call s:clear_prevmatch()
    endif
    if exists("a:1") && a:1 =~ "N"
    	let s:ColorV_view_name=0
    else
    	let s:ColorV_view_name=g:ColorV_view_name
    endif
    if exists("a:1") && a:1 =~ "B"
        let s:ColorV_view_block=1
    else
        let s:ColorV_view_block=g:ColorV_view_block
    endif
    if exists("a:2") && a:2 >0  && a:2 <= line('$')
    	let line = getline(a:2)
    else
        let line=getline('.')
    endif
    call colorv#prev_txt(line)
    let s:ColorV_view_name=g:ColorV_view_name
    let s:ColorV_view_block=g:ColorV_view_block
endfunction "}}}
"}}}
" INIT: "{{{1
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
        au!
        au VIMLEAVEPre * call <SID>write_cache()
    aug END
endif "}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"}}}
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tw=78:fdm=marker:

