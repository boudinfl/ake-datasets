# -*- coding: utf-8 -*-

"""Extract raw text from (already preprocessed files)."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import os
import re
import codecs
import sys
import logging
import pprint
from xml.etree import ElementTree

logging.basicConfig(level=logging.INFO)

with codecs.open(sys.argv[1], 'r', 'utf-8') as f:
    tree = ElementTree.parse(f)

test = tree.find('./article/front/article-meta/title-group/')
if test is None:
    logging.info("No title found in {}".format(sys.argv[1]))
    sys.exit(0)

text = []

# extract title
title = tree.findall("./article/front/article-meta/title-group/")[0]
title_text = ''.join(list(title.itertext()))
title_text = re.sub('\s+', ' ', title_text.strip())

text.append(title_text)

test = tree.find('./article/front/article-meta/abstract/')
if test is None:
    logging.info("No abstract found in {}".format(sys.argv[1]))
else:
    # extract abstract
    abstract = tree.findall("./article/front/article-meta/abstract/")[0]
    abstract_text = ''.join(list(abstract.itertext()))
    abstract_text = re.sub('\s+', ' ', abstract_text.strip())
    text.append(abstract_text)

test = tree.find('./article/body/')
if test is None:
    logging.info("No body found in {}".format(sys.argv[1]))
else:
    # extract body
    body = tree.findall("./article/body/")[0]
    body_text = ' '.join(list(body.itertext()))
    body_text = re.sub(' +', ' ', body_text.strip())
    body_text = '\n'.join([u.strip() for u in body_text.split('\n')])
    text.append(body_text)

with codecs.open(sys.argv[2], 'w', 'utf-8') as f:
    f.write("\n".join(text))
