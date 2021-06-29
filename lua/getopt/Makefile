SHELL=/bin/bash	
CC=gcc

.PHONY: all
all: getopt.so

getopt.so: getopt.o
	$(CC) -shared getopt.o -o getopt.so

getopt.o: getopt.c
	$(CC) -c getopt.c -fpic

.PHONY: clean
clean:
	rm getopt.so getopt.o
