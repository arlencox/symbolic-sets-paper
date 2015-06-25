#------------------------------------------------------------------------
# Main target
#------------------------------------------------------------------------
all: symbolic-sets.pdf

# Add pictures here
PIC=    
SRC=	llncs.cls \
	macros.tex \
	intro.tex \
	overview.tex \
	logic.tex \
	symbolic-sets.bib \
	symbolic-sets.tex
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
