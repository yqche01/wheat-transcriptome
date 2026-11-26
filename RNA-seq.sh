#RNA-seq data
#Quality control and adapter trimming with fastp.
fastp -i SampleName_R1.fq.gz -I SampleName_R2.fq.gz \
    -o clean.SampleName_R1.fq.gz -O clean.SampleName_R2.fq.gz \
    --detect_adapter_for_pe --compression 9 \
    -h SampleName.fastp.html -j SampleName.fastp.json

#Align trimmed reads to the wheat reference with HISAT2.
hisat2 --dta -x /wheat_genome/Taestivum_CSv2/dbs/hisat2/db -1 clean.SampleName_R1.fq.gz -2 clean.SampleName_R2.fq.gz -S SampleName.sam 2> SampleName.hisat2.log

samtools sort -o SampleName.sort.bam SampleName.sam
samtools view -b -q 60 -o SampleName.mapq60.bam SampleName.sort.bam

#Generate gene-level counts with featureCounts.
featureCounts -t exon -p -P -B -C -g gene_id -a wheat_annotation.gtf -o wheat.development.featureCounts.txt SampleName.mapq60.bam
