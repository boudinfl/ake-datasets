#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 12 july 2018
# Script for preprocessing PubMedEvaluation files

PATH_CORENLP=/nlp/stanford-corenlp-full-2018-02-27

################################################################################
# Prepare data
################################################################################
unzip quantitative-evaluation-dataset.zip -d quantitative-evaluation-dataset/
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p ../test
mkdir -p ../xml

for FILE in quantitative-evaluation-dataset/*.xml;
do
	
	DOC_ID=`basename $FILE .xml`
	PMID=$(echo $DOC_ID | grep -Eo '[0-9]+$')
	if [ ! -f ../xml/$DOC_ID.xml ]; then
		echo "info - wgetting ../test/$DOC_ID.xml"
		wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc\&id=$PMID -O ../xml/$DOC_ID.xml
	fi

	if [ ! -f ../test/$DOC_ID.txt ]; then
		python3 extract.py ../xml/$DOC_ID.xml ../test/$DOC_ID.txt
	fi

done

ls ../test/*.txt > ../test.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory ../test/ \
     -ssplit.newlineIsSentenceBreak always \
     -replaceExtension \
     -filelist ../test.filelist
################################################################################


################################################################################
# References
################################################################################
mkdir -p ../references
python3 json_references.py ../xml/ ../references/test.author.json word
python3 json_references.py ../xml/ ../references/test.author.stem.json stem
################################################################################

rm ../test.filelist
rm ../test/*.txt
rm -Rf ../xml
rm -Rf quantitative-evaluation-dataset