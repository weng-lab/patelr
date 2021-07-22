#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=03:00:00
#SBATCH --mem=30G
#SBATCH --output=/home/patelr/slurm-logs/bl-logs/pbc-bl.log
#SBATCH --error=/home/patelr/slurm-errors/bl-errors/pbc-bl.errors.log
# The SumHer paper says it should take 2hrs on 20G, I gave 1.5x just in case, just 1 job

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
$HOME
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
./ldak5.1.linux.fast --sum-hers pbc-bl --summary $SUMSTAT --tagfile $TAG --fixed-n 24751 --check-sums NO --max-threads 1
echo "End: " 
date
echo "Done."
echo ""

#Transfer files
echo "Copying results ..."
cp pbc-bl.* /home/patelr/pbc/
echo "Done."
echo ""

#Clean up
echo "Cleaning up ..."
cd $HOME
echo "Deleting temp dir: " $TMPDIR
