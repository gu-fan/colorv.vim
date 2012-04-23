#include <gtk/gtk.h>
#include <ctype.h>

void sel_color(gint r,gint g,gint b) {
    GtkWidget *colorseldlg;
    GtkColorSelection *colorsel;
    GdkColor color;
    gint response;

    color.red   = r * 256;
    color.green = g * 256;
    color.blue  = b * 256;

    colorseldlg = gtk_color_selection_dialog_new("[ColorV]colorpicker");
    colorsel = GTK_COLOR_SELECTION(
                gtk_color_selection_dialog_get_color_selection(
                GTK_COLOR_SELECTION_DIALOG(colorseldlg)));
    gtk_color_selection_set_current_color(colorsel, &color);
    gtk_color_selection_set_has_palette(colorsel, TRUE);
    gtk_color_selection_set_has_opacity_control(colorsel, TRUE);
    gtk_window_set_position(GTK_WINDOW(colorseldlg), GTK_WIN_POS_CENTER);
    gtk_window_set_keep_above(GTK_WINDOW(colorseldlg), TRUE);

    response = gtk_dialog_run(GTK_DIALOG(colorseldlg));
    if(response == GTK_RESPONSE_OK){
        gtk_color_selection_get_current_color(colorsel, &color);
        r = color.red   / 256;
        g = color.green / 256;
        b = color.blue  / 256;
        printf("%02x%02x%02x", r, g, b);
    }
}

gint main(gint argc, gchar * argv[]){
    gint r, g, b;

    if (argc==2) {
        for(r=0; r<6; r++){
            if(!isxdigit(argv[1][r])){
                return 2;
            }
        }
        sscanf(argv[1], "%2x%2x%2x", &r, &g, &b);
        gtk_init(&argc, &argv);
        sel_color(r,g,b);
        return 0;
    }
    return 2;

}
