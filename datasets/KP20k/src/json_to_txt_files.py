"""
Usage : $0 INPUT SPLIT REF_TYPE
Given a jsonl file, create a file per document at "./`split`/", and references at "../references/".
"""

import sys
import json
from tqdm import tqdm
import os
import nltk

stem = nltk.stem.PorterStemmer().stem

ref, ref_s = {}, {}
# Tokenize, stem, join, lower
tsjl = lambda x: ' '.join(map(stem, nltk.word_tokenize(x))).lower()

root = os.path.dirname(__file__)

def process(path, split, ref_type):
    input_file = path.format(split)
    references_dir = os.path.join(root, '..', 'references')
    output_path = references_dir + os.sep + '{}.{}.json'.format(split, ref_type)
    output_path_stem = references_dir + os.sep + '{}.{}.stem.json'.format(split, ref_type)
    output_file_name = os.path.join(root, split, '{}.txt')

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    os.makedirs(os.path.dirname(output_file_name), exist_ok=True)

    with open(input_file) as f:
        # Get the length of the file for tqdm
        length = sum(1 for l in f)
        f.seek(0)
        for line in tqdm(f, total=length, desc=split):
            line = json.loads(line)
            id_ = line['id']
            file_name = output_file_name.format(id_)
            keywords = line['keyword']
            if ';' in keywords:
                keywords = [kw.split(',') for kw in keywords.split(';')]
            ref[id_] = keywords
            ref_s[id_] = [[tsjl(v) for v in kw] for kw in keywords]
            with open(file_name, 'w') as g:
                g.write('\n'.join([line['title'], line['abstract']]))

    with open(output_path, 'w') as g:
        json.dump(ref, g, indent=4)
    with open(output_path_stem, 'w') as g:
        json.dump(ref_s, g, indent=4)


if __name__ == '__main__':
    _, file_path, split, ref_type = sys.argv
    process(file_path, split, ref_type)

