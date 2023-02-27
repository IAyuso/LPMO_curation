#!/bin/bash
#let script exit if a command fails
set -o errexit
#let script exit if undeclared variable is used
set -o nounset

echo 'Introduce the family of interest in the format AA10 to select all proteins in a family or AA10|CBM to select sequences with CBMs only'
	read family

echo 'Introduce the name of the fasta file database'
	read database

echo 'Minimum sequence length?'
	read seqkit_min

echo 'Maximum sequence length?'
	read seqkit_max

echo 'CD-hit cutoff? 1.0 generate unique sequences'
	read cd_hit_cutoff

echo -------------------------------
echo the family of choice is $family
echo Minimum length is $seqkit_min, maximum length is $seqkit_max
echo cd-hit cutoff is $cd_hit_cutoff
echo -------------------------------

echo "Do you want to continue (select a number)?"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) 
		#generate the headers for all the datasets
			grep -F '|'$family $database > $family'_headers_all';
			sed -e 's/>//g' $family'_headers_all' > $family'_headers_all2';
			grep 'CBM' $family'_headers_all2' > $family'_headers_wCBM';
			grep -v 'CBM' $family'_headers_all2' > $family'_headers_single_domain'
		
		#fetch the sequences, curate them, and get single domain or CBM-containing sequences
			faSomeRecords $database $family'_headers_all2' $family'_sequences_all';
			seqkit seq -m $seqkit_min -M $seqkit_max $family'_sequences_all' > $family'_lenght_filter';
			cd-hit -i $family'_lenght_filter' -o $family'_lenght_filter_cdhit'.fas -c $cd_hit_cutoff;
			faSomeRecords $family'_lenght_filter_cdhit'.fas $family'_headers_wCBM' $family'sequences_wCBM';
			faSomeRecords $family'_lenght_filter_cdhit'.fas $family'_headers_single_domain' $family'sequences_single_domain';
		
		#move files to a data folder to create clean output
		if [ -d "./data_generated" ]
		then
			cp $family'_headers'* $family'_sequences_all' $family'_lenght_filter' $family'_lenght_filter_cdhit'.fas.clstr ./data_generated;	
		else
			mkdir data_generated
			cp $family'_headers'* $family'_sequences_all' $family'_lenght_filter' $family'_lenght_filter_cdhit'.fas.clstr ./data_generated;
		fi
		rm $family'_headers'* $family'_sequences_all' $family'_lenght_filter' $family'_lenght_filter_cdhit'.fas.clstr;
		break;;
		No ) exit;;
	esac
done







