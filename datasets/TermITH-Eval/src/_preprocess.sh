#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 21 august 2018
# Script for preprocessing NUS files

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
# unzip TermITH-Eval-master.zip
################################################################################

################################################################################
# TEST split
################################################################################
# mkdir -p ../test

# for CORPUS in TermITH-Eval-master/corpus*;
# do
# 	echo "Processing $CORPUS"
# 	for FILE in $CORPUS/*.xml;
# 	do
# 		DOC_ID=`basename $FILE`
# 		echo "Processing file $DOC_ID"

# 		python3 extract.py $FILE ../test/${DOC_ID%.xml}.txt ../test/${DOC_ID%.xml}.key
# 	done
# done

# ls ../test/*.txt > ../test.filelist

# java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
# 	 -props StanfordCoreNLP-french.properties \
#      -annotators tokenize,ssplit,pos,lemma \
#      -outputDirectory ../test/ \
#      -ssplit.newlineIsSentenceBreak two \
#      -replaceExtension \
#      -filelist ../test.filelist
################################################################################


# ################################################################################
# # References
# ################################################################################
mkdir -p ../references
python3 json_references.py ../test/ ../references/test.indexer.json word
python3 json_references.py ../test/ ../references/test.indexer.stem.json stem
# ################################################################################

rm ../test.filelist
rm ../test/*.txt
rm ../test/*.key
rm -Rf TermITH-Eval-master