#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=12:00:00
#SBATCH --job-name snippy
#SBATCH --output=snippy_output.txt

cd $SLURM_SUBMIT_DIR

export PATH=/home/d/dguttman/pstapton/Software/anaconda3/bin:$PATH
source activate mapping
## snippy installed in conda virtual environment "mapping"

for i in `cat list.txt`; \
do \
snippy --cpus 40 --outdir \
--ref NC_002516.2.gbk \
--R1 reads/$i"_1.fq.gz" \
--R2 reads/$i"_2.fq.gz"; \
done

grep mutS */snps.tab | grep -v 'synonymous_variant' > non-synonymous_mutS_mutations_all_samples.txt

##ends
