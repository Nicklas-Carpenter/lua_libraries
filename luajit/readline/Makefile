SHELL=/bin/bash
CC=gcc

.PHONY: all
all: readline_test

readline_test: test.o
	gcc test.o -lreadline -o readline_test

test.o: test.c
	gcc -c test.c
