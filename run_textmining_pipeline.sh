#!/usr/bin/sh


#PBS -W group_list=pr_47001 -A pr_47001
#PBS –l procs=28
#PBS –l walltime=120:00:00
#PBS -e coordinates2text.err
#PBS -o coordinates2text.log


echo -e "Running tagcorpus and sampling matches for review..."

snakemake --cores 20

echo -e "Sorting files according to PMID..."

gzip -cd PMC*.tsv.gz | sort -k1,1 -t $'\t' | gzip > sorted_PMC_ALL.tsv.gz
sort -k1,1 -k4,4 -t $'\t' Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review.tsv > sorted_Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review.tsv

echo -e "Extracting the text surrounding the sampled matches..."
./generate_output_w_text.sh
