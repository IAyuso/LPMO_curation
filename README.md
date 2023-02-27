# dbCAN2_curation
This bash script will get and filter the specific families required as they are annotated in the headers of dbCAN2 FASTA database file (https://bcb.unl.edu/dbCAN2/).

It is built around the wonderful faSomeRecords (https://github.com/ENCODE-DCC/kentUtils/tree/master/src/utils/faSomeRecords) and seqkit (https://github.com/shenwei356/seqkit) utilities for FASTA files, and the widely used CD-HIT (https://sites.google.com/view/cd-hit?pli=1), so they need to be installed and be accessible from any folder from the command line. The code will fetch the sequences and filter them by user specified length and identity threshold.

The only inputs needed are the name of the family and the name of the database, that must be downloaded and be present in the folder where this script is run.

It will generate as outputs a file for all the sequences according to the user input parameters, a file with single domain proteins of the family selected and a file containing the sequences with CBM domains within the family.
