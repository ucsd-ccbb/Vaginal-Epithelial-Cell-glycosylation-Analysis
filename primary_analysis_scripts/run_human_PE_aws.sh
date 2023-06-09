#!/bin/bash

yes | sudo yum install perl-Env

filename=$1
sample_num=$2
workspace=/scratch/workspace/$filename

STAR=/shared/software/STAR/2.5.1a/bin/Linux_x86_64

star_ref=/shared/software/STAR_index/Hsapiens_h38p13_v38/Hsapiens_h38p13_v38 #gencode v38
fastqc=/shared/software/FastQC/fastqc #v0.11.8
trimmomatic=/shared/software/Trimmomatic-0.38/trimmomatic-0.38.jar
rsem=/shared/software/RSEM-1.3.0/rsem-calculate-expression
aws_addr=s3://ccbb-data-upload/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression

mkdir -p $workspace

cd $workspace
echo $PWD

## Download data ##
aws s3 cp $aws_addr"/fastq/"$filename/$filename"_"$sample_num"_L004_R1_001.fastq.gz" $workspace/$filename"_R1.fastq.gz"
aws s3 cp $aws_addr"/fastq/"$filename/$filename"_"$sample_num"_L004_R2_001.fastq.gz" $workspace/$filename"_R2.fastq.gz"

export _JAVA_OPTIONS=-Djavax.accessibility.assistive_technologies=
$fastqc $workspace/$filename"_R1.fastq.gz" -o $workspace/
$fastqc $workspace/$filename"_R2.fastq.gz" -o $workspace/

## Trim ##
java -jar $trimmomatic PE -threads 5 -phred33 -trimlog $workspace/trimlog.log $workspace/$filename"_R1.fastq.gz" $workspace/$filename"_R2.fastq.gz" $workspace/$filename"_R1.trim.fastq.gz" $workspace/$filename"_R1.unpaired.fastq.gz" $workspace/$filename"_R2.trim.fastq.gz" $workspace/$filename"_R2.unpaired.fastq.gz" LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:27 ILLUMINACLIP:/shared/software/Trimmomatic-0.38/adapters/NexteraPE-PE.fa:2:30:10

## Check for adapters ##
$fastqc $workspace/$filename"_R1.trim.fastq.gz" -o $workspace/
$fastqc $workspace/$filename"_R2.trim.fastq.gz" -o $workspace/

## Default rsem STAR wrapper ##
$rsem --paired-end --star --star-path $STAR --star-gzipped-read-file -p 8 $workspace/$filename"_R1.trim.fastq.gz" $workspace/$filename"_R2.trim.fastq.gz" $star_ref $workspace/$filename

rm $workspace/$filename"_R1.fastq.gz"
rm $workspace/$filename"_R2.fastq.gz"
rm $workspace/$filename"_R1.trim.fastq.gz"
rm $workspace/$filename"_R2.trim.fastq.gz"
rm $workspace/$filename"_R1.unpaired.fastq.gz"
rm $workspace/$filename"_R2.unpaired.fastq.gz"
rm $workspace/trimlog.log
#upload results to S3
aws s3 cp $workspace $aws_addr/primary_analysis/$filename/ --recursive
