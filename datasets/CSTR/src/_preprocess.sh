#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 11 july 2017
# Script for preprocessing cstr files

PATH_CORENLP=/nlp/stanford-corenlp-full-2016-10-31

################################################################################
# Prepare data
################################################################################
tar zxvf CSTR.tar.gz
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p test

ls kea-data-text/test/*.txt > test.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory test/ \
     -ssplit.newlineIsSentenceBreak two \
     -replaceExtension True \
     -filelist test.filelist

rm test.filelist
################################################################################

################################################################################
# TRAIN split
################################################################################
mkdir -p train

ls kea-data-text/train/*.txt > train.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory train/ \
     -ssplit.newlineIsSentenceBreak two \
     -replaceExtension True \
     -filelist train.filelist

rm train.filelist
################################################################################


################################################################################
# REFERENCES
################################################################################
mkdir -p references

python json_references.py kea-data-text/test/ references/test.author.stem.json True
python json_references.py kea-data-text/train/ references/train.author.stem.json True

python json_references.py kea-data-text/test/ references/test.author.json False
python json_references.py kea-data-text/train/ references/train.author.json False
################################################################################

################################################################################
# CLEAN UP
################################################################################
rm -R kea-data-text/
mv test ../test
mv train ../train
mv references ../references