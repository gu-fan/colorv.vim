#############################
ColorV: A Powerful color tool
#############################

:Author: Rykka G.F
:Update: 2013-04-21
:Version: 3.0.5
:Github: https://github.com/Rykka/colorv.vim
:Vim.org: http://www.vim.org/scripts/script.php?script_id=3597


Intro
=====

**ColorV** is a color view/pick/edit/design/scheme tool in vim.

It makes handling colors much easier.  

With it, you can:

View colors
    ``:ColorV`` (<leader>cv): show ColorV window

    ``:ColorVView`` (<leader>cw): show ColorV window with color text under cursor.

    ``:ColorVPreview`` (<leader>cpp): Preview colors in current buffer

Edit colors
    ``:ColorVEdit`` (<leader>ce): Edit color text under cursor

    ``:ColorVEditAll`` (<leader>cE): Edit color text under cursor and change all in current buffer.

    ``:ColorVInsert`` (<leader>cii): Insert color with ColorV window.

Design Colors
    ``:ColorVName`` (<leader>cn): show color name list window.

    ``:ColorVList Hue`` (<leader>cgh) generate Hue list with color text under cursor.

    ``:ColorVTurn2 {hex1} {hex2}`` (<leader>cgg) generate Hue list from hex1 to hex2.

    ``:ColorVPicker`` (<leader>cd): show a GUI color picker.

Design Schemes
    ``:ColorVScheme`` (<leader>css) Fetch scheme from Kuler or ColourLover

    ``:ColorVSchemeFav`` (<leader>csf) Show Faved schemes

    ``:ColorVSchemeNew`` (<leader>csn) Create a new scheme

And More
    You can even use it under 8/256 color terminal.

Get latest and Post issues at https://github.com/Rykka/colorv.vim

ScreenShot:

.. image:: http://i.minus.com/iF5Cd8D74Rfls.png

Install
-------
* Using Vundle_  (Recommended)

  Add this line to your vimrc::
 
    Bundle 'Rykka/colorv.vim'
    " needed for fetching schemes online.
    Bundle 'mattn/webapi-vim'

* Using downloaded zip/tar.gz file. 
  Just extract it to your ``.vim`` folder .

:NOTE: webapi.vim_ is needed for fetching schemes online.


:NOTE: Make sure ``filetype plugin on`` and ``syntax on`` is in your vimrc

* Related tools: 

  + vim: Galaxy_, generate colorschemes with colorv

Tutors
------

* Global:

  - ``ColorV`` (<leader>cv)
  - ``ColorVView`` (<leader>cw)
  - ``ColorVEdit`` (<leader>ce)
  - ``ColorVEditTo {fmt}`` (<leader>c2r...) fmt see  formats_
  - ``ColorVEditAll`` (<leader>cE)
  - ``ColorVInsert {fmt}`` (<leader>cii...)
  - ``ColorVList {gen}`` (<leader>cg2...) gen see generates_
  - ``ColorVTurn2 {hex1} {hex2}`` (<leader>cgg)
  - ``ColorVPreview`` (<leader>cpp)
  - ``ColorVPreviewLine`` (<leader>cpl)
  - ``ColorVClear`` (<leader>cpc)
  - ``ColorVScheme`` (<leader>css)
  - ``ColorVSchemeFav`` (<leader>csf)
  - ``ColorVSchemeNew`` (<leader>csn)
  - ``ColorVSchemeNew`` (<leader>csn)
  - ``ColorVPicker`` (<leader>cd)

* In ColorV window:

  - Double Click or Press <Enter> to trigger actions.

    1. Hue Line: change hue
    2. pallete: set current color
    3. Attrbuite: change attr of current color
    4. history pallete: previous 3 colors
    5. Tips: show tips or trigger relevant actions.
    6. Stats: change relevant setting.

  - ``<Tab>/<S-tab>`` will jump to next/prev input
  - ``+=/-_/scroll up/scroll down`` to change RGB/HSV attributes under cursor
  - ``yy/cc/p/yr/...`` to copy/paste colors
  - ``gg/g2/...`` to generate a list
  - ``ss/sf/...`` to trigger scheme actions
  - ``q`` to quit
  - ``?`` to show tips
  - Other actions, see ``:h colorv-mapping-buffer``
