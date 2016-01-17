LECTURES := $(wildcard *.org)
PROBLEMS := $(wildcard problems_*.tex)

ERLC      = @echo "  ERLC\t$<"; /usr/local/bin/erlc
PDFLATEX  = @echo "  PDFLATEX\t$<"; /Library/TeX/texbin/pdflatex

all: lectures problems	

lecture_%.pdf: %.org
	../src/make_slides $<

lectures: ${LECTURES:%.org=lecture_%.pdf}

problems: ${PROBLEMS:%.tex=%.pdf}

problems_%.pdf: problems_%.tex
	/Library/TeX/texbin/pdflatex $<
	/Library/TeX/texbin/pdflatex $<
	rm -rf *.toc *.log *.aux

clean:
	rm -rf *.pdf *.toc *.log *.beam *.aux


