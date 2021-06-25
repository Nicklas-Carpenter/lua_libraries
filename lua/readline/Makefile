SHELL=/bin/sh
CC=gcc

.PHONY: all
all: lua_readline.so

lua_readline.so: lua_readline.o
	gcc -shared lua_readline.o -o lua_readline.so

lua_readline.o: lua_readline.c
	gcc -c lua_readline.c -fpic
