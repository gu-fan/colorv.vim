
#INTRO:#
>  **ColorV** is a color tool for Vim.
 
>  With this you can deal with colors easily.
    
>  **A Quick Start**

>  * Open ColorV window to select colors. 

        <leader>cv   Normal Win.
        <leader>cm   min mode:Less Space.
        <leader>cx   max mode:More Info.
        

>  * Open colorname list window, where you can get W3C standard colornames.
 
        <leader>cl

>  * Open ColorV window by word under cursor, to see the color visually.

        <leader>cw
        #ff9744 rgb(33,44,155) orangered 'cadetblue'
        Put your cursor on the word 'rgb(33,44,155)' and press <leader>cw.
        You will see a ColorV is opend with the color of it.

>  * Easily change word under cursor with visually chosing color.
 
        <leader>cgg
        Put your cursor on the word 'orangered' and press <leader>cgg.
        After chosing a color (e.g. yellow),
        close the window by pressing "q". 
        You will see the word is changed to 'Yellow'.
        And you can try with 'rgb(33,44,155)' 'hsl(50,30%,47%)' .

>  * Generate 'Monochromatic' colorscheme List (and more) with cursor.
 
        <leader>cnm

>  *  Copy the color in the ColorV window quickly.

        cc/<Ctrl-C>/yy

>  * Paste a color text to the ColorV window to have a visual look.

        p/<Ctrl-V>

>  * Use GTK eyedropper to pick colors on screen easily.
 
        <leader>cd
        (with '+python' compiled and pygtk2.0 included)

##NEW IN 2.5:##
- Rewrite core function in python. 10 times faster.
- ColorV Win with HLS colorspace(`g:ColorV_win_space="hls"`).
- Max mode(`<leader>cx`).
- History cache and pallette(in Max mode).
- Terminal supported.
- YIQ calculator added.

> **NOTE** 
 
>   You'd better delete your previous ColorV files .
 
>   because the file name have changed to 'colorv.vim'
 
#INSTALL:#
    
  * Using Vundle (Recommend): 
  
>  Install git and script [Vundle.vim](https://github.com/gmarik/vundle)

>  then put this line in your vimrc  

>       Bundle 'Rykka/colorv' 

>  and use this command to install it.  

>       :BundleInstall 

  * Using vim.org: 

>  http://www.vim.org/scripts/script.php?script_id=3597

>  Download the latest version of tar.gz file, 

>  extract it into your VIMFILE folder.

>  ("~/.vim" for linux. "$HOME/vimfiles" for windows)

>  Then use help tag to generate tags.

>       :helptags ~/.vim/doc     

  * Using git: 

>  open terminal go and input.
  
>        git clone git://github.com/Rykka/ColorV.git ~/.vim/bundle/ColorV 

>  then add the folder to &runtimepath in your vimrc;

>  (NOT necessary if pathogen.vim installed) 

>        set rtp+=~/.vim/bundle/ColorV/ 

>  Then run helptags.

>        :helptags ~/.vim/bundle/ColorV/doc  

##VIMRC EXAMPLE##
    
    "remap the ColorVchange command 
    nmap <silent> <leader>ce :ColorVchange<CR>

    "use HLS colorspace instead of HSV
    let g:ColorV_win_space="hls"  
    "use YIQ colorspace for generating color list
    let g:ColorV_gen_space="yiq" 
    "Stop coloring colornames 'black/white'
    let g:ColorV_view_name=0
