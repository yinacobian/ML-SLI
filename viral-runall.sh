#!/bin/bash

#bash viral-runall.sh IDS.txt /home/acobian/LILAC 40

#To run do: thisscrit.sh [IDS.txt] [path to main folder] [number of threads to use in the system]

#1) Create a working directory: mkdir LILAC
#2) Save this file in the folder LILAC
#3) Create a folder for the raw reads, inside your main project folder: mkdir LILAC/P00_raw
#4) Put all reads files, including R1 and R1 inside the folder LILAC/P00_raw
#5) Create a list with the sample names and save it as IDS.txt, place it in the folder LILAC
#	For exmaple do: ls /LILAC/P00_raw | cut -f 1,2,3 -d '_' | sort | uniq | wc -l > IDS.txt 
#6) Open a screes session: screen -DR work-lilac
#7) Run the command: bash viral-runall.sh IDS.txt /home/acobian/LILAC 40

mkdir $2/P01_prinseq_output
#1.- Quality filtering pair end : prinseq++
cat $1 | xargs -t -I{fileID} sh -c "prinseq++ -fastq $2/P00_raw/{fileID}_R1_001.fastq -fastq2 $2/P00_raw/{fileID}_R2_001.fastq -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_left=15 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name $2/P01_prinseq_output/{fileID} -threads $3 -out_format 1"
#prinseq++ -fastq /home/acobian/LILAC/P00_raw/AC5204_S63_R1_001.fastq -fastq2 /home/acobian/LILAC/P00_raw/AC5204_S63_R2_001.fastq -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_left=15 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name /home/acobian/LILAC/P01_prinseq_output/AC5204_S63 -threads 40-out_format 1
