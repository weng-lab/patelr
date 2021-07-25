args <- commandArgs(trailingOnly = TRUE)
dat <- read.table(args[1],header=T)

library(biomaRt)
hg19.snp<- useMart(biomart="ENSEMBL_MART_SNP",host="grch37.ensembl.org",path="/biomart/martservice",dataset="hsapiens_snp")

fill.snp.pos <- function(snp.info,mart.name){
  snp.pos <- getBM(attributes=c("chr_name","chrom_start","refsnp_id"),filters="snp_filter",values=snp.info[1],mart=mart.name)
  snp.pos <- snp.pos[snp.pos[,3]==snp.info[1],]
  if(dim(snp.pos)[1]==0){
    snp.pos <- getBM(attributes=c("chr_name","chrom_start","refsnp_id"),filters="snp_synonym_filter",values=snp.info[1],mart=mart.name)
  }
  if(dim(snp.pos)[1]>1){
    snp.pos <- snp.pos[check.numeric(snp.pos[,1]),]
  }
  return(paste(snp.pos[1],snp.pos[2],sep=":"))
  }

dat$SNP <- apply(dat,1,fill.snp.pos,hg19.snp)
write.table(dat, args[2], quote=F, row.names=F)
