#!/bin/bash
###   Structure of files   ######
# /experiment
# /experiment/data
# /experiment/code
# Current bash file is in /experiment/code



###   Instance of useful data and experiment data   ######

## Download list
# If download from sra, there will be a SRR_Acc_list
# srr_acc_list=""
# If download from ebi, there will be a ebi_list
# ebi_list=""

## Fastq folder 
fastq_folder="../data/fastq"


#------------------------------------------------------------
filelist_single="../SRR_Acc_List_Single.txt"
filelist_paired="../SRR_Acc_List_Paired.txt"

sra_file_dir="/data8t_5/mtx/GSE85908/orignal_data/reads/"
fastq_file_dir="/data8t_5/mtx/GSE85908/orignal_data/raw_reads/"
fastqc_file_dir="/data8t_5/mtx/GSE85908/analysis/QC/"

#for single end
#cat $filelist_single | while read line
#do
#    file=${sra_file_dir}${line}.sra
#    fastqfile=${fastq_file_dir}${line}.fastq
#   #fastq-dump -I $file -O $fastq_file_dir
#    fastqc -t 20 $fastqfile --outdir=${fastqc_file_dir}
#done

#for paired end
cat $filelist_paired | while read line
do
    file=${sra_file_dir}${line}.sra
    fastqfile1=${fastq_file_dir}${line}_1.fastq
    fastqfile2=${fastq_file_dir}${line}_2.fastq
   #fastq-dump -I $file -O $fastq_file_dir
    fastqc -t 20 $fastqfile1 --outdir=${fastqc_file_dir}
    fastqc -t 20 $fastqfile2 --outdir=${fastqc_file_dir}
done

###      download from NCBI      ###
# Here we need to configure the sratools first
# Then we can get sra files into some folder
# Then we need to check the integrity
# Then we need to change sra file into fastq file
# For paired end data

