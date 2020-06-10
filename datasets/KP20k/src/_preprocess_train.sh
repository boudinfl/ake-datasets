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
if test ! -f "${root}/kp20k.tar"; then
    if test -n "$(which gdown)"; then
        gdown --id "1Z7fgWkmGaVElhH9tuf08p1vVoZBkAKbk" -O "${root}/kp20k.tar"
    else
        echo "Please download data at https://drive.google.com/uc?id=1Z7fgWkmGaVElhH9tuf08p1vVoZBkAKbk&export=download to ${root}."
        echo "You can alternatively install \`gdown\` via pip and relaunch this script. To download automatically."
        exit
    fi
fi

tar -xzvf "${root}/kp20k.tar" -C "${root}"

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

pretreat "${root}/kp20k/kp20k.train.jsonl" "train" "author"

################################################################################
