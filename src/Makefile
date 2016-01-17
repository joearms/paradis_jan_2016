MODS := $(wildcard *.erl)

ERLC      = @echo "  ERLC\t$<"; /usr/local/bin/erlc

all: beams

beams: ${MODS:%.erl=%.beam}

%.beam: %.erl
	$(ERLC) -W $<

clean:
	rm -rf *.pdf *.toc *.log *.beam *.aux


