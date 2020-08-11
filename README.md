# Mining PubMed/PMC for lifestyle factors.

## STEP 1: Create the types, entities, names, blacklist etc. files

### FROM AN  .obo FILE (e,g, Lifestyle_Factor_Ontology_wo_Obsolete.obo) (REMOVING THE OBSOLETE TERMS IS IMPORTANT FOR THE DISAMBIGUATION STEP (see below) )

Step 1a:

./obo2reflect.pl Lifestyle_Factor_Ontology_wo_Obsolete

Step 1b:

./disambiguate.pl Lifestyle_Factor_Ontology_wo_Obsolete_names.tsv > disambiguated_Lifestyle_Factor_Ontology_wo_Obsolete_names.tsv


###  Without an .obo file:

awk 'BEGIN{FS=", "}{print ++i"\t""-94\t"$1}' Lifestyle-factor_Synonyms.txt > lf_entities.tsv
awk 'BEGIN{FS=", "; OFS="\t"; i=1}{if (NF>1) {for (f=1;f<=NF;f++) print i,$f} else {print i,$0}; i++}' Lifestyle-factor_Synonyms.txt > lf_names.tsv



## STEP 2: Run tagcorpus 

gzip -cd `ls -1r /home/danvag/abstracts/*.tsv.gz` | tagcorpus --types=lf_types.tsv --entities=lf_entities.tsv --names=lf_names.tsv --stopwords=../tagger/data/blacklist_from_Katerina.tsv --threads=16 --out-matc\
hes=lf_output.tsv

gzip -cd `ls -1r /home/danvag/PubMed_Abstracts/*.tsv.gz` | tagcorpus --types=Lifestyle_Factor_Ontology_wo_Obsolete_types.tsv --entities=Lifestyle_Factor_Ontology_wo_Obsolete_entities.tsv --names=disambiguated_Li\
festyle_Factor_Ontology_wo_Obsolete_names.tsv --groups=Lifestyle_Factor_Ontology_wo_Obsolete_groups.tsv --stopwords=../tagger/data/blacklist_from_Katerina.tsv --threads=16 --out-matches=Lifestyle_Factor_Ontology\
_wo_Obsolete_output.tsv

## STEP 3: Choose 5 random instances of each matched term to review manually

python sample_matches_to_review.py


## STEP 4: Extract the text flanking the match from the tagcorpus output

nohup ./generate_output_w_text.sh &



###############	  STEPS 1	- 4 using Snakemake (on Computerome 2.0)    ##############

`snakemake --cluster "qsub -l nodes=1:ppn=16,walltime=120:00:00" -j 1`


###########################################################################################


## STEP 5: Update blacklist (stopwords) if necessary 


## STEP 6: Update the dictionary/ontology if necessary
