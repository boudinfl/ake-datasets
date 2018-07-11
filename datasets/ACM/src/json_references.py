#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys
import os
import glob
import json
from nltk.stem.snowball import SnowballStemmer as Stemmer

references = {}

for input_file in glob.glob(sys.argv[1]+'/*.key'):
	file_id = input_file.split('/')[-1].split('.')[0]
	with open(input_file, 'r') as f:
		lines = f.readlines()
		keyphrases = []
		for line in lines:
			words = line.strip().split()
			stems = [Stemmer('porter').stem(w.lower()) for w in words]
			keyphrases.append([' '.join(stems)])
			# keyphrases.append([' '.join([w.lower() for w in words])])
		references[file_id] = keyphrases

with open(sys.argv[2], 'w') as o:
	json.dump(references, o, sort_keys = True, indent = 4)
