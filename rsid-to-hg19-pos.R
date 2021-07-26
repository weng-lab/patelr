args <- commandArgs(trailingOnly = TRUE)
dat <- read.table(args[1],header=T)

library(biomaRt)
hg19.snp<- useMart(biomart="ENSEMBL_MART_SNP",host="grch37.ensembl.org",path="/biomart/martservice",dataset="hsapiens_snp")

snp.pos <- getBM(attributes=c("chr_name","chrom_start","refsnp_id"),filters="snp_filter",values=dat[,1],mart=hg19.snp)
snp.pos <- snp.pos[(check.numeric(snp.pos[,1])|snp.pos[,1]=="X"|snp.pos[,1]=="Y"),]

more.pos <- getBM(attributes=c("chr_name","chrom_start","synonym_id"),filters="snp_synonym_filter",values=setdiff(dat[,1],snp.pos[,3]),mart=mart.name)
snp.pos <- snp.pos[(check.numeric(snp.pos[,1])|snp.pos[,1]=="X"|snp.pos[,1]=="Y"),]

names(more.pos)[3] <- "refsnp_id"
snp.pos <- rbind(snp.pos,more.pos)
snp.pos$SNP <- paste(snp.pos$chr_name,snp.pos$chrom_start,sep=":")
dat$SNP <- snp.pos$SNP[match(dat[,1],snp.pos[,3])]

write.table(dat, args[2], quote=F, row.names=F)
