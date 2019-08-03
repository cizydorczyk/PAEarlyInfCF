#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --job-name pipe1
#SBATCH --output=pipeline1_output.txt

### This pipeline was designed for use on the Niagara HPC at University of Toronto (40 cpus/node)
### Several software packages are loaded as anaconda virtual environments as required 

cd $SLURM_SUBMIT_DIR
## cd to project directory that contains sequencing reads in fastq format in a folder called raw_reads

pigz raw_reads/*.fastq
## gzip the reads

ls raw_reads/*_R1.fastq.gz | \
sed 's/raw_reads\///g' | \
sed 's/_R1.fastq.gz//g' > list_read_filenames.txt

mkdir trimmed_reads
mkdir unpaired_reads
cp ~/Software/anaconda3/pkgs/trimmomatic-0.36-5/share/trimmomatic-0.36-5/adapters/NexteraPE-PE.fa .
# NexteraPE-PE.fa is an file with illumina adapters used at CAGEF

for i in `cat list_read_filenames.txt`; do \
trimmomatic PE -threads 40 \
raw_reads/$i"_R1.fastq.gz" raw_reads/$i"_R2.fastq.gz" \
trimmed_reads/${i%_181009_NextSeq}"_R1.fastq.gz" \
unpaired_reads/$i"_unpaired_R1.fastq.gz" \
trimmed_reads/${i%_181009_NextSeq}"_R2.fastq.gz" \
unpaired_reads/$i"_unpaired_R2.fastq.gz" \
CROP:150 SLIDINGWINDOW:4:5 \
ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 \
MINLEN:100 ;\
done
## Use trimmomatic-0.36 to trim the reads to max lenght 150, min length 100, remove adapters
## Sliding window settings are not stringent with respect to quality scores i.e. keep as many bases as possible
## unpaired reads are not utilised downstream

ls trimmed_reads/*_R1.fastq.gz | \
sed 's/trimmed_reads\///g' | \
sed 's/_R1.fastq.gz//g' > list_trimmed_base.txt
## setting up list of filenames

mkdir kraken_trimmed

for t in `cat list_trimmed_base.txt`; 
do \
kraken --preload --threads 40 --quick \
--db /home/d/dguttman/pstapton/dbs/minikraken_20171019_8GB/ \
--paired trimmed_reads/$t"_R1.fastq.gz" trimmed_reads/$t"_R1.fastq.gz" \
| kraken-report --db /home/d/dguttman/pstapton/dbs/minikraken_20171019_8GB/ \
> kraken_trimmed/$t"_kraken-report.tsv"; \
~/Software/translate_kraken_scripts/summarize_kraken-report.sh \
kraken_trimmed/$t"_kraken-report.tsv" > kraken_trimmed/$t"_kraken-summary.tsv" 
done 
## use Kraken version 1.0 and the minikraken 8GB database to identify each read
## summarise the kraken output using supplementary scripts kraken-report.tsv and kraken-summary.tsv, from https://github.com/chrisgulvik/summarize_kraken_data to 

mkdir fastqc_trimmed

fastqc -o fastqc_trimmed -t 40 trimmed_reads/*
## Use FastQC v0.11.8 on trimmed reads

multiqc fastqc_trimmed
## Summarise fastqc data with MultiQC v1.0


mkdir shovill1 shovill2 shovill3
sed -n -e '1,60p' list_trimmed_base.txt > shovill1/list_of_files.txt
sed -n -e '61,120p' list_trimmed_base.txt > shovill2/list_of_files.txt
sed -n -e '121,187p' list_trimmed_base.txt > shovill3/list_of_files.txt
## set up directories to run de-novo asssemblies with spades/shovill in (3) batches after analysing qc data
## ends



