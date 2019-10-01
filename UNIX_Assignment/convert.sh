#!/bin/bash

# This field is for the SNP data set
genotable=$1
# This field is for SNP positions file
snppos=$2
# Put all excluded chromosome classifications here, separated by commas
# e.g. unknown,multiple
excludes=$3
# Put all genotype groupings here, with groups separated by double commas and 
# group members separated by underscores e.g. ZMMIL,ZMMLR,ZMMMR,,ZMPBA,ZMPIL,ZMPJA
groupings=$4

# Set up genotables for each group
for group in $(echo $groupings | sed 's/,,/ /g');

# Initialize genotable
	do head -n 1 $genotable > $group.$genotable.temp;
# Add lines each for type from genotable to subgenotable
	for typer in $(echo $group | sed 's/,/ /g');
		do awk -v typer="$typer" '$3 == typer {print}' $genotable >> $group.$genotable.temp;
	done;

# Transpose subgenotable
	awk -f transpose.awk $group.$genotable.temp | sort -k 1b,1 > $group.$genotable.transposed.temp;

# Get sorted list of unique chromosomal classifications from snnpos
	for chrom in $(tail -n+2 $snppos | awk '{print $3}' | sort | uniq); 

# Check if chrom is in excludes 
		do for exclud in $(echo $excludes | sed 's/,/ /g'); 
			do if [[ "$chrom" == "$exclud" ]]; 
# For unknown or multiple class, get list of the gene ids that are in snppos
# Print SNP_ID, Chromosome, and Position, and pass to join
				then awk -v chrom="$chrom" '$3 == chrom {print $1 "\t" $3 "\t" $4}' $snppos | sort -k1b,1 |

# Join list to transposed genotable, record and continue to next iteration of loop
				join - $group.$genotable.transposed.temp > SNPS.$group.$chrom.$genotable;
				continue 2;
			fi;
		done;

# For each chrom class, get list of the gene ids that are in snppos
# Print SNP_ID, Chromosome, and Position, then SORT and pass on
		awk -v chrom="$chrom" '$3 == chrom {print $1 "\t" $3 "\t" $4}' $snppos | sort -k 1b,1 |

# Join list to transposed genotable, sort by increasing position
# Record and pass on
		join - $group.$genotable.transposed.temp | sort -g -k 3,3 | 
		tee SNPS.$group.$chrom.incr_pos.$genotable |
# Sort by decreasing position, replace "?/?" with "-/-", record and continue
		sort -g -r -k 3,3 | sed 's/?\/?/-\/-/g' > SNPS.$group.$chrom.decr_pos.$genotable;
	done;
done;
rm *.temp

