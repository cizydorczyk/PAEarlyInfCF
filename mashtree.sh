#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=1:00:00
#SBATCH --job-name mashtree
#SBATCH --output=mashtree_joboutput.txt

cd $SLURM_SUBMIT_DIR
## Submit this script from a directory that contains the denovo assemblies you wish to include in the tree
## output is a newick file with tip labels taken directly from the assembly names

export PATH=~/Software/anaconda3/bin:$PATH
## add anaconda path

source activate assemblers
## activate conda virtual environment containing Mashtree v0.30

mashtree.pl --genomesize 6300000 --numcpus 40 *.fa > whole_genome_tree.nwk

## ends
