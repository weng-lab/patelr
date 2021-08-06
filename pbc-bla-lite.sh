#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=03:00:00
#SBATCH --mem=30G
#SBATCH --output=/home/patelr/slurm-logs/bla-lite-logs/pbc_bla_lite.log
#SBATCH --error=/home/patelr/slurm-errors/bla-lite-errors/pbc_bla_lite_errors.log
# The SumHer paper says it should take 2hrs on 20G, I gave 1.5x just in case, just 1 job

# Debug info
echo "HOSTNAME: " $(hostname)
echo "SLURM_JOBID: " $SLURM_JOBID
date
echo ""

# Summary stats, tagging files and SumHER
SUMSTAT=/data/zusers/patelr/gwas_summary_stats/PBC-fixed.txt
TAG=/data/zusers/patelr/taggings/bld.ldak.lite.alpha.hapmap.gbr.tagging
POW=/data/zusers/patelr/taggings/pow.txt
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
cp $SUMSTAT $TAG $POW .

echo "Copying SumHer to temp dir ..."
cp $SUMHER .
echo "Done."

# Get temp file names
SUMSTAT=$(basename $SUMSTAT)
TAG=$(basename $TAG)
POW=$(basename $POW)

# Run SumHer
echo "Running SumHer BLA Lite ..."
echo "Start: "
date
./ldak5.1.linux.fast --sum-hers pbc-bla-lite --summary $SUMSTAT --tagfile $TAG --divisions 7 --powerfile $POW --fixed-n 24751 --check-sums NO --max-threads 1
echo "End: "
date
echo "Done."
echo ""

#Transfer files
echo "Copying results ..."
cp pbc-bla-lite.* /home/patelr/pbc/
echo "Done."
echo ""

#Clean up
echo "Cleaning up ..."
cd $HOME
echo "Deleting temp dir: " $TMPDIR
rm -rd $TMPDIR
echo "Script complete."
date
