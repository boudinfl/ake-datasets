#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 21 august 2018
# Script for preprocessing Wikinews files

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
unzip WikinewsKeyphraseCorpus-master.zip
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p ../test

for FILE in WikinewsKeyphraseCorpus-master/documents/*.html;
do
		DOC_ID=`basename $FILE`
		echo "Processing file $DOC_ID"

		python extract_text.py $FILE ../test/${DOC_ID%.html}.txt
done

ls ../test/*.txt > ../test.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
 	 -props StanfordCoreNLP-french.properties \
      -annotators tokenize,ssplit,pos,lemma \
      -outputDirectory ../test/ \
      -ssplit.newlineIsSentenceBreak two \
      -replaceExtension \
      -filelist ../test.filelist
################################################################################


rm ../test.filelist
rm ../test/*.txt
rm -Rf WikinewsKeyphraseCorpus-master