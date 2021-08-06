args <- commandArgs(trailingOnly = TRUE)
dat <- read.table(args[1],header=T)
pos <- read.table(args[2])

pos[,1] <- substring(pos[,1],first=4)
pos$SNP <- paste(pos$V1,pos$V3,sep=":")
dat$SNP <- pos$SNP[match(dat[,1],pos[,3])]
incomp <-  dat[(is.na(dat$SNP)|duplicated(dat$SNP)),]
comp <- dat[!(is.na(dat$SNP)|duplicated(dat$SNP)),]

write.table(incomp,args[3],quotes=F,row.names=F)
write.table(comp,args[4],quotes=F,row.names=F)
