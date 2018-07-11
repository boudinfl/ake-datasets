#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys
import os
import glob
import json
from nltk.stem.snowball import SnowballStemmer as Stemmer

extension = sys.argv[3]
references = {}

for input_file in glob.glob(sys.argv[1]+'/*.'+extension):
	file_id = input_file.split('/')[-1].split('.')[0]
	with open(input_file, 'r') as f:
		lines = f.readlines()
		text = ' '.join(lines).strip()
		text = re.sub('\s+', ' ', text)
		keyphrases = text.split(';')
		for i, keyphrase in enumerate(keyphrases):
			words = keyphrase.strip().split()
			stems = [Stemmer('porter').stem(w.lower()) for w in words]
			if sys.argv[4] == "True":
				keyphrases[i] = ' '.join(stems)
			else:
				keyphrases[i] = ' '.join(words).lower()

		references[file_id] = [[k] for k in keyphrases]

with open(sys.argv[2], 'w') as o:
	json.dump(references, o, sort_keys = True, indent = 4)
