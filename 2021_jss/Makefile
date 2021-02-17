default: index.pdf

index.pdf: article.pdf
	cp $^ $@

sfiles := $(wildcard *.Rnw)

article: article.pdf
article.pdf: article.Rnw $(sfiles) config.yaml
	Rscript -e "Sweave('$<')"
	latexmk -pdf article
