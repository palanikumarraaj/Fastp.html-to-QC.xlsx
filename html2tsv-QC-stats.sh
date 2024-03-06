files=`ls *.html|cut -d "." -f1`
for i in $files
do
sed -e 's/<[^>]*>//g' $i".html" > $i"_.txt"
echo "Sample:$i" >> $i"_.fastp.txt"
cat $i"_.txt" | grep "duplication" >> $i*"_.fastp.txt"
cat $i"_.txt" | grep "total reads" | head -n 1 >> $i"_.fastp.txt"
cat $i"_.txt" | grep "total bases" | tail -n 1 >> $i"_.fastp.txt"
cat $i"_.txt" | grep "Q30 bases" | tail -n 1 >> $i"_.fastp.txt"
cat $i"_.txt" | grep "GC content" | tail -n 1 >> $i"_.fastp.txt"
sed 's/:/\t/g' $i"_.fastp.txt" > $i".fastp.txt"
awk 'BEGIN { FS = "\t"; OFS = "\t" } {
    if (NR == 1) {
        for (i = 1; i <= NF; i++) {
            header[i] = $i
        }
    } else {
        for (i = 1; i <= NF; i++) {
            data[NR - 1, i] = $i
        }
    }
}
END {
    for (i = 1; i <= NF; i++) {
        printf "%s", header[i]
        for (j = 1; j <= NR - 1; j++) {
            printf "%s%s", OFS, data[j, i]
        }
        printf "\n"
    }
}' $i".fastp.txt" >> $i".tsv"
cat $i".tsv"| tail -n 1 > $i".final.tsv"
done
#####
mkdir Final_files
mv *.final.tsv Final_files
cd Final_files
cat *.tsv >> Final-set.tsv
sed '1i\Sample\tDuplication Rate\tTotal Reads\tTotal Bases\tQ30 Bases\tGC content' Final-set.tsv > Result-stats.tsv
rm *.final.tsv
echo "Process completed"
##

