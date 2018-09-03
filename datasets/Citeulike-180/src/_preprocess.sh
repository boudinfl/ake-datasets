#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 31 august 2018
# Script for preprocessing reuters21578 files
# ModApte split
# Training Set (9,603 docs): LEWISSPLIT="TRAIN";  TOPICS="YES"
# Test Set (3,299 docs): LEWISSPLIT="TEST"; TOPICS="YES"

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
tar zxvf citeulike180.tar.gz
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p ../test

ls citeulike180/documents/*.txt > test.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory ../test/ \
     -ssplit.newlineIsSentenceBreak two \
     -replaceExtension \
     -filelist test.filelist
################################################################################

################################################################################
# REFERENCES
################################################################################
mkdir -p ../references

python json_references.py citeulike180/taggers/ ../references/test.reader.json word
python json_references.py citeulike180/taggers/ ../references/test.reader.stem.json stem
################################################################################

################################################################################
# CLEAN UP
################################################################################
rm test.filelist
rm -R citeulike180/
rm ../test/2163327.xml