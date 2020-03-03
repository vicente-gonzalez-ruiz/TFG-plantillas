%.pdf:	%.tex
	pdflatex $*
	while ( grep "Rerun to get cross-references" $*.log > /dev/null ); do		\
		echo '** Re-running LaTeX **';						\
		pdflatex --interaction errorstopmode $*;				\
	done
	bibtex $*
	pdflatex $*
	while ( grep "Rerun to get cross-references" $*.log > /dev/null ); do		\
		echo '** Re-running LaTeX **';						\
		pdflatex --interaction errorstopmode $*;				\
	done
