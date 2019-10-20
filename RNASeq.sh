#!/bin/bash

################################################
########### structure of the folder ############
################################################
# /experiment-name
# /experiment-name/data
# /experiment-name/code
# /experiment-name/code/current-bash
################################################


################################################
##############   useful-data   #################
################################################
# reference-of-genome
reference_genome=""

# gene-model(annotation)
annotation=""
################################################


################################################
#############  experiment-data  ################
################################################
# if download from sra
ini_folder=`pwd`
# current location
# sra_file_list=""
# fastq_folder
# fastq_folder=""
# read length
read_length=101
################################################


################################################
################################################
############      Pipeline         #############
################################################
################################################


################################################
###############   QC-by-fastqc  ################
################################################

### paird-end-data
## input:fastq1 and fastq2 in fastq_folder
## output:fastqc_folder/sampleid
fastqc_folder="../data/fastqc_result"
fastqc_folder=`realpath ${fastqc_folder}`

cd ${fastq_folder}
for file in ./*_1.fastq
do
	# input
	fastq_basename=`basename ${file} _1.fastq`
	fastq1=${file}
	fastq2=${fastq_basename}_2.fastq

	# output
	fastqc_subfolder=${fastqc_folder}/${fastq_basename}
	mkdir -p ${fastqc_subfolder}
	
	# command
	fastqc ${fastq1} ${fastq2} -o ${fastqc_subfolder} -t 40
done	
################################################



################################################
###########   star-building-index   ############
################################################

## input: reference-genome, gene-model-annotation, sjdbOverhang
## output: star_index_folder
cd ${ini_folder}
star_index_folder="../data/mapping/star_index"
mkdir -p ${star_index_folder}
sjdbOverhang=`expr ${read_length} -1`
STAR --runThreadN 30 \
	--runMode genomeGenerate \
	--genomeDir ${star_index_folder} \
	--genomeFastaFiles ${reference_genome} \
	--sjdbGTFfile ${annotation} \
	--sjdbOverhang ${sjdbOverhang}
################################################



################################################    
###########    mapping-with-star    ############
################################################

### paired-end-data
## input: fastq1, fastq2, parameters-for-STAR
## output: bam-related-files
cd ${ini_folder}
bam_folder="../data/mapping/bam"
mkdir -p ${bam_folder}

cd ${fastq_folder}
for file in ./*_1.fastq
do
	# input
	fastq_basename=`basename $file _1.fastq`
	fastq1=${file}
	fastq2=${fastq_basename}_2.fastq
	thread_mapping=20
	# output
	bam_prefix=${bam_folder}/${fastq_basename}
	# command
	STAR --runThreadN ${thread_mapping} \
	--genomeDir ${star_index_folder} \
	--readFilesIn ${fastq1} ${fastq2} \
	--outSAMtype BAM SortedByCoordinate \
	--outFileNamePrefix ${bam_prefix}
done
################################################


################################################
############   indexing-bam-files   ############
################################################

## input: bam_folder
## output: bam_index
cd ${bam_folder}
for file in ./*Aligned.sortedByCoord.out.bam
do
	# input
	# output
	bam_basename=`basename ${file} Aligned.sortedByCoord.out.bam`
	bam_index=${bam_basename}.bai
	# command
	samtools index ${file} ${bam_index}	
done
################################################








