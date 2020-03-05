%.pdf:	%.tex
	pdflatex $*
	while ( grep "Rerun to get cross-references" $*.log > /dev/null ); do \
		echo '** Re-running LaTeX **'; \
		pdflatex --interaction errorstopmode $*; \
	done
	bibtex $*
	pdflatex $*
	while ( grep "Rerun to get cross-references" $*.log > /dev/null ); do \
		echo '** Re-running LaTeX **'; \
		pdflatex --interaction errorstopmode $*; \
	done

%.pdf: %.fig
	@echo -e "\e[92mCompiling $*.fig\e[0m"
	fig2dev -L pdftex $*.fig > /tmp/$*.pdf
	fig2dev -L pdftex_t -f sf -p /tmp/$*.pdf $< > /tmp/$*.tex
	pdflatex  -halt-on-error -output-directory /tmp -jobname $*_raw << EOF \
\\documentclass[portrait,a0,final]{a0poster} \
\\usepackage{epsfig} \
\\usepackage{amsmath} \
\\usepackage{amssymb} \
\\usepackage{color} \
\\begin{document} \
\\sffamily \
\\def\\normalfont{\\sffamily} \
\\renewcommand{\\familydefault}{cmss} \
\\pagestyle{empty} \
\\thispagestyle{empty} \
\\input{/tmp/$*} \
\\end{document} \
EOF > /tmp/$*_raw.log
	pdfcrop /tmp/$*_raw.pdf /tmp/$*_crop.pdf >> /tmp/$*_raw.log
	mv /tmp/$*_crop.pdf $*.pdf

default: $(PDFs)

clean:
	rm -f $(PDFs) *.aux *.log *.bbl *.blg *.out
