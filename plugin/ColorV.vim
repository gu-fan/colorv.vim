"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Script: ColorV 
"    File: plugin/ColorV.vim
" Summary: A color manager with color toolkits
"  Author: Rykka.Krin <rykka.krin@gmail.com>
"    Home: 
" Version: 1.1.8.0 
" Last Update: 2011-05-24
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim
if !has("gui_running")
    " "GUI MODE ONLY"
    finish
endif
if v:version < 700
    finish
endif

let g:ColorV={}
let g:ColorV.ver="1.1.8.0"
let g:ColorV.name="[ColorV]"
let g:ColorV.HEX="ff0000"
let g:ColorV.RGB={}
let g:ColorV.HSV={}
let g:ColorV.rgb=[]
let g:ColorV.hsv=[]

if !exists('g:ColorV_silent_set')
    let g:ColorV_silent_set=1
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
    let g:ColorV_show_tips=2
endif
if !exists('g:ColorV_show_quit')
    let g:ColorV_show_quit=0
endif
if !exists('g:ColorV_show_star')
    let g:ColorV_show_star=1
endif
if !exists('g:ColorV_word_mini')
    let g:ColorV_word_mini=1
endif
command! -nargs=*  ColorV call ColorV#Win("",<q-args>)
command! -nargs=*  ColorVnorm call ColorV#Win("",<q-args>)
command! -nargs=*  ColorVmini call ColorV#Win("mini",<q-args>)
command! -nargs=0  ColorVword call ColorV#open_word()
command! -nargs=0  ColorVchange call ColorV#change()
command! -nargs=0  ColorVchangeAll call ColorV#change("","all")
command! -nargs=0  ColorVclear call ColorV#clear_all()
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
  silent! nmap <unique> <silent> <Leader>cw :ColorVword<CR>
endif

if !hasmapto(':ColorVchange<CR>')
  silent! nmap <unique> <silent> <Leader>cg :ColorVchange<CR>
endif

if !hasmapto(':ColorVchangeALl<CR>')
  silent! nmap <unique> <silent> <Leader>ca :ColorVchangeAll<CR>
endif

if !hasmapto(':ColorVdropper<CR>') && has('python')
  silent! nmap <unique> <silent> <Leader>cd :ColorVdropper<CR>
endif
let &cpo = s:save_cpo
unlet s:save_cpo
