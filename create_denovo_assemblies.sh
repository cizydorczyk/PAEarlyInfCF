#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --job-name shovill
#SBATCH --output=shovill_joboutput.txt

cd $SLURM_SUBMIT_DIR
## cd to project directoy after running qc pipeline

export PATH=/home/d/dguttman/pstapton/Software/anaconda3/bin:$PATH
## add anaconda path

source activate assemblers
## activate conda virtual environment containing shovill

for i in `cat list_of_files.txt`; \
do shovill --outdir $i \
-R1 trimmed_reads/"$i"_R1.fastq.gz \
-R2 trimmed_reads/"$i"_R2.fastq.gz \
--cpus 40 --ram 140 \
--gsize 6.3M \
--minlen 1000 
done
## use shovill 1.0.1, SPAdes v3.12.0, to create de-novo assemblies
## output includes raw SPAdes assemblies, and assemblies containging only contigs >1000 bases (and 2X kmer depth by default)

## ends
