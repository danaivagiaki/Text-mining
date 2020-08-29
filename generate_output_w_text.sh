#! /usr/bin/sh

coords="/home/projects/pr_47001/people/danvag/sorted_Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review.tsv"

current_line=1

while read line
do
    pid=$(echo $line | awk '{print $1}')
    f=$(echo $line | awk '{print $2}')
    l=$(echo $line | awk '{print $3}')
    match=$(echo $line | awk -v FS=" " -v ORS=" " '{for (i=4;i<=NF;i++) print $i}')
    echo -e "$pid\t$match"
    article=$(gzip -cd sorted_PMC_ALL.tsv.gz | sed -n "${current_line},$ p" | grep -nE -m 1 "\<$pid\>")    
    current_line=$(echo $article | awk -v FS="\t" 'match($0,/[0-9]+:PMID:/){print substr($0, RSTART, RLENGTH-6)}')                                                                                   
    # PMID, match, title, text
    echo "$article" | sort -u | tr -d '\n' | awk -v FS="\t" -v ORS="\t" '{for(i=5;i<=NF;i++){print $i}}' | awk -v RS="\t" -v ORS="\t" -v FS="" -v OFS="" '(NR==1){print $0, "\t", $0}; {if(NR>=2){print $0}}' | awk -v RS="\t" -v ORS="" -v FS="" -v OFS="" -v id="$pid" -v s="$f" -v e="$l" -v m="$match" -v w=30 -f /home/projects/pr_47001/people/danvag/Lifestyle_Factors/coordinates2text.awk >> Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review_with_text.tsv
done < "$coords" # "${1:-/dev/stdin}"
