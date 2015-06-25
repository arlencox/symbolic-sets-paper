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
	symbolic-sets.tex
symbolic-sets.pdf: $(SRC)
	pdflatex symbolic-sets.tex && \
	pdflatex symbolic-sets.tex && \
	pdflatex symbolic-sets.tex
