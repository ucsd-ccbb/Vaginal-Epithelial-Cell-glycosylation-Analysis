#!/bin/bash

#yes | sudo yum install perl-Env

# Use this script to download fastqc from IGM and upload to UCSD CCBB AWS S3 servers

sample_name=$1
sample_num=$2
ftp_path=ftp://igm-storage.ucsd.edu/230203_A00953_0687_BHVW2WDSX5
s3_path=s3://ccbb-data-upload/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression/fastq
user=alewis
password="ooGh?oa0"
R1suffix="_"$sample_num"_L004_R1_001.fastq.gz"
R2suffix="_"$sample_num"_L004_R2_001.fastq.gz"

mkdir -p tmp_dl
cd tmp_dl

# Download data to ec2 instance (R1 and R2)
wget --user=$user --password=$password $ftp_path/$sample_name$R1suffix 
wget --user=$user --password=$password $ftp_path/$sample_name$R2suffix

#Transfer to s3
aws s3 cp $sample_name$R1suffix $s3_path/$sample_name/
aws s3 cp $sample_name$R2suffix $s3_path/$sample_name/

# Delete fastqs from ec2 instance
cd ..
rm -r tmp_dl
