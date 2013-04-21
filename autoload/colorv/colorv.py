#!/usr/bin/env python3

from math import fmod
import vim
import colorsys
import re

vcmd = vim.command
veval = vim.eval
# number 
def number(x):
    return int(round(float(x)))

# hex
def hex2rgb(h):
    h = h[1:] if h.startswith('#') else h[2:] if h.startswith(("0x","0X")) else h
    return map(lambda x:int(x,16), [h[0:2],h[2:4],h[4:6]])
def rgb2hex(rgb):
    r,g,b = map(lambda x: 0 if x < 0 else 255 if x > 255 else x,
            map(lambda x: int(round(float(x))),rgb))
    return '%02X%02X%02X' % (r,g,b)

#hsv
def rgb2hsv(rgb):
    r,g,b=rgb
    h,s,v=colorsys.rgb_to_hsv(r/255.0,g/255.0,b/255.0)
    return [int(round(h*360.0)),int(round(s*100.0)),int(round(v*100.0))]
def hsv2rgb(hsv):
    h,s,v=hsv
    r,g,b=colorsys.hsv_to_rgb(h/360.0,s/100.0,v/100.0)
    return map(lambda x: int(round(x*255.0)),[r,g,b])

#yiq
def rgb2yiq(rgb):
    r,g,b=rgb
    y,i,q=colorsys.rgb_to_yiq(r/255.0,g/255.0,b/255.0)
    return map(lambda x: int(round(x*100.0)),[y,i,q])
def yiq2rgb(yiq):
    y,i,q=yiq
    r,g,b=colorsys.yiq_to_rgb(y/100.0,i/100.0,q/100.0)
    return map(lambda x: int(round(x*255.0)),[r,g,b])
    
#hls
def rgb2hls(rgb):
    r,g,b=rgb
    h,l,s=colorsys.rgb_to_hls(r/255.0,g/255.0,b/255.0)
    return [int(round(h*360.0)),int(round(l*100.0)),int(round(s*100.0))]
def hls2rgb(hls):
    h,l,s=hls
    r,g,b=colorsys.hls_to_rgb(h/360.0,l/100.0,s/100.0)
    return map(lambda x: int(round(x*255.0)),[r,g,b])

#cmyk
def rgb2cmyk(rgb):
    R,G,B = rgb
    [C,M,Y]=[1.0-R/255.0,1.0-G/255.0,1.0-B/255.0]
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
    return map(lambda x: int(round(x*100)),[C,M,Y,K])
def cmyk2rgb(cmyk):
    C,M,Y,K = map(lambda x: x/100.0, cmyk)
    C=C*(1-K)+K
    M=M*(1-K)+K
    Y=Y*(1-K)+K
    return map(lambda x: int(round((1-x)*255)),[C,M,Y])


