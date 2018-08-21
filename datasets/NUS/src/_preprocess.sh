#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 21 august 2018
# Script for preprocessing NUS files

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
unzip Nguyen2007.zip
################################################################################

# Patching file with no gold references
sed -i.back -e '19,21d' data/180/180.xml 
echo -e "Simulation of multivariate integrations\nMonte Carlo and Quasi-Monte Carlo methods\nLattice rules\nOption Pricing" > data/180/180.kwd

sed -i.back -e '14,15d' data/190/190.xml 
echo -e "Knowledge Engineering\nSemantic Web\nTopic Maps" > data/190/190.kwd

################################################################################
# TEST split
################################################################################
mkdir -p ../test

for DOC_DIR in data/[0-9]*;
do
	DOC_ID=`basename $DOC_DIR`
	echo $DOC_ID

	TITLE1=`head -1 $DOC_DIR/$DOC_ID.txt`
	TITLE2=`./pdftitle $DOC_DIR/$DOC_ID.pdf`
	OUTPUT=../test

	if [ ${#TITLE1} -gt ${#TITLE2} ]
	then
		echo "$TITLE1" > ../test/$DOC_ID.txt
	else
		echo "$TITLE2" > ../test/$DOC_ID.txt
	fi

	echo "" >> ../test/$DOC_ID.txt
	cat $DOC_DIR/$DOC_ID.xml >> ../test/$DOC_ID.txt

done

ls ../test/*.txt > ../test.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,cleanxml,ssplit,pos,lemma \
     -outputDirectory ../test/ \
     -ssplit.newlineIsSentenceBreak two \
     -replaceExtension \
     -filelist ../test.filelist
################################################################################


################################################################################
# References
################################################################################
mkdir -p ../references
python3 json_references.py data/ ../references/test.author.json raw author
python3 json_references.py data/ ../references/test.author.stem.json stem author
python3 json_references.py data/ ../references/test.reader.json raw reader
python3 json_references.py data/ ../references/test.reader.stem.json stem reader
python3 json_references.py data/ ../references/test.combined.json raw combined
python3 json_references.py data/ ../references/test.combined.stem.json stem combined
################################################################################

rm ../test.filelist
rm ../test/*.txt
rm -Rf data