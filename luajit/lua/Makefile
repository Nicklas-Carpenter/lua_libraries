SHELL=/bin/sh
CC=gcc

.PHONY: all
all: introspection.so

introspection.so: introspection.o
	gcc -shared introspection.o -o introspection.so

introspection.o: introspection.c
	gcc -c introspection.c -fpic
