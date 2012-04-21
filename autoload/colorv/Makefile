NAME=colorpicker
CFLAGS=-g -Wall -o $(NAME)
GTKFLAGS=-export-dynamic `pkg-config --cflags --libs gtk+-2.0`
SRCS=colorpicker.c
CC=gcc
 
# top-level rule to create the program.
all: main
 
# compiling the source file.
main: $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) $(GTKFLAGS)

clean:
	/bin/rm -f colorpicker
