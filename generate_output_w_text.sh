#! /usr/bin/sh

coords="/home/danvag/Lifestyle_Factors/lf_output_for_review.tsv"

sed -i "s/ /-/g" $coords

while read line
do
    pid=$(echo $line | awk '{print $1}')
    f=$(echo $line | awk '{print $2}')
    l=$(echo $line | awk '{print $3}')
    match=$(echo $line | awk '{print $4}')
    echo -e "$pid\t$match"
    # PMID, match, title, text
    gzip -cd ../abstracts/*.tsv.gz | grep -E "\<$pid\>" | sort -u | cut -f 5,6 | sed 's/\s\s\+//g' | tr -d '\n' | awk -v RS="\t" -v ORS="\t" -v FS="" -v OFS="" '(NR==1){print $0; prev_line=$0};(NR==2){print prev_line$0;}' | awk -v RS="\t" -v ORS="" -v FS="" -v OFS="" -v id="$pid" -v s="$f" -v e="$l" -v m="$match" -v w=30 -f /home/danvag/Lifestyle_Factors/tmp2_coordinates2text.awk >> lf_output_with_text.tsv
#    sed -i ':a;$!{N;s/\n\n/\n/;ba;}' tmp4_lf_output_with_text.tsv
done < "$coords" # "${1:-/dev/stdin}"

# sed ':a;$!{N;s/\n\n/\n/;ba;}'
