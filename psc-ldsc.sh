#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=04:00:00
#SBATCH --mem=30G
#SBATCH --output=/home/patelr/slurm-logs/bl-logs/psc-ldsc.log
#SBATCH --error=/home/patelr/slurm-errors/bl-errors/psc-ldsc.error

# Debug info
echo "HOSTNAME: " $(hostname)
echo "SLURM_JOBID: " $SLURM_JOBID
date
echo ""

# Summary stats, tagging files
SUMSTAT=/data/zusers/patelr/gwas_summary_stats/PSC-summary-statistics.txt
TAG=/data/zusers/patelr/taggings/eur_w_ld_chr
LDSC=/home/patelr/ldsc/ldsc.py

# Create temp directory
echo "Creating temp working dir ..."
cd $HOME
TMPDIR=$(mktemp -d patelr-tmp-XXXXXXXX)
cd $TMPDIR
echo "Changing wd: " $(pwd)
echo ""

# Copy files
echo "Copying files to temp dir ..."
cp $SUMSTAT $LDSC .
cp -r $TAG

echo "Set up environment ..."
source ~/.bashrc
source activate ldsc
echo "Done."

# Get temp file names
SUMSTAT=$(basename $SUMSTAT)
TAG=$(basename $TAG)

# Run SumHer
echo "Running SumHer BL ..."
echo "Start: " 
date
./ldsc.py \
--h2 $SUMSTAT \
--ref-ld-chr eur_w_ld_chr/ \
--w-ld-chr eur_w_ld_chr/ \
--N 24751 \
--out psc-ldsc
echo "End: " 
date
echo "Done."
echo ""

#Transfer files
echo "Copying results ..."
cp psc-ldsc.* /home/patelr/psc/
echo "Done."
echo ""

#Clean up
echo "Cleaning up ..."
cd $HOME
echo "Deleting temp dir: " $TMPDIR
