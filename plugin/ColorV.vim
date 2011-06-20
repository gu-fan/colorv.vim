"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: plugin/ColorV.vim
" Summary: A Color Viewer and Color Picker for Vim
"  Author: Rykka.Krin <rykka.krin@gmail.com>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if !has("gui_running") || v:version < 700
    finish
endif

command! -nargs=*  ColorV call ColorV#Win("",<q-args>)
command! -nargs=*  ColorVnorm call ColorV#Win("",<q-args>)
command! -nargs=*  ColorVmini call ColorV#Win("min",<q-args>)
command! -nargs=0  ColorVword call ColorV#open_word()
command! -nargs=0  ColorVchange call ColorV#change_word()
command! -nargs=0  ColorVchangeAll call ColorV#change_word("all")
command! -nargs=0  ColorVclear call ColorV#clear_all()
command! -nargs=1  ColorVchange2 call ColorV#change_word("",<q-args>)
command! -nargs=0  ColorVquit call ColorV#exit()
command! -nargs=0  ColorVlist call ColorV#list_win()
command! -nargs=+  ColorVgenerate call ColorV#gen_win(<f-args>)
command! -nargs=+  ColorVwordgen call ColorV#cursor_gen(<f-args>)
command! -nargs=0  ColorVpreview call ColorV#preview()
command! -nargs=0  ColorVpreviewline call ColorV#preview_line()

if has('python')
command! -nargs=0  ColorVdropper call ColorV#Dropper()
endif

if !hasmapto(':ColorV<CR>')
  silent! nmap <unique> <silent> <Leader>cv :ColorV<CR>
endif

if !hasmapto(':ColorVmini<CR>')
  silent! nmap <unique> <silent> <Leader>cm :ColorVmini<CR>
endif

if !hasmapto(':ColorVword<CR>')
  silent! nmap <unique> <silent> <Leader>cww :ColorVword<CR>
endif

if !hasmapto(':ColorVchange<CR>')
  silent! nmap <unique> <silent> <Leader>cgg :ColorVchange<CR>
endif

if !hasmapto(':ColorVchangeALl<CR>')
  silent! nmap <unique> <silent> <Leader>cga :ColorVchangeAll<CR>
endif

if !hasmapto(':ColorVchange2 HEX<CR>')
  silent! nmap <unique> <silent> <Leader>c2x :ColorVchange2 HEX<CR>
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
endif

if !hasmapto(':ColorVdropper<CR>') && has('python')
  silent! nmap <unique> <silent> <Leader>cd :ColorVdropper<CR>
endif
if !hasmapto(':ColorVquit<CR>') && has('python')
  silent! nmap <unique> <silent> <Leader>cq :ColorVquit<CR>
endif

if !hasmapto(':ColorVlist<CR>')
  silent! nmap <unique> <silent> <Leader>cl :ColorVlist<CR>
endif

if !hasmapto(':ColorVwordgenerate Hue<CR>')
  silent! nmap <unique> <silent> <Leader>cwgh :ColorVwordgen Hue<CR>
endif
if !hasmapto(':ColorVwordgenerate Saturation<CR>')
  silent! nmap <unique> <silent> <Leader>cwgs :ColorVwordgen Saturation<CR>
endif
if !hasmapto(':ColorVwordgenerate Value<CR>')
  silent! nmap <unique> <silent> <Leader>cwgv :ColorVwordgen Value<CR>
endif

if !hasmapto(':ColorVwordgenerate Analogous<CR>')
  silent! nmap <unique> <silent> <Leader>cwga :ColorVwordgen Analogous<CR>
endif
if !hasmapto(':ColorVwordgenerate Monochromatic<CR>')
  silent! nmap <unique> <silent> <Leader>cwgm :ColorVwordgen Monochromatic<CR>
endif
if !hasmapto(':ColorVwordgenerate Rectangle<CR>')
  silent! nmap <unique> <silent> <Leader>cwgr :ColorVwordgen Rectangle<CR>
endif
if !hasmapto(':ColorVwordgenerate Neutral<CR>')
  silent! nmap <unique> <silent> <Leader>cwgn :ColorVwordgen Neutral<CR>
endif
if !hasmapto(':ColorVwordgenerate Clash<CR>')
  silent! nmap <unique> <silent> <Leader>cwgc :ColorVwordgen Clash<CR>
endif

if !hasmapto(':ColorVwordgenerate Split-Complementary<CR>')
  silent! nmap <unique> <silent> <Leader>cwgp :ColorVwordgen Split-Complementary<CR>
endif
if !hasmapto(':ColorVwordgenerate Complementary<CR>')
  silent! nmap <unique> <silent> <Leader>cwg2 :ColorVwordgen Complementary<CR>
endif
if !hasmapto(':ColorVwordgenerate Triadic<CR>')
  silent! nmap <unique> <silent> <Leader>cwgt :ColorVwordgen Triadic<CR>
  silent! nmap <unique> <silent> <Leader>cwg3 :ColorVwordgen Triadic<CR>
endif
if !hasmapto(':ColorVwordgenerate Tetradic<CR>')
  silent! nmap <unique> <silent> <Leader>cwg4 :ColorVwordgen Tetradic<CR>
endif
if !hasmapto(':ColorVwordgenerate Five-Tone<CR>')
  silent! nmap <unique> <silent> <Leader>cwg5 :ColorVwordgen Five-Tone<CR>
endif
if !hasmapto(':ColorVwordgenerate Six-Tone<CR>')
  silent! nmap <unique> <silent> <Leader>cwg6 :ColorVwordgen Six-Tone<CR>
endif

if !hasmapto(':ColorVpreview<CR>')
  silent! nmap <unique> <silent> <Leader>cpp :ColorVpreview<CR>
endif
if !hasmapto(':ColorVpreviewline<CR>')
  silent! nmap <unique> <silent> <Leader>cpl :ColorVpreviewline<CR>
endif

let &cpo = s:save_cpo
unlet s:save_cpo