* In Color Scheme window:

  - ``n/N/p`` to navigate through multi schemes.
  - ``f/F`` to fav/Unfav schemes
  - ``e`` on a color to edit the color
  - ``K/C`` search item under cursor with Kuler/ColourLover
  - ``sn`` to create new scheme
  - ``q`` quit


* Detailed instructions: use ``:h colorv``
* Options: see ``:h colorv-options``

.. _formats:

  **Color Text Formats**::

      There are following formats currently:

      The KEY means the abbrevation key used in mapping
      
      KEY  NAME    EXAMPLE                       DESCRIPTION
           HEX     FF00FF 334455
           HEX3    #CFF #F11
      #/s  HEX#    #FF00FF #00FFFF 
      0/x  HEX0    0xFFFF00   0xEE3399
      n    NAME    red/lime/blue                 (|colorv-colorname|)
      r    RGB     rgb(255,55,15)                (css1 standard)
      ar   RGBA    rgba(205,25,255,1.0)          (css2 standard)
      l    HSL     hsl(50,90%,40%)               (css3 standard)
      al   HSLA    hsla(230,30%,50%,1.0)         (css3 standard)
           glRGBA  glColor4f(1.00,0.5,1.00,1.00) (openGL color format)
      pr   RGBP    rgb(30%, 98%, 98%)             
      ap   RGBAP   rgba(100%,40%,100%,1.0) 
      h    HSV     hsv(360,100,100)
      m    CMYK    cmyk(25,41, 0,46) 

      e.g.: <leader>cim  will insert a CMYK color text

.. _generates:


  **Color Generate Methods**::

    There are following type currently:

    The KEY means the abbrevation key used in mapping

    KEY  NAME                     DESCRIPTION
    h    Hue                      Hue 
    s    Saturation               Saturation
    v    Value                    Value/Lightness
    m    Monochromatic            Generate by S and V s/v+{step}
    a    Analogous                Generate colors h+15
    3    Triadic                  Generate 3 colors 
    4    Tetradic                 Generate 4 colors 
    n    Neutral                  Generate colors h+30
    c    Clash                    Generate 3 clash color 
    q    Square                   Generate 4 colors h+90
    5    Five-Tone                Generate 5 colors 
    6    Six-Tone                 Generate 6 colors 
    2    Complementary            Generate opposite color h+180
    p    Split-Complementary      Generate 2 opposite colors
    l    Luma                     Generate by Luma+{step} ('yiq' only)
    g    Turn-To                  Generate colorlist by history_0 and history_1

    e.g.: <leader>cg5  will generate a Five-Tone list

Todo and Done
-------------

TODO
~~~~

* 3.1: 
 
  - add upload, maybe a site to uplad to is needed.
  - ColorVTurn2 should use cursor color text if hex1 omitted.
  - DONE 2013-04-21 Add '<Tab>/<S-Tab>' for input jumping
  - DONE 2013-04-21 Add 0 value support for pallette and input

Done
~~~~

* bug fix:

  - fix #16 and #17: nnor for maps inside colorv.
  - fix #18: #888888 term code should be 102

* 3.0.2:

  - add back_buf for all win. 
  - add scheme fetch info. 
  - fix scheme nav arrow pos. 

* 3.0.1:

  - fix debug message: miss cache file.
  - fix scheme navigation with key.
  - update image.

* 3.0: 

  - add Scheme (fetch, fav, edit, new)
  - change cache behavior
  - auto preview edited color if in a preview buffer
  - back to last buffer if closed colorv
  - add ColorVInsert

  
Contribution
------------

Anyone willing to help can contact me, for now.

* The document and helpdoc need rewrite. 
* a tutor screencast is needed.

.. _Vundle: https://www.github.com/gmarik/vundle
.. _Galaxy: https://www.github.com/Rykka/galaxy.vim
.. _webapi.vim: https://github.com/mattn/webapi-vim 
