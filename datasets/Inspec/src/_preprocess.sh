#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr)
# 11 july 2017
# Script for preprocessing Inspec files

PATH_CORENLP=/nlp/stanford-corenlp-full-2016-10-31

################################################################################
# Prepare data
################################################################################
tar zxvf Hulth2003.tar.gz
unzip Hulth2003/Test.zip -d Testing
unzip Hulth2003/Training.zip -d Training
unzip Hulth2003/Validation.zip -d Validation
################################################################################

################################################################################
# TEST split
################################################################################
mkdir -p test

# add a line break to make sure the title is not merged into first sentence
for FILE in Testing/*.abstr;
do
	python pre-document.py $FILE $FILE.clean
done

ls Testing/*.clean > Testing.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory test/ \
     -ssplit.newlineIsSentenceBreak always \
     -filelist Testing.filelist

# java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
#      -annotators tokenize,ssplit,pos,lemma \
#      -outputDirectory test/ \
#      -ssplit.newlineIsSentenceBreak always \
#      -outputFormat json \
#      -filelist Testing.filelist

rm Testing.filelist
rm Testing/*.clean

for FILE in test/*.abstr.clean.xml
do
    mv $FILE ${FILE%.abstr.clean.xml}.xml
done

# for FILE in test/*.abstr.clean.json
# do
#     mv $FILE ${FILE%.abstr.clean.json}.json
# done
################################################################################

################################################################################
# DEV split
################################################################################
mkdir -p dev

# add a line break to make sure the title is not merged into first sentence
for FILE in Validation/*.abstr;
do
	python pre-document.py $FILE $FILE.clean
done

ls Validation/*.clean > Validation.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory dev/ \
     -ssplit.newlineIsSentenceBreak always \
     -filelist Validation.filelist

# java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
#      -annotators tokenize,ssplit,pos,lemma \
#      -outputDirectory dev/ \
#      -ssplit.newlineIsSentenceBreak always \
#      -outputFormat json \
#      -filelist Validation.filelist

rm Validation.filelist
rm Validation/*.clean

for FILE in dev/*.abstr.clean.xml
do
    mv $FILE ${FILE%.abstr.clean.xml}.xml
done

# for FILE in dev/*.abstr.clean.json
# do
#     mv $FILE ${FILE%.abstr.clean.json}.json
# done
################################################################################

################################################################################
# TRAIN split
################################################################################
mkdir -p train

# add a line break to make sure the title is not merged into first sentence
for FILE in Training/*.abstr;
do
	python pre-document.py $FILE $FILE.clean
done

ls Training/*.clean > Training.filelist

java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
     -annotators tokenize,ssplit,pos,lemma \
     -outputDirectory train/ \
     -ssplit.newlineIsSentenceBreak always \
     -filelist Training.filelist

# java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
#      -annotators tokenize,ssplit,pos,lemma \
#      -outputDirectory train/ \
#      -ssplit.newlineIsSentenceBreak always \
#      -outputFormat json \
#      -filelist Training.filelist

rm Training.filelist
rm Training/*.clean

for FILE in train/*.abstr.clean.xml
do
    mv $FILE ${FILE%.abstr.clean.xml}.xml
done

# for FILE in train/*.abstr.clean.json
# do
#     mv $FILE ${FILE%.abstr.clean.json}.json
# done
################################################################################

################################################################################
# REFERENCES
################################################################################

mkdir -p references

python json_references.py Testing/ references/test.uncontr.stem.json uncontr True
python json_references.py Testing/ references/test.contr.stem.json contr True
python json_references.py Training/ references/train.uncontr.stem.json uncontr True
python json_references.py Training/ references/train.contr.stem.json contr True
python json_references.py Validation/ references/dev.uncontr.stem.json uncontr True
python json_references.py Validation/ references/dev.contr.stem.json contr True

python json_references.py Testing/ references/test.uncontr.json uncontr False
python json_references.py Testing/ references/test.contr.json contr False
python json_references.py Training/ references/train.uncontr.json uncontr False
python json_references.py Training/ references/train.contr.json contr False
python json_references.py Validation/ references/dev.uncontr.json uncontr False
python json_references.py Validation/ references/dev.contr.json contr False


################################################################################
# CLEAN UP
################################################################################
rm -R Testing/
rm -R Training/
rm -R Validation/
rm -R Hulth2003/
mv test ../test
mv train ../train
mv dev ../dev
mv references ../references

