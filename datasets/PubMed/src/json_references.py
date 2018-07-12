# -*- coding: utf-8 -*-

"""Extract raw text from (already preprocessed files)."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import os
import re
import json
import glob
import codecs
import sys
import logging
import pprint
from xml.etree import ElementTree
from nltk.stem.snowball import SnowballStemmer as Stemmer

logging.basicConfig(level=logging.INFO)

references = {}


for document in glob.glob(sys.argv[1]+'/*.xml'):

    doc_id = document.split("/")[-1][:-4]

    with codecs.open(document, 'r', 'utf-8') as f:
        tree = ElementTree.parse(f)
        test = tree.find('./article/front/article-meta/title-group/')
        if test is None:
            logging.info("No title found in {}".format(document))
        else:
            # extract keyphrases
            keyphrases = []
            for child in tree.findall("./article/front/article-meta/kwd-group/"):
                if child.tag == 'kwd':
                    keyword = "".join(list(child.itertext()))
                    keyword = re.sub('\s+', ' ', keyword.strip())
                    words = [w.lower() for w in keyword.split()]
                    if sys.argv[3] == "stem":
                        words = [Stemmer('porter').stem(w.lower()) for w in words]

                    keyphrases.append([" ".join(words)])

            references[doc_id] = keyphrases

with open(sys.argv[2], 'w') as o:
    json.dump(references, o, sort_keys = True, indent = 4)
