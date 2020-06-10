#!/bin/bash

# Florian Boudin (florian.boudin@univ-nantes.fr) & Ygor Gallina (ygor.gallina@univ-nantes.fr)
# 8 july 2020
# Script for preprocessing KP20k files

set -e

if test "$PATH_CORENLP" = ""
then
    echo "\$PATH_CORENLP is not defined. Download StanfordCoreNLP from https://stanfordnlp.github.io/CoreNLP/download.html"
    exit
fi

# Get path to this file
root=$(python3 -c "import os.path as p; print(p.dirname(p.realpath('$0')))")

################################################################################
# Prepare data
################################################################################
# Download data
if test "$(find "${root}" -name 'KPTimes.*.jsonl.gz' | wc -l)" -ne "3"; then
    if test -n "$(which gdown)"; then
        test -f "${root}/KPTimes.test.jsonl.gz"  || gdown --id "1LSREXfJxAK2jbzzvXYUvXufPdvL_Aq1J" -O "${root}/KPTimes.test.jsonl.gz"
        test -f "${root}/KPTimes.valid.jsonl.gz" || gdown --id "1XgVZbIw0Cbs2ZczBj2-tUKg3Z2whi5Zm" -O "${root}/KPTimes.valid.jsonl.gz"
        test -f "${root}/KPTimes.train.jsonl.gz" || gdown --id "12chZA87VUviFyOh1qWs8DI33hbjKsKiv" -O "${root}/KPTimes.train.jsonl.gz"
    else
        echo "Please download data at:"
        test -f "${root}/KPTimes.test.jsonl.gz"  || echo "  - Test   (30Mo): https://drive.google.com/open?id=1LSREXfJxAK2jbzzvXYUvXufPdvL_Aq1J"
        test -f "${root}/KPTimes.valid.jsonl.gz" || echo "  - Valid  (19Mo): https://drive.google.com/open?id=1XgVZbIw0Cbs2ZczBj2-tUKg3Z2whi5Zm"
        test -f "${root}/KPTimes.train.jsonl.gz" || echo "  - Train (474Mo): https://drive.google.com/open?id=12chZA87VUviFyOh1qWs8DI33hbjKsKiv"
        echo "And place it at \"${root}\""
        echo "You can alternatively install \`gdown\` via pip to download automatically and relaunch this script."
        exit
    fi
fi

echo "Unzipping ..."

gzip -d -c "${root}/KPTimes.test.jsonl.gz" > "${root}/KPTimes.test.jsonl"
gzip -d -c "${root}/KPTimes.valid.jsonl.gz" > "${root}/KPTimes.valid.jsonl"
gzip -d -c "${root}/KPTimes.train.jsonl.gz" > "${root}/KPTimes.train.jsonl"

################################################################################

################################################################################
# Process each split
################################################################################

pretreat() { # input_file split ref_type
    input_file="$1"
    split="$2"
    ref_type="$3"
    file_list="${root}/${split}.filelist"
    python3 "${root}/json_to_txt_files.py" "${input_file}" "${split}" "${ref_type}"
    find "${root}/${split}" -name '*.txt' > "${file_list}"
    java -cp "$PATH_CORENLP/*" -Xmx2g edu.stanford.nlp.pipeline.StanfordCoreNLP \
        -annotators tokenize,cleanxml,ssplit,pos,lemma \
        -outputDirectory "${root}/../${split}/" \
        -ssplit.newlineIsSentenceBreak two \
        -replaceExtension \
        -filelist "${file_list}"
    rm -rf "${root}/${split}"
    rm "${file_list}"
}

echo "Training dataset will not be processed with CoreNLP as it is rarely used and takes approx. 1.5 hour."
echo "To process it please run \`datasets/KPTimes/_preprocess_train.sh\`"

pretreat "${root}/KPTimes.test.jsonl" "test" "editor"
pretreat "${root}/KPTimes.valid.jsonl" "valid" "editor"
#pretreat "${root}/KPTimes.train.jsonl" "train" "editor"

################################################################################
