#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Convert references to JSON file."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import
from __future__ import with_statement

import re
import os
import sys
import glob
import logging
import json
from nltk.stem.snowball import SnowballStemmer as Stemmer

logging.basicConfig(level=logging.INFO)

references = {}
readers_references = {}
author_references = {}

for input_dir in glob.glob(sys.argv[1]+'/[0-9]*'):
    file_id = input_dir.split('/')[-1].split('.')[0]
    logging.info("loading author-assigned references from {}".format(file_id))

    author_references[file_id] = []

    try:
        with open(input_dir+"/"+file_id+".kwd", 'r', errors='replace') as f:
            text = f.read()
            text = text.replace(u"\uFFFD", "\n")
            text = re.sub(r'\n+', '\n', text).strip()
            lines = text.split("\n")

            keyphrases = []
            for line in lines:
                words = line.strip().split()
                if sys.argv[3] == "stem":
                    stems = [Stemmer('porter').stem(w.lower()) for w in words]
                    keyphrases.append(' '.join(stems))
                else:
                    keyphrases.append(' '.join([w.lower() for w in words]))

            author_references[file_id] = keyphrases
    except IOError:
        logging.info("No author-assigned references for {}".format(file_id))

    readers_references[file_id] = []

    for reader_file in glob.glob(input_dir+'/KEY/*.key'):
        logging.info("loading reader-assigned references from {}".format(reader_file))

        with open(reader_file, 'r', errors='replace') as f:
            text = f.read()
            text = text.replace(u"\uFFFD", "\n")
            text = re.sub(r'\n+', '\n', text).strip()
            lines = text.split("\n")

            keyphrases = []
            for line in lines:
                words = line.strip().split()
                if sys.argv[3] == "stem":
                    stems = [Stemmer('porter').stem(w.lower()) for w in words]
                    keyphrases.append(' '.join(stems))
                else:
                    keyphrases.append(' '.join([w.lower() for w in words]))

            for keyphrase in keyphrases:
                readers_references[file_id].append(keyphrase)

if sys.argv[4] == "author":
    for doc_id in author_references:
        references[doc_id] = [[u] for u in set(author_references[doc_id])]
elif sys.argv[4] == "reader":
    for doc_id in readers_references:
        references[doc_id] = [[u] for u in set(readers_references[doc_id])]
else:
    for doc_id in readers_references:
        references[doc_id] = [[u] for u in set(readers_references[doc_id])| set(author_references[doc_id])]

with open(sys.argv[2], 'w') as o:
    json.dump(references, o, sort_keys = True, indent = 4)
