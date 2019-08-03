setwd("cov_depth_plot")
## For this R script, create a new directory "cov_length_plot" containing a subdirectory called "files"
## files should contain all "ISOLATE_ec13_parsed_blast_output.txt" output from previous steps
## rename the file headers to pad leading numbers with zero and make human readable 
## e.g. with following unix command: rename 's/\d+/sprintf("%05d",$&)/e' *.txt

files=list.files(path="files/", pattern="*.txt", full.names=TRUE, recursive=FALSE)
## read in files

pdf("Pseudomonas_contig_length_coverage_plots.pdf", width=20, height=20)
### setup pdf output 

par(mfrow=c(4,4))
## sets number of plots per page


for (file in files){

name <- basename(file)

data <- read.table(file, header=TRUE, sep="\t")


ls

data1 <- transform(data, Color=as.character(data$color1), Outline=as.character(data$color2))

plot(log10(data$Length), log10(data$Coverage), pch=21, cex=0.8, col=(data$color2), bg=data1$Color, xlab="Contig Length (log)", ylab="Contig Coverage (log)", las=1, main=name, ylim=c(0,4))

}

dev.off()
## once complete, the output is a single pdf file with coverage-length plots colored by top blast hit 
##blue = Paeruginosa, red = Not Paeruginosa
##Note: log10 scale applied to both axes

##ends

