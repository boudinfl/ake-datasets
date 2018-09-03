# -*- coding: utf-8 -*-

"""Pre-process portuguese text files using spacy."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import sys
import glob
import json
import collections
from nltk.stem.snowball import SnowballStemmer as Stemmer

tags = collections.defaultdict(collections.Counter)

for tagger in glob.glob(sys.argv[1]+'/tagger*'):

    # print('Reading tags from {}'.format(tagger))

    for file_id in glob.glob(tagger+'/*.tags'):

        doc_id = file_id.split('/')[-1][:-5]

        # print('Loading {}'.format(doc_id))

        with open(file_id, 'r') as f:
            lines = f.readlines()
            tags[doc_id].update([l.lower().strip() for l in lines])

references = {}

for doc_id in tags:

    # group tags by stem
    stem_to_tag = collections.defaultdict(list)
    for tag in tags[doc_id]:
        stem = [Stemmer('porter').stem(w) for w in tag.split()]
        for _ in range(tags[doc_id][tag]):
            stem_to_tag[' '.join(stem)].append(tag)

    valid_tags = []
    for tag in stem_to_tag:
        if len(stem_to_tag[tag]) > 1:
            valid_tags.append(tag)

    if len(valid_tags):
        if sys.argv[3] == 'stem':
            references[doc_id] = [[t] for t in valid_tags]
        else:
            references[doc_id] = [list(set(stem_to_tag[t])) for t in valid_tags]

    else:
        print("{} should be removed from test because 0 gold".format(doc_id))


with open(sys.argv[2], 'w') as o:
    json.dump(references, o, sort_keys = True, indent = 4)

print(len(references))