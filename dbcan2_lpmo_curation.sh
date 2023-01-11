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
		grep $family $database > $family'_headers';
		sed -e 's/>//g' $family'_headers' > $family'_headers2'
		faSomeRecords $database $family'_headers2' $family'_sequences';
		seqkit seq -m $seqkit_min -M $seqkit_max $family'_sequences' > $family'_sequence_lenght_filter';
		cd-hit -i $family'_sequence_lenght_filter' -o $family'_sequence_lenght_filter_cdhit'.fas -c $cd_hit_cutoff;
		break;;
		No ) exit;;
	esac
done
