#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Convert the JSON file to txt files."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import
from __future__ import with_statement

import sys
import logging
import json
import codecs

from nltk.stem.snowball import SnowballStemmer as Stemmer

logging.basicConfig(level=logging.INFO)

references = {}
stemmed_references = {}

with open(sys.argv[1], 'r') as f:
    for file_number, line in enumerate(f.readlines()):
        document = json.loads(line)
        file_id = '{0:05d}'.format(file_number)
        output_file = sys.argv[2]+'/{}.txt'.format(file_id)

        logging.info("writting file {}".format(output_file))
        with codecs.open(output_file, 'w', 'utf-8') as o:
            o.write(document['title']+"\n\n")
            o.write(document['abstract'])

        references[file_id] = []
        stemmed_references[file_id] = []

        keyphrases = document['keyword'].split(';')
        for keyphrase in keyphrases:
            words = keyphrase.lower().strip().split()
            stems = [Stemmer('porter').stem(w) for w in words]
            references[file_id].append([' '.join(words)])
            stemmed_references[file_id].append([' '.join(stems)])

with open(sys.argv[3], 'w') as o:
    json.dump(references, o, sort_keys = True, indent = 4)

with open(sys.argv[4], 'w') as o:
    json.dump(stemmed_references, o, sort_keys = True, indent = 4)
