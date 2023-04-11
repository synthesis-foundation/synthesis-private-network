.PHONY: all

all: util synthesis-brute-multi-curve25519 synthesis-brute-multi-ed25519

util: util.c
	gcc -Wall -std=c89 -O3 -c -o util.o util.c

synthesis-brute-multi-ed25519: synthesis-brute-multi-ed25519.c util.o
	gcc -Wall -std=c89 -O3 -o synthesis-brute-multi-ed25519 -lsodium synthesis-brute-multi-ed25519.c util.o

synthesis-brute-multi-curve25519: synthesis-brute-multi-curve25519.c util.o
	gcc -Wall -std=c89 -O3 -o synthesis-brute-multi-curve25519 -lsodium synthesis-brute-multi-curve25519.c util.o
