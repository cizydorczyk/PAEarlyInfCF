#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j y
#$ -o output_group1.txt
#PBS -l walltime=04:00:00

## This script is designed to use with a cluster that uses the PBS scheduler and allows docker access
## Make sure docker access is enabled before submitting the script
## snvphyl command line should be installed first
## see https://snvphyl.readthedocs.io/en/latest/install/docker/ for details

cd ~/sharing_project/group_1

## cd to a working directory contiaing reads from isolates that may comprise a shared strain
## the working directory should contains 2 subdirectories:
## a sequencing_data/ folder with the reads of interest
## a reference/ folder with a suitable reference in fasta format 

python ~/Software/snvphyl-galaxy-cli/bin/snvphyl.py --deploy-docker \
--fastq-dir ~/sharing_project/group_1/ \
--reference-file ~/sharing_project/group_1/reference/W26662_3630.fa \
--filter-density-window 200 \
--run-name group_1_W26662_3630_window200 \
--output-dir ~/sharing_project/group_1/W26662_3630_window200

## runs snvphyl command line client (the most current version is automatically pulled by docker)
## the only change to default settings is the flag --filter-density-window 200 

## ends

