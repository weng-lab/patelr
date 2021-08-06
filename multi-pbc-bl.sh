#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=30:00:00
#SBATCH --mem=30G
#SBATCH --output=/home/patelr/slurm-logs/bl-logs/multi-pbc-bl.log
#SBATCH --error=/home/patelr/slurm-errors/bl-errors/multi-pbc-bl.errors.log

# Debug info
echo "HOSTNAME: " $(hostname)
echo "SLURM_JOBID: " $SLURM_JOBID
date
echo ""

# Summary stats, tagging files and SumHER
SUMSTAT=/data/zusers/patelr/gwas_summary_stats/PBC-fixed.txt
TAG=/data/zusers/patelr/taggings/bld.ldak.hapmap.gbr.tagging
SUMHER=/data/zusers/patelr/ldak5.1.linux.fast

# Create temp directory
echo "Creating temp working dir ..."
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
echo "Running SumHer BL ..."
echo "Start: " 
date
for i in {1..10}
do
./ldak5.1.linux.fast --sum-hers pbc-bl --summary $SUMSTAT --tagfile $TAG --fixed-n 24751 --check-sums NO --max-threads 1
done
echo "End: " 
date
echo "Done."
echo ""

#Clean up
echo "Cleaning up ..."
cd $HOME
cd ../../data/zusers/patelr
echo "Deleting temp dir: " $TMPDIR
