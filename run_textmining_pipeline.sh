#!/usr/bin/sh


#PBS -W group_list=pr_47001 -A pr_47001
#PBS –l procs=25
#PBS –l walltime=120:00:00
#PBS -e coordinates2text.err
#PBS -o coordinates2text.log

module load parallel/20200522

echo -e "Running tagcorpus and sampling matches for review..."

snakemake --cores 20

echo -e "Extracting the text surrounding the sampled matches..."

./parallel_generate_fulltext_output_w_text.sh Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review.tsv
