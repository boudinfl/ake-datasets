#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Convert references to JSON file."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import


import os
import sys
import glob
import logging
import json
from nltk.stem.snowball import SnowballStemmer as Stemmer

logging.basicConfig(level=logging.INFO)

references = {}

for input_file in glob.glob(sys.argv[1]+'/[0-9]*'):
    file_id = input_file.split('/')[-1].split('.')[0]
    logging.info("loading references from {}".format(file_id))

    with open(input_file, 'r') as f:
        lines = f.readlines()
        keyphrases = []
        for line in lines:
            words = line.strip().split()
            if sys.argv[3] == "stem":
                stems = [Stemmer('porter').stem(w.lower()) for w in words]
                keyphrases.append([' '.join(stems)])
            else:
                keyphrases.append([' '.join([w.lower() for w in words])])
            
        references[file_id] = keyphrases

with open(sys.argv[2], 'w') as o:
    json.dump(references, o, sort_keys = True, indent = 4)
