options(prompt = "R> ", continue = "+  ", width = 70, useFancyQuotes = FALSE)
settings <- yaml::read_yaml('config.yaml')

# figure out the titles
title <- gsub("\\\\", "\\\\\\\\", settings$title)
title_short <- if (is.null(settings$title_short)) title else gsub("\\\\", "\\\\\\\\", settings$title_short)
title_plain <- gsub("[\\]+pkg\\{([a-zA-Z]+)\\}", "'\\1'", title)
title_plain <- gsub("[\\]+proglang\\{([a-zA-Z]+)\\}", "\\1", title_plain)

# authors and their affiliations
authors <- settings$authors
affiliations <- gsub("\\\\", "\\\\\\\\", settings$affiliations)
affiliations <- factor(affiliations, levels = affiliations)
author_affiliations <- lapply(strsplit(authors, "\\["),
    function(x) {
        author <- trimws(x[1])
        affil <- as.integer(strsplit(gsub("\\]", "", x[2]), ",")[[1]])
        list(
            author = author,
            affiliations = factor(affil,
                levels = seq_along(levels(affiliations)),
                labels = levels(affiliations)
            )
        )
    }
)
authors <- paste(sapply(author_affiliations, function(x) x$author))

authors_with_affil_nums <- function(authors) {
    authors <- sapply(authors,
        function(x) {
            sprintf("%s$^\\{%s\\}$",
                x$author,
                paste(as.integer(x$affiliations), collapse = ",")
            )
        }
    )
    paste(authors, collapse = ", ")
}
numbered_affilations <- function(affiliations) {
    paste(
        seq_along(affiliations),
        ".~",
        levels(affiliations),
        sep = "",
        collapse = "\\\\\\\\"
    )
}

# abstract, cleaned up:
abstract <- gsub("\\", "\\\\", settings$abstract, fixed = TRUE)
