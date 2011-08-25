"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: plugin/ColorV.vim
" Summary: A Color Viewer and Color Picker for Vim
"  Author: Rykka.Krin <rykka.krin@gmail.com>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if v:version < 700
    finish
endif


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
if !exists('g:ColorV_word_mini')
    let g:ColorV_word_mini=1
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


command! -nargs=*  ColorV call colorv#win("",<q-args>)
command! -nargs=*  ColorVmid call colorv#win("",<q-args>)
command! -nargs=*  ColorVmin call colorv#win("min",<q-args>)
command! -nargs=*  ColorVmax call colorv#win("max",<q-args>)
command! -nargs=0  ColorVquit call colorv#exit()
command! -nargs=0  ColorVclear call colorv#clear_all()

command! -nargs=0  ColorVword call colorv#cursor_win()
command! -nargs=0  ColorVchange call colorv#cursor_win(1)
command! -nargs=0  ColorVchangeAll call colorv#cursor_win(2)
command! -nargs=1  ColorVchange2 call colorv#cursor_win(1,<q-args>)

command! -nargs=0  ColorVlist call colorv#list_and_colorv()
command! -nargs=+  ColorVgenerate call colorv#gen_win(<f-args>)
command! -nargs=+  ColorVwordgen call colorv#cursor_win(3,<f-args>)

command! -nargs=0  ColorVpreview call colorv#preview()
command! -nargs=0  ColorVpreviewblock call colorv#preview("B")
command! -nargs=0  ColorVpreviewline call colorv#preview_line()
command! -nargs=+  ColorVTimer call colorv#timer(<f-args>)

command! -nargs=0  ColorVdropper call colorv#dropper()

if !hasmapto(':ColorV<CR>')
  silent! nmap <unique> <silent> <Leader>cv :ColorV<CR>
endif
if !hasmapto(':ColorVmin<CR>')
  silent! nmap <unique> <silent> <Leader>cm :ColorVmin<CR>
endif
if !hasmapto(':ColorVmax<CR>')
  silent! nmap <unique> <silent> <Leader>cx :ColorVmax<CR>
endif

if !hasmapto(':ColorVword<CR>')
  silent! nmap <unique> <silent> <Leader>cw :ColorVword<CR>
endif

if !hasmapto(':ColorVchange<CR>')
  silent! nmap <unique> <silent> <Leader>ce :ColorVchange<CR>
endif

if !hasmapto(':ColorVchangeALl<CR>')
  silent! nmap <unique> <silent> <Leader>ca :ColorVchangeAll<CR>
endif

if !hasmapto(':ColorVchange2 HEX<CR>')
  silent! nmap <unique> <silent> <Leader>c2x :ColorVchange2 HEX<CR>
endif
if !hasmapto(':ColorVchange2 HSV<CR>')
  silent! nmap <unique> <silent> <Leader>c2h :ColorVchange2 HSV<CR>
endif

if !hasmapto(':ColorVchange2 NAME<CR>')
  silent! nmap <unique> <silent> <Leader>c2n :ColorVchange2 NAME<CR>
endif
if !hasmapto(':ColorVchange2 RGB<CR>')
  silent! nmap <unique> <silent> <Leader>c2r :ColorVchange2 RGB<CR>
endif

if !hasmapto(':ColorVchange2 RGBP<CR>')
  silent! nmap <unique> <silent> <Leader>c2p :ColorVchange2 RGBP<CR>
endif

if !hasmapto(':ColorVchange2 #<CR>')
  silent! nmap <unique> <silent> <Leader>c2# :ColorVchange2 NS6<CR>
  silent! nmap <unique> <silent> <Leader>c2s :ColorVchange2 NS6<CR>
endif

if !hasmapto(':ColorVdropper<CR>')
  silent! nmap <unique> <silent> <Leader>cd :ColorVdropper<CR>
endif
if !hasmapto(':ColorVquit<CR>') 
  silent! nmap <unique> <silent> <Leader>cq :ColorVquit<CR>
endif

if !hasmapto(':ColorVlist<CR>')
  silent! nmap <unique> <silent> <Leader>cl :ColorVlist<CR>
endif

if !hasmapto(':ColorVwordgenerate Hue<CR>')
  silent! nmap <unique> <silent> <Leader>cgh :ColorVwordgen Hue<CR>
endif
if !hasmapto(':ColorVwordgenerate Saturation<CR>')
  silent! nmap <unique> <silent> <Leader>cgs :ColorVwordgen Saturation<CR>
endif
if !hasmapto(':ColorVwordgenerate Value<CR>')
  silent! nmap <unique> <silent> <Leader>cgv :ColorVwordgen Value<CR>
endif

if !hasmapto(':ColorVwordgenerate Analogous<CR>')
  silent! nmap <unique> <silent> <Leader>cga :ColorVwordgen Analogous<CR>
endif
if !hasmapto(':ColorVwordgenerate Square<CR>')
  silent! nmap <unique> <silent> <Leader>cgq :ColorVwordgen Square<CR>
endif
if !hasmapto(':ColorVwordgenerate Neutral<CR>')
  silent! nmap <unique> <silent> <Leader>cgn :ColorVwordgen Neutral<CR>
endif
if !hasmapto(':ColorVwordgenerate Clash<CR>')
  silent! nmap <unique> <silent> <Leader>cgc :ColorVwordgen Clash<CR>
endif

if !hasmapto(':ColorVwordgenerate Split-Complementary<CR>')
  silent! nmap <unique> <silent> <Leader>cgp :ColorVwordgen Split-Complementary<CR>
endif
if !hasmapto(':ColorVwordgenerate Monochromatic<CR>')
  silent! nmap <unique> <silent> <Leader>cgm :ColorVwordgen Monochromatic<CR>
  silent! nmap <unique> <silent> <Leader>cg1 :ColorVwordgen Monochromatic<CR>
endif
if !hasmapto(':ColorVwordgenerate Complementary<CR>')
  silent! nmap <unique> <silent> <Leader>cg2 :ColorVwordgen Complementary<CR>
endif
if !hasmapto(':ColorVwordgenerate Triadic<CR>')
  silent! nmap <unique> <silent> <Leader>cgt :ColorVwordgen Triadic<CR>
  silent! nmap <unique> <silent> <Leader>cg3 :ColorVwordgen Triadic<CR>
endif
if !hasmapto(':ColorVwordgenerate Tetradic<CR>')
  silent! nmap <unique> <silent> <Leader>cg4 :ColorVwordgen Tetradic<CR>
endif
if !hasmapto(':ColorVwordgenerate Five-Tone<CR>')
  silent! nmap <unique> <silent> <Leader>cg5 :ColorVwordgen Five-Tone<CR>
endif
if !hasmapto(':ColorVwordgenerate Six-Tone<CR>')
  silent! nmap <unique> <silent> <Leader>cg6 :ColorVwordgen Six-Tone<CR>
endif
if !hasmapto(':ColorVpreview<CR>')
  silent! nmap <unique> <silent> <Leader>cpp :ColorVpreview<CR>
endif
if !hasmapto(':ColorVpreviewline<CR>')
  silent! nmap <unique> <silent> <Leader>cpl :ColorVpreviewline<CR>
endif
if !hasmapto(':ColorVpreviewblock<CR>')
  silent! nmap <unique> <silent> <Leader>cpb :ColorVpreviewblock<CR>
endif
if !hasmapto(':ColorVpreviewclear<CR>')
  silent! nmap <unique> <silent> <Leader>cpc :ColorVclear<CR>
endif
let &cpo = s:save_cpo
unlet s:save_cpo
