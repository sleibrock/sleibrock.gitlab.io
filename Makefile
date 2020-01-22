# Website makefile

BIN=racket
MAIN=Builder2.rkt

build:
	$(BIN) $(MAIN) build

prod:
	$(BIN) $(MAIN) --prod build

clean:
	$(BIN) $(MAIN) clean
