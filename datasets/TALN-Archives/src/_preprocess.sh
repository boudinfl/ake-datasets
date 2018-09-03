#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 3 september 2018
# Script for preprocessing TALN-Archives files

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
wget https://github.com/boudinfl/taln-archives/archive/master.zip
unzip master.zip
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p ../test/en/
mkdir -p ../test/fr/

python3 extract.py taln-archives-master/TALN/ ../test/en/ en
python3 extract.py taln-archives-master/TALN/ ../test/fr/ fr
python3 extract.py taln-archives-master/RECITAL/ ../test/en/ en
python3 extract.py taln-archives-master/RECITAL/ ../test/fr/ fr

ls ../test/en/*.txt > ../test.en.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory ../test/en/ \
     -ssplit.newlineIsSentenceBreak two \
     -replaceExtension \
     -filelist ../test.en.filelist

ls ../test/fr/*.txt > ../test.fr.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
	 -props StanfordCoreNLP-french.properties \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory ../test/fr/ \
     -ssplit.newlineIsSentenceBreak two \
     -replaceExtension \
     -filelist ../test.fr.filelist
################################################################################


################################################################################
# References
################################################################################
mkdir -p ../references/en/
mkdir -p ../references/fr/
python3 json_references.py ../test/en/ ../references/en/test.author.json word porter
python3 json_references.py ../test/en/ ../references/en/test.author.stem.json stem porter
python3 json_references.py ../test/fr/ ../references/fr/test.author.json word french
python3 json_references.py ../test/fr/ ../references/fr/test.author.stem.json stem french
################################################################################

rm ../test.en.filelist
rm ../test.fr.filelist
rm ../test/en/*.txt
rm ../test/en/*.key
rm ../test/fr/*.txt
rm ../test/fr/*.key
rm -Rf taln-archives-master
rm master.zip