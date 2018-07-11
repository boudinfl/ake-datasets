#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 21 june 2017
# Script for preprocessing krapivin files

PATH_CORENLP=$PATH_NLP/stanford-corenlp-full-2016-10-31


# mkdir -p test

# ls all_docs_abstacts_refined/*.txt > test.filelist

# java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
#      -annotators tokenize,ssplit,pos,lemma \
#      -outputDirectory test/ \
#      -ssplit.eolonly true \
#      -filelist Test.filelist

# rm test.filelist

# for FILE in test/*.txt.xml
# do
#     mv $FILE ${FILE%.txt.xml}.xml
# done

mkdir -p references

python src/json_references.py all_docs_abstacts_refined/ references/test.author.stem.json
