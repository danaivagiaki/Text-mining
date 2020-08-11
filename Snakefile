rule all:
    input:
        "Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review_with_text.tsv"


rule convert_obo:
    output:
        types="Lifestyle_Factor_Ontology_wo_Obsolete_types.tsv",
        entities="Lifestyle_Factor_Ontology_wo_Obsolete_entities.tsv",
        names="Lifestyle_Factor_Ontology_wo_Obsolete_names.tsv",
        groups="Lifestyle_Factor_Ontology_wo_Obsolete_groups.tsv",
        texts="Lifestyle_Factor_Ontology_wo_Obsolete_texts.tsv"
    shell:
        "./obo2reflect.pl Lifestyle_Factor_Ontology_wo_Obsolete"


rule disambiguate:
    input:
        {rules.convert_obo.names}
    output:
        "disambiguated_Lifestyle_Factor_Ontology_wo_Obsolete_names.tsv"
    shell:
        "./disambiguate.pl {input} > {output}"
        
        
rule run_tagcorpus:
    input:
        types="Lifestyle_Factor_Ontology_wo_Obsolete_types.tsv",
        entities="Lifestyle_Factor_Ontology_wo_Obsolete_entities.tsv",
        names={rules.disambiguate.output},
	groups="Lifestyle_Factor_Ontology_wo_Obsolete_groups.tsv",
	stopwords="blacklist_from_Katerina.tsv"
    output:
        "Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output.tsv"
    shell:
        "gzip -cd `ls -1r /home/projects/pr_47001/people/danvag/PMC*.tsv.gz` | tagcorpus --types={input.types} --entities={input.entities} --names={input.names} --groups={input.groups} --stopwords={input.stopwords} --threads=16 --out-matches={output}"


rule sampling:
    input:
        {rules.run_tagcorpus.output}
    output:
        "Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review.tsv"
    script:
        "./sample_matches_to_review.py"


rule extract_text:
    input:
        {rules.sampling.output}
    output:
        "Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review_with_text.tsv"
    script:
        "./generate_output_w_text.sh"
        
