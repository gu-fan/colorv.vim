##INTRO:##

**ColorV** is a vim plugin tries to make colors handling easier.
   
    For example:
    When editing text like '#9370D8' or 'LightSlateGray' or 'rgb(216,112,147)'
    We want to view it's actual color, and pick the actual color we want.

    ColorV helps you doing this.

    Press '<leader>ce'(':ColorVEdit') in 'LightSlateGray',
    this will open ColorV window showing the text's color.
    And after picking a color and close the window,
    The text will be changed to your picked color.

    Features:
    View, Edit, Preview, Generate, Pick, Cache ... Colors and more.

    Screenshot: http://img.ly/gC9p
![Screenshot](http://s3.amazonaws.com/imgly_production/3959903/large.png)

Post issues at https://github.com/Rykka/colorv.vim/issues 

##INSTALL:##

1. Using Vundle  https://github.com/gmarik/vundle 

    Add this Line to your vimrc
    `Bundle 'Rykka/colorv.vim'` 

2. Using vim.org http://www.vim.org/scripts/script.php?script_id=3597

    Extract to your ~/.vim folder.
    `:helptags ~/.vim/doc`
    
**NOTE**   Get Latest version
           https://github.com/Rykka/colorv.vim/
