# -*- coding: utf-8 -*-

"""Extract raw text from TEI files."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import os
import re
import codecs
import sys
import logging

from bs4 import BeautifulSoup

logging.basicConfig(level=logging.INFO)

with codecs.open(sys.argv[1], 'r', 'utf-8') as f:

    soup = BeautifulSoup(f, "html.parser")
    title = soup.find('title', {"type": "main", "xml:lang": "fr"})
    abstract = soup.find('abstract', {"xml:lang": "fr"})
    keywords = soup.find('keywords', {"xml:lang": "fr"})

    with codecs.open(sys.argv[2], 'w', 'utf-8') as f:
        f.write(title.text+'\n'+abstract.text)

    with codecs.open(sys.argv[3], 'w', 'utf-8') as f:
        f.write(keywords.text.strip())
