# Title     : De novo Mutational Signatures using NMF package
# Objective : Run NMF and comparison to known signatures (Alexandrov v2)
# Created by: susrei
# Created on: 2020-06-15


rm(list=ls(all=TRUE))


# Load packages
library(NMF)
library(ggplot2)
library(MutationalPatterns)

today.date <- format(Sys.time(), "%Y%m%d")

# Read SNV data and metadata

# outdir <- "/home/susanne/bclr_genomics/snv/mutational_signatures/"  # TODO: arg
# date <- "20200626"
# dataFile <- paste0(outdir, date, "_mutation_catalog.tsv")
#
# mutation.file <- "/home/susanne/bclr_genomics/snv/mutational_signatures/20200626_mutation_catalog.tsv"


#' NMF rank estimation
#'
#' Given a mutation catolog as input the function will perform the NMF rank estimation
#' @param mutation.file A mutation catalog containing trinucleotide counts
#' @param min.rank Minimum number for the NMF factorization rank to extract muational signatures
#' @param max.rank Maximum number for the NMF factorization rank to extract muational signatures
#' @param output.dir Path to store the results
#' @param nrun Number of iterations, default 100
#' @param method Method used to estimate the rank, default 'brunet'
#' @param seed Set to 333
#' @return Returns a figure with metrices to select the rank
estimate.rank <- function(
    mutation.file,
    min.rank,
    max.rank,
    output.dir,
    nrun=100,
    method="brunet",
    seed=3245
) {
    # Read matrix X (mutational catalog) from file
    data.mat <- read.table(mutation.file, sep="\t", header=TRUE)
    X <- data.mat[, -1]

    # Run nmf rank estimation
    estimate <- nmf(
        X + 0.0001,
        rank=min.rank:max.rank,
        nrun=nrun,
        method=method,
        seed=seed)

    # Plot estimates and save the figure as pdf
    estimate.fig <- plot(estimate)
    fig.name <- paste0(today.date, "_deNovoNMF_rankEstimation.pdf")
    ggsave(fig.name, path=output.dir, plot=estimate.fig, device="pdf")

    write(paste("Output written to:", output.dir), stdout())
}


#' Perform NMF
#'
#' Run NMF to extract mutational signatures from the mutation count matrix
#' @param mutation.file A mutation catalog containing trinucleotide counts
#' @param nmf.rank NMF factorization rank as the number of muational signatues to extract
#' @param output.dir Path to store the results
#' @param nrun Number of iterations, default 200
#' @param method Method used to estimate the rank, default 'brunet'
#' @param seed Set to 3245
#' @return Returns a list with NMF output matrices: ConsensusMatrix, SignatureMatrixW, ExposureMatrixH
run.nmf <- function(
    mutation.file,
    nmf.rank,
    output.dir,
    nrun=200,
    method="brunet",
    seed=3245
) {

    # # Drop ending backslash from path
    # if (substr(output.dir, nchar(output.dir), nchar(output.dir)) == "/") {
    #     output.dir <- substr(output.dir, 1, nchar(output.dir)-1)
    # }

    # Read mutational catalog file
    data.mat <- read.table(mutation.file, sep="\t", header=TRUE)  # TODO: arg

    # Get info
    snv.list <- data.mat$TN_CONTEXT
    pat.list <- colnames(data.mat)[-1]
    sig.list <- paste("Signature", LETTERS[1:nmf.rank])

    # Matrix: X
    X <- data.mat[, -1]
    n <- nrow(X)
    p <- ncol(X)

    # Run NMF
    X <- X + 1e-4  # add small pseudo-count to avoid 0 in the matrix
    res <- nmf(X, rank=nmf.rank, nrun=nrun, method=method, seed=seed, .options="v")

    # Extract matrices from NMF result
    C <- data.frame(res@consensus)
    colnames(C) <- pat.list
    rownames(C) <- pat.list
    write.matrix(C, "ConsensusMatrix", nmf.rank, output.dir)

    W <- data.frame(res@fit@W)
    colnames(W) <- sig.list
    rownames(W) <- snv.list
    write.matrix(W, "SignatureMatrixW", nmf.rank, output.dir)

    H <- data.frame(res@fit@H)
    colnames(H) <- pat.list
    rownames(H) <- sig.list
    write.matrix(H, "ExposureMatrixH", nmf.rank, output.dir)

    write(paste("Output written to:", output.dir), stdout())

    # pack all matrices in one object
    nmf.result <- list(X=X, W=W, H=H, C=C)

    return(nmf.result)
}


