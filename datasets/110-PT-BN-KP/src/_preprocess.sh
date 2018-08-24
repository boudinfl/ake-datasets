#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 24 august 2018
# Script for preprocessing 110-PT-BN-KP files

################################################################################
# Prepare data
################################################################################
unzip 110-PT-BN-KP.zip
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p ../test
for FILE in 110-PT-BN-KP/test/*.txt;
do
     DOC_ID=`basename $FILE`
     echo "info - pre-processing $DOC_ID"
     python3 preprocess.py $FILE > ../test/${DOC_ID%.txt}.xml
done
################################################################################

################################################################################
# TRAIN split
################################################################################
mkdir -p ../train
for FILE in 110-PT-BN-KP/train/*.txt;
do
     DOC_ID=`basename $FILE`
     echo "info - pre-processing $DOC_ID"
     python3 preprocess.py $FILE > ../train/${DOC_ID%.txt}.xml
done
################################################################################


################################################################################
# REFERENCES
################################################################################
mkdir -p ../references
python3 json_references.py 110-PT-BN-KP/test/ ../references/test.reader.json word
python3 json_references.py 110-PT-BN-KP/test/ ../references/test.reader.stem.json stem
python3 json_references.py 110-PT-BN-KP/train/ ../references/train.reader.json word
python3 json_references.py 110-PT-BN-KP/train/ ../references/train.reader.stem.json stem
################################################################################

################################################################################
# CLEAN UP
################################################################################
rm -R 110-PT-BN-KP/