args <- commandArgs(trailingOnly = TRUE)
dat <- read.table(args[1],header=T)

library(biomaRt)
hg19.snp<- useMart(biomart="ENSEMBL_MART_SNP",host="grch37.ensembl.org",path="/biomart/martservice",dataset="hsapiens_snp")

snp.pos <- getBM(attributes=c("chr_name","chrom_start","refsnp_id"),filters="snp_filter",values=dat[,1],mart=hg19.snp)
snp.pos <- snp.pos[check.numeric(snp.pos[,1]),]

more.pos <- getBM(attributes=c("chr_name","chrom_start","synonym_id"),filters="snp_synonym_filter",values=setdiff(dat[,1],snp.pos[,3]),mart=mart.name)
more.pos <- more.pos[check.numeric(more.pos[,1]),]

names(more.pos)[3] <- "refsnp_id"
snp.pos <- rbind(snp.pos,more.pos)
snp.pos$SNP <- paste(snp.pos$chr_name,snp.pos$chrom_start,sep=":")
dat$SNP <- snp.pos$SNP[match(dat[,1],snp.pos[,3])]

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
