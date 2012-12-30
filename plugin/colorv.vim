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
command! -nargs=?  ColorVInsert      call colorv#insert_text(<q-args>)
command! -nargs=0  ColorVEdit        call colorv#cursor_text("edit")
command! -nargs=0  ColorVEditAll     call colorv#cursor_text("editAll")
command! -nargs=1  ColorVEditTo      call colorv#cursor_text("changeTo",<q-args>)

command! -nargs=0  ColorVName        call colorv#list_win()
command! -nargs=+  ColorVList        call colorv#cursor_text("list",<f-args>)
command! -nargs=*  ColorVTurn2       call colorv#list_win2(<f-args>)

command! -nargs=0  ColorVAutoPreview   call colorv#prev_aug()
command! -nargs=0  ColorVNoAutoPreview call colorv#prev_no_aug()

command! -nargs=0  ColorVPreview     call colorv#preview("c")
command! -nargs=0  ColorVPreviewArea call colorv#preview("bc")
command! -nargs=0  ColorVPreviewLine call colorv#preview_line()
command! -nargs=0  ColorVClear       call colorv#clear_all()

command! -nargs=0  ColorVPicker     call colorv#picker()

command! -nargs=?  ColorVScheme     call colorv#scheme#win(<q-args>)
command! -nargs=0  ColorVSchemeFav  call colorv#scheme#show_fav()
command! -nargs=?  ColorVSchemeNew  call colorv#scheme#new(<args>)

call colorv#default("g:colorv_no_global_map",0)
call colorv#default("g:colorv_global_leader",'<leader>c')

call colorv#define_global()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
