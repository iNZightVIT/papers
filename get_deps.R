ca <- commandArgs(TRUE)
files <- list.files(pattern = ".R[a-z]*", full.names = TRUE, recursive = TRUE)
files <- files[!grepl("jss-rnw", files)]
text <- suppressWarnings(do.call(c, sapply(files, readLines)))

if (!requireNamespace("stringr", quietly = TRUE))
    install.packages("stringr")

pkgs <- c(
    stringr::str_match(text, "library\\(\"?([a-zA-Z0-9]+)\"?\\)")[,2],
    stringr::str_match(text, "([a-zA-Z0-9]+)::")[,2]
)
pkgs <- unique(pkgs[!is.na(pkgs)])

# ignore:
pkgs <- pkgs[!pkgs %in% c("iNZight")]
pkgs <- c(pkgs, "rmarkdown", "knitr")

if (length(ca)) {
    saveRDS(pkgs, file = ca[1], version = 2)
} else {
    pkgs <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
    if (length(pkgs))
        install.packages(pkgs,
            repos = c(
                "https://r.docker.stat.auckland.ac.nz",
                "https://cran.rstudio.com"
            ),
            dependencies = TRUE
        )
}
