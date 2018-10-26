#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 21 august 2018
# Script for preprocessing NUS files

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
# wget https://drive.google.com/uc?id=1ZTQEGZSq06kzlPlOv4yGjbUpoDrNxebR&export=download
# unzip kp20k_new.zip
################################################################################

################################################################################
# TEST split
################################################################################
# mkdir -p ../test
# mkdir -p ../references

# python3 json_to_txt_files.py kp20k_testing.json ../test/ ../references/test.author.json ../references/test.author.stem.json

# find ../test/ -name "*.txt" -exec ls {} \; > ../test.filelist

# java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
#      -annotators tokenize,ssplit,pos,lemma \
#      -outputDirectory ../test/ \
#      -ssplit.newlineIsSentenceBreak two \
#      -replaceExtension \
#      -filelist ../test.filelist

################################################################################

# rm ../test.filelist
# find ../test/ -name "*.txt" -exec rm {} \;

# zip -r ../test.zip ../test
# rm kp20k_testing.json
# rm kp20k_training.json
# rm kp20k_validation.json
