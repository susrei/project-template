#!/usr/bin/env Rscript
library("optparse")

source("nmf_signatures.R")

today.date <- format(Sys.time(), "%Y%m%d")

option_list = list(
    make_option(c("--estimate"), type="logical", default=FALSE, action="store_true", dest="estimate",
              help="Run rank estimation. If this is set, 'minrank' and 'maxrank' arguments must be supplied."),

    make_option(c("--fit"), type="logical", default=FALSE, action="store_true", dest="fit",
              help="Run non-negative least square fit to Alexandrov signatures."),

    make_option(c("--nmf"), type="logical", default=FALSE, action="store_true", dest="nmf",
              help="Run NMF."),

    make_option(c("--similarity"), type="logical", default=FALSE, action="store_true", dest="similarity",
              help="Run cosine similarity to Alexandrov."),

    make_option(c("--minrank"), type="integer", action="store", dest="minrank",
              help="Minimum rank for NMF rank estimation. If '--estmiate' is not set this is ignored."),

    make_option(c("--maxrank"), type="integer", action="store", dest="maxrank",
              help="Maximum rank for NMF rank estimation. If '--estmiate' is not set this is ignored."),

    make_option(c("-r", "--rank"), type="integer", action="store", dest="rank",
              help="Rank for NMF. If '--estmiate' is set this is ignored."),

    make_option(c("--nrun"), type="integer", action="store", dest="nrun", default=100,
              help="Number of iterations for the NMF algorithm (default=%default)."),

    make_option(c("--method"), type="character", action="store", dest="method", default="brunet",
              help="NMF method (default=%default)."),

    make_option(c("--seed"), type="integer", action="store", dest="seed", default=3245,
              help="Seed (default=%default)."),

    make_option(c("-f", "--file"), type="character", action="store", dest="file",
              help="Input file."),

    make_option(c("-o", "--outdir"), type="character", action="store", dest="outdir",
              help="Output directory for the results."),

    make_option(c("-p", "--prefix"), type="character", action="store", dest="prefix", default=today.date,
              help="Prefix for output (default=%default).")
)

opt_parser = OptionParser(
    option_list=option_list,
    usage=paste(
        "Non-Negative Matrix Factorization Package",
        "",
        "This package supports four different options:",
        "   estimate        Run rank estimation (requires: minrank, maxrank)",
        "   fit             Fit to Alexandrov signatures",
        "   nmf             Run NMF (requires: rank)",
        "   similarity      Run cosine similarity to Alexandrov",
        "These options are exclusive and only one of them must be supplied.",
        "",
        sep="\n"
    )
)

opt = parse_args(opt_parser)

# Only one of estimate, fit, nmf or similarity must be supplied
if (opt$estimate + opt$fit + opt$nmf + opt$similarity != 1) {
    print_help(opt_parser)
    stop("Exactly one of estimate, fit or nmf must be supplied. See usage above.")
}

# Check if file and outdir are supplied
if (!("file" %in% names(opt)) || !("outdir" %in% names(opt))) {
    print_help(opt_parser)
    stop("You must supply both file and outdir arguments. See usage above.")
}

# Drop ending backslash from path
outdir <- opt$outdir
if (substr(opt$outdir, nchar(opt$outdir), nchar(opt$outdir)) == "/") {
    outdir <- substr(opt$outdir, 1, nchar(opt$outdir)-1)
}

# Drop ending backslash from prefix
prefix <- opt$prefix
if (substr(opt$prefix, nchar(opt$prefix), nchar(opt$prefix)) == "/") {
    prefix <- substr(opt$prefix, 1, nchar(opt$prefix)-1)
}

outpath <- file.path(path.expand(outdir), prefix)

# Create output directory if it doesn't exits
if (!dir.exists(outpath)) {
    dir.create(outpath, recursive=TRUE)
}

# Run Rank Estimation
if (opt$estimate) {
    # minrank and maxrank must be supplied for rank estimation
    if (("minrank" %in% names(opt)) && ("maxrank" %in% names(opt))) {
        estimate.rank(opt$file, opt$minrank, opt$maxrank, outpath)
    } else {
        print_help(opt_parser)
        stop("You must supply minrank and maxrank. See usage above.")
    }
}

# Run Fit to Alexandrov
if (opt$fit) {
    fit.to.alexandrov(opt$file, outpath)
}

# Run NMF
if (opt$nmf) {
    # rank must be supplied for NMF
    if ("rank" %in% names(opt)) {
        nmf.res <- run.nmf(opt$file, opt$rank, outpath)
    } else {
        print_help(opt_parser)
        stop("You must supply rank. See usage above.")
    }
}

# Run Cosine Similarity to Alexandrov
if (opt$similarity) {
    nmf.res <- get.similarity.to.alexandrov(opt$file, outpath)
}
