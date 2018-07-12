#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 11 july 2018
# Script for preprocessing KDD files

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
tar -zxvf kpdata.tgz kpdata/WWW/gold
tar -zxvf kpdata.tgz kpdata/WWW/gold2
tar -zxvf kpdata.tgz kpdata/WWW/abstracts
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p ../test

for FILE in kpdata/WWW/abstracts/[0-9]*;
do
	# check if there are references for this file
	if [ ! -f kpdata/WWW/gold/`basename $FILE` ]
	then
		echo "info - no gold references for $FILE"
	else
		python extract.py $FILE ../test/`basename $FILE`.txt
	fi
done

ls ../test/*.txt > ../test.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory ../test/ \
     -ssplit.newlineIsSentenceBreak always \
     -tokenize.whitespace true \
     -replaceExtension \
     -filelist ../test.filelist
################################################################################


################################################################################
# References
################################################################################
mkdir -p ../references
python3 json_references.py kpdata/WWW/gold/ ../references/test.author.json word
python3 json_references.py kpdata/WWW/gold/ ../references/test.author.stem.json stem
python3 json_references.py kpdata/WWW/gold2/ ../references/test.extra.json word
python3 json_references.py kpdata/WWW/gold2/ ../references/test.extra.stem.json stem
python3 combine_references.py ../references/test.author.json ../references/test.extra.json ../references/test.combined.json
python3 combine_references.py ../references/test.author.stem.json ../references/test.extra.stem.json ../references/test.combined.stem.json
################################################################################

rm ../test.filelist
rm ../test/*.txt
rm -Rf kpdata