def hex2term8(hex1,mode=8): 
    r,g,b = hex2rgb(hex1)
    r,g,b = map(lambda x: 0 if x <= 64 else 1 if x <= 192 else 2, [r,g,b])
    if r <= 1 and g <= 1 and b <= 1:
        i = r*4 + g*2 + b
        z = 0
    else:
        i = (r//2)*4 + (g//2)*2   + b//2
        z = 1
    if mode == 16:
        t  = i  + z * 8
    else:
        t  = number("04261537"[i]) + z * 8
    if t == 7:
        t = 8
    return t

def hex2term(h): 
    r,g,b = hex2rgb(h)
    
    if abs(r-g) <=16 and  abs(g-b) <=16 and abs(r-b) <=16:
        if r<=4:
            t_num = 16
        elif r>= 92 and r<=96:
            t_num = 59
        elif r>= 132 and r<=136:
            t_num = 102
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
        r,g,b = map(lambda x: 0 if x <= 48  else
                              1 if x <= 115 else
                              2 if x <= 155 else
                              3 if x <= 195 else
                              4 if x <= 235 else
                              5 , [r,g,b])
        t_num  = r*36 + g*6 + b + 16
    return t_num
    

fmt={} 
# NOTE: '\b\s..' as first word in vim should escape twice.
fmt['RGB']=re.compile(r'''
        \b rgb[ ]?[(]                       # wordbegin
        [ \t]*(?P<R>\d{1,3}),               # group2 R
        [ \t]*(?P<G>\d{1,3}),               # group3 G
        [ \t]*(?P<B>\d{1,3})                # group4 B
        [)](?ix)                            # [iLmsux] i:igone x:verbose
                      ''')
fmt['RGBA']=re.compile(r'''
        \b rgba[(]
        [ \t]*(?P<R>\d{1,3}),                    # group2 R
        [ \t]*(?P<G>\d{1,3}),                    # group3 G
        [ \t]*(?P<B>\d{1,3}),                    # group4 B
        [ \t]*(?P<A>\d{1,3}(?:\.\d*)?)%?
        [)] (?ix) ''')
fmt['glRGBA']=re.compile(r'''
        \b glColor\du?[bsifd][(]
        [ \t]*(?P<R>\d(?:\.\d*)?),               # group2 R
        [ \t]*(?P<G>\d(?:\.\d*)?),               # group3 G
        [ \t]*(?P<B>\d(?:\.\d*)?),               # group4 B
        [ \t]*(?P<A>\d(?:\.\d*)?)
        [)](?ix) ''')
fmt['RGBP']=re.compile(r'''
        \b rgb[(]
        [ \t]*(?P<R>\d{1,3})%,                   # group2 R
        [ \t]*(?P<G>\d{1,3})%,                   # group3 G
        [ \t]*(?P<B>\d{1,3})%                    # group4 B
        [)] (?ix) ''')
fmt['RGBAP']=re.compile(r'''
        \b rgba[(]
        [ \t]*(?P<R>\d{1,3})%,                   # group2 R
        [ \t]*(?P<G>\d{1,3})%,                   # group3 G
        [ \t]*(?P<B>\d{1,3})%,                   # group4 B
        [ \t]* (?P<A>\d{1,3} (?:\.\d*)?) %?
        [)] (?ix) ''')

fmt['HSL']=re.compile(r'''
        \b hsl[(]
        [ \t]*(?P<H>\d{1,3}),                    # group2 H
        [ \t]*(?P<S>\d{1,3})%,                   # group3 S
        [ \t]*(?P<L>\d{1,3})%                    # group4 L
        [)] (?ix) ''')
fmt['HSLA']=re.compile(r'''
        \b hsla[(]
        [ \t]*(?P<H>\d{1,3}),                    # group2 H
        [ \t]*(?P<S>\d{1,3})%,                   # group3 S
        [ \t]*(?P<L>\d{1,3})%,                   # group4 L
        [ \t]*(?P<A>\d{1,3} (?:\.\d*)?) %?
        [)] (?ix) ''')
fmt['CMYK']=re.compile(r'''
        \b cmyk[(]
        [ \t]*(?P<C>\d{1,3}),                    # group2 C
        [ \t]*(?P<M>\d{1,3}),                    # group3 M
        [ \t]*(?P<Y>\d{1,3}),                    # group4 Y
        [ \t]*(?P<K>\d{1,3})                     # group4 K
        [)] (?ix) ''')
fmt['HSV']=re.compile(r'''
        \b hsv[(]
        [ \t]*(?P<H>\d{1,3}),                    # group2 H
        [ \t]*(?P<S>\d{1,3}),                    # group3 S
        [ \t]*(?P<V>\d{1,3})                     # group4 V
        [)] (?ix) ''')
fmt['HSVA']=re.compile(r'''
        \b hsva[(]
        [ \t]*(?P<H>\d{1,3}),                    # group2 H
        [ \t]*(?P<S>\d{1,3}),                    # group3 S
        [ \t]*(?P<V>\d{1,3}),                    # group4 V
        [ \t]* (?P<A>\d{1,3} (?:\.\d*)?) %?
        [)] (?ix) ''')

# NOTE (?<![0-9a-fA-F]|0[xX]) is wrong!
#      (?<![0-9a-fA-F])|(?<!0[xX]) is wrong too!
#      maybe (?<!([09a-fA-F])|(0[xX])) still wrong.
#      use (?<![\w#]) or (?<![09a-fA-FxX#])

fmt['HEX']=re.compile(r'''
        ([#]|\b0x|\b)                     # ffffff #ffffff 0xffffff
        (?P<HEX>[0-9A-F]{6})            #group HEX in upper 'FFFFFF'
        (?!\w)(?ix)     ''')
fmt['HEX3']=re.compile(r'''
        [#](?P<HEX3>[0-9a-fA-F]{3})(?!\w)(?ix)''')


# clr_lst 
clrnX11 = veval("s:clrnX11")
clrnW3C = veval("s:clrnW3C")
clrdX11 = veval("s:clrdX11")
clrdW3C = veval("s:clrdW3C")

def nametxt2hex(txt): 
    hex_list=[]
    startidx=0
    for t in re.split(r'(\s+|[^0-9a-zA-Z_-])',txt):
        ltxt = t.lower()
        if ltxt in clrdW3C:
            p_idx = txt.find(t, startidx)
            hex_list.append([t, clrdW3C[ltxt], 'NAME', p_idx, 1])
            startidx = p_idx + len(t)
    return hex_list 
def txt2hex(txt): 
    hex_list=[]
    for fm,reg in fmt.iteritems():
        for obj in reg.finditer(txt):
            alp = 1
            if fm=="HEX":
                HEX=obj.group('HEX')
            elif fm=="HEX3":
                HEX3=obj.group('HEX3')
                HEX=HEX3[0]*2+HEX3[1]*2+HEX3[2]*2
            elif fm=="RGBA":
                alp = float(obj.group('A'))
                r,g,b=[int(obj.group('R')),int(obj.group('G')), 
                        int(obj.group('B'))]
                if r<0 or r>255 or g<0 or g>255 or b<0 or b>255 :
                    continue
                HEX=rgb2hex([r,g,b])
            elif fm=="RGB":
                r,g,b=[int(obj.group('R')),int(obj.group('G')), 
                        int(obj.group('B'))]
                if r<0 or r>255 or g<0 or g>255 or b<0 or b>255 :
                    continue
                HEX=rgb2hex([r,g,b])
            elif fm=="RGBP":
                r,g,b=[int(obj.group('R'))*2.55,int(obj.group('G'))*2.55,
                        int(obj.group('B'))*2.55]
                if r<0 or r>255 or g<0 or g>255 or b<0 or b>255:
                    continue
                HEX=rgb2hex([r,g,b])
            elif fm=="RGBAP":
                alp = float(obj.group('A'))
                r,g,b=[int(obj.group('R'))*2.55,int(obj.group('G'))*2.55,
                        int(obj.group('B'))*2.55]
                if r<0 or r>255 or g<0 or g>255 or b<0 or b>255:
                    continue
                HEX=rgb2hex([r,g,b])
            elif fm=="glRGBA":
                alp = float(obj.group('A'))
                r,g,b=[float(obj.group('R'))*255,float(obj.group('G'))*255,
                       float(obj.group('B'))*255]
                if r<0 or r>255 or g<0 or g>255 or b<0 or b>255:
                    continue
                HEX=rgb2hex([r,g,b])
            elif fm=="HSL":
                h,s,l=[int(obj.group('H')),int(obj.group('S')),
                        int(obj.group('L'))]
                if h>360 or h<0 or s>100 or s<0 or l>100 or l<0:
                    continue
                HEX=rgb2hex(hls2rgb([h,l,s]))
            elif fm=="HSLA" :
                alp = float(obj.group('A'))
                h,s,l=[int(obj.group('H')),int(obj.group('S')),
                        int(obj.group('L'))]
                if h>360 or h<0 or s>100 or s<0 or l>100 or l<0:
                    continue
                HEX=rgb2hex(hls2rgb([h,l,s]))
            elif fm=="CMYK" :
                c,m,y,k=[int(obj.group('C')),int(obj.group('M'))
                        ,int(obj.group('Y')),int(obj.group('K'))]
                if c>100 or c<0 or m>100 or m<0 or y>100 or y<0 \
                   or k>100 or k<0:
                    continue 
                HEX=rgb2hex(cmyk2rgb([c,m,y,k]))
            elif fm=="HSV":
                h,s,v= [int(obj.group('H')),int(obj.group('S')),
                        int(obj.group('V'))]
                if h>360 or h<0 or s>100 or s<0 or v>100 or v<0:
                    continue
                HEX=rgb2hex(hsv2rgb([h,s,v]))
            elif fm=="HSVA" :
                alp = float(obj.group('A'))
                h,s,v= [int(obj.group('H')),int(obj.group('S')),
                        int(obj.group('V'))]
                if h>360 or h<0 or s>100 or s<0 or v>100 or v<0:
                    continue
                HEX=rgb2hex(hsv2rgb([h,s,v]))
            else:
                continue
            hex_list.append([obj.group(),HEX,fm,obj.start(),alp])
    nhex_list = nametxt2hex(txt)
    return hex_list + nhex_list 

def nam2hex(name,*rule): 
    if len(name):
        if len(rule) and rule[0]=="X11":
            dic=clrdX11
        else:
            dic=clrdW3C
        ln = name.lower()
        if ln in dic:
            return dic[ln]
    return 0 
def hex2nam(hex,lst="W3C"): 

    best_match = ""
    smallest_distance = 10000000

    t = int(veval("s:aprx_rate"))
    if lst=="X11":clr_list=clrnX11
    else:         clr_list=clrnW3C

    r1,g1,b1 = hex2rgb(hex)
    for name,HEX in clr_list:
        r2,g2,b2 = map(lambda x:int(x,16), [HEX[0:2],HEX[2:4],HEX[4:6]])
        d = abs(r1-r2)+abs(g1-g2)+abs(b1-b2)
        if d < smallest_distance:
            smallest_distance = d
            best_match = name

    if smallest_distance == 0:
        return best_match
    elif smallest_distance <= t*4:
        return best_match+"~"
    elif smallest_distance <= t*8:
        return best_match+"~~"
    else:
        return "" 

lookup = {}
H_OFF,W_OFF = int(veval("s:OFF_H")),int(veval("s:OFF_W"))
def draw_palette(H,height,width): 

    H = fmod(H,360) if H >= 360 else 360+fmod(H,360) if H < 0 else H
    name = "_".join([str(H),str(height),str(width)])
    if name not in lookup: 
        p2=[]
        V_step = 100.0/height
        S_step = 100.0/(width-1)
        for row in range(height):
            V = 100 - V_step * row
            if V<=0 : V = 1
            l=[]
            for col in range(width):
                S = 100 - S_step * col
                if S<=0 : S = 1
                hex = rgb2hex(hsv2rgb([H,S,V]))
                l.append(hex)
            p2.append(l)
        lookup[name] = p2        # obmit coping as 
                                 # the list ref will not be changed
                                 # when we use [] to creat a new one
    else:
        p2 = lookup[name]
    
    vcmd("call colorv#clear('pal')")
    for row  in range(height):
        for col in range(width):
            hex = p2[row][col]
            hi_grp  = "".join(["cv_pal_",str(row),"_",str(col)])
            pos_ptn = "".join(["\\%",str(row+H_OFF+1),"l\\%"
                                    ,str(col+W_OFF+1),"c"])
            vcmd("call s:hi_color('{}','{}','{}',' ')".format(hi_grp,hex,hex))
            vcmd("sil! let s:cv_dic['pal']['{0}'] = matchadd('{0}','{1}')"
                    .format( hi_grp,pos_ptn))
    vcmd("".join(["let s:pal_clr_list=",str(p2)]))

def draw_pallete_hex(hex): 
    h,s,v=rgb2hsv(hex2rgb(hex))
    pal_H,pal_W = int(veval("s:pal_H")),int(veval("s:pal_W"))
    draw_palette(h,pal_H,pal_W)

def rlt_clr(hex1):
    y,i,q=rgb2yiq(hex2rgb(hex1))

    if   y>=80: y-=60
    elif y>=40: y-=40
    elif y>=20: y+=40
    else:       y+=55

    if   i >= 55: i -= 30
    elif i >= 35: i -= 20
    elif i >= 10: i -= 5
    elif i >=-10: i += 0
    elif i >=-35: i += 5
    elif i >=-55: i += 20
    else:         i += 30

    if   q >= 55: q -= 30
    elif q >= 35: q -= 20
    elif q >= 10: q -= 5
    elif q >=-10: q += 0
    elif q >=-35: q += 5
    elif q >=-55: q += 20
    else:         q += 30
    return rgb2hex(yiq2rgb([y,i,q]))
