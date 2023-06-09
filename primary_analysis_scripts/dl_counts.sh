#!/bin/bash

#yes | sudo yum install perl-Env

# Use this script to download fastqc and STAR/rsem files to make counts matrices and compile a multiqc report

filename=$1
data_dir="/Volumes/TOSHIBA-EXT/UCSD-CCBB/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression/primary_analysis"
s3_addr=s3://ccbb-data-upload/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression/primary_analysis

workspace=$data_dir/$filename

mkdir -p $workspace
cd $workspace

# download fastqcs, .genes.results, .isoforms.results, .stat folder
aws s3 cp $s3_addr/$filename/$filename"_R1.trim_fastqc.html" .
aws s3 cp $s3_addr/$filename/$filename"_R1.trim_fastqc.zip" .
aws s3 cp $s3_addr/$filename/$filename"_R2.trim_fastqc.html" .
aws s3 cp $s3_addr/$filename/$filename"_R2.trim_fastqc.zip" .
aws s3 cp $s3_addr/$filename/$filename".genes.results" .
aws s3 cp $s3_addr/$filename/$filename".isoforms.results" .
aws s3 cp $s3_addr/$filename/$filename".stat" . --recursive
