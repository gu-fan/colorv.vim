#!/usr/bin/env python2

from __future__ import print_function
if __name__ == "__main__":
    import sys
    if len(sys.argv)==2:
        try:
            import gtk
            import pygtk
            pygtk.require('2.0')
        except ImportError:
            print("python gtk module import error")
            sys.exit(2)

        if gtk:
            cdlg = gtk.ColorSelectionDialog("[ColorV] Python colorpicker")
            c_set = gtk.gdk.color_parse("#"+sys.argv[1])
            cdlg.colorsel.set_current_color(c_set)
            cdlg.colorsel.set_has_palette(True)
            cdlg.colorsel.set_has_opacity_control(True)
            cdlg.set_position(gtk.WIN_POS_CENTER)

            if cdlg.run() == gtk.RESPONSE_OK:
                clr = cdlg.colorsel.get_current_color()
                r,g,b = map(lambda x: 0 if x < 0 else 255 if x > 255 else x,
                        map(lambda x: int(round(float(x))),
                        [clr.red/257,clr.green/257,clr.blue/257]))
                c_hex = '%02X%02X%02X' % (r,g,b)
                print(c_hex,end='')

            cdlg.destroy()
