##INTRO:##
**ColorV** is a color tool for Vim.

Have a look at it.

* ColorV window
    * Normal          http://flic.kr/p/9Vh7ES
    * Mini            http://flic.kr/p/9Vh7P1
* Colorname List window 
    * colorname list  http://flic.kr/p/9Vh7xG
* Generated List window
    * Analogous       http://flic.kr/p/9Vh4Nh
    * Monochromatic   http://flic.kr/p/9Vh8zj
* Preview color text in file
    * preview css     http://flic.kr/p/9VehHD
    * preview vim     http://flic.kr/p/9VehUi

Have a try of it. 
Install it first. See details with |colorv-install|.

Open ColorV window.  `<leader>cv`

Open color name list window. `<leader>cl`

Open ColorV window by word under cursor.

    #ff9744 rgb(33,44,155) orangered  'cadetblue'

put cursor on above words. `<leader>cw`

Change the word under cursor with chosing color after quit the ColorV window.
`<leader>cgg`

Generate Analogous color scheme with cursor word `<leader>cgea`
See details in |colorv-generate|

Copy the color in the ColorV window.  `yy`

Use GTK eyedropper to pick colors in screen.  `<leader>cd`
('+python' compiled and pygtk2.0 included.)


There are several configs and commands to define ColorV. 
See details in help docs.  `:h colorv`

If useful, please rate it
    http://www.vim.org/scripts/script.php?script_id=3597

If have any advice, patches or bug reports.
Submit at github 
    https://github.com/rykka/colorv

##VERSION:##
- NEW! 2.0.2  Preview Color in files or in line
- NEW! 2.0.1  Generate color scheme (Analogous/Monochromatic/...)
- NEW! 2.0.0  Color Name list window

##INSTALL:##
    
- Using vim.org: 
    http://www.vim.org/scripts/script.php?script_id=3597

Download the latest version of tar.gz file, extract it into your VIMFILE folder.("~/.vim" for linux. "$HOME/vimfiles" for windows)

Then use help tag to generate tags.

    :helptags ~/.vim/doc

- Using git:

open terminal and input

    git clone git://github.com/rykka/ColorV.git ~/.vim/bundle/ColorV

then add &runtimepath to your vimrc; then run helptags
(NOT necessary if pathogen.vim installed) 

    set rtp+=~/.vim/bundle/ColorV/
    :helptags ~/.vim/bundle/ColorV/doc

- Using Vundle:

Install git and script [Vundle.vim](https://github.com/gmarik/vundle)
then put this line in your vimrc

    Bundle 'rykka/colorv'

and use this to install it.

    :BundleInstall

##VIMRC EXAMPLE##
    
    "dynamic hue
    "let g:ColorV_dynamic_hue=1
    "let g:ColorV_dynamic_hue_step=9

    "Keep It Simple and Silent
    let g:ColorV_show_tips=0
    "let g:ColorV_echo_tips=1
    let g:ColorV_show_star=1
    let g:ColorV_word_mini=1
    let g:ColorV_silent_set=1
    
    "copy to "+ each time set colors
    "let g:ColorV_set_register=2
    "colorname approximate ratio
    "let g:ColorV_name_approx=10
