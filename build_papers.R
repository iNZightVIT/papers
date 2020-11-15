if (!dir.exists("figure")) dir.create("figure")
d <- getwd()
dirs <- list.dirs(recursive = FALSE)
dirs <- dirs[grepl("^\\./[0-9]+.+", dirs)]
for (dir in dirs) {
    setwd(dir)
    source("build.R")
    setwd(d)
    # make png cover
    cmd <- sprintf(
        "pdftoppm -png -singlefile %s/index.pdf > figure/%s.png",
        dir, dir
    )
    system(cmd)
}