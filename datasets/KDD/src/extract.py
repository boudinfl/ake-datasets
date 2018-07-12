# -*- coding: utf-8 -*-

"""Extract raw text from (already preprocessed files)."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import os
import codecs
import sys
import logging

logging.basicConfig(level=logging.INFO)

conv = {'-LRB-':'(',
        '-RRB-':')',
        '-LCB-':'{',
        '-RCB-':'}',
        '-LSB-':'[',
        '-RSB-':']'}

with codecs.open(sys.argv[1], 'r', 'utf-8') as f:
    logging.info("extract text from {}".format(sys.argv[1]))
    lines = f.readlines()
    text = []
    for line in lines:
        tokens = line.strip().split()
        if len(tokens):
            untagged_tokens = [token.split('_')[0] for token in tokens]
            untagged_tokens = [conv[u] if u in conv else u for u in untagged_tokens]
            text.append(' '.join(untagged_tokens))

    with codecs.open(sys.argv[2], 'w', 'utf-8') as f2:
        f2.write("\n".join(text))
