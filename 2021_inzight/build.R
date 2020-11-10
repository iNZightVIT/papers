# build files
library(stringr)

clean_tex <- function(f) {
    txt <- readLines(f)
    from <- grep("\\maketitle", txt, fixed = TRUE) + 1L
    to <- grep("\\end{document}", txt, fixed = TRUE) - 1L
    txt <- txt[from:to]

    # convert @cite:Paper_2000,Paper2_2001; to
    # `\cite{Paper_2000, Paper2_2001}`{=latex}

    regx <- "@([a-zA-Z]+):([a-zA-Z0-9,_\\\\:]+);"
    m <- do.call(rbind, stringr::str_match_all(txt, regx))
    if (nrow(m)) {
        for (i in seq_len(nrow(m))) {
            rep <- paste0("\\", m[i, 2], "{", m[i, 3], "}")
            rep <- gsub("[\\]+_", "_", rep)
            # cat("\n ", m[i, 1], "->", rep)
            txt <- stringr::str_replace_all(txt, stringr::fixed(m[i, 1]), rep)
        }
        # cat("")
    }

    writeLines(txt, f)
}

build_main <- function(file, include) {
    out <- gsub(".Rnw", ".tex", file, fixed = TRUE)
    knitr::knit(file, out)

    # remove things
    x <- readLines(out)
    x <- gsub("\\usepackage{knitr}", "", x, fixed = TRUE)
    x <- x[!grepl("upquote.sty", x)]

    # add things
    inc <- paste0("\\input{", include, "}", collapse = "")
    x <- gsub("%includes%", inc, x, fixed = TRUE)

    writeLines(x, out)

    # cleanup
    unlink("knitr.sty")
}

build_tex_from_rmd <- function(file, extra_pkgs = NULL) {
    # .Rmd -> .tex (+ cleanup)
    b <- tools::file_path_sans_ext(file)
    rmarkdown::render(file,
        output_format =
            rmarkdown::pdf_document(
                keep_tex = TRUE,
                extra_dependencies = extra_pkgs
            ),
        quiet = TRUE
    )
    unlink(sprintf("%s.pdf", b))

    f <- sprintf("%s.tex", b)
    clean_tex(f)

    f
}


build <- function() {
    x <- readLines("index.Rnw")
    pkgs <- grep("\\usepackage", x, fixed = TRUE)
    if (length(pkgs)) {
        deps <- stringr::str_match(x[pkgs],
            "\\\\usepackage\\[?([^\\]]*)\\]?\\{(.*)\\}"
        )
        pkgs <- lapply(deps[,2], function(x) if (x == "") NULL else x)
        names(pkgs) <- deps[,3]
    } else {
        pkgs <- NULL
    }
    rmds <- list.files(pattern = ".Rmd")
    texs <- lapply(rmds, build_tex_from_rmd,
        extra_pkgs = pkgs)
    build_main("index.Rnw", texs)

    system("latexmk -pdf index")
}

build()
unlink("__latexindent_temp.tex")
