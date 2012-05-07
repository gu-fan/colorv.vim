"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: plugin/colorv.vim
" Summary: A vim plugin to make colors handling easier.
"  Author: Rykka G.Forest <Rykka10(at)gmail.com>
" Last Update: 2012-05-07
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if v:version < 700
    echom "[ColorV] Stoped as your vim version < 7.0."
    finish
elseif exists("g:colorv_loaded") && g:colorv_loaded == 1
    finish
else
    let g:colorv_loaded = 1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=*  ColorV            call colorv#win("",<q-args>)
command! -nargs=*  ColorVMid         call colorv#win("mid",<q-args>)
command! -nargs=*  ColorVMin         call colorv#win("min",<q-args>)
command! -nargs=*  ColorVMax         call colorv#win("max",<q-args>)
command! -nargs=0  ColorVQuit        call colorv#exit()

command! -nargs=0  ColorVView        call colorv#cursor_text("view")
command! -nargs=0  ColorVEdit        call colorv#cursor_text("edit")
command! -nargs=0  ColorVEditAll     call colorv#cursor_text("editAll")
command! -nargs=1  ColorVEditTo      call colorv#cursor_text("changeTo",<q-args>)

command! -nargs=0  ColorVName        call colorv#list_win()
command! -nargs=+  ColorVList        call colorv#cursor_text("list",<f-args>)
command! -nargs=*  ColorVList2       call colorv#list_win2(<f-args>)

command! -nargs=0  ColorVAutoPreview   call colorv#prev_aug()
command! -nargs=0  ColorVNoAutoPreview call colorv#prev_no_aug()

command! -nargs=0  ColorVPreview     call colorv#preview("c")
command! -nargs=0  ColorVPreviewArea call colorv#preview("bc")
command! -nargs=0  ColorVPreviewLine call colorv#preview_line()
command! -nargs=0  ColorVClear       call colorv#clear_all()

command! -nargs=0  ColorVPicker     call colorv#picker()

call colorv#default("g:colorv_no_global_map",0)
call colorv#default("g:colorv_global_leader",'<leader>c')

function! colorv#define_global() "{{{
    if g:colorv_no_global_map==1
        return
    endif
    let leader_maps=g:colorv_global_leader
    let map_dicts=[
    \{'key': ['v'] ,       'cmd': ':ColorV<CR>'},
    \{'key': ['1','m'] ,   'cmd': ':ColorVMin<CR>'},
    \{'key': ['2'] ,       'cmd': ':ColorVMid<CR>'},
    \{'key': ['3','x'] ,   'cmd': ':ColorVMax<CR>'},
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
    \{'key': ['2x'] ,      'cmd': ':ColorVEditTo HEX<CR>'},
    \{'key': ['2h'] ,      'cmd': ':ColorVEditTo HSV<CR>'},
    \{'key': ['2n'] ,      'cmd': ':ColorVEditTo NAME<CR>'},
    \{'key': ['2r'] ,      'cmd': ':ColorVEditTo RGB<CR>'},
    \{'key': ['2m'] ,      'cmd': ':ColorVEditTo CMYK<CR>'},
    \{'key': ['2p'] ,      'cmd': ':ColorVEditTo RGBP<CR>'},
    \{'key': ['2l'] ,      'cmd': ':ColorVEditTo HSL<CR>'},
    \{'key': ['2s','2#'] , 'cmd': ':ColorVEditTo NS6<CR>'},
    \{'key': ['2l' ],      'cmd': ':ColorVEditTo HSL<CR>'},
    \{'key': ['g1', 'lh'] ,'cmd': ':ColorVList Hue 20 15<CR>'},
    \{'key': ['gs'] ,      'cmd': ':ColorVList Saturation 20 15<CR>'},
    \{'key': ['gv'] ,      'cmd': ':ColorVList Value 20 5 1<CR>'},
    \{'key': ['ga'] ,      'cmd': ':ColorVList Analogous<CR>'},
    \{'key': ['gq'] ,      'cmd': ':ColorVList Square<CR>'},
    \{'key': ['gn'] ,      'cmd': ':ColorVList Neutral<CR>'},
    \{'key': ['gc'] ,      'cmd': ':ColorVList Clash<CR>'},
    \{'key': ['gp'] ,      'cmd': ':ColorVList Split-Complementary<CR>'},
    \{'key': ['gm'] ,      'cmd': ':ColorVList Monochromatic<CR>'},
    \{'key': ['g2'] ,      'cmd': ':ColorVList Complementary<CR>'},
    \{'key': ['g3'] ,      'cmd': ':ColorVList Triadic<CR>'},
    \{'key': ['g4'] ,      'cmd': ':ColorVList Tetradic<CR>'},
    \{'key': ['g5'] ,      'cmd': ':ColorVList Five-Tone<CR>'},
    \{'key': ['g6'] ,      'cmd': ':ColorVList Six-Tone<CR>'},
    \]
    for i in map_dicts
        if !hasmapto(i.cmd, 'n')
        for k in i['key']
            silent! exe 'nmap <unique> <silent> '.leader_maps.k.' '.i['cmd'] 
        endfor
        endif
    endfor
endfunction "}}}
call colorv#define_global()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
