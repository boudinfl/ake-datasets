# -*- coding: utf-8 -*-

"""Pre-process portuguese text files using spacy."""

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import re
import sys
import glob
import codecs
from bs4 import BeautifulSoup

language = sys.argv[3]
nb_documents = 0

for input_dir in glob.glob(sys.argv[1]+'/*'):

    input_file = input_dir + '/' + input_dir.split('/')[-1].lower() + '.xml'

    print('Processing {}'.format(input_file))

    with open(input_file, 'r') as f:

        soup = BeautifulSoup(f, "html.parser")
        
        documents = soup.find_all('article')

        for document in documents:

            title = document.titre.text.strip()
            abstract = document.resume.text.strip()
            keywords = document.mots_cles.text.strip()

            if language == "en":
                title = document.title.text.strip()
                abstract = document.abstract.text.strip()
                keywords = document.keywords.text.strip()

            if len(title) and len(abstract) and len(keywords):

                nb_documents += 1

                output_file = sys.argv[2]+'/'+document.attrs["id"]+'.txt'
                print('Writting {}'.format(output_file))
                with codecs.open(output_file, 'w', 'utf-8') as f:
                    f.write(title+'\n\n')
                    f.write(abstract+'\n\n')

                output_file = sys.argv[2]+'/'+document.attrs["id"]+'.key'
                print('Writting {}'.format(output_file))
                keywords = [k.lower().strip() for k in re.split('[,;]', keywords)]
                with codecs.open(output_file, 'w', 'utf-8') as f:
                    f.write('\n'.join(keywords))

    print("{} documents extracted".format(nb_documents))