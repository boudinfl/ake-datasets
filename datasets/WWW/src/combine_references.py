#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Combine JSON reference files."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import sys
import codecs
import logging
import json

logging.basicConfig(level=logging.INFO)


logging.info('loading file {}'.format(sys.argv[1]))
with codecs.open(sys.argv[1], 'r', 'utf-8') as f:
    ref1 = json.load(f)

logging.info('loading file {}'.format(sys.argv[2]))
with codecs.open(sys.argv[2], 'r', 'utf-8') as f:
    ref2 = json.load(f)

doc_ids = set(ref1.keys()) | set(ref2.keys())

references = {}

for file_id in doc_ids:

    references[file_id] = []
    if file_id in ref1:
        references[file_id].extend(ref1[file_id])
    if file_id in ref2:
        references[file_id].extend(ref2[file_id])


with open(sys.argv[3], 'w') as o:
    json.dump(references, o, sort_keys = True, indent = 4)
