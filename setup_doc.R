options(prompt = "R> ", continue = "+  ", width = 70, useFancyQuotes = FALSE)
settings <- yaml::read_yaml('config.yaml')
title <- gsub("\ R", "\ \\\\\\\\proglang{R}", settings$title)
title <- gsub("iNZight", "\\\\\\\\pkg{iNZight}", title)
title_short <- settings$title_short
title_plain <- settings$title
affiliation <- strsplit(settings$affiliation, ",")[[1]]
abstract <- gsub("\\", "\\\\", settings$abstract, fixed = TRUE)
authors <- strsplit(settings$author, " and ")[[1]]
authors_long <- paste(authors, affiliation, sep = "\\\\\\\\")
if (!exists("AUTHOR_COLS")) AUTHOR_COLS <- length(authors)
authors_long <- matrix(authors_long, ncol = AUTHOR_COLS, byrow = TRUE)
authors_long <- paste(apply(authors_long, 1, paste, collapse = " \\\\And "), collapse = " \\\\AND ")
authors <- paste(authors, collapse = " and ")
