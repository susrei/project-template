# Title     : <Project Title>
# Objective : <Project Description>
# Created by: susrei
# Created on: <YYYY-MM-DD>


rm(list=ls(all=TRUE))


# Load packages
# library(ggplot2)

today.date <- format(Sys.time(), "%Y%m%d")

#' Dummy data processing function
#'
#' Given an input file process the data and write the result to the output file
#' @param input.file Path to input data file
#' @param output.file Path to output file
#' @return Return processed data as a matrix
process.data <- function(
    input.file,
    output.file
) {
    write(paste("Reading data from:", input.file), stdout())
    data <- matrix(data=c(1, 2, 3, 4, 5, 6), nrow=3, ncol=2)
    write(paste("Write processed data to:", output.file), stdout())
    data
}


#' Dummy data visualization function
#'
#' Given an input data file plot the data and write the figure to the output file
#' @param input.file Path to input data file
#' @param output.file Path to output file
plot.data <- function(
    input.file,
    output.file
) {
    write(paste("Reading data from:", input.file), stdout())
    write(paste("Plotting figure...DONE"), stdout())
    write(paste("Write figure to:", output.file), stdout())
}
