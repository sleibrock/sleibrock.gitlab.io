# Website makefile

BIN=racket
MAIN=Builder.rkt

build:
	$(BIN) $(MAIN) build

clean:
	$(BIN) $(MAIN) clean
