#!/services/tools/parallel/20200522/bin/parallel --shebang-wrap /usr/bin/sh

while read line
do
    pid=$(echo $line | awk '{print $1}')
    f=$(echo $line | awk '{print $2}')
    l=$(echo $line | awk '{print $3}')
    match=$(echo $line | awk -v FS=" " -v ORS=" " '{for (i=4;i<=NF;i++) print $i}')
    echo -e "$pid\t$match"
    gzip -cd ./PMC*.tsv.gz | grep -E "\<$pid\>" | sort -u | tr -d '\n' | awk -v FS="\t" -v ORS="\t" '{for(i=5;i<=NF;i++){print $i}}' | awk -v RS="\t" -v ORS="" -v FS="" -v OFS="" '(NR==1){print $0, "\t"; title=$0}; {if(NR>=2){print title; for(i=2;i<=NR;i++){print $0}}};' | awk -v RS="\t" -v ORS="" -v FS="" -v OFS="" -v id="$pid" -v s="$f" -v e="$l" -v m="$match" -v w=30 -f ./coordinates2txt.awk >> Lifestyle_Factor_Ontology_wo_Obsolete_fulltext_output_for_review_with_text.tsv
done < "$1"
