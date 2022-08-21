#!/usr/bin/env Rscript
library("optparse")

source("example.R")

today.date <- format(Sys.time(), "%Y%m%d")

option_list = list(
    make_option(c("--process"), type="logical", default=FALSE, action="store_true", dest="process",
              help="Run data processing. If this is set, 'file' and 'outfile' arguments must be supplied."),

    make_option(c("--plot"), type="logical", default=FALSE, action="store_true", dest="plot",
              help="Run plotting."),

    make_option(c("-f", "--file"), type="character", action="store", dest="file",
              help="Input file."),

    make_option(c("-o", "--outfile"), type="character", action="store", dest="outfile",
              help="Output file for the results."),

    make_option(c("-p", "--prefix"), type="character", action="store", dest="prefix", default=today.date,
              help="Prefix for output (default=%default).")
)

opt_parser = OptionParser(
    option_list=option_list,
    usage=paste(
        "Example R Package",
        "",
        "This package supports two different options:",
        "   process        Process data (--process)",
        "   plot           Plot data (--plot)",
        "These options are exclusive and only one of them must be supplied.",
        "",
        sep="\n"
    )
)

opt = parse_args(opt_parser)

## Only one of 'process' and 'plot' must be supplied
if (opt$process + opt$plot != 1) {
    print_help(opt_parser)
    stop("Exactly one of 'process' or 'plot' must be supplied. See usage above.")
}

## Check if file and outfile are supplied
if (!("file" %in% names(opt)) || !("outfile" %in% names(opt))) {
    print_help(opt_parser)
    stop("You must supply both 'file' and 'outfile' arguments. See usage above.")
}

## Example: drop ending backslash from path
# outdir <- opt$outdir
# if (substr(opt$outdir, nchar(opt$outdir), nchar(opt$outdir)) == "/") {
#     outdir <- substr(opt$outdir, 1, nchar(opt$outdir)-1)
# }

## Example: drop ending backslash from prefix
# prefix <- opt$prefix
# if (substr(opt$prefix, nchar(opt$prefix), nchar(opt$prefix)) == "/") {
#     prefix <- substr(opt$prefix, 1, nchar(opt$prefix)-1)
# }

## Example: create output file path with prefix
# outpath <- file.path(path.expand(outdir), prefix)

## Example: create output directory if it doesn't exits
# if (!dir.exists(outpath)) {
#     dir.create(outpath, recursive=TRUE)
# }

## Run data processing
if (opt$process) {
    # Example: check if required arguments are supplied
    if (("file" %in% names(opt)) && ("outfile" %in% names(opt))) {
        process.data(opt$file, opt$outfile)
    } else {
        print_help(opt_parser)
        stop("You must supply 'file' and 'outfile'. See usage above.")
    }
}

## Run plotting
if (opt$plot) {
    plot.data(opt$file, opt$outfile)
}
