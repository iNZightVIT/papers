if (!dir.exists("figure")) dir.create("figure")
unlink("figure/*.png")
d <- getwd()
dirs <- list.dirs(recursive = FALSE, full.names = TRUE)
dirs <- dirs[grepl("^\\./_?.+", dirs)]
for (dir in dirs) {
    setwd(d)
    setwd(dir)
    if (!file.exists("Makefile")) next
    system("make")
    setwd(d)
    # make png cover
    if (grepl("^\\./_", dir)) next
    cmd <- sprintf(
        "pdftoppm -png -singlefile %s/index.pdf > figure/%s.png",
        dir, dir
    )
    system(cmd)
}
