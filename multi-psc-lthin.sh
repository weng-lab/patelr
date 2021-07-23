#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=30:00:00
#SBATCH --mem=30G
#SBATCH --output=/home/patelr/slurm-logs/ldak-thin-logs/multi-psc-lthin.log
#SBATCH --error=/home/patelr/slurm-errors/ldak-thin-errors/multi-psc-lthin.error
# The SumHer paper says it should take 2hrs on 20G, I gave 1.5x just in case, just 1 job

# Debug info
echo "HOSTNAME: " $(hostname)
echo "SLURM_JOBID: " $SLURM_JOBID
date
echo ""

# Summary stats, tagging files and SumHER
SUMSTAT=/data/zusers/patelr/gwas_summary_stats/alt-PSC.txt
TAG=/data/zusers/patelr/taggings/ldak.thin.hapmap.gbr.tagging
SUMHER=/data/zusers/patelr/ldak5.1.linux.fast

# Create temp directory
echo "Creating temp working dir ..."
cd $HOME
TMPDIR=$(mktemp -d patelr-tmp-XXXXXXXX)
cd $TMPDIR
echo "Changing wd: " $(pwd)
echo ""

# Copy files
echo "Copying files to temp dir ..."
cp $SUMSTAT $TAG .

echo "Copying SumHer to temp dir ..."
cp $SUMHER .
echo "Done."

# Get temp file names
SUMSTAT=$(basename $SUMSTAT)
TAG=$(basename $TAG)

# Run SumHer
echo "Running SumHer LDAK Thin ..."
echo "Start: " 
date
for i in {1..10}
do
./ldak5.1.linux.fast --sum-hers psc-ldak-thin --summary $SUMSTAT --tagfile $TAG --fixed-n 24751 --check-sums NO --max-threads 1
done
echo "End: " 
date
echo "Done."
echo ""

#Clean up
echo "Cleaning up ..."
cd $HOME
echo "Deleting temp dir: " $TMPDIR
rm -rd $TMPDIR
