default: index.pdf

files := $(wildcard *.Rmd)
index.pdf: index.Rnw $(files)
	Rscript build.R
