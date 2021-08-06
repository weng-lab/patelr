args <- commandArgs(trailingOnly = TRUE)
dat <- read.table(args[1],header=T)

original <- dat
dat <- dat[(nchar(dat[,2])==1)&(nchar(dat[,3])==1),]
dat <- dat[dat[,2]!=dat[,3],]


library(biomaRt)
g38.snp<-useEnsembl(biomart="ENSEMBL_MART_SNP",dataset="hsapiens_snp", mirror = "useast")

snp.pos <- getBM(attributes=c("chr_name","chrom_start","refsnp_id"),filters="snp_filter",values=dat[,1],mart=hg19.snp)
snp.pos <- snp.pos[snp.pos %in% c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y"),]

more.pos <- getBM(attributes=c("chr_name","chrom_start","synonym_name"),filters="snp_synonym_filter",values=setdiff(dat[,1],snp.pos[,3]),mart=mart.name)
more.pos <- more.pos[more.pos %in% c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y"),]

names(more.pos) <- names(snp.pos)
snp.pos <- rbind(snp.pos,more.pos)
snp.pos[,4] <- snp.pos[,3]
snp.pos[,3] <- snp.pos[,2]
snp.pos[,2] <- snp.pos[,2]-1
snp.pos[,1] <- paste0("chr",snp.pos[,1])

removed <-original[!(original[,1] %in% snp.pos[,4]),]
write.table(removed, args[2], quote=F, row.names=F)
write.table(snp.pos, args[3], quote=F, row.names=F,col.names=F)
