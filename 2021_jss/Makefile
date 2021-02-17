default: article.pdf

index.pdf: article.pdf
	cp $^ $@

sfiles := $(wildcard *.Rnw)
article.pdf: article.Rnw $(sfiles) config.yaml
	Rscript -e "Sweave('$<')"
	latexmk -pdf article
