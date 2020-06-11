#!/bin/bash

#bash viral-runall.sh IDS.txt /home/acobian/LILAC 40

#To run do: thisscrit.sh [IDS.txt] [path to main folder] [number of threads to use in the system]

#1) Create a working directory: mkdir LILAC
#2) Save this file in the folder LILAC
#3) Create a folder for the raw reads, inside your main project folder: mkdir LILAC/P00_raw
#	Use two zeros and not two "o" to create this folder 
#4) Put all reads files, including R1 and R1 inside the folder LILAC/P00_raw
#5) Create a list with the sample names and save it as IDS.txt, place it inside the folder LILAC
#	  For exmaple do: ls P00_raw/ | cut -f 1,2,3 -d '_' | sort | uniq > IDS.txt
#6) Open a screen session: screen -DR work-lilac
#7) Go to your working directory (LILAC in this case) 
#8) Run the command: bash viral-runall.sh IDS.txt /home/acobian/LILAC 40


# PART1: quality filtering 
#mkdir $2/P01_prinseq_output
#1.- Quality filtering pair end : prinseq++
#cat $1 | xargs -t -I{fileID} sh -c "prinseq++ -fastq $2/P00_raw/{fileID}_R1_001.fastq -fastq2 $2/P00_raw/{fileID}_R2_001.fastq -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_left=15 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name $2/P01_prinseq_output/{fileID} -threads $3 -out_format 1"
#prinseq++ -fastq /home/acobian/LILAC/P00_raw/AC5204_S63_R1_001.fastq -fastq2 /home/acobian/LILAC/P00_raw/AC5204_S63_R2_001.fastq -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_left=15 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name /home/acobian/LILAC/P01_prinseq_output/AC5204_S63 -threads 40-out_format 1

# PART2: move reads to use in FRAP, good quality single end
mkdir $2/P02_for_FRAP
cat $1 | xargs -t -I{fileID} sh -c "cp $2/P01_prinseq_output/{fileID}_good_out_R1.fasta $2/P02_for_FRAP/"

# PART3: FRAP vs viral refseq
mkdir $2/P03_FRAP_viralrefseq
#copy FRAP scripts
cp /home/SHARE/FRAP-bin/jmf4.pl $2/P03_FRAP_viralrefseq/ 
cp /home/SHARE/FRAP-bin/frap_normalization.pl $2/P03_FRAP_viralrefseq/
#copy database file
cp /home/DATABASES/RefSeq/viral/all_viral_genomic.fna $2/P03_FRAP_viralrefseq
#run FRAP
perl jmf4.pl $2/P03_FRAP_viralrefseq/all_viral_genomic.fna $2/P02_for_FRAP $2/P03_FRAP_viralrefseq/results smalt 50000
