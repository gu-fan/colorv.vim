##INTRO:##

**ColorV** is a vim plugin for dealing with colors.
 
With this you can:

        Choose colors 
        Get color infos
        Edit color-texts
        Generate color lists
        Preview color-texts in buffers
        ...
        
        (color-text: e.g.,yellow/rgb(255,255,0)/#ff3300)

**Take a glance:** ![Take a glance](http://i55.tinypic.com/2jg7yu0.jpg)

**in Terminal:** ![Terminal](http://i56.tinypic.com/kb4tch.png)

    
###A Quick Start###

* Open ColorV window to select colors. 

        <leader>c1/cm   min mode:Less Space.
        <leader>c2      mid mode:Normal.
        <leader>c3/cx   max mode:More Info.
        <leader>cv      ColorV with previous mode.

  **NOTE** 

>       <leader> is a key can change in vimrc. Default is "\".
>       Mappings may not exist if it has been used by other plugins.
>       Then you should redefine it in your vimrc.

* Choose a color in ColorV window.

        Move the cursor around in the pallette. press <Enter>
        The color will changed to the color you choose.

* Edit Hue property of the color.

        Move cursor to the property 'H: 50'. press <Enter>.
        Input a number. The color will change by your input.

* Get W3C standard colornames list.
 
        <leader>cl
        This will open a name list window that showing the colornames.

* Open ColorV window with color-text under cursor to get it's info.

        <leader>cw

        Color-Text: #ff9744 rgb(33,44,155) OrangeRed 'cadetblue'

        Put your cursor on the word 'rgb(33,44,155)' and press <leader>cw.
        ColorV is opend with it's color.

* Easily change color-text under cursor with choosing color.
 
        <leader>ce

        Put your cursor on the word 'rgb(33,44,155)' and press <leader>ce.
        Then choose a color and Close the window by pressing "q". 
        You will see the word is changed with the choosed color.
        Also you can try with 'cadetblue' 'hsl(50,30%,47%)'...

* Generate 'Monochromatic' (and more) colorscheme List with color-text.
 
        <leader>cg1 or g1 in ColorV window

* Copy the color in the ColorV window directly.

        cc/<Ctrl-C>/yy

* Paste a color-text to the ColorV window to get it's info.

        p/<Ctrl-V>

* Preview all color-text in current file with highlighting in it's color.

        <leader>cpp

* Use pyGTK colorpicker to pick colors on screen easily.
 
        <leader>cd
        (with '+python' compiled and pygtk2.0 included)

###NEWS IN 2.5:###
+ **Faster**

>       Core function optimized and rewrited with python.
>       10+ times Faster than previous version.
>       (Normal mode:GUI runtime <0.06s, TERM runtime <0.10s)

+ **New Mode**

>       Max mode ('<leader>cx') added, and show more infos(RGB/HSV/HLS/YIQ).
>       With copied color history, which tracks color copied from ColorV.

+ **New Space**

>       'HLS' added for choosing colors in HLS colorspace.
>       Use it by set "g:ColorV_win_space" to "hls"
 
+ **With Term**

>       Now ColorV works under Terminal(both 8/16/256 colors).   
>       Set your '&t_Co' option (Default:8), if it supports more colors.
 
+ New in 2.5.1 : Auto preview css files.(g:ColorV_prev_css)
+ New in 2.5.2 : Fix some bugs in mac/windows/terminal.

##INSTALL:##
    
  * Using [Vundle.vim](https://github.com/gmarik/vundle) (Recommend): 
  
>   After git and vundle installed. 
 
>   Add this line to your vimrc  
>   `Bundle 'Rykka/ColorV'` 

>   Install it by 
>   `:BundleInstall`

>   And Update it simply by
>   `:BundleInstall!`

  * Using [ColorV on Vim.org](http://www.vim.org/scripts/script.php?script_id=3597) 

>  Download the latest version of tar.gz file, 

>  Extract to $VIMFILE folder. ("~/.vim" for linux. "$HOME/vimfiles" for windows)

>  Generate helptags. `:helptags ~/.vim/doc`
 
  **NOTE**  

>       You can always get the latest version at
>       https://github.com/Rykka/ColorV
>       And you can report bugs and suggestions at
>       https://github.com/Rykka/ColorV/issues
 
###VIMRC EXAMPLE###


```vim
"remap the ColorVchange command 
nmap <silent> <leader>cr :ColorVchange<CR>

"use HLS colorspace instead of HSV
let g:ColorV_win_space="hls"  
"use YIQ colorspace for generating color list
let g:ColorV_gen_space="yiq" 
"Stop coloring colornames like 'Black','Navy','white'
let g:ColorV_view_name=0
```
