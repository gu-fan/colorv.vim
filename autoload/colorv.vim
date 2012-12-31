"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV
"    File: autoload/colorv.vim
" Summary: A vim plugin to make colors handling easier.
"  Author: Rykka G.Forest <Rykka10(at)gmail.com>
"    Home: https://github.com/Rykka/ColorV
" Version: 3.0
" Last Update: 2012-06-08
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim
" if version < 700 || exists("g:loaded_ColorV") | finish
" else             | let g:loaded_ColorV = 1  | endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GVAR: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:colorv={}
let g:colorv.version="3.0"

let g:colorv.HEX="FF0000"
let g:colorv.RGB={'R':255 , 'G':0   , 'B':0   }
let g:colorv.HSV={'H':0   , 'S':100 , 'V':100 }
let g:colorv.HLS={'H':0   , 'L':50  , 'S':100 }
let g:colorv.YIQ={'Y':30  , 'I':60  , 'Q':21  }
let g:colorv.rgb=[255 , 0   , 0   ]
let g:colorv.hls=[0   , 50  , 100 ]
let g:colorv.yiq=[30  , 60  , 21  ]
let g:colorv.hsv=[0   , 100 , 100 ]
let g:colorv.NAME="Red"

"SVAR: {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:ColorV = {}
let s:ColorV.name="_ColorV_".g:colorv.version
let s:ColorV.listname="_ColorVList_".g:colorv.version
let g:_colorv = s:ColorV
let s:size = "mid"
let s:mode = has("gui_running") ? "gui" : "cterm"
let s:path = expand('<sfile>:p:h').'/'
let g:_colorv['size'] = s:size
let g:_colorv['mode'] = s:mode
let g:_colorv['path'] = s:path
"colorname list "{{{
let s:a='Uryyb'
let s:t='fghDPijmrYFGtudBevwxklyzEIZOJLMnHsaKbcopqNACQRSTUVWX'
let s:e='stuQCvwzeLSTghqOrijkxylmRVMBWYZaUfnXopbcdANPDEFGHIJK'

let s:aprx_rate=5
let s:tune_step=4
"X11 Standard
call colorv#data#init()
let s:clrn = g:_colorv['clrn']
let s:cX11 = g:_colorv['cX11']
let s:cW3C = g:_colorv['cW3C']

let s:clrnW3C = s:clrn + s:cW3C
let s:clrnX11 = s:clrn + s:cX11

let s:clrf = g:_colorv['clrf']
let s:clrd = g:_colorv['clrd']

let s:cX11d = g:_colorv['cX11d']
let s:cW3Cd = g:_colorv['cW3Cd']
let s:clrdX11 = extend(copy(s:clrd),s:cX11d)
let s:clrdW3C = extend(copy(s:clrd),s:cW3Cd)

" pos "{{{
let s:line_width=60
let [s:pal_W,s:pal_H]=[20,5]
let [s:OFF_W,s:OFF_H]=[0,1]
let [s:max_h,s:mid_h,s:min_h]=[8,6,3]


" the status col pos in colorv window
let s:stat_pos = 53
let s:tip_pos = 22

"}}}
" txt "{{{
let s:hlp_d = {
            \"r":["[RGB]RED"        , 0   , 255] ,
            \"g":["[RGB]GREEN"      , 0   , 255] ,
            \"b":["[RGB]Blue"       , 0   , 255] ,
            \"H":["[HLS]Hue"        , 0   , 360] ,
            \"L":["[HLS]Lightness"  , 0   , 100] ,
            \"S":["[HLS]Saturation" , 0   , 100] ,
            \"h":["[HSV]Hue"        , 0   , 360] ,
            \"s":["[HSV]Saturation" , 0   , 100] ,
            \"v":["[HSV]Value"      , 0   , 100] ,
            \"Y":["[YIQ]Luma"       , 0   , 100] ,
            \"I":["[YIQ]I-Channel"  , -60 , 60 ]  ,
            \"Q":["[YIQ]Q-Channel"  , -52 , 52 ]  ,
            \}

let s:win_tips = [
            \"Yank:yy Hue:gh Names:nn Tips:? ",
            \"Copy:cc Sat:gs Next:Tab Help:H ",
            \"Paste:P Val:gv TurnT:gg Mark:m ",
            \"Scheme:ss Faved_Schemes:sf",
            \"Edit:Clik/Enter   Change:+/-   ",
            \]
let s:tips_list=[
            \'Move:Click/<Tab>/hjkl...',
            \'Edit:<2-Click>/<2-Space>/<Enter>',
            \'Yank(reg"): yy:HEX yr:RGB yl:HSL ym:CMYK ',
            \'Copy(reg+): cy:HEX cr:RGB cl:HSL cm:CMYK ',
            \'Toggle Size: zz/Z',
            \'Mark(shows in max window): mm',
            \'DelMark(color in max window): dd',
            \'Paste:<Ctrl-V>/p (Paste color and show)',
            \'Schemes:ss Faved Schemes:sf',
            \'ColornameEdit(W3C):na/ne       (X11):nx',
            \'ColornameList:nn (:ColorVName  <leader>cn)',
            \'ColorList: g1/g2/g3/g4/g5/g6/gh/gs/gv...',
            \'ColorList2: gg (hex1 Turn To hex2)',
            \'View color-text: :ColorVView (<leader>cw) ',
            \'Edit color-text: :ColorVEdit (<leader>ce) ',
            \'Preview in file: :ColorVPreview (<leader>cpp) ',
            \'Pick in screen:  :ColorVPicker (<leader>cd) ',
            \'Help:<F1>/H       Quit:q/Q',
            \]
"}}}
" match dic "{{{

if !exists("s:cv_dic")|let s:cv_dic={}|endif
let g:_colorv['cv_dic'] = s:cv_dic
if !exists("s:cv_dic['misc']")|let s:cv_dic['misc']={}|endif
if !exists("s:cv_dic['rect']")|let s:cv_dic['rect']={}|endif
if !exists("s:cv_dic['hsv']") |let s:cv_dic['hsv']={} |endif
if !exists("s:cv_dic['pal']") |let s:cv_dic['pal']={} |endif
if !exists("s:cv_dic['scheme']") |let s:cv_dic['scheme']={} |endif
let s:pal_clr_list= []
let s:hueline_list= []
let s:satline_list= []
let s:valline_list= []
"}}}
" miscs "{{{
let s:skip_his_rec_upd = 0
" let g:_colorv['mark']=exists("g:_colorv['mark']")
"             \ ? g:_colorv['mark'] : repeat([0],20)
let s:his_set_list=exists("s:his_set_list")
            \ ? s:his_set_list : ['ff0000']
let g:_colorv['history'] = s:his_set_list

let s:his_set_rect=[45,2,5,4]
let s:his_cpd_rect=[22,7,2,1]
let g:_colorv['mark_rect'] = s:his_cpd_rect
"}}}
"PYTH: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:py = "py"
let s:pycolor = s:path."colorv/colorv.py"
let s:pypicker = shellescape(s:path."colorv/picker.py")
let s:cpicker = shellescape(s:path."colorv/colorpicker")
function! s:py_core_load() "{{{
    if exists("s:py_core_loaded")
        return
    endif
    let s:py_core_loaded=1
    exec s:py."file ".s:pycolor
endfunction "}}}

"CORE: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorv#rgb2hex(rgb)   "{{{
    let [r,g,b] = a:rgb
    let r = r>255 ? 255 : r<0 ? 0 : r
    let g = g>255 ? 255 : g<0 ? 0 : g
    let b = b>255 ? 255 : b<0 ? 0 : b
    return printf("%02X%02X%02X",float2nr(r+0.0),
                \float2nr(g+0.0),float2nr(b+0.0))
endfunction "}}}
function! colorv#hex2rgb(hex) "{{{
    let hex=substitute(a:hex,'#\|0x\|0X','','')
    if len(hex) == 3
       let hex=substitute(hex,'.','&&','g')
    endif
    if len(hex) < 6
       let hex=printf("%06X","0x".hex)
    endif
    return [str2nr(hex[0:1],16),str2nr(hex[2:3],16),str2nr(hex[4:5],16)]
    " return ["0x".hex[0:1],"0x".hex[2:3],"0x".hex[4:5]]
    " return map([hex[0:1],hex[2:3],hex[4:5]],'str2nr(v:val,16)')
endfunction "}}}

function! colorv#rgb2hsv(rgb)  "{{{
    let [r,g,b] = a:rgb
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b

    let max=max([r,g,b])
    let min=min([r,g,b])
    let df=max-min+0.0

    let V = float2nr(round(max/2.55))
    let S = V==0 ? 0 : float2nr(round(df*100.0/max))
    let H = max==min ? 0 : max==r ? 60.0*(g-b)/df :
                         \ max==g ? 120+60.0*(b-r)/df : 240+60.0*(r-g)/df
    let H = float2nr(round(H))
    let H = H>=360 ? H%360: H<0 ? 360+H%360 : H
    return [H,S,V]
endfunction "}}}
function! colorv#hsv2rgb(hsv) "{{{
    " NOTE:  use a:hsv to avoid variable mismatch: x="3", x=0.3
    let [h, s, v]=[float2nr(a:hsv[0]+0.0),a:hsv[1]/100.0,a:hsv[2]*2.55]
    let h = h>=360 ? h%360: h<0 ? 360+h%360 : h
    let s = s>1   ? 1.0 : s < 0 ? 0.0 : s
    let v = v>255 ? 255.0 : v < 0 ? 0.0 : v

    if s == 0
        let v = float2nr(round(v))
        return [v,v,v]
    else
        let hi = floor(abs(h/60.0))
        let f  = h/60.0 - hi
        let p  = float2nr(round(v*(1-s)))
        let q  = float2nr(round(v*(1-f*s)))
        let t  = float2nr(round(v*(1-(1-f)*s)))
        let v  = float2nr(round(v))
        if hi==0
            return [v,t,p]
        elseif hi==1
            return [q,v,p]
        elseif hi==2
            return [p,v,t]
        elseif hi==3
            return [p,q,v]
        elseif hi==4
            return [t,p,v]
        elseif hi==5
            return [v,p,q]
        endif
    endif
endfunction "}}}
function! colorv#hex2hsv(hex) "{{{
   return colorv#rgb2hsv(colorv#hex2rgb(a:hex))
endfunction "}}}
function! colorv#hsv2hex(hsv) "{{{
    return colorv#rgb2hex(colorv#hsv2rgb(a:hsv))
endfunction "}}}

function! colorv#rgb2hls(rgb) "{{{
    let [r,g,b] = a:rgb
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    let max=max([r,g,b])
    let min=min([r,g,b])
    let df=max-min+0.0

    let L = float2nr(round((max+min)*0.196078431))
    if L==0 || max==min
        let S=0
    elseif L>0 && L<=50
        let S= float2nr(round(df/(max+min)*100))
    else
        let S= float2nr(round(df/(510-max-min)*100))
    endif

    let H = max==min ? 0 : max==r ? 60.0*(g-b)/df :
                         \ max==g ? 120+60.0*(b-r)/df : 240+60.0*(r-g)/df
    let H = float2nr(round(H))
    let H = H>=360 ? H%360: H<0 ? 360+H%360 : H
    return [H,L,S]
endfunction "}}}
function! s:vh2rgb(v1,v2,vh) "{{{
    let [v1,v2,vh]=[a:v1,a:v2,a:vh]
    if     vh<0 | let vh+=1
    elseif vh>1 | let vh-=1
    endif
    if     vh<0.1666667
        return v1+(v2-v1)*6*vh
    elseif vh<0.5
        return v2
    elseif vh<0.6666667
        return v1+(v2-v1)*(4-vh*6)
    endif
    return v1
endfunction "}}}
function! colorv#hls2rgb(hls) "{{{
    let [h,l,s]=[float2nr(a:hls[0]+0.0),a:hls[1]/100.0,a:hls[2]/100.0]
    let h = h>=360 ? h%360: h<0 ? 360+h%360 : h
    let l = l>1 ? 1.0 : l < 0 ? 0.0 : l
    let s = s>1 ? 1.0 : s < 0 ? 0.0 : s
    let h = h/360.0

    if s == 0
        let l = float2nr(round(l*255))
        return [l,l,l]
    else
        if l < 0.5
            let var_2 = l * (1+s)
        else
            let var_2 = (l+s)-(s*l)
        endif
        let var_1 = 2*l-var_2
        let r = float2nr(round(s:vh2rgb(var_1,var_2,(h+0.3333333))*255))
        let g = float2nr(round(s:vh2rgb(var_1,var_2,h)*255))
        let b = float2nr(round(s:vh2rgb(var_1,var_2,(h-0.3333333))*255))
    endif
    return [r,g,b]
endfunction "}}}
function! colorv#hex2hls(hex) "{{{
   return colorv#rgb2hls(colorv#hex2rgb(a:hex))
endfunction "}}}
function! colorv#hls2hex(hls) "{{{
    return colorv#rgb2hex(colorv#hls2rgb(a:hls))
endfunction "}}}

function! colorv#hex2hsl(hex) "{{{
   let [h,l,s]=colorv#rgb2hls(colorv#hex2rgb(a:hex))
   return [h,s,l]
endfunction "}}}
function! colorv#hsl2hex(hsl) "{{{
    let [h,s,l]=a:hsl
    return colorv#rgb2hex(colorv#hls2rgb([h,l,s]))
endfunction "}}}

"YUV color space (PAL)
function! colorv#rgb2yuv(rgb) "{{{
    let [r,g,b] = a:rgb
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b

    let Y=float2nr(round( 0.11725490*r + 0.23019608*g + 0.04470588*b))
    let U=float2nr(round(-0.05764706*r - 0.11333333*g + 0.17098039*b))
    let V=float2nr(round( 0.24117647*r - 0.20196078*g - 0.03921569*b))
    return [Y,U,V]
endfunction "}}}
function! colorv#yuv2rgb(yuv) "{{{
    let [Y,U,V]=a:yuv
    let Y= Y>100 ? 100 : Y<0 ? 0 : Y
    let U= U>100 ? 100 : U<-100 ? -100 : U
    let V= V>100 ? 100 : V<-100 ? -100 : V
    let R = float2nr(round(Y*2.55 + 2.907 *V))
    let G = float2nr(round(Y*2.55 - 1.00725*U - 1.48155*V))
    let B = float2nr(round(Y*2.55 + 5.1816*U))
    let R = R>255 ? 255 : R<0 ? 0 : R
    let G = G>255 ? 255 : G<0 ? 0 : G
    let B = B>255 ? 255 : B<0 ? 0 : B
    return [R,G,B]
endfunction "}}}
function! colorv#hex2yuv(hex) "{{{
   return colorv#rgb2yuv(colorv#hex2rgb(a:hex))
endfunction "}}}
function! colorv#yuv2hex(yuv) "{{{
    return colorv#rgb2hex(colorv#yuv2rgb(a:yuv))
endfunction "}}}

"YIQ color space (NTSC)
function! colorv#rgb2yiq(rgb) "{{{.
    let [r,g,b] = a:rgb
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    let Y=float2nr(round(0.11725490*r + 0.23019608*g+ 0.04470588*b))
    let I=float2nr(round(0.23360784*r +-0.10764706*g+-0.126*b))
    let Q=float2nr(round(0.08294118*r +-0.20494118*g+ 0.122*b))
    return [Y,I,Q]
endfunction "}}}
function! colorv#yiq2rgb(yiq) "{{{
    let [y,i,q]=a:yiq
    let y= y>100 ? 100 : y<0   ?  0  : y
    let i= i>60  ? 60  : i<-60 ? -60 : i
    let q= q>52  ? 52  : q<-52 ? -52 : q
    let r = float2nr(round(y*2.55 + 2.438565*i+ 1.58355*q))
    let g = float2nr(round(y*2.55 - 0.693855*i- 1.65087*q))
    let b = float2nr(round(y*2.55 - 2.822850*i+ 4.34673*q))
    let r = r>255 ? 255 : r<0 ? 0 : r
    let g = g>255 ? 255 : g<0 ? 0 : g
    let b = b>255 ? 255 : b<0 ? 0 : b
    return [r,g,b]
endfunction "}}}
function! colorv#hex2yiq(hex) "{{{
   return colorv#rgb2yiq(colorv#hex2rgb(a:hex))
endfunction "}}}
function! colorv#yiq2hex(yiq) "{{{
    return colorv#rgb2hex(colorv#yiq2rgb(a:yiq))
endfunction "}}}

" http://www.fho-emden.de/~hoffmann/ciexyz29082000.pdf
" http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
" sRGB D65(noon light) 2ᵒ
" xr=95.047 yr=100 zr=108.883
function! colorv#rgb2xyz(rgb) "{{{
    let [r,g,b]= a:rgb
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    let [r,g,b]=[r/255.0,g/255.0,b/255.0]
    let X = 0.4124564*r + 0.3575761*g + 0.1804375*b
    let Y = 0.2126729*r + 0.7151522*g + 0.0721750*b
    let Z = 0.0193339*r + 0.1191920*g + 0.9503041*b
    let X = X*100.0
    let Y = Y*100.0
    let Z = Z*100.0
    return [X,Y,Z]
endfunction "}}}
function! colorv#xyz2rgb(xyz) "{{{
    let [x,y,z]= a:xyz
    let x = x/100.0
    let y = y/100.0
    let z = z/100.0
    let R = 3.2404542*x +-1.5371385*y +-0.4985314*z
    let G =-0.9692660*x + 1.8760108*y + 0.0415560*z
    let B = 0.0556434*x +-0.2040259*y + 1.0572252*z
    return [R*255,G*255,B*255]
endfunction "}}}
" CIELAB
" http://www.fho-emden.de/~hoffmann/cielab03022003.pdf
" http://www.easyrgb.com/index.php?X=MATH&H=07#text7
function! colorv#xyz2lab(xyz) "{{{
    let [X,Y,Z] = a:xyz
    let X = X/ 95.047
    let Y = Y/100.0
    let Z = Z/108.883
    if (X > 0.008856)
      let X = pow(X ,(0.3333333))
    else
      let X = (7.787 * X) + (0.1379310)
    endif
    if (Y > 0.008856)
      let Y = pow(Y ,(0.3333333))
    else
      let Y = (7.787 * Y) + (0.1379310)
    endif
    if (Z > 0.008856)
      let Z = pow(Z ,(0.3333333))
    else
      let Z = (7.787 * Z) + (0.1379310)
    endif

    let L = (116 * Y) - 16
    let a = 500 * (X - Y)
    let b = 200 * (Y - Z)

    return [L, a, b]
endfunction "}}}
function! colorv#lab2xyz(lab) "{{{
    let [L,a,b] = a:lab
    let Y = (L+16)/116.0
    let X = a/500.0 + Y
    let Z = Y-b/200.0

    if pow(X,3) > 0.008856
        let X = pow(X,3)
    else
        let X = (116*X-16)/903.3
    endif

    if pow(Y,3) > 0.008856
        let Y = pow(Y,3)
    else
        let Y = (116*Y-16)/903.3
    endif
    if pow(Z,3) > 0.008856
        let Z = pow(Z,3)
    else
        let Z = (116*Z-16)/903.3
    endif
    let X = X* 95.047
    let Y = Y*100.0
    let Z = Z*108.883
    return [X,Y,Z]
endfunction "}}}
function! colorv#rgb2lab(rgb) "{{{
    return colorv#xyz2lab(colorv#rgb2xyz(a:rgb))
endfunction "}}}
function! colorv#lab2rgb(lab) "{{{
    return colorv#xyz2rgb(colorv#lab2xyz(a:lab))
endfunction "}}}


"CMYK (Cyan,Magenta,Yellow and Black)
function! colorv#rgb2cmyk(rgb) "{{{
    let [r,g,b] = a:rgb
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    let [C,M,Y]=[1.0-r/255.0,1.0-g/255.0,1.0-b/255.0]
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
    return [float2nr(round(C*100)),float2nr(round(M*100)),
                \float2nr(round(Y*100)),float2nr(round(K*100))]
endfunction "}}}
function! colorv#cmyk2rgb(cmyk) "{{{
    let [C,M,Y,K]=map(a:cmyk,'v:val/100.0')
    let R=float2nr(round((1.0-(C*(1.0-K)+K))*255))
    let G=float2nr(round((1.0-(M*(1.0-K)+K))*255))
    let B=float2nr(round((1.0-(Y*(1.0-K)+K))*255))
    return [R,G,B]
endfunction "}}}
function! colorv#hex2cmyk(hex) "{{{
   return colorv#rgb2cmyk(colorv#hex2rgb(a:hex))
endfunction "}}}
function! colorv#cmyk2hex(cmyk) "{{{
    return colorv#rgb2hex(colorv#cmyk2rgb(a:cmyk))
endfunction "}}}

"Terminal
function! colorv#hex2term(hex,...) "{{{
    if g:colorv_has_python
        if a:0
            if (&t_Co<=8 && a:1==#"CHECK") || a:1==8
                exe s:py . ' vcmd("return \""+str(hex2term8(veval("a:hex"))) + "\"")'
            elseif (&t_Co<=16 && a:1=="CHECK") || a:1==16
                exe s:py . ' vcmd("return \""+str(hex2term8(veval("a:hex"),16))+ "\"")'
            endif
        endif
        exe s:py . ' vcmd("return \""+str(hex2term(veval("a:hex")))+"\"")'
    else
        if a:0
            if ( a:1=="CHECK" && &t_Co<=8) || a:1==8
                return s:hex2term8(a:hex)
            elseif ( a:1=="CHECK" && &t_Co<=16 ) || a:1==16
                return s:hex2term8(a:hex,16)
            endif
        endif
        return s:hex2term(a:hex)
    endif
endfunction "}}}

function! s:hex2term(hex) "{{{
    let [r,g,b]=colorv#hex2rgb(a:hex)

    " NOTE: the grayscale colors.
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
        " NOTE: get the idx num of hex in term table.
        for i in ["r", "g" ,"b"]
            if {i} <= 48
                let {i} = 0
            elseif {i} <= 115
                let {i} = 1
            elseif {i} <= 155
                let {i} = 2
            elseif {i} <= 195
                let {i} = 3
            elseif {i} <= 235
                let {i} = 4
            else
                let {i} = 5
            endif
        endfor
        let t_num = r*36 + g*6 + b + 16
    endif
    return t_num
endfunction "}}}
function! s:hex2term8(hex,...) "{{{
    let [r,g,b]=colorv#hex2rgb(a:hex)
    for i in ["r","g","b"]
        if {i} <= 64
            let {i} = 0
        elseif {i} <= 192
            let {i} = 1
        else
            let {i} = 2
        endif
    endfor
    " 808000
    if r <= 1 && g <= 1 && b <= 1
        let i = r*4 + g*2 + b
        let z = 0
    else
        " ffff00
        let i = (r/2)*4 + (g/2)*2   + b/2
        let z = 1
    endif
    if a:0 && a:1 == 16
        let t  = i  + z * 8
    else
        " NOTE: 8 color needs to change sequence
        let t  = "04261537"[i] + z * 8
    endif
    if t == 7
        let t = 8
    endif
    return t
endfunction "}}}

" RGBA
function! s:rgb2rgba(rgb,...) "{{{
    if a:0
        return a:rgb + [a:1]
    else
        return a:rgb + [255]
    endif
endfunction "}}}
function! s:rgba2rgb(rgba) "{{{
    return a:rgba[0:2]
endfunction "}}}
function! s:hex2hexa(hex,...) "{{{
    if a:0
        return a:hex + a:1
    else
        return a:hex + "ff"
    endif
endfunction "}}}
function! s:hexa2hex(hexa) "{{{
    return a:hexa[0:-3]
endfunction "}}}
function! s:hexa2rgba(hexa) "{{{
    let hex=substitute(a:hexa,'#\|0x\|0X','','')
    if len(hex) < 8
       let hex=printf("%08X","0x".hex)
    endif
    return [str2nr(hex[0:1],16), str2nr(hex[2:3],16),
            \str2nr(hex[4:5],16), str2nr(hex[6:7],16)]
endfunction "}}}
function! s:rgba2hexa(rgba) "{{{
    let [r,g,b,a]=map(a:rgba,'float2nr(v:val)')
    let r= r>255 ? 255 : r<0 ? 0 : r
    let g= g>255 ? 255 : g<0 ? 0 : g
    let b= b>255 ? 255 : b<0 ? 0 : b
    let a= a>255 ? 255 : a<0 ? 0 : a
    return printf("%02X%02X%02X%02X",r,g,b,a)
endfunction "}}}

" Operation
function! s:add(rgba1,rgba2) "{{{
    let [r1,g1,b1,a1] = a:rgba1
    let [r2,g2,b2,a2] = a:rgba2
    let t = ( a1 + 0.0 ) / ( a1 + a2 + 0.0 )
    let r3 = r1 * t + r2 * ( 1 - t )
    let g3 = g1 * t + g2 * ( 1 - t )
    let b3 = b1 * t + b2 * ( 1 - t )
    let a3 = a1 * t + a2 * ( 1 - t )
    return [r3,g3,b3,a3]
endfunction "}}}
function! colorv#hexadd(hexa1,hexa2) "{{{
    let rgba1 = s:hexa2rgba(a:hexa1)
    let rgba2 = s:hexa2rgba(a:hexa2)
    return  s:rgba2hexa(s:add(rgba1, rgba2))
endfunction "}}}

"DRAW: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:lookup = {}
function! s:draw_palette(H,h,w) "{{{
    let [H,height,width]=[float2nr(a:H),a:h,a:w]
    let H = H>=360 ? H%360: H<0 ? 360+H%360 : H
    let name = H.'_'.height.'_'.width
    if !has_key(s:lookup , name) "{{{
        let p2 = []
        let V_step = 100.0/height
        let S_step = 100.0/width
        for row in range(height)
            let V =  100 - V_step * row
            let V = V<=0 ? 0 : V
            let l = []
            for col in range(width)
                let S = 100 -  S_step * col
                let S = S<=0 ? 0 : S
                let hex = colorv#hsv2hex([H,S,V])
                call add(l, hex)
            endfor
            call add(p2, l)
        endfor
        let s:lookup[name] = p2       " ref it, will be kept when p2 destroy
    else
        let p2 = s:lookup[name]       " ref it, will be destroied when [] new
    endif "}}}

    " clear it. otherwise it will get slower and slower.
    call colorv#clear("pal")
    for row in range(height) "{{{
        for col in range(width)
            let hex = p2[row][col]
            let hi_grp  = "tv_pal_".row."_".col
            call s:hi_color(hi_grp,hex,hex," ")
            let pos_ptn = '\%'.(row+s:OFF_H+1).'l'
                        \.'\%'.(col+s:OFF_W+1).'c'
            sil! let s:cv_dic['pal'][hi_grp]=matchadd(hi_grp,pos_ptn)
        endfor
    endfor "}}}
    let s:pal_clr_list = p2
endfunction
"}}}
function! s:draw_palette_hex(hex,...) "{{{
    if g:colorv_has_python
        exe s:py . ' draw_pallete_hex(veval("a:hex"))'
    else
        let [h,s,v]=colorv#hex2hsv(a:hex)
        let g:colorv.HSV.H=h
        if a:0 && len(a:1) == 2
            call s:draw_palette(h,a:1[0],a:1[1])
        else
            call s:draw_palette(h,s:pal_H,s:pal_W)
        endif
    endif
endfunction "}}}
function! s:draw_multi_rect(rect,hex_list,...) "{{{
    "rect:      rectangle[x,y,w,h]
    "hex_list:  [ffffff,ffffff]
    let [x,y,w,h]=a:rect
    let rect_hex_list=a:hex_list
    let dic = a:0 ? a:1 : 'rect'

    for idx in range(len(rect_hex_list))
        let hex=rect_hex_list[idx]
        let hi_grp="cv_rct_".(x+w*idx)."_".y."_".w."_".h
        let rect_ptn='\%>'.(x+w*idx-1).'c\%<'.(x+w*(idx+1))
                     \.'c\%>'.(y-1).'l\%<'.(y+h)."l"
        call s:hi_color(hi_grp,hex,hex," ")
        sil! let s:cv_dic[dic][hi_grp]=matchadd(hi_grp,rect_ptn)
    endfor
endfunction "}}}
let s:his_color0 = "FF0000"
let s:his_color1 = "FFFFFF"
let s:his_color2 = "FFFFFF"
function! s:draw_history_rect(hex) "{{{
    let hex= s:fmt_hex(a:hex)
    let len=len(s:his_set_list)
    let s:his_color2= len >2 ? s:his_set_list[len-3] : 'FFFFFF'
    let s:his_color1= len >1 ? s:his_set_list[len-2] : 'FFFFFF'
    let s:his_color0= len >0 ? s:his_set_list[len-1] : hex
    call s:draw_multi_rect(s:his_set_rect,[s:his_color0,s:his_color1,s:his_color2])
endfunction "}}}

fun! colorv#draw_rects(rect, hex_list,...) "{{{
    call s:draw_multi_rect(a:rect,a:hex_list,a:0 ? a:1 : 'rect')
endfun "}}}

let s:hue_H = 0
let s:val_S = 100
function! s:draw_hueline(l) "{{{
    call colorv#clear("hsv")

    let step  = 360/s:pal_W

    " NOTE: make hueline dynamic.
    if g:colorv.HSV.S !=0
        let s:hue_H = g:colorv.HSV.H
    endif
    let h = s:hue_H

    let [s,v] = [100,100]

    let hue_list = []
    for col in range(s:pal_W)
        let hi_grp = "cv_hue_".col
        let hex = colorv#hsv2hex([h,s,v])
        let pos = "\\%". a:l ."l\\%".(col+1+s:OFF_W)."c"
        call s:hi_color(hi_grp,hex,hex," ")
        sil! let s:cv_dic['hsv'][hi_grp]=matchadd(hi_grp,pos)
        call add(hue_list,hex)
        let h += step
    endfor
    let s:hueline_list = hue_list
endfunction "}}}
function! s:draw_satline(l) "{{{

    let h = s:hue_H
    let v = 100

    let step = 100.0/(s:pal_W)
    let sat_list=[]
    for col in range(s:pal_W)
        let s =  100 - col * step
        let s = s<=0 ? 0 : s

        let hi_grp = "cv_sat_".col
        let hex = colorv#hsv2hex([h,s,v])
        let ptn = '\%'. a:l .'l\%'.(col+1+s:OFF_W).'c'

        call s:hi_color(hi_grp,hex,hex," ")
        sil! let s:cv_dic['hsv'][hi_grp]=matchadd(hi_grp, ptn)
        call add(sat_list,hex)

    endfor
    let s:satline_list=sat_list
endfunction "}}}
function! s:draw_valline(l) "{{{

    let h = s:hue_H
    " make val Lines's Saturation same with color.
    if g:colorv.HSV.S != 0
        let s:val_S = g:colorv.HSV.S
    endif
    let s = s:val_S

    let step = 100.0/(s:pal_W)
    let val_list = []
    for col in range(s:pal_W)
        let v = 100.0 - col*step
        let v = v<=0 ? 0 : v

        let hi_grp="cv_val_".col
        let hex = colorv#hsv2hex([h,s,v])

        let ptn = '\%'.a:l.'l'
                \.'\%'.(col+1+s:OFF_W).'c'

        call s:hi_color(hi_grp,hex,hex," ")
        sil! let s:cv_dic['hsv'][hi_grp] = matchadd(hi_grp,ptn)
        call add(val_list,hex)
    endfor
    let s:valline_list=val_list
endfunction "}}}
function! s:hi_color(hl_grp,hl_fg,hl_bg,hl_fm) "{{{

    let [hl_grp,hl_fg,hl_bg,hl_fm]=[a:hl_grp,a:hl_fg,a:hl_bg,a:hl_fm]

    if s:mode == "gui"
        let hl_fg = hl_fg=~'^\x\{6}$' ? "#".hl_fg : hl_fg
        let hl_bg = hl_bg=~'^\x\{6}$' ? "#".hl_bg : hl_bg
    else
        "  if hex , convert to term numbers 255:0~255 8/16:0~15
        let hl_fg = hl_fg=~'\x\{6}' ? colorv#hex2term(hl_fg,"CHECK") : hl_fg
        let hl_bg = hl_bg=~'\x\{6}' ? colorv#hex2term(hl_bg,"CHECK") : hl_bg

        " NOTE: in cterm 8 color 8~15 should be bold  and foreground only.
        " and only have reverse formats
        let hl_fm = hl_fm=~'reverse' ? "reverse": "NONE"

        if &t_Co == 8
            if hl_fg >= 8
                let hl_fm .= ",bold"
                let hl_fg -= 8
            endif

            let hl_bg -= hl_bg >= 8 ? 8 : 0
        endif
    endif

    let hl_fg = empty(hl_fg) ? "" : " ".s:mode."fg=".hl_fg
    let hl_bg = empty(hl_bg) ? "" : " ".s:mode."bg=".hl_bg
    let hl_fm = hl_fm=~'^\s*$' ? "" : " ".s:mode."="  .hl_fm

    try
        exec "hi ".hl_grp.hl_fg.hl_bg.hl_fm
    catch /^Vim\%((\a\+)\)\=:E/
        call colorv#debug(v:exception."    hi ".hl_grp.hl_fg.hl_bg.hl_fm)
    endtry

endfunction "}}}
function! s:hi_link(from,to) "{{{
    try
        exe "hi link" a:from  a:to
    catch /^Vim\%((\a\+)\)\=:E/
        call colorv#debug(v:exception."    hi link ".a:from." ".a:to)
    endtry
endfunction "}}}
function! s:update_his_list(hex) "{{{
    let hex= s:fmt_hex(a:hex)

    if s:skip_his_rec_upd==1
        let s:skip_his_rec_upd=0
    else
        if get(s:his_set_list,-1)!=hex
            call add(s:his_set_list,hex)
        endif
    endif
endfunction "}}}
function! s:update_global(hex) "{{{
    let hex           = s:fmt_hex(a:hex)
    let g:colorv.HEX  = hex
    let g:colorv.NAME = s:hex2nam(hex)
    let [r,g,b] = colorv#hex2rgb(hex)
    let [h,s,v] = colorv#rgb2hsv([r,g,b])
    let [H,L,S] = colorv#rgb2hls([r,g,b])
    let [Y,I,Q] = colorv#rgb2yiq([r,g,b])
    let g:colorv.rgb = [r,g,b]
    let g:colorv.hsv = [h,s,v]
    let g:colorv.hls = [H,L,S]
    let g:colorv.hsl = [H,S,L]
    let g:colorv.yiq = [Y,I,Q]
    let [g:colorv.RGB.R,g:colorv.RGB.G,g:colorv.RGB.B] = [r,g,b]
    let [g:colorv.HSV.H,g:colorv.HSV.S,g:colorv.HSV.V] = [h,s,v]
    let [g:colorv.HLS.H,g:colorv.HLS.S,g:colorv.HLS.L] = [H,L,S]
    let [g:colorv.YIQ.Y,g:colorv.YIQ.I,g:colorv.YIQ.Q] = [Y,I,Q]

    " update callback
    if exists("s:call_type")
        if s:call_type == "updt"
            call call(s:call_func,s:call_args)
            colorv#win#get(s:ColorV.name)
            unlet s:call_type
            unlet s:call_func
            unlet s:call_args
        endif
    endif
endfunction "}}}
fun! colorv#hi(group,name,ptn,hl,...) "{{{
    if len(a:hl) == 3
        let [fg,bg,attr] = a:hl
        call s:hi_color(a:name,fg,bg,attr)
    else
        let [to] = a:hl
        call s:hi_link(a:name,to)
    endif
    try
        let s:cv_dic[a:group][a:name]=matchadd(a:name,a:ptn,a:0 && a:1 ? a:1 : 10)
    catch
        call colorv#debug('hi match '.v:exception)
    endtry
endfun "}}}
function! s:hi_misc() "{{{

    " change as s:pal_W changes.
    call colorv#clear("misc")

    let [l,c]=s:get_star_pos()
    if s:size=="min"
        let bg= s:valline_list[c-1]
    else
        let bg=s:pal_clr_list[l-s:OFF_H-1][c-s:OFF_W-1]
    endif
    let fg= s:rlt_clr(bg)

    let star_ptn='\%<'.(s:pal_H+1+s:OFF_H).'l\%<'.
                \(s:pal_W+1+s:OFF_W).'c\*'
    call colorv#hi('misc','cv_star',star_ptn,[fg,bg,'bold'],40)

    if s:size=="min"
        let [l,c]=s:get_bar_pos()
        let bg=  s:satline_list[c-1]
        let fg= s:rlt_clr(bg)

        let bar_ptn='\%2l\%<'. (s:pal_W+1+s:OFF_W).'c+'
        call colorv#hi('misc','cv_plus',bar_ptn,[fg,bg,'bold'],20)
    endif

    " tip text highlight
    if s:size!="min"
        " let tip_ptn='\%'.(s:pal_H+1).'l\%>21c\%<60c'
        " call s:hi_link("cv_tip","Comment")
        " sil! let s:cv_dic['misc']["cv_tip"]=matchadd("cv_tip",tip_ptn)
        call colorv#hi('misc','cv_tip','\%'.(s:pal_H+1).'l\%>21c\%<60c',['Comment'])

        " let tip_ptn='\%'.(s:pal_H+1).'l\%>21c\%<60c\S*:'
        " call s:hi_link("cv_stip","SpecialComment")
        " sil! let s:cv_dic['misc']["cv_stip"]=matchadd("cv_stip",tip_ptn,15)
        call colorv#hi('misc','cv_stip','\%'.(s:pal_H+1).'l\%>21c\%<60c\S*:',['SpecialComment'],15)

        " let stat_ptn='\%'.(s:pal_H+1).'l\%>'.(s:stat_pos-1).'c\%<60c[zZYHKC]'
        " call s:hi_link("cv_stat","Keyword")
        " sil! let s:cv_dic['misc']["cv_stat"]=matchadd("cv_stat",stat_ptn,25)
        call colorv#hi('misc','cv_stat','\%'.(s:pal_H+1).'l\%>'.(s:stat_pos-1).'c\%<60c[zZYHKC]' ,['Keyword'],25)

        " let stat_ptn='\%'.(s:pal_H+1).'l\%>'.(s:stat_pos-1).'c\%<60c[x]'
        " call s:hi_link("cv_xstat","Title")
        " sil! let s:cv_dic['misc']["cv_xstat"]=matchadd("cv_xstat",stat_ptn,26)
        call colorv#hi('misc','cv_xstat','\%'.(s:pal_H+1).'l\%>'.(s:stat_pos-1).'c\%<60c[q]' ,['Keyword'],28)
    endif
endfunction "}}}

function! s:draw_text(...) "{{{
    let cur=s:clear_text()
    let cv = g:colorv
    let hex= cv.HEX
    let [r,g,b]= map(copy(cv.rgb),'printf("%3d",v:val)')
    let [h,s,v]= map(copy(cv.hsv),'printf("%3d",v:val)')
    let [H,L,S]= map(copy(cv.hls),'printf("%3d",v:val)')
    let [Y,I,Q]= map(copy(cv.yiq),'printf("%3d",float2nr(v:val))')

    let height = s:size=="max" ? s:max_h : s:size=="mid" ? s:mid_h :
                \ s:min_h

    let line=[]
    for i in range(height)
        let m=repeat(' ',s:line_width)
        call add(line,m)
    endfor

    " para and help, stat:
    let help_txt = s:win_tips[s:tip_c]

    let stat_g = g:colorv_gen_space==?"hsv" ? "H" : "Y"
    let stat_m = s:size=="max" ? " Z" : s:size=="mid" ? " z" : " -"
    let stat_s = g:colorv_default_api ==? 'kuler' ? " K" : ' C'
    let stat_txt = stat_g.stat_s.stat_m." q"
    let line[0]=s:line("ColorV ".g:colorv.version,3)
    let line[0]=colorv#line_sub(line[0],"HEX:".hex,22)
    if s:size=="max"
        let line[1]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[2]=s:line("H:".h."  S:".s."  V:".v,22)
        let line[3]=s:line("H:".H."  L:".L."  S:".S,22)
        let line[4]=s:line("Y:".Y."  I:".I."  Q:".Q,22)
        let line[s:pal_H]=s:line(help_txt,22)
        let line[s:pal_H]=colorv#line_sub(line[s:pal_H],stat_txt,s:stat_pos)
    elseif s:size=="mid"
        let line[2]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[3]=s:line("H:".h."  S:".s."  V:".v,22)
        let line[4]=s:line("H:".H."  L:".L."  S:".S,22)
        let line[s:pal_H]=s:line(help_txt,22)
        let line[s:pal_H]=colorv#line_sub(line[s:pal_H],stat_txt,s:stat_pos)
    elseif s:size=="min"
        let line[1]=s:line("R:".r."  G:".g."  B:".b,22)
        let line[2]=s:line("H:".h."  S:".s."  V:".v,22)
        let line[2]=colorv#line_sub(line[2],stat_txt,s:stat_pos)
    endif

    " colorname
    let nam=g:colorv.NAME
    if !empty(nam)
        if s:size=="min"
        let line[0]=colorv#line_sub(line[0],nam,45)
        else
        let line[0]=colorv#line_sub(line[0],nam,45)
        endif
    endif


    "draw star (asterisk) at pos
    for i in range(height)
        let line[i]=substitute(line[i],'\*',' ','g')
    endfor
    let [l,c]=s:get_star_pos()
    let line[l-1]=colorv#line_sub(line[l-1],"*",c)

    "draw BAR for saturation
    if s:size=="min"
        for i in range(height)
            let line[i]=substitute(line[i],'+',' ','g')
        endfor
        let [l,c]=s:get_bar_pos()
        let line[l-1]=colorv#line_sub(line[l-1],"+",c)
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
    if s:size=="min"
        let l = 2
        let step = 100.0/(s:pal_W)
        let c = s:pal_W - float2nr(round(g:colorv.HSV.S/step)) + 1 + s:OFF_W
        if c>= s:pal_W+s:OFF_W
            let c = s:pal_W+s:OFF_W
        elseif c <= 1 + s:OFF_W
            let c = 1 + s:OFF_W
        endif
        return [l,c]
    endif
endfunction "}}}
function! s:get_star_pos() "{{{
    if s:size=="max" || s:size=="mid"
        let h_step=100.0/(s:pal_H)
        let w_step=100.0/(s:pal_W)
        let l = s:pal_H - float2nr(round(g:colorv.HSV.V/h_step)) + 1 + s:OFF_H
        let c = s:pal_W - float2nr(round(g:colorv.HSV.S/w_step)) + 1 + s:OFF_W

        if l >= s:pal_H+s:OFF_H
            let l = s:pal_H+s:OFF_H
        elseif l <= 1 + s:OFF_H
            let l = 1 + s:OFF_H
        endif

    elseif s:size=="min"
        let l = 3
        let w_step = 100.0/s:pal_W
        let c = s:pal_W - float2nr(round(g:colorv.HSV.V/w_step)) + 1 + s:OFF_W
    endif

    if c >= s:pal_W+s:OFF_W
        let c = s:pal_W+s:OFF_W
    elseif c <= 1 + s:OFF_W
        let c = 1 + s:OFF_W
    endif

    return [l,c]
endfunction "}}}
function! s:clear_text() "{{{
    if !colorv#win#is_same(s:ColorV.name)
        call colorv#error("Not [ColorV] buffer.")
        return
    else
        let cur=getpos('.')
        " silent! normal! ggVG"_x
        silent %delete _
        return cur
    endif
endfunction "}}}
function! s:line(text,pos) "{{{
    "return text in blank line
    return printf("%-".(s:line_width)."s" ,repeat(' ', a:pos-1).a:text)
endfunction "}}}
function! colorv#line_sub(line,text,pos) "{{{
    "return substitute line at pos in input line
    "XXX could not use doublewidth text
    let [line,text,pos]=[a:line,a:text,a:pos]
    let x = len(text)+pos-len(line)
    if  x > 0
        let line .= repeat(' ', x)
    endif
    " if pos!=1
    let pat = '^\(.\{'.(pos-1).'}\)\%(.\{'.len(text).'}\)'
    return substitute(line,pat,'\1'.text,'')
    " else
    "     let pat='^\%(.\{'.len(text).'}\)'
    "     return substitute(line,pat,text,'')
    " endif
endfunction "}}}

function! colorv#clear(c) "{{{
    for [key,var] in items(s:cv_dic[a:c])
        try
            exe "hi clear ".key
            call matchdelete(var)
        catch
            call colorv#debug("clear ".a:c. " " . v:exception)
        endtry
    endfor
    let s:cv_dic[a:c]={}
endfunction "}}}

function! colorv#clear_all() "{{{
    call colorv#clear("rect")
    call colorv#clear("hsv")
    call colorv#clear("misc")
    call colorv#clear("pal")
    call colorv#clear_prev()
    call clearmatches()
endfunction "}}}
"WINS: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:_colorv['bufinfo'] = []
let g:_colorv['lbufinfo'] = []
function! colorv#win(...) "{{{
    " Args: a:1 size  a:2 color a:3 callback [type, func, arg]
    let size  = a:0 ? a:1 : ""
    let color = ( a:0>1 && a:2 !~ '^\s*$' ) ? a:2 : ""
    let funcl = ( a:0>2 && type(a:3) == type([]) ) ? a:3 : []

    if !colorv#win#is_same(s:ColorV.name)
        let g:_colorv['bufinfo'] = [bufnr('%'),bufname('%'),winnr(),getpos('.')]
    endif
    call colorv#win#new(s:ColorV.name,['','',s:pal_H+1])
    call s:set_map()

    let s:tip_c = colorv#random(0,len(s:win_tips)-1)

    " color
    let hex = exists("g:colorv.HEX") ? g:colorv.HEX : "FF0000"
    let s:skip_his_rec_upd = 1
    let hex_list = s:txt2hex(color)
    if !empty(hex_list)
        let hex = s:fmt_hex(hex_list[0][1])
        let s:skip_his_rec_upd = 0
        " cal colorv#echo("Use [".hex."]")
    endif

    if      size == "min" | let s:size="min"
    elseif  size == "max" | let s:size="max"
    elseif  size == "mid" | let s:size="mid"
    endif

    if      s:size=="min" | let s:pal_H=s:min_h-1
    elseif  s:size=="max" | let s:pal_H=s:max_h-1
    else                  | let s:pal_H=s:mid_h-1
    endif

    let g:_colorv['size'] = s:size

    "_funcs
    if len(funcl) >= 2
        let s:call_type = funcl[0]
        let s:call_func = funcl[1]
        let s:call_args = get(funcl,2,[])
    endif

    call s:win_hl()
    call s:draw_win(hex)
endfunction "}}}
let s:prv_hex = "FF0000"
function! s:draw_win(hex,...) "{{{

    if !colorv#win#is_same(s:ColorV.name)
        call colorv#error("Not [ColorV] buffer.")
        return
    endif

    " hex from from internal call may get wrong
    let hex= s:fmt_hex(a:hex)

    if g:colorv_debug==1
        let funcs = "colorv#timer"
        echom "====================================="
    else
        let funcs = "call"
    endif

    call call("s:update_his_list",[hex])
    call {funcs}("s:update_global",[hex])

    " NOTE: we should clear it here, otherwise can not draw multi.
    call {funcs}("colorv#clear",["rect"])

    setl ma lz
    call {funcs}("s:draw_hueline",[1])
    if s:size == "min"
        call {funcs}("s:draw_satline",[2])
        call {funcs}("s:draw_valline",[3])
    else
        " NOTE: prv_hex: avoid pallete hue became 0 when sat became 0
        if g:colorv.HSV.S==0
            call {funcs}("s:draw_palette_hex",[s:prv_hex])
        else
            if a:0 && a:1=="skippal"
                let [ph,ps,pv] = colorv#hex2hsv(s:prv_hex)
                let [h,s,v]    = colorv#hex2hsv(hex)
                if ph != h
                    call {funcs}("s:draw_palette_hex",[hex])
                endif
            else
                call {funcs}("s:draw_palette_hex",[hex])
            endif
            let s:prv_hex= hex
        endif
        if s:size == "max"
            call {funcs}("colorv#mark#draw",[])
        endif
    endif
    call call("s:hi_misc",[])
    call call("s:draw_history_rect",[hex])
    call call("s:draw_text",[])
    setl noma nolz

    if winnr('$') != 1
        if     s:size == "max" | let l:win_h=s:max_h
        elseif s:size == "min" | let l:win_h=s:min_h
        else                   | let l:win_h=s:mid_h
        endif
        execute 'resize' l:win_h
        redraw
    endif

endfunction "}}}

function! s:win_hl() "{{{
    aug colorv#cursor
        au!
        autocmd CursorMoved,CursorMovedI <buffer>  call s:cursor_text_hi()
    aug END
endfunction "}}}
function! s:cursor_text_hi() "{{{
    let [l,c] = getpos('.')[1:2]
    let pos_list = s:size=="max" ? s:max_pos :
                \ s:size=="min" ? s:min_pos : s:mid_pos
    for [str,line,column,length] in pos_list
        if l==line && c>=column && c<column+length
            execute '3match' "Pmenu".' /\%>1l\%'.(line).'l'
                    \.'\%>21c\%<41c/'
            execute '2match' "PmenuSel".' /\%'.(line)
                        \.'l\%>'.(column-1) .'c\%<'.(column+length).'c/'
            return
        endif
    endfor
    execute '2match ' "none"
    execute '3match ' "none"
endfunction "}}}

function! colorv#exit_list_win() "{{{
    if colorv#win#get(s:ColorV.listname)
        close
    endif
    if !empty(g:_colorv['lbufinfo'])
        call colorv#win#back(g:_colorv['lbufinfo'])
    endif
endfunction "}}}
function! colorv#exit() "{{{
    if colorv#win#get(s:ColorV.name)
        call colorv#clear_all()
        close
    else
        return -1
    endif

    " exit callback
    if exists("s:call_type")
        if s:call_type == "exit"
            call call(s:call_func,s:call_args)
        endif
        unlet s:call_type
        unlet s:call_func
        unlet s:call_args
    else
        " back to last window
        if !empty(g:_colorv['bufinfo'])
            call colorv#win#back(g:_colorv['bufinfo'])
        endif
    endif

endfunction "}}}

function! colorv#picker() "{{{
    let color=""
    call colorv#warning("Select color and press OK to Return it to Vim.")
    try
        let color = system(g:colorv_python_cmd." ".s:pypicker." ".g:colorv.HEX)
    catch
        let color = system(s:cpicker." ".g:colorv.HEX)
    finally
        if !empty(color)
            if color =~ '\x\{6}'
                call colorv#win(s:size,color)
            else
                if color =~ 'no such file'
                    call colorv#error("No colorpicker. Compile it first.")
                    echom "Makefile is in $VIM/autoload/colorv/"
                else
                    call colorv#error("Errors occures with colorpicker:\r".color)
                endif
            endif
        else
            call colorv#warning("No color returned.")
        endif
    endtry
endfunction "}}}

function! s:list_map() "{{{
    nmap <silent><buffer> q :call colorv#exit_list_win()<cr>
    nmap <silent><buffer> Q :call colorv#exit_list_win()<cr>
    nmap <silent><buffer> H :h colorv-colorname<cr>
    nmap <silent><buffer> <F1> :h colorv-colorname<cr>
endfunction "}}}
function! colorv#list_win(...) "{{{
    " call s:new_win(s:ColorV.listname,"v")

    let list=a:0 && !empty(a:1) ? a:1 :
            \ [['Colorname List','=======']] + s:clrn
            \+[['W3C_Standard'  ,'=======']] + s:cW3C
            \+[['X11_Standard'  ,'=======']] + s:cX11
    let lines =[]

    let max = 0
    for [name,hex] in list
        let n = len(name)
        if n > max
            let max = n
        endif
    endfor

    for [name,hex] in list
        let txt= hex =~'\x\{6}' ? "#".hex : hex
        let line=printf("%-".(max+2)."s%s",name,txt)
        call add(lines,line)
    endfor

    if !colorv#win#is_same(s:ColorV.listname)
        let g:_colorv['lbufinfo'] = [bufnr('%'),bufname('%'),winnr(),getpos('.')]
    endif
    call colorv#win#new(s:ColorV.listname,['v','',(max+9)])
    call s:list_map()
    setl ma
        silent! %delete _
        call setline(1,lines)
    setl noma

    "preview without highlight colorname
    call colorv#preview("Nc")
endfunction "}}}
function! colorv#list_gen_win(hex,...) "{{{
    let hex=a:hex
    let type= a:0   ? a:1 : ""
    let nums= a:0>1 ? a:2 : ""
    let step= a:0>2 ? a:3 : ""
    let list=[]
    if g:colorv_gen_space ==? "yiq"
        let genlist=colorv#list_yiq_gen(hex,type,nums,step)
        call add(list,["YIQ ".type,'======='])
    else
        let genlist=colorv#list_gen(hex,type,nums,step)
        call add(list,[type.' List','======='])
    endif
    let i=0
    for hex in genlist
        call add(list,[type.i,hex])
        let i+=1
    endfor
    call colorv#list_win(list)
    call colorv#win#get(s:ColorV.listname)
endfunction "}}}
function! colorv#list_win2(...) "{{{
    let hex1 = a:0 ? a:1 : s:his_color0
    let hex2 = a:0>1 ? a:2 : s:his_color1
    let list=[]
    if g:colorv_gen_space ==? "yiq"
        let genlist=colorv#list_yiq_gen2(hex1,hex2)
        call add(list,['TurtTo YIQ ','======='])
    else
        let genlist=colorv#list_gen2(hex1,hex2)
        call add(list,['TurtTo List','======='])
    endif
    let i=0
    for hex in genlist
        call add(list,["TurnTo".i,hex])
        let i+=1
    endfor
    call colorv#list_win(list)
    call colorv#win#get(s:ColorV.listname)
endfunction "}}}
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
    return float2nr(a:x+0.0)
endfunction "}}}
function! s:float(x) "{{{
    if type(a:x) == type("")
        return str2float(a:x)
    else
        return a:x+0.0
    endif
endfunction "}}}
let s:seed = localtime() * (localtime()+101) * 2207
function! colorv#random(num,...) "{{{
    if a:0
        let min = a:num
        let max = a:1
    else
        let min = 0
        let max = a:num
    endif
    if g:colorv_has_python
        exe s:py . ' import random'
        exe s:py . ' import vim'
        exe s:py . ' vim.command("return "+str(random.randint(int(veval("min")),int(veval("max")))))'
    else
        let s:seed = s:fmod((1097*s:seed+2713),10457)
        return float2nr(s:fmod(abs(s:seed),max-min+1) + min)
    endif
endfunction "}}}
"HELP: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:fmt_hex(hex) "{{{
   let hex=substitute(a:hex,'#\|0x\|0X','','')
   if len(hex) == 3
       let hex=substitute(hex,'.','&&','g')
   endif
   if len(hex) > 6
        call colorv#debug("Formated Hex too long. Truncated")
        let hex = hex[:5]
   endif
   return printf("%06X","0x".hex)
endfunction "}}}

function! colorv#echo_tips() "{{{
    call s:seq_echo(s:tips_list)
endfunction "}}}
function! s:all_echo(txt_list) "{{{
    let txt_list=a:txt_list
    call colorv#caution("[Tips of Keyboard Shortcuts]")
    let idx=0
    for txt in txt_list
        echo "[".idx."]" txt
        let idx+=1
    endfor
endfunction "}}}
function! s:rnd_echo(txt_list) "{{{
    let txt_list=a:txt_list
    let idx=0
    let rnd=colorv#random(0,len(txt_list)-1)
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
            call colorv#echo(idx.": ".txt)
            break
        endif
        let idx+=1
    endfor
    let s:seq_num+=1
endfunction "}}}

function! colorv#caution(msg) "{{{
    echohl Modemsg
    redraw
    exe "echon '[ColorV]' "
    echohl Normal
    echon " ".escape(a:msg,'"')." "
endfunction "}}}
function! colorv#warning(msg) "{{{
    echohl Warningmsg
    redraw
    exe "echon '[ColorV]' "
    echohl Normal
    echon " ".escape(a:msg,'"')." "
endfunction "}}}
function! colorv#error(msg) "{{{
    echohl Errormsg
    redraw
    echom "[ColorV] ".escape(a:msg,'"')
    echohl Normal
endfunction "}}}
function! colorv#echo(msg) "{{{
    try
        echohl SpecialComment
        redraw
        exe "echon '[ColorV]' "
        echohl Normal
        exe "echon \" ".escape(a:msg,'"')."\""
    catch /^Vim\%((\a\+)\)\=:E488/
        call colorv#debug("Trailing character.")
    endtry
endfunction "}}}
function! colorv#debug(msg) "{{{
    if g:colorv_debug==1
        redraw
        echohl KeyWord
        echom "[ColorV Debug] ".escape(a:msg,'"')
        echohl Normal
    endif
endfunction "}}}

function! s:rlt_clr(hex) "{{{
    if g:colorv_has_python
        exec s:py ' vcmd("return \""+ rlt_clr(veval("a:hex")) + "\"")'
    else
        let hex=s:fmt_hex(a:hex)
        let [y,i,q]=colorv#hex2yiq(hex)

        if     y>=80    | let y -= 60
        elseif y>=40    | let y -= 40
        elseif y>=20    | let y += 40
        else            | let y += 55
        endif

        if     i >= 55  | let i -= 30
        elseif i >= 35  | let i -= 20
        elseif i >= 10  | let i -= 5
        elseif i >=-10  | let i += 0
        elseif i >=-35  | let i += 5
        elseif i >=-55  | let i += 20
        else            | let i += 30
        endif

        if     q >= 55  | let q -= 30
        elseif q >= 35  | let q -= 20
        elseif q >= 10  | let q -= 5
        elseif q >=-10  | let q += 0
        elseif q >=-35  | let q += 5
        elseif q >=-55  | let q += 20
        else            | let q += 30
        endif

        return colorv#yiq2hex([y,i,q])
    endif
endfunction "}}}
function! s:opz_clr(hex) "{{{
    let hex=s:fmt_hex(a:hex)
    let [y,i,q]=colorv#hex2yiq(hex)
    if y>=30 && y < 50
        let y = 65
    elseif y >=50 && y < 70
        let y = 35
    else
        let y = 100-y
    endif
    return colorv#yiq2hex([y,-i,-q])
endfunction "}}}

function! s:time() "{{{
    if has("reltime")
        return str2float(reltimestr(reltime()))
    else
        return localtime()
    endif
endfunction "}}}
function! colorv#timer(func,...) "{{{
    if !exists("*".a:func)
        call colorv#debug("[TIMER]: ".a:func." does not exists. stopped")
        return
    endif
    let farg = a:0 ? a:1 : []
    let num  = a:0>1 ? a:2 : 1

    let o_t = s:time()

    for i in range(num)
        sil! let rtn = call(a:func,farg)
    endfor
    let e_t = s:time()
    let time = printf("%.4f",(e_t-o_t))
    echom "[TIMER]: " . time . " seconds for exec" a:func num "times. "

    return rtn
endfunction "}}}

function! colorv#assert(func,farg,assert_val) "{{{
    let t = call(a:func,a:farg)
    if t == a:assert_val
        echo "assert: run ". a:func." succsessful."
    else
        echo "assert: run ". a:func." failed . with arg". string(a:farg)
                    \."\n\tasserts  ".string(a:assert_val)
                    \."\n\treturns  ".string(t)
    endif
endfunction "}}}
function! colorv#compare(func1,func2,num,...) "{{{
    if a:0==1
        echom colorv#timer(a:func1,a:1,a:num)
        echom colorv#timer(a:func2,a:1,a:num)
    elseif a:0==2
        echom colorv#timer(a:func1,a:1,a:num)
        echom colorv#timer(a:func2,a:2,a:num)
    else
        echom colorv#timer(a:func1,[],a:num)
        echom colorv#timer(a:func2,[],a:num)
    endif
    echom colorv#timer("colorv#stub0",[],a:num)
endfunction "}}}
function! colorv#stub0() "{{{
endfunction "}}}

function! colorv#default(option,value) "{{{
    if !exists(a:option)
        let {a:option} = a:value
        return 0
    endif
    return 1
endfunction "}}}

"EDIT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:max_pos=[["Hex:",1,22,10],
            \["R:",2,22,5],["G:",2,29,5],["B:",2,36,5],
            \["H:",3,22,5],["S:",3,29,5],["V:",3,36,5],
            \["N:",1,45,15],
            \["H:",4,22,5],["L:",4,29,5],["S:",4,36,5],
            \["Y ",5,22,5],["I ",5,29,5],["Q ",5,36,5],
            \]
let s:mid_pos=[["Hex:",1,22,10],
            \["R:",3,22,5],["G:",3,29,5],["B:",3,36,5],
            \["H:",4,22,5],["S:",4,29,5],["V:",4,36,5],
            \["N:",1,45,15],
            \["H:",5,22,5],["L:",5,29,5],["S:",5,36,5],
            \]
let s:min_pos=[["Hex:",1,22,10],
            \["R:",2,22,5],["G:",2,29,5],["B:",2,36,5],
            \["H:",3,22,5],["S:",3,29,5],["V:",3,36,5],
            \["N:",1,45,15]
            \]
function! s:set_in_pos(...) "{{{
    let [l,c] = getpos('.')[1:2]

    let clr=g:colorv
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

    if s:size!="max" || l!=rc_y || c<rc_x  || c>(rc_x+rc_w*18-1)
        if a:0 && ( a:1 =="D" || a:1 =="M")
            return
        endif
    endif
    "pallette "{{{3
    if (s:size=="max" || s:size=="mid" ) && l > s:OFF_H && l<= s:pal_H+s:OFF_H && c<= s:pal_W
        let phex = hex
        let hex = s:pal_clr_list[l-s:OFF_H-1][c-s:OFF_W-1]
        if phex != hex
            call colorv#echo("HEX(Pallet): ".hex)
            call s:draw_win(hex,"skippal")
        endif
    "hsv line "{{{3
    elseif l==1 &&  c<=s:pal_W
        "hue line
        let [h1,s1,v1]=colorv#hex2hsv(s:hueline_list[(c-1)])
        if h != h1
            call colorv#echo("Hue(Hue Line): ".h1)
            "NOTE: help to avoid stuck in '000000' when changing hue .
            if  s<=3 && v<=3
                let [s,v] = [5,5]
            elseif s<=3 && v<= 30
                let s = 5
            endif
            let hex=colorv#hsv2hex([h1,s,v])
            call s:draw_win(hex)
        endif
    elseif s:size=="min" && (l=~'^[23]$') && ( c<=s:pal_W  )

        if (l==2)
            let chr = "s"
        elseif (l==3)
            let chr = "v"
        endif
        let h_txt = s:hlp_d[chr][0]
        " step = 100.0 / s:pal_W
        let {chr} = 100 - float2nr( ( c - 1 - s:OFF_W )* (100.0 / s:pal_W) )
        let {chr} = {chr} <=0 ? 0 : {chr}
        call colorv#echo(h_txt.":".{chr})

        let hex=colorv#hsv2hex([h,s,v])
        call s:draw_win(hex)
        return
    "mrk_line "{{{3
    elseif s:size=="max" && l==rc_y &&  c>=rc_x  && c<=(rc_x+rc_w*19-1)
        for i in range(19)
            if c<rc_x+rc_w*(i+1)
                if len(g:_colorv['mark'])>i
                    let hex_h=g:_colorv['mark'][-1-i]
                else
                    let hex_h="0"
                endif
                if hex_h!="0"
                    if a:0 && a:1 == "D"
                        call colorv#mark#del(-1-i)
                        return
                    elseif a:0 && a:1 == "M"
                        call colorv#mark#add(-1-i)
                        return
                    else
                        call colorv#echo("HEX(Marked history ".(i)."): ".hex_h)
                        call s:draw_win(hex_h)
                        return
                    endif
                else
                    call colorv#echo("No Marked Color here.")
                    return
                endif
            endif
        endfor
    "tip_line "{{{3
    elseif s:size != "min" && l==s:pal_H+1 && c < s:stat_pos && c>=s:tip_pos
        let word = expand('<cWORD>')
        " check if it is whitespace
        if empty(word) || getline(line('.'))[col('.')-1] =~ '\s'
            return
        endif
        let key = split(word,':')[0]
        if key == "Tips"
            call colorv#echo_tips()
        elseif key == "Help"
            h colorv-quickstart
        elseif key == "TurnT"
            call colorv#list_win2()
            call colorv#echo("Convert from ".s:his_color0. " to ".s:his_color1)
        elseif key == "Hue"
            call colorv#list_gen_win(g:colorv.HEX,"Hue",20,15)
        elseif key == "Sat"
            call colorv#list_gen_win(g:colorv.HEX,"Saturation",20,5)
        elseif key == "Val"
            call colorv#list_gen_win(g:colorv.HEX,"Value",20,5)
        elseif key == "Names"
            call colorv#list_win()
        elseif key == "Scheme"
            call colorv#scheme#win()
        elseif key == "Faved_Schemes"
            call colorv#scheme#show_fav()
        elseif key == "Copy"
            call s:copy("HEX","+")
        elseif key == "Yank"
            call s:copy()
        elseif key == "Mark"
            call colorv#mark#add()
        endif

    "ctr_stat "{{{3
    elseif l==s:pal_H+1 && c >= s:stat_pos
        let char = getline(l)[c-1]
        if char =~ "Y"
            let g:colorv_gen_space = "hsv"
            setl ma
            call s:draw_text()
            setl noma
            call colorv#echo("change generating color space to 'hsv'")
        elseif char =~ 'H'
            let g:colorv_gen_space = "yiq"
            setl ma
            call s:draw_text()
            setl noma
            call colorv#echo("change generating color space to 'yiq'")
        elseif char =~ 'K'
            let g:colorv_default_api = "colour"
            setl ma
            call s:draw_text()
            setl noma
            call colorv#echo("change scheme api to ColourLover ")
        elseif char =~ 'C'
            let g:colorv_default_api = "kuler"
            setl ma
            call s:draw_text()
            setl noma
            call colorv#echo("change scheme api to Kuler")
        elseif char =~ 'q'
            call colorv#exit()
            call colorv#echo("Exit.")
        elseif char =~ '[Zz-]'
            call s:size_toggle()
            call colorv#echo("window size: ".s:size)
        endif
    "his_pal "{{{3
    elseif l<=(rs_h+rs_y-1)  && l>=rs_y &&  c>=rs_x && c<=(rs_x+rs_w*3-1)
        for i in range(3)
            if c<=(rs_x+rs_w*(1+i)-1)
                let hex=s:his_color{i}
                call colorv#echo("HEX(history ".i."): ".hex)
                break
            endif
        endfor
        call s:draw_win(hex)
        return
    else
    "cur_chk "{{{3
        let pos_list = s:size=="max" ? s:max_pos :
                \ s:size=="min" ? s:min_pos : s:mid_pos
        for [name,y,x,width] in pos_list
            if l==y && c>=x && c<=(x+width-1)
                call s:edit_at_cursor()
                return
            endif
        endfor

        call colorv#warning("Not Valid Position.")
    endif "}}}3

endfunction "}}}
function! s:size_toggle() "{{{
    if     s:size=="min" | call colorv#win("max")
    elseif s:size=="max" | call colorv#win("mid")
    else                 | call colorv#win("min")
    endif
endfunction "}}}
function! s:edit_at_cursor(...) "{{{
    let tune=a:0 ? a:1 == "+" ? 1 : a:1 == "-" ? -1  : 0  : 0
    let clr=g:colorv
    let hex=clr.HEX
    let [r,g,b]=clr.rgb
    let [h,s,v]=clr.hsv
    let [H,L,S]=clr.hls
    let [Y,I,Q]=clr.yiq
    let [l,c] = getpos('.')[1:2]
    let pos_list = s:size=="max" ? s:max_pos :
                \ s:size=="min" ? s:min_pos : s:mid_pos
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
            else
                call colorv#error("invalid input.")
            endif
        endif
    elseif position==7
        call s:input_colorname()
    elseif position =~ '^[1-6]$' || (position>=8 && position<=13 )
        if position =~ '^[1-3]$'
            let c = ["r","g","b"][position-1]
            let e_txt = "let hex = colorv#rgb2hex([r,g,b])"
        elseif position =~ '^[4-6]$'
            let c = ["h","s","v"][position-4]
            let e_txt = "let hex = colorv#hsv2hex([h,s,v])"
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
        else
            call colorv#error("invalid input.")
        endif
    endif "}}}

endfunction "}}}
function! s:input_colorname(...) "{{{

    let name = substitute(g:colorv.NAME,'\~',"","g")
    if a:0 && a:1=="X11"
        let text = input("Input color name(X11:Blue/Green/Red):",name)
        let hex = s:nam2hex(text,a:1)
    else
        let text = input("Input color name(W3C:Blue/Lime/Red):",name)
        let hex = s:nam2hex(text)
    endif

    if !empty(hex)
        call s:draw_win(hex)
    else
        let t=tr(text,s:t,s:e)
        let flg_l=s:flag_clr(t)
        if !empty(flg_l)
            call s:update_his_list(flg_l[2])
            call s:update_his_list(flg_l[1])
            call s:draw_win(flg_l[0])
            let n=tr(flg_l[3],s:t,s:e)
            call colorv#caution("Hello! ".n."!")
        else
            call colorv#warning("Not a W3C colorname. Nothing changed.")
        endif
    endif
endfunction "}}}
function! s:flag_clr(nam) "{{{
    if empty(a:nam)
        return []
    endif
    let clr_list=s:clrf
    for [c1,c2,c3,flg] in clr_list
        if  a:nam =~? flg
            return [c1,c2,c3,flg]
            break
        endif
    endfor
    return []
endfunction "}}}
"TEXT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:fmt = g:_colorv['fmt'] 
function! s:txt2hex(txt) "{{{
    if g:colorv_has_python
        exe s:py . ' vcmd("".join(["return ",str(txt2hex(veval("a:txt")))]))'
    endif
    let hex_list = []
    for [fmt,reg] in items(s:fmt)
        for [p_lst,p_idx] in s:reg_match(reg,a:txt)
            let p_alp = 1
            if fmt=="RGB"
                let [r,g,b]=p_lst[1:3]
                if r>255 || r<0 || g>255 || g<0 || b>255 || b<0
                    continue
                endif
                let hex = colorv#rgb2hex([r,g,b])
            elseif fmt=="RGBA"
                let p_alp = str2float(p_lst[4])
                let [r,g,b]=p_lst[1:3]
                if r>255 || r<0 || g>255 || g<0 || b>255 || b<0
                    continue
                endif
                let hex = colorv#rgb2hex([r,g,b])
            elseif fmt=="RGBP"
                let [r,g,b]=p_lst[1:3]
                if r>100 || r<0 || g>100 || g<0 || b>100 || b<0
                    continue
                endif
                let hex = colorv#rgb2hex([r*2.55,g*2.55,b*2.55])
            elseif fmt=="RGBAP"
                let [r,g,b]=p_lst[1:3]
                if r>100 || r<0 || g>100 || g<0 || b>100 || b<0
                    continue
                endif
                let p_alp  = str2float(p_lst[4])
                let hex = colorv#rgb2hex([r*2.55,g*2.55,b*2.55])
            elseif fmt=="HSV"
                let [h,s,v]=p_lst[1:3]
                if h>360 || h<0 || s>100 || s<0 || v>100 || v<0
                    continue
                endif
                let hex = colorv#hsv2hex([h,s,v])
            elseif fmt=="HSL"
                let [h,s,l]=p_lst[1:3]
                if h>360 || h<0 || s>100 || s<0 || l>100 || l<0
                    continue
                endif
                let hex = colorv#hsl2hex([h,s,l])
                echoe hex
            elseif fmt=="HSLA"
                let p_alp  = str2float(p_lst[4])
                let [h,s,l]=p_lst[1:3]
                if h>360 || h<0 || s>100 || s<0 || l>100 || l<0
                    continue
                endif
                let hex = colorv#hsl2hex([h,s,l])
            elseif fmt=="CMYK"
                let [c,m,y,k]=p_lst[1:4]
                if c>100 || c<0 || m>100 || m<0 || y>100 || y<0 || k>100 || k<0
                    continue
                endif
                let hex = colorv#cmyk2hex([c,m,y,k])
            elseif fmt=="glRGBA"
                let p_alp  = str2float(p_lst[4])
                " let [r,g,b] = p_lst[1:3]
                let [r,g,b] = [str2float(p_lst[1])*255,str2float(p_lst[2])*255,str2float(p_lst[3])*255]
                if r>255 || r<0 || g>255 || g<0 || b>255 || b<0
                    continue
                endif
                let hex = colorv#rgb2hex([r,g,b])
            elseif fmt=="HEX"
                let hex = toupper(p_lst[1])
            elseif fmt=="HEX3"
                let hex3 = p_lst[1]
                let hex = hex3[0].hex3[0].hex3[1].hex3[1].hex3[2].hex3[2]
            else
                break
            endif
            " let list=[hex,p_idx,p_len,p_str,fmt,p_alp]
            let list=[p_lst[0],hex,fmt,p_idx,p_alp]
            call add(hex_list,list)
        endfor
    endfor
    return hex_list + s:nametxt2hex(a:txt)
endfunction "}}}
function! s:hex2txt(hex,fmt,...) "{{{

    let hex = s:fmt_hex(a:hex)
    " NOTE: ' 255'/2 = 0 . so use str and nr separately
    let [r ,g ,b ] = colorv#hex2rgb(hex)
    let [rs,gs,bs] = map([r,g,b],'printf("%3d",v:val)')
    let a = a:0 && a:1>=0 && a:1<=1 ? a:1 : 1.0
    let A = printf("%.1f",a)
    if a:fmt=="RGB"
        let text="rgb(".rs.",".gs.",".bs.")"
    elseif a:fmt=="RGBA"
        let text="rgba(".rs.",".gs.",".bs.",".A.")"
    elseif a:fmt=="HSV"
        let [h,s,v] = map(colorv#rgb2hsv([r,g,b]),'printf("%3d", v:val)')
        let text="hsv(".h.",".s.",".v. ")"
    elseif a:fmt=="HSL"
        let [H,L,S] = map(colorv#rgb2hls([r,g,b]),'printf("%3d",v:val)')
        let text="hsl(".H.",".S."%,".L."%)"
    elseif a:fmt=="HSLA"
        let [H,L,S] = map(colorv#rgb2hls([r,g,b]),'printf("%3d",v:val)')
        let text="hsla(".H.",".S."%,".L."%,".A.")"
    elseif a:fmt=="RGBP"
        let [rp,gp,bp] = map([r/2.55,g/2.55,b/2.55],
                    \'printf("%3d",float2nr(v:val))')
        let text="rgb(".rp."%,".gp."%,".bp."%)"
    elseif a:fmt=="glRGBA"
        let [rf,gf,bf] = map([r/255.0,g/255.0,b/255.0],'printf("%.2f",v:val)')
        let text="glColor4f(".rf.",".gf.",".bf.",".A.")"
    elseif a:fmt=="RGBAP"
        let [rp,gp,bp] = map([r/2.55,g/2.55,b/2.55],
                    \'printf("%3d",float2nr(v:val))')
        let text="rgba(".rp."%,".gp."%,".bp."%,".A.")"
    elseif a:fmt=="HEX3"
        let text="#".hex
    elseif a:fmt=="HEX0"
        let text="0x".hex
    elseif a:fmt=="HEX#"
        let text="#".hex
    elseif a:fmt=="CMYK"
        let [c,m,y,k]= map(colorv#rgb2cmyk([r,g,b]),'printf("%2d",v:val)')
        let text="cmyk(".c.",".m.",".y.",".k.")"
    elseif a:fmt=="NAME"
        if a:0>1 && a:2 == "X11"
            let text=s:hex2nam(hex,a:2)
        else
            let text=s:hex2nam(hex)
        endif
        let text = substitute(text,'\~','','g')
    else
        let text=hex
    endif

    return text
endfunction "}}}

function! s:nam2hex(nam,...) "{{{
    if empty(a:nam)
        return 0
    endif
    if a:0 && a:1 == "X11"
        let clr_dic = s:clrdX11
    else
        let clr_dic = s:clrdW3C
    endif
    let lo=tolower(a:nam)
    if has_key(clr_dic,lo)
        return clr_dic[lo]
    else
        return 0
    endif
endfunction "}}}
function! s:hex2nam(hex,...) "{{{
    let lst = a:0 && a:1 == "X11" ? "X11" : "W3C"
    if g:colorv_has_python
        exe s:py . ' vcmd("return \""+ hex2nam(veval("a:hex"),veval("lst"))+"\"")'
    else

        if lst =="X11"  | let clr_list=s:clrnX11
        else            | let clr_list=s:clrnW3C
        endif

        let best_name=""
        let dist = 20000
        let [r1,g1,b1] = colorv#hex2rgb(a:hex)
        for [name,hex] in clr_list
            let [r2,g2,b2] = ['0x'.hex[0:1],'0x'.hex[2:3],'0x'.hex[4:5]]
            let d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
            if d < dist
                let dist = d
                let best_name = name
            endif
        endfor
        if dist == 0
            return best_name
        elseif dist <= s:aprx_rate*4
            return best_name."~"
        elseif dist <= s:aprx_rate*8
            return best_name."~~"
        else
            return ""
        endif
    endif
endfunction "}}}

function! s:nametxt2hex(txt) "{{{
    " find all color name and hex in a string. by dict
    let text = a:txt
    let hex_list=[]
    let startidx = 0
    for txt in split(text,'\v%(\s+|[^0-9A-Za-z_-])\zs')
        let t_len=len(txt)
        "NOTE: we only need word which is not following or followed by '-_'
        " let rtx = matchstr(txt,'\v%(\w|[-_])@<!\w+%(\w|[-_])@!')
        let ltx = tolower(txt)
        if has_key(s:clrdW3C,ltx)
            let p_idx = match(text,txt,startidx)
            let hex   = s:clrdW3C[ltx]
            call add(hex_list,[txt,hex,'NAME',p_idx,1])
        endif
        let startidx += t_len
    endfor
    return hex_list
endfunction "}}}
function! s:reg_match(reg,str) "{{{
    " return reg_list [[list],idx]
    let match_list=[]
    let idx = 0
    for i in range(200)
        let p_idx = match(a:str,a:reg,idx)
        if p_idx >= 0
            let p_lst = matchlist(a:str,a:reg,idx)
            let idx = p_idx + len(p_lst[0])
            call add(match_list,[p_lst,p_idx])
        else
            break
        endif
    endfor
    return match_list
endfunction "}}}

function! s:paste(...) "{{{
    if a:0 && a:1=="+"
        let l:cliptext = @+
        let t = "+"
    else
        let l:cliptext = @"
        let t = "\""
    endif
    let list=s:txt2hex(l:cliptext)
    if !empty(list)
        let hex=list[0][1]
        call colorv#echo("Paste from Clipboard(reg".t.") :".hex)
        call s:draw_win(hex)
    else
        call colorv#warning("Could not find color in clipboard")
    endif
endfunction "}}}
function! s:copy(...) "{{{
    let fmt = a:0 ? a:1 : "HEX"
    let l:cliptext=s:hex2txt(g:colorv.HEX,fmt)

    if  a:0>1 && a:2=="\""
        call colorv#echo("Copied to Clipboard(reg\"):".l:cliptext)
        let @" = l:cliptext
    elseif a:0>1 && a:2=="+"
        call colorv#echo("Copied to Clipboard(reg+):".l:cliptext)
        let @+ = l:cliptext
    else
        call colorv#echo("Copied to Clipboard(reg\"):".l:cliptext)
        let @" = l:cliptext
    endif
endfunction "}}}

fun! s:get_cur_clist(line, col) "{{{
    if a:line =~ '^\s*$'
        return []
    endif
    let w_list=[]
    for [str,hex,fmt,idx,alp] in s:txt2hex(a:line) 
        if idx<=(a:col-1) && (idx+len(str))>=(a:col-1)
            return [str,hex,fmt,idx,alp]
        endif
    endfor
    return []
endfun "}}}
function! colorv#cursor_text(action,...) "{{{

    if colorv#win#is_same(s:ColorV.name)
        call colorv#warning("Could not change text in ColorV")
        return
    endif

    let pos = getpos('.')
    let [row,col] = pos[1:2]

    let w_list = s:get_cur_clist(getline(row), col)
    if empty(w_list)
        call colorv#error("No color-text under cursor.")
        return
    endif
    let [str,hex,fmt,idx,alp] = w_list

    if a:action == "view"
        call colorv#win(s:size,hex)
        call colorv#echo("View color-text under cursor.")
    elseif a:action =~ "edit"
        call colorv#win(s:size,hex,["exit","s:edit_text",[a:action, w_list]])
        call colorv#echo("Edit color-text under cursor.")
    elseif a:action == "changeTo" && a:0
                \ && a:1 =~ '\vRGBA=P=|HEX[#0]=|NAME|HS[VL]A=|CMYK'
        call colorv#win(s:size,hex,["exit","s:edit_text"
                    \,[a:action,w_list,a:1]])
        call colorv#echo("Change format of color-text under cursor to ".a:1)
    elseif a:action == "list"
        let type = exists("a:1") ? a:1 : ""
        let nums = exists("a:2") ? a:2 : ""
        let step = exists("a:3") ? a:3 : ""
        call colorv#list_gen_win(hex,type,nums,step)
    else
        call colorv#error("invalid action with color-text under cursor.")
    endif
endfunction "}}}
function! s:edit_text(action,w_list,...) "{{{
    if a:action =~ "edit" || (a:action == "changeto" && a:0)
        " let w_list = a:w_list
        " pass
    else
        return
    endif

    if !colorv#win#back(g:_colorv['bufinfo'])
        call colorv#error("Doesn't get the right buffer.")
        return
    endif

    let [bufnr,bufname,bufwinnr,pos] = g:_colorv['bufinfo']

    call setpos('.',pos)

    let [row, col] = pos[1:2]

    if s:get_cur_clist(getline(row), col) != a:w_list
        call colorv#error("Doesn't get the right word.")
        return
    endif
    let [str,hex,fmt,idx,alp] = a:w_list
    if a:0
        let to_fmt = a:1
    else
        let to_fmt = fmt
    endif

    if a:action =="changeTo"
        if &filetype=="vim"
            let to_str = s:hex2txt(g:colorv.HEX,to_fmt,alp,"X11")
        else
            let to_str = s:hex2txt(g:colorv.HEX,to_fmt,alp)
        endif
    else
        let to_str = s:hex2txt(g:colorv.HEX,fmt,alp)
    endif

    if empty(to_str)
        call colorv#error("No Changing as colortext is empty.")
        return
    endif

    if to_fmt=='HEX'
        if str=~'0x'
            let to_str = "0x".to_str
        elseif str=~'#'
            let to_str = "#".to_str
        endif
    endif

    let str = escape(str,'[]*/~.$\')
    let to_str = escape(to_str,'&/~.$\')
    if a:action == "editAll"
        let cmd =  '%s/'.str.'/'.to_str.'/gc'
    else
        if idx>=1
            let cmd = 's/\%>'.(idx-1).'c'.str.'/'.to_str.'/'
        else
            let cmd = 's/'.str.'/'.to_str.'/'
        endif
    endif

    try
        exec cmd
        call setpos('.',pos)
    catch /^Vim\%((\a\+)\)\=:E/
        call colorv#error(v:exception)
    endtry

    " if the buf it's in preview list, then we preview the to_str
    if exists("s:pbuf_dict[bufnr]")
        call s:prev_list(s:txt2hex(to_str))
    endif

endfunction "}}}

fun! colorv#insert_text(...) "{{{
    call colorv#win(s:size,'',["exit","s:insert_text"
                    \,[a:0 ? a:1 : '']])
endfun "}}}
fun! s:insert_text(...) "{{{

    if !colorv#win#back(g:_colorv['bufinfo'])
        call colorv#error("Doesn't get the right buffer.")
        return
    endif

    let [bufnr,bufname,bufwinnr,pos] = g:_colorv['bufinfo']

    call setpos('.',pos)
    let [line,col] = pos[1:2]
    if a:0 && !empty(a:1)
        let to_fmt = a:1
    else
        let to_fmt = 'HEX#'
    endif

    let to_str = s:hex2txt(g:colorv.HEX,to_fmt)

    let cmd = 'normal! a'.to_str
    try
        exec cmd
    catch /^Vim\%((\a\+)\)\=:E/
        call colorv#error(v:exception)
    endtry

    if exists("s:pbuf_dict[bufnr]")
        call s:prev_list(s:txt2hex(to_str))
    endif
endfun "}}}

"PREV: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:prev_list(list) "{{{
    "TODO: mix alpha with 'background' SynID:45

    for [str,hex,fmt,idx,alpha;rest] in a:list
        if fmt == 'NAME'
            if b:view_name == 1
                " NOTE: highlight name in all cases,
                " except which is following or followed by '-_'
                " yes: ":BluE\blue" no: "_blue\-blue"
                " use '\w' atom make this ptn 10% faster than [:alnum:] form.
                let hi_ptn = '\v\c%(\w|[-_])@<!'.str.'%(\w|[-_])@!'
            else
                continue
            endif
        elseif fmt == 'HEX'
            " NOTE: highlight hex in all cases,
            " '#ffc0ff' 'ff00cf' '0xfc00ff' '-ffffff'
            let hi_ptn = '\v\c%(#|<0x|<)'.hex.'\w@!'
        elseif fmt == 'HEX3'
            let hi_ptn = '\v\c'.str.'\w@!'
        else
            "  XXX: use fmt's ptn to match?
            let hi_ptn = str
        endif

        " cv_prv_0_FF0000FF
        let hi_grp="cv_prv_".b:view_area."_".hex."FF"
        let hi_fg = b:view_area==1 ? hex : s:rlt_clr(hex)

        " NOTE: we should clear the hl-grp
        " and only clear the hl-grp not used anymore.
        "                grp      buf:num
        " s:pgrp_dict: {cv_prv_xx: {1:1,2:1},cv_prv_xx:{1:1,3:1}...}

        " we dont' have this grp.
        if !has_key(s:pgrp_dict,hi_grp)
            call s:hi_color(hi_grp,hi_fg,hex," ")
            let s:pgrp_dict[hi_grp] = { b:view_bufn : 1}
        else
            " we don't have this grp in this buf.
            if !has_key(s:pgrp_dict[hi_grp],b:view_bufn)
                " NOTE: we should use '[]' to access key with b: , not '.'
                let s:pgrp_dict[hi_grp][b:view_bufn] = 1
            endif
        endif

        if fmt =~ 'HEX'
            let hi_dic_name = fmt.'_'.hex
        elseif fmt == 'NAME'
            let hi_dic_name = fmt.'_'.tolower(str)
        else
            let hi_dic_name = substitute(str,'\W',"_","g")
        endif

        try
            " NOTE: no duplicated hl-ptn
            if !has_key(b:pptn_dict,hi_dic_name)
                sil! let b:pptn_dict[hi_dic_name]= matchadd(hi_grp,hi_ptn)
            endif
        catch /^Vim\%((\a\+)\)\=:E/
            call colorv#debug("E254: Could not hi color:".str)
        endtry
    endfor
endfunction "}}}
" the dict to keep which grp have been previewed.
" and it keeps the buffer which have the grp.
let s:pgrp_dict=!exists("s:pgrp_dict") ? {} : s:pgrp_dict
" the dict to keep which buffer have been previewed.
let s:pbuf_dict=!exists("s:pbuf_dict") ? {} : s:pbuf_dict
function! colorv#clear_prev() "{{{
    if exists("b:pptn_dict")
        " echoe 1 string(b:pptn_dict)
        for [key,var] in items(b:pptn_dict)
            try
                call matchdelete(var)
            catch
                call colorv#debug("prev ptn:".v:exception)
            endtry
        endfor
    endif
    let b:pptn_dict={}
    let bufnr  = bufnr("%")
    if has_key(s:pbuf_dict,bufnr)
        for [grp,val] in items(s:pgrp_dict)
            " NOTE: clear if we have the buf in the grp.
            try
                if exists("val.".bufnr)
                    if len(val)==1
                        exe "hi clear ".grp
                        call remove(s:pgrp_dict,grp)
                    else
                        call remove(s:pgrp_dict[grp],bufnr)
                    endif
                endif
            catch
                call colorv#debug("prev grp:".v:exception)
            endtry
        endfor
        call remove(s:pbuf_dict,bufnr)
    endif
endfunction "}}}
function! colorv#preview(...) "{{{

    let b:view_name=g:colorv_preview_name
    let b:view_area=g:colorv_preview_area
    let b:view_bufn=bufnr("%")
    let b:pptn_dict=!exists("b:pptn_dict") ? {} : b:pptn_dict

    let view_silent=0
    if a:0 "{{{
        " NOTE:      c->clear
        " n-> name_  b->area   s->silence
        " N-> noname B->noarea S->nosilence
        let b:view_name = a:1=~#"N" ? 0 : a:1=~#"n" ? 1 : b:view_name
        let b:view_area = a:1=~#"B" ? 0 : a:1=~#"b" ? 1 : b:view_area
        let view_silent = a:1=~#"S" ? 0 : a:1=~#"s" ? 1 : view_silent
        if a:1 =~# "c"
            "FIXME: In fact, we should clear it before leaving the buffer.
            " otherwise we could not find the match ID.
            call colorv#clear_prev()
        endif
    endif "}}}

    let o_time = s:time()

    " if file > 300 line, preview 200 line around cursor.
    let cur = line('.')
    let eof = line('$')
    let mprv = g:colorv_max_preview
    if eof >= mprv*3/2
        let [begin,end] = cur<mprv ? [1,mprv]
                  \ : cur>eof-mprv ? [eof-mprv,eof]
                  \ : [cur-mprv/2,cur+mprv/2]
    else
        let [begin,end] =[1,eof]
    endif

    let prv_list = []
    for line in getline(begin,end)
        call extend(prv_list,s:txt2hex(line))
    endfor
    call s:prev_list(prv_list)
    let s:pbuf_dict[b:view_bufn] = 1
    call s:clear_prev_aug()

    if !view_silent
        call colorv#echo( (end-begin)." lines previewed."
                \." Takes ". string(s:time() - o_time). " sec." )
    endif
endfunction "}}}
function! colorv#preview_line(...) "{{{

    let b:view_name=g:colorv_preview_name
    let b:view_area=g:colorv_preview_area
    let b:view_bufn=bufnr("%")
    let b:pptn_dict=!exists("b:pptn_dict") ? {} : b:pptn_dict
    if a:0
        " n-> name   b->area   c->clear
        " N-> noname B->noarea C->noclear
        let b:view_name = a:1=~#"N" ? 0 : a:1=~#"n" ? 1 : b:view_name
        let b:view_area = a:1=~#"B" ? 0 : a:1=~#"b" ? 1 : b:view_area
        if a:1 =~# "c"
            call colorv#clear_prev()
        endif
    endif

    " a:2:line num to parse
    if a:0>1 && a:2 > 0  && a:2 <= line('$')
        let line = getline(a:2)
    else
        let line = getline('.')
    endif

    call s:prev_list(s:txt2hex(line))
    let s:pbuf_dict[b:view_bufn] = 1
    call s:clear_prev_aug()
endfunction "}}}
function! colorv#prev_aug(...) "{{{
    aug colorv#prev_aug
        au!
        au!  BufWinEnter  <buffer> call colorv#preview()
        au!  BufWritePost <buffer> call colorv#preview()
        au!  InsertLeave  <buffer> call colorv#preview_line()
    aug END
    if !a:0 || a:1 != "s"
        call colorv#echo("current buffer will be auto previewed.")
    endif
endfunction "}}}
function! colorv#prev_no_aug() "{{{
    aug colorv#prev_aug
        au!
    aug END
    call colorv#echo("current buffer will NOT be auto previewed.")
endfunction "}}}
function! s:clear_prev_aug() "{{{
    aug colorv#prev_auto_clear
        au!
        au!  BufHidden    <buffer> call colorv#clear_prev()
    aug END
endfunction "}}}
"LIST:"{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:gen_def_nums=20
let s:gen_def_step=10
let s:gen_def_type="Hue"
function! colorv#list_yiq_gen(hex,...) "{{{
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
    cal add(hex_list,hex0)
    if type==?"Hue"
        for i in range(1,nums-1)
            let h{i}=h+i*step
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Luma"
        "y+
        for i in range(1,nums-1)
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
        for i in range(1,nums-1)
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
        for i in range(1,nums-1)
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
        let hex_list=colorv#list_yiq_gen(hex,"Hue",nums,30)
    elseif type==?"Neutral"
        let hex_list=colorv#list_yiq_gen(hex,"Hue",nums,15)
    elseif type==?"Complementary"
        let hex_list=colorv#list_yiq_gen(hex,"Hue",nums,180)
    elseif type=="Split-Complementary"
        for i in range(1,nums-1)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+150 : h{i-1}+60
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Triadic"
        let hex_list=colorv#list_yiq_gen(hex,"Hue",nums,120)
    elseif type=="Clash"
        for i in range(1,nums-1)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+90 : h{i-1}+180
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type=="Square"
        let hex_list=colorv#list_yiq_gen(hex,"Hue",nums,90)
    elseif type=="Tetradic" || type=="Rectangle"
        "h+60,h+120,...
        for i in range(1,nums-1)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+60 : h{i-1}+120
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    elseif type==?"Five-Tone"
        "h+115,+40,+50,+40,+115
        for i in range(1,nums-1)
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
        for i in range(1,nums-1)
            let h{i}=s:fmod(i,2)==1 ? h{i-1}+30 : h{i-1}+90
            let hex{i}=colorv#hsv2hex([h{i},s,v])
            let [y{i},i{i},q{i}]=colorv#rgb2yiq(colorv#hex2rgb(hex{i}))
            let hex{i} = colorv#yiq2hex([y,i{i},q{i}])
            call add(hex_list,hex{i})
        endfor
    else
            call colorv#warning("No fitting Color Generator Type.")
            return []
    endif
    return hex_list
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
    call add(hex_list,hex0)
    for i in range(1,nums-1)
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
        elseif type==?"MonSat"
            "s always -step,v+step
            let step=step>0 ? 5 : step<0 ? -5 : 0
            let s{i}=s{i-1}-abs(step)
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
            call colorv#warning("No fitting Color Generator Type.")
            return []
        endif
        call add(hex_list,hex{i})
    endfor
    return hex_list
endfunction "}}}
function! colorv#list_gen2(hex1,hex2) "{{{
    let hex0=s:fmt_hex(a:hex1)
    let HEX0=s:fmt_hex(a:hex2)
    let hex_list=[]
    let nums=20
    let [h0,s0,v0] = colorv#hex2hsv(hex0)
    let [H0,S0,V0] = colorv#hex2hsv(HEX0)
    let [hd,sd,vd] = [H0-h0,S0-s0,V0-v0]
    " NOTE: differ hex0 to hex1 and hex1 to hex0
    if hd < 0
        let hd +=360
    endif
    let hstep = (hd+0.0) /(nums-1)
    let sstep = (sd+0.0) /(nums-1)
    let vstep = (vd+0.0) /(nums-1)
    call add(hex_list,hex0)
    for i in range(1,nums-1)

        let h{i}  = h{i-1} + hstep
        let s{i}  = s{i-1} + sstep
        let v{i}  = v{i-1} + vstep

        let hex{i}=colorv#hsv2hex([h{i},s{i},v{i}])
        call add(hex_list,hex{i})
    endfor
    return hex_list
endfunction "}}}
function! colorv#list_yiq_gen2(hex1,hex2) "{{{
    let hex0=s:fmt_hex(a:hex1)
    let HEX0=s:fmt_hex(a:hex2)
    let hex_list=[]
    let nums=20
    let [y0,i0,q0] = colorv#hex2yiq(hex0)
    let [Y0,I0,Q0] = colorv#hex2yiq(HEX0)
    let [yd,id,qd] = [Y0-y0,I0-i0,Q0-q0]
    let ystep = (yd+0.0) /(nums-1)
    let istep = (id+0.0) /(nums-1)
    let qstep = (qd+0.0) /(nums-1)
    call add(hex_list,hex0)
    for i in range(1,nums-1)

        let y{i}  = y{i-1} + ystep
        let i{i}  = i{i-1} + istep
        let q{i}  = q{i-1} + qstep

        let hex{i}=colorv#yiq2hex([y{i},i{i},q{i}])
        call add(hex_list,hex{i})
    endfor
    return hex_list
endfunction "}}}
"INIT: "{{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:fmt_keys = {
            \ '#'  : 'HEX#'   ,
            \ 's'  : 'HEX#'   ,
            \ '0'  : 'HEX0'   ,
            \ 'x'  : 'HEX0'   ,
            \ 'n'  : 'NAME'   ,
            \ 'r'  : 'RGB'    ,
            \ 'ar' : 'RGBA'   ,
            \ 'l'  : 'HSL'    ,
            \ 'al' : 'HSLA'   ,
            \ 'pr' : 'RGBP'   ,
            \ 'pa' : 'RGBAP'  ,
            \ 'h'  : 'HSV'    ,
            \ 'm'  : 'CMYK'   ,
            \}

let s:gen_keys = {
    \'h' : 'Hue'                ,
    \'s' : 'Saturation'         ,
    \'v' : 'Value'              ,
    \'m' : 'Monochromatic'      ,
    \'a' : 'Analogous'          ,
    \'3' : 'Triadic'            ,
    \'4' : 'Tetradic'           ,
    \'n' : 'Neutral'            ,
    \'c' : 'Clash'              ,
    \'q' : 'Square'             ,
    \'5' : 'Five-Tone'          ,
    \'6' : 'Six-Tone'           ,
    \'2' : 'Complementary'      ,
    \'p' : 'Split-Complementary',
    \'l' : 'luma',
    \}

function! s:set_map() "{{{

    mapclear <buffer>

    let t = ["<C-k>","<CR>","<KEnter>","<Space>"
                \,"<Space><Space>","<2-Leftmouse>","<3-Leftmouse>"]

    let m_txt = "nmap <silent><buffer> "
    let c_txt = " :call <SID>set_in_pos()<CR>"

    for m in t
        exe m_txt.m.c_txt
    endfor

    nmap <silent><buffer> Z :call <SID>size_toggle()<cr>
    nmap <silent><buffer> zz :call <SID>size_toggle()<cr>

    nmap <silent><buffer> M  :call colorv#mark#add()<CR>
    nmap <silent><buffer> mm :call <SID>set_in_pos("M")<CR>
    nmap <silent><buffer> dd :call <SID>set_in_pos("D")<cr>
    nmap <silent><buffer> D :call <SID>set_in_pos("D")<cr>

    nmap <silent><buffer> <tab> W
    nmap <silent><buffer> <S-tab> B

    "edit
    nmap <silent><buffer> = :call <SID>edit_at_cursor("+")<cr>
    nmap <silent><buffer> + :call <SID>edit_at_cursor("+")<cr>
    nmap <silent><buffer> - :call <SID>edit_at_cursor("-")<cr>
    nmap <silent><buffer> _ :call <SID>edit_at_cursor("-")<cr>
    nmap <silent><buffer> <ScrollWheelUp> :call <SID>edit_at_cursor("+")<cr>
    nmap <silent><buffer> <ScrollWheelDown> :call <SID>edit_at_cursor("-")<cr>

    "edit name
    nmap <silent><buffer> nn :call colorv#list_win()<cr>
    nmap <silent><buffer> na :call <SID>input_colorname()<cr>
    nmap <silent><buffer> ne :call <SID>input_colorname()<cr>
    nmap <silent><buffer> nx :call <SID>input_colorname("X11")<cr>


    nmap <silent><buffer> q :call colorv#exit()<cr>
    nmap <silent><buffer> Q :call colorv#exit()<cr>
    nmap <silent><buffer> ? :call colorv#echo_tips()<cr>
    nmap <silent><buffer> H :h colorv-quickstart<cr>
    nmap <silent><buffer> <F1> :h colorv-quickstart<cr>

    "Copy color
    map <silent><buffer> C   :call <SID>copy("HEX","+")<cr>
    map <silent><buffer> cc  :call <SID>copy("HEX","+")<cr>
    map <silent><buffer> Y   :call <SID>copy()<cr>
    map <silent><buffer> yy  :call <SID>copy()<cr>
    for [key,fmt] in items(s:fmt_keys)
        exe 'map <silent><buffer> c'.key.'  :call <SID>copy("'.fmt.'","+")<CR>'
        exe 'map <silent><buffer> y'.key.'  :call <SID>copy("'.fmt.'")<CR>'
    endfor


    "paste color
    map <silent><buffer> <c-v> :call <SID>paste("+")<cr>
    map <silent><buffer> p :call <SID>paste()<cr>
    map <silent><buffer> P :call <SID>paste()<cr>
    map <silent><buffer> <middlemouse> :call <SID>paste("+")<cr>

    "generator with current color
    "
    for [key,gen] in items(s:gen_keys)
        exe 'nmap <silent><buffer> g'.key.'  :call colorv#list_gen_win(g:colorv.HEX,"'.gen.'")<CR>'
    endfor

    nmap <silent><buffer> gg :call colorv#list_win2()<CR>

    "easy moving
    noremap <silent><buffer>j gj
    noremap <silent><buffer>k gk

    nmap <silent><buffer> ss :call colorv#scheme#win(g:colorv.HEX)<CR>
    nmap <silent><buffer> s1 :call colorv#scheme#win()<CR>
    nmap <silent><buffer> st :call colorv#scheme#win('top')<CR>
    nmap <silent><buffer> sn :call colorv#scheme#win('new')<CR>
    nmap <silent><buffer> sh :call colorv#scheme#win('hot')<CR>
    nmap <silent><buffer> sf :call colorv#scheme#show_fav()<CR>
    nmap <silent><buffer> sN :call colorv#scheme#new()<CR>

endfunction "}}}
function! colorv#define_global() "{{{
    if g:colorv_no_global_map==1
        return
    endif
    let leader_maps=g:colorv_global_leader
    let map_dicts=[
    \{'key': ['v'] ,       'cmd': ':ColorV<CR>'},
    \{'key': ['ss'] ,      'cmd': ':ColorVScheme<CR>'},
    \{'key': ['sf'] ,      'cmd': ':ColorVSchemeFav<CR>'},
    \{'key': ['sn'] ,      'cmd': ':ColorVSchemeNew<CR>'},
    \{'key': ['1','mn'] ,  'cmd': ':ColorVMin<CR>'},
    \{'key': ['md'] ,      'cmd': ':ColorVMid<CR>'},
    \{'key': ['3','mx'] ,  'cmd': ':ColorVMax<CR>'},
    \{'key': ['w' ],       'cmd': ':ColorVView<CR>'},
    \{'key': ['e' ],       'cmd': ':ColorVEdit<CR>'},
    \{'key': ['E' ],       'cmd': ':ColorVEditAll<CR>'},
    \{'key': ['d' ],       'cmd': ':ColorVPicker<CR>'},
    \{'key': ['n' ],       'cmd': ':ColorVName<CR>'},
    \{'key': ['q' ],       'cmd': ':ColorVQuit<CR>'},
    \{'key': ['pp'] ,      'cmd': ':ColorVPreview<CR>'},
    \{'key': ['ap'] ,      'cmd': ':ColorVAutoPreview<CR>'},
    \{'key': ['an'] ,      'cmd': ':ColorVNoAutoPreview<CR>'},
    \{'key': ['pl'] ,      'cmd': ':ColorVPreviewLine<CR>'},
    \{'key': ['pa'] ,      'cmd': ':ColorVPreviewArea<CR>'},
    \{'key': ['pc'] ,      'cmd': ':ColorVClear<CR>'},
    \{'key': ['22'] ,      'cmd': ':ColorVEditTo HEX<CR>'},
    \{'key': ['ii'] ,      'cmd': ':ColorVInsert<CR>'},
    \{'key': ['gg'] ,      'cmd': ':ColorVTurn2<CR>'},
    \]

    let tmp_l = []
    for [key, fmt] in items(s:fmt_keys)
        call add(tmp_l, {'key':['2' . key], 'cmd': ':ColorVEditTo '.fmt.'<CR>'})
        call add(tmp_l, {'key':['i' . key], 'cmd': ':ColorVInsert '.fmt.'<CR>'})
    endfor
    for [key, gen] in items(s:gen_keys)
        call add(tmp_l, {'key':['g' . key], 'cmd': ':ColorVList '.gen.'<CR>'})
    endfor
    call extend(map_dicts, tmp_l)

    for i in map_dicts
        if !hasmapto(i.cmd, 'n')
        for k in i['key']
            silent! exe 'nmap <unique> <silent> '.leader_maps.k.' '.i['cmd']
        endfor
        endif
    endfor
endfunction "}}}
function! colorv#init() "{{{
    call colorv#default("g:colorv_debug"         , 0                )
    call colorv#default("g:colorv_load_cache"    , 1                )
    call colorv#default("g:colorv_win_pos"       , "bot"            )
    call colorv#default("g:colorv_preview_name"  , 1                )
    call colorv#default("g:colorv_preview_area"  , 0                )
    call colorv#default("g:colorv_gen_space"     , "hsv"            )
    call colorv#default("g:colorv_preview_ftype" , 'css,html,javascript' )
    call colorv#default("g:colorv_max_preview"   , 200              )
    call colorv#default("g:colorv_python_cmd"    , "python2"        )
    if !exists('g:colorv_cache_file') "{{{
        if has("win32") || has("win64")
            if exists('$HOME')
                let g:colorv_cache_file = expand('$HOME') . '\.vim_colorv_cache'
                let g:colorv_cache_fav = expand('$HOME') . '\.vim_colorv_cache_fav'
            else
                let g:colorv_cache_file = expand('$VIM') . '\.vim_colorv_cache'
                let g:colorv_cache_fav = expand('$VIM') . '\.vim_colorv_cache_fav'
            endif
        else
            let g:colorv_cache_file = expand('$HOME') . '/.vim_colorv_cache'
            let g:colorv_cache_fav = expand('$HOME') . '/.vim_colorv_cache_fav'
        endif
    endif "}}}

    if has("python") "{{{
        call colorv#default("g:colorv_has_python"     , 2                )
        let s:py="py"
        call s:py_core_load()
    elseif has("python3")
        call colorv#default("g:colorv_has_python"     , 3                )
        let s:py="py3"
        call s:py_core_load()
    else
        let g:colorv_has_python = 0
    endif "}}}

    if g:colorv_load_cache==1 "{{{
        call colorv#mark#load()
        call colorv#scheme#load()
        aug colorv#cache
            au! VIMLEAVEPre * call colorv#mark#save()
            au! VIMLEAVEPre * call colorv#scheme#save()
        aug END
    endif "}}}

    aug colorv#preview_ftpye "{{{
        au!
        for file in  split(g:colorv_preview_ftype, '\s*,\s*')
                exec "au!  FileType ".file." call colorv#prev_aug('s')"
        endfor
        au! BufEnter */doc/colorv.txt    call colorv#preview_line("b",9)
    aug END "}}}
endfunction "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call colorv#init()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:tw=78:fdm=marker:
