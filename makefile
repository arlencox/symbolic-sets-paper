#------------------------------------------------------------------------
# Main target
#------------------------------------------------------------------------
all: symbolic-sets.pdf

# Macros, templates sources, bibliography
MACROS= llncs.cls \
	macros.tex \
	symbolic-sets.bib
# Pictures (order of appearance in the paper)
TIKZ=	tkz-hoo-conc.tex \
	tkz-hoo-abs.tex \
	tkz-memcad-conc.tex \
	tkz-memcad-abs.tex
# Chapters (in order) and main file
BODY=	abstract.tex \
	intro.tex \
	overview.tex \
	logic.tex \
	constructed.tex \
	solvers.tex \
	evaluation.tex \
	symbolic-sets.tex
SRC= $(MACROS) $(TIKZ) $(BODY)
symbolic-sets.pdf: $(SRC)
	pdflatex symbolic-sets.tex && \
	bibtex   symbolic-sets     && \
	pdflatex symbolic-sets.tex && \
	pdflatex symbolic-sets.tex

#------------------------------------------------------------------------
# Auxilliary targets
#------------------------------------------------------------------------
.PHONY: clean edit wc wca lab todo todos check
clean:
	rm -f *.ps *.dvi *.pdf *~ *.eps \#* *.swp *.log *.aux *.out && \
	rm -f *.bbl *.blg *.toc *.bb
wc:
	wc $(SRC)
