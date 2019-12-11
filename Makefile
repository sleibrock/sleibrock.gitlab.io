# Website makefile

BIN=racket
MAIN=Builder.rkt

build:
	$(BIN) $(MAIN) build

prod:
	$(BIN) $(MAIN) --prod build

clean:
	$(BIN) $(MAIN) clean
