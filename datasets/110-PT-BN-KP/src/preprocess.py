# -*- coding: utf-8 -*-

"""Pre-process portuguese text files using spacy."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import re
import sys
import codecs
import spacy
# from spacy.lang.pt.examples import sentences

with codecs.open(sys.argv[1], 'r', 'iso-8859-1') as f:

    text = f.read()
    nlp = spacy.load('pt_core_news_sm')

    text = re.sub('\s+', ' ', text).strip()

    doc = nlp(text)



    xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
    xml += '<?xml-stylesheet href="CoreNLP-to-HTML.xsl" type="text/xsl"?>\n'
    xml += '<root>\n'
    xml += '  <document>\n'
    xml += '    <sentences>\n'

    for sentence_id, sentence in enumerate(doc.sents):
        xml += '      <sentence id="{}">\n'.format(sentence_id+1)
        xml += '        <tokens>\n'
        for token_id, token in enumerate(sentence):
            xml += '          <token id="{}">\n'.format(token_id+1)
            xml += '            <word>{}</word>\n'.format(token.text)
            xml += '            <lemma>{}</lemma>\n'.format(token.lemma_)
            xml += '            <POS>{}</POS>\n'.format(token.pos_)
            xml += '            <CharacterOffsetBegin>{}</CharacterOffsetBegin>\n'.format(token.idx)
            xml += '            <CharacterOffsetEnd>{}</CharacterOffsetEnd>\n'.format(token.idx+len(token.text))
            xml += '          </token>\n'
        xml += '        </tokens>\n'
        xml += '      </sentence>\n'

    xml += '    </sentences>\n'
    xml += '  </document>\n'
    xml += '</root>'

    print(xml)