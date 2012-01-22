"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: plugin/colorv.vim
" Summary: A Color tool in Vim
"  Author: Rykka10 <Rykka10(at)gmail.com>
" Last Update: 2012-01-22
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if v:version < 700
    finish
endif

command! -nargs=*  ColorV call colorv#win("",<q-args>)
command! -nargs=*  ColorVmid call colorv#win("mid",<q-args>)
command! -nargs=*  ColorVmin call colorv#win("min",<q-args>)
command! -nargs=*  ColorVmax call colorv#win("max",<q-args>)
command! -nargs=0  ColorVquit call colorv#exit()
command! -nargs=0  ColorVclear call colorv#clear_all()

command! -nargs=0  ColorVword call colorv#cursor_win()
command! -nargs=0  ColorVsub call colorv#cursor_win(1)
command! -nargs=0  ColorVsuball call colorv#cursor_win(2)
command! -nargs=1  ColorVsub2 call colorv#cursor_win(1,<q-args>)

command! -nargs=0  ColorVlist call colorv#list_win()
command! -nargs=+  ColorVlistgen call colorv#cursor_win(3,<f-args>)

command! -nargs=0  ColorVview call colorv#preview()
command! -nargs=0  ColorVviewblock call colorv#preview("bc")
command! -nargs=0  ColorVviewline call colorv#preview_line("c")

command! -nargs=0  ColorVdropper call colorv#dropper()

if !exists('g:ColorV_no_global_map')
  let g:ColorV_no_global_map = 0
endif

if !exists('g:ColorV_global_leader')
  let g:ColorV_global_leader = '<Leader>c'
endif
function! colorv#define_global() "{{{
    if g:ColorV_no_global_map==1
        return
    endif
    let leader_maps=g:ColorV_global_leader
    let map_dicts=[
                \{'key': 'v' , 'cmd': ':ColorV<CR>'},         
                \{'keys': ['1','m'] , 'cmd': ':ColorVmin<CR>'},         
                \{'key': '2' , 'cmd': ':ColorVmid<CR>'},         
                \{'keys': ['3','x'] , 'cmd': ':ColorVmax<CR>'},         
                \{'key': 'w' , 'cmd': ':ColorVword<CR>'},         
                \{'key': 'e' , 'cmd': ':ColorVsub<CR>'},         
                \{'key': 'd' , 'cmd': ':ColorVdropper<CR>'},         
                \{'key': 'l' , 'cmd': ':ColorVlist<CR>'},         
                \{'key': 'q' , 'cmd': ':ColorVquit<CR>'},         
                \{'key': 'pp' , 'cmd': ':ColorVview<CR>'},         
                \{'key': 'pl' , 'cmd': ':ColorVviewline<CR>'},         
                \{'key': 'pc' , 'cmd': ':ColorVclear<CR>'},         
                \{'key': 'pb' , 'cmd': ':ColorVviewblock<CR>'},         
                \{'key': '2x' , 'cmd': ':ColorVsub2 HEX<CR>'},         
                \{'key': '2h' , 'cmd': ':ColorVsub2 HSV<CR>'},         
                \{'key': '2n' , 'cmd': ':ColorVsub2 NAME<CR>'},         
                \{'key': '2r' , 'cmd': ':ColorVsub2 RGB<CR>'},         
                \{'key': '2m' , 'cmd': ':ColorVsub2 CMYK<CR>'},         
                \{'key': '2p' , 'cmd': ':ColorVsub2 RGBP<CR>'},         
                \{'key': '2l' , 'cmd': ':ColorVsub2 HSL<CR>'},         
                \{'keys': ['2s','2#'] , 'cmd': ':ColorVsub2 NS6<CR>'},         
                \{'key': '2l' , 'cmd': ':ColorVsub2 HSL<CR>'},         
                \{'keys': ['g1', 'gh'] , 'cmd': ':ColorVlistgen Hue 20 15<CR>'},         
                \{'key': 'gs' , 'cmd': ':ColorVlistgen Saturation 20 15<CR>'},         
                \{'key': 'gv' , 'cmd': ':ColorVlistgen Value 20 5 1<CR>'},         
                \{'key': 'ga' , 'cmd': ':ColorVlistgen Analogous<CR>'},         
                \{'key': 'gq' , 'cmd': ':ColorVlistgen Square<CR>'},         
                \{'key': 'gn' , 'cmd': ':ColorVlistgen Neutral<CR>'},         
                \{'key': 'gc' , 'cmd': ':ColorVlistgen Clash<CR>'},         
                \{'key': 'gp' , 'cmd': ':ColorVlistgen Split-Complementary<CR>'},         
                \{'key': 'gm' , 'cmd': ':ColorVlistgen Monochromatic<CR>'},         
                \{'key': 'g2' , 'cmd': ':ColorVlistgen Complementary<CR>'},         
                \{'key': 'g3' , 'cmd': ':ColorVlistgen Triadic<CR>'},         
                \{'key': 'g4' , 'cmd': ':ColorVlistgen Tetradic<CR>'},         
                \{'key': 'g5' , 'cmd': ':ColorVlistgen Five-Tone<CR>'},         
                \{'key': 'g6' , 'cmd': ':ColorVlistgen Six-Tone<CR>'},         
                \]
    for i in map_dicts
        if !hasmapto(i.cmd, 'n')
            if exists("i['key']")
                silent! exe 'nmap <unique> <silent> '.leader_maps.i['key'].' '.i['cmd'] 
            elseif exists("i['keys']")
                for k in i['keys']
                    silent! exe 'nmap <unique> <silent> '.leader_maps.k.' '.i['cmd'] 
                endfor
            endif
        endif
    endfor
endfunction "}}}
call colorv#define_global()
let &cpo = s:save_cpo
unlet s:save_cpo