#' Calculate cosine similarity to Alexandrov signatures
#'
#' Quantify the contribution of a set of signatures to the mutational profile of a sample
#' @param W A file containing the SignatureMatrixW (derived from NMF)
#' @param output.dir Path to store the results
#' @return Returns a file containing for each signature a cosine similarity to Alexandrov signatures
get.similarity.to.alexandrov <- function(W, output.dir) {
    alexandrov.signatures.mat <- get.alexandrov.signatures()

    # Read matrix W (signature matrix) from file
    signatures.ordered <- read.table(W, sep="\t", header=TRUE)
    signatures.ordered.norm <- scale(signatures.ordered, center=FALSE, scale=colSums(signatures.ordered))
    nmf.rank <- dim(signatures.ordered.norm)[2]

    cos.sim.mat <- matrix(nrow=dim(signatures.ordered.norm)[2], ncol=dim(alexandrov.signatures.mat)[2])
    for (i in 1:dim(signatures.ordered.norm)[2]) {
      for (j in 1:dim(alexandrov.signatures.mat)[2]) {
        cos.sim.mat[i,j] <- cos.sim(signatures.ordered.norm[,i], alexandrov.signatures.mat[,j])
      }
    }

    for (i in 1:nmf.rank) {
      signature <- sort(cos.sim.mat[i,], decreasing=TRUE, index.return=TRUE)
      signature$ix <- paste0("Signature.", signature$ix)
      names(signature) <- c("similarity", "alexandrov")
      signame <- LETTERS[i]
      sig.out <- sprintf(
        "%s/%s_deNovoNMF_nmfCosineSimilarity_signature%s_rank%d.txt",
        output.dir, today.date, signame, nmf.rank
        )
      write.table(signature, file=sig.out, sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    }
    write(paste("Output written to:", output.dir), stdout())
}


#' Perform fitting to Alexandrov signatures
#'
#' Find the optimal linear combination of mutational signatures that most closely reconstructs
#' the mutation matrix by solving a non-negative least-squares constraints problem
#' @param mutation.file A file containing the mutation catalog
#' @param output.dir Path to store the results
#' @return Returns a file containing for each signature a cosine similarity to Alexandrov signatures
fit.to.alexandrov <- function(mutation.file, output.dir) {

    # Read matrix X (mutational catalog) from file
    data.mat <- read.table(mutation.file, sep="\t", header=TRUE)
    X <- data.mat[, -1]
    X.norm <- scale(X, center=FALSE, scale=colSums(X))

    alexandrov.signatures.mat <- get.alexandrov.signatures()

    # Finding the optimal linear combination of mutational signatures that most closely reconstructs the mutation matrix
    # by solving a non-negative least-squares constraints problem
    fit.res <- fit_to_signatures(X.norm, alexandrov.signatures.mat)
    fit.out <- sprintf(
        "%s/%s_fitted_signatures_contributions.txt",
        output.dir, today.date)
    write.table(fit.res$contribution, file=fit.out, sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

    write(paste("Output written to:", output.dir), stdout())
}


write.matrix <- function(mat, name, rank, output.dir) {
    output.file <- sprintf(
        "%s/%s_deNovoNMF_%s_rank%d.txt",
        output.dir, today.date, name, rank
    )
    write.table(mat, file=output.file, sep="\t", row.names=TRUE, col.names=TRUE, quote=FALSE)
}



#' Get Alexandrov signature
#'
#' Read in some already existing signatures, here Alexandrov/COSMIC (v2 - March 2015)
#' @return Returns a file containing the Alexandrov/COSMIC signatures (v2)
get.alexandrov.signatures <- function() {

    signatures.path <- "/opt/extdata/alexandrov_signatures_probabilities.txt"
    alexandrov.signatures <- read.table(signatures.path, sep = "\t", header = TRUE)
    alexandrov.signatures <- alexandrov.signatures[,c(1:33)]

    rownames(alexandrov.signatures) <- paste(alexandrov.signatures$Substitution.Type, alexandrov.signatures$Trinucleotide)
    alexandrov.signatures.mat <- as.matrix(alexandrov.signatures[sort(rownames(alexandrov.signatures)), 4:33])

    return(alexandrov.signatures.mat)
}



#' Calculate cosine similarity
#'
#' Given two vectors calculate the cosine similarity.
#' @param u A numeric vector to be used to calculate the cosine similarity
#' @param v A numeric vector to be used to calculate the cosine similarity
#' @return Returns a numeric value representing the cosine similarity between the vectors provided
cos.sim <- function(u, v) {
  return (sum(u * v) / sqrt(sum(u^2) * sum(v^2)))
}
