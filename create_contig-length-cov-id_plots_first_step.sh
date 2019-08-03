#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --job-name blast_assemblies
#SBATCH --output=blast_assemblies_joboutput.txt

## script is designed to work with assemblies which have been split into 3 seperate folders setup by the initial pipeline

cd $SLURM_SUBMIT_DIR

export PATH=~/Software/anaconda3/bin:$PATH

export BLASTDB=~/dbs/blastdb
## setup local instance of blast database before running script
 
mkdir assemblies blast_results parsed_blast_output 
## sets up directory structure

for i in `cat list_of_files.txt`; \
do \
cp $i/spades.fasta assemblies/$i".fa"; \
done
## copy and rename raw assembly "spades.fasta" from each isolates folder to the "assemblies" folder

for i in `cat list_of_files.txt`; \
do \
blastn \
-db /dbs/blastdb/nt \
-query assemblies/$i".fa" -evalue 0.00001 \
-out blast_results/$i"_raw_blast_output.txt" \
-outfmt "7 qseqid sseqid pident length evalue sscinames" \
-num_threads 40; \
done
## use BLAST 2.7.1+ to idenify each contig in an assembly (~10 mins per assembly)
## could ammend this script to use kraken instead (potentially faster)

source activate py27
## activate python2 environment so the following python2 scripts work

for i in `cat list_of_files.txt`; \
do \
python ~/scripts/ec_12_parse_blastoutput_1.py \
blast_results/$i"_raw_blast_output.txt" \
parsed_blast_output/$i"_ec12_parsed_blast_output.txt"; \
python ~/scripts/ec_13_parse_blastoutput_2.py \
parsed_blast_output/$i"_ec12_parsed_blast_output.txt" \
parsed_blast_output/$i"_ec13_parsed_blast_output.txt"
done
## parse the raw contid ID output in "blast_results" using 2 custom scripts: ec12.py and ec13.py
## this sets up a final table for each isolate, "ISOLATE_ec13_parsed_blast_output.txt"
## The final table contains depth and length information and a column with a color value indicating if the best ID for each contig is Pseudomonas aeruginosa (deepblue=yes, red=no)
## A directory containing all the "ISOLATE_ec13_parsed_blast_output.txt" files will be parsed next with an R script


source deactivate

## ends


