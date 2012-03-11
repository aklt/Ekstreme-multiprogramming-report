
REPORT=report
LATEX=latex
RM=rm -fv

FIGS=$(wildcard *.fig)
EPS=$(patsubst %.fig,%.eps,$(FIGS))
TMP=$(EPS) $(REPORT).tex 

.PHONY: dvi pdf clean distclean

dvi: $(REPORT).dvi
	xdvi $<

pdf: $(REPORT).pdf
	gpdf $<

$(REPORT).pdf: $(REPORT).dvi
	dvipdf $< $@

$(REPORT).dvi: $(TMP) $(REPORT)-header.tex bibliography.bib makefile
	$(LATEX) $(REPORT)
	bibtex $(REPORT)
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)
	rm $(REPORT).tex

%.tex: %.tex.m4
	m4 $< > $@

%.occ.num: ../kroc/%.occ
	nl $< > $@

%.eps: %.fig
	fig2dev -L eps $< $@

distclean: ALWAYS
	@$(RM) *.dvi *.aux *.bbl *.blg *.log *.bak *.toc  $(REPORT).dvi $(TMP)

clean: distclean
	@$(RM) $(REPORT).pdf

ALWAYS:

