default: index.pdf

index.pdf: article.pdf
	cp $^ $@

sfiles := $(wildcard *.Rnw)

article: article.pdf
article.pdf: article.Rnw $(sfiles) config.yaml ../references.bib
	Rscript -e "Sweave('$<')"
	latexmk -pdf article
