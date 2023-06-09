data_dir=/Volumes/TOSHIBA-EXT/UCSD-CCBB/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression/primary_analysis

python /Volumes/TOSHIBA-EXT/UCSD-CCBB/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression/primary_scripts/calculate_counts/RSEM_count_parser.py $data_dir
python /Volumes/TOSHIBA-EXT/UCSD-CCBB/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression/primary_scripts/calculate_counts/RSEM_gene_parser.py $data_dir
python /Volumes/TOSHIBA-EXT/UCSD-CCBB/2023/20230207_Agarwal_Lewis_Human_Bulk_RNA-Seq_Differential_Expression/primary_scripts/calculate_counts/RSEM_isoform_parser.py $data_dir