# Benchmark datasets for keyphrase extraction

This repository contains a large, curated set of benchmark datasets for
evaluating automatic keyphrase extraction algorithms. These datasets are all
pre-processed using the Stanford CoreNLP suite and are available in XML format.

## Dataset format

All datasets are stored according to the following, common structure:

    dataset/
           /test/       <- test documents
           /train/      <- training documents (if available)
           /dev/        <- validation documents (if available)
           /src/        <- everything used to build the dataset
           /references/ <- reference keyphrases in json format

## Reference (gold annotation) format

Reference keyphrases, used for evaluating automatic keyphrase extraction
algorithms, are available in json format and named according to the following
rules: `[split].[annotator].[stem]?.json`

where

* `split` corresponds to the dataset split: test, train or dev
* `annotator` is the type of annotation: author, reader, combined, contr (controlled vocabulary), uncontr (free annotation)
* `stem` (optional) indicates that stemming (using nltk Porter algorithm) is applied on reference keyphrases.

Below is a an example of reference file format:

    {
        "doc-1": [
            [
                "target detect"
            ],
            [
                "number of sensor",
                "sensor number"
            ]
        ],
        ...
    }

## Available datasets

| dataset                | lang | nature       | train | dev | test | Annotation  | #kp (test) | #words (test) |
| ---------------------- | ---- | ------------ | ----: | --: | ---: | ----------: | ---------: | ------------: |
| CSTR [1]               | en   | Full papers  | 130   | -   | 500  | A           | 5.4        | 11501.4       |
| NUS [3]                | en   | Full papers  | -     | -   | 211  | A+R         | 11.0       | 8398.3        |
| PubMed [5]             | en   | Full papers  | -     | -   | 1320 | A           | 5.4        | 820.6         |
| ACM [6]                | en   | Full papers  | -     | -   | 2304 | A           | 5.3        | 9197.6        |
| Citeulike-180 [13]     | en   | Full papers  | -     | -   | 182  | R           | 5.4        | 8589.7        |
| SemEval-2010 [10]      | en   | Full papers  | 144   | -   | 100  | A+R         | 14.7       | 7961.2        |
| Inspec [2]             | en   | Abstracts    | 1000  | 500 | 500  | I (uncontr) | 9.8        | 134.6         |
| TALN-Archives [14]     | en/fr | Abstracts   | -     | -   | 521/1207 | A       | 4.0/4.1    | 123.1/141.0   |
| KDD [9]                | en   | Abstracts    | -     | -   | 755  | A           | 4.1        | 190.7         |
| WWW [9]                | en   | Abstracts    | -     | -   | 1330 | A           | 4.8        | 163.5         |
| KP20k [15]             | en   | Abstracts    | 530,809 | 20,000 | 20,000 | A    | 5.3        | 158.0         |
| TermITH-Eval [11]      | fr   | Abstracts    | -     | -   | 400  | I           | 11.8       | 164.7         |
| DUC-2001 [4]           | en   | News         | -     | -   | 308  | R           | 8.1        | 847.2         |
| 500N-KPCrowd [7]       | en   | News         | 450   | -   | 50   | R           | 46.2       | 465.3         |
| 110-PT-BN-KP [12]      | pt   | News         | 100   | -   | 10   | R           | 27.6       | 439.4         |
| Wikinews-Keyphrase [8] | fr   | News         | -     | -   | 100  | R           | 9.7        | 313.6         |


Annotation for gold keyphrases are performed by authors (A), readers (R) or
professional indexers (I).


## References

1. **KEA: Practical automatic keyphrase extraction.**
   Witten, I. H., Paynter, G. W., Frank, E., Gutwin, C., & Nevill-Manning, C. G.
   *In Proceedings of the fourth ACM conference on Digital libraries.*
   p. 254-255. 1999.

2. **Improved automatic keyword extraction given more linguistic knowledge.**
   Anette Hulth.
   *In Proceedings of EMNLP 2003.*
   p. 216-223.

3. **Keyphrase Extraction in Scientific Publications.**
   Thuy Dung Nguyen and Min-Yen Kan.
   *In Proceedings of International Conference on Asian Digital Libraries 2007.*
   p. 317-326.

4. **Single Document Keyphrase Extraction Using Neighborhood Knowledge.**
   Xiaojun Wan and Jianguo Xiao.
   *In Proceedings of AAAI 2008.*
   pp. 855-860.

5. **Keyphrase extraction from single documents in the open domain exploiting
   linguistic and statistical methods.**
   Alexander Thorsten Schutz. 
   *Master's thesis, National University of Ireland (2008).*

6. **Large dataset for keyphrases extraction.**
   Krapivin, M., Autaeu, A., & Marchese, M. (2009). 
   *University of Trento.*

7. **Supervised Topical Key Phrase Extraction of News Stories using
   Crowdsourcing, Light Filtering and Co-reference Normalization.**
   Marujo, L., Gershman, A., Carbonell, J., Frederking, R., & Neto, J. P.
   *In Proceedings of LREC 2012.*

8. **TopicRank: Graph-Based Topic Ranking for Keyphrase Extraction.**
   Adrien Bougouin, Florian Boudin, Béatrice Daille.
   *In Proceedings of the International Joint Conference on Natural Language
   Processing (IJCNLP), 2013.*

9. **Citation-Enhanced Keyphrase Extraction from Research Papers: A Supervised
   Approach.**
   Cornelia Caragea, Florin Bulgarov, Andreea Godea and Sujatha Das Gollapalli.
   *In Proceedings of EMNLP 2014.*
   pp. 1435-1446.

10. **How Document Pre-processing affects Keyphrase Extraction Performance.**
    Florian Boudin, Hugo Mougard and Damien Cram.
    *COLING 2016 Workshop on Noisy User-generated Text (WNUT).*

11. **TermITH-Eval: a French Standard-Based Resource for Keyphrase Extraction
    Evaluation.**
    Adrien Bougouin, Sabine Barreaux, Laurent Romary, Florian Boudin and​
    Béatrice Daille.
    *Language Resources and Evaluation Conference (LREC), 2016.*

12. **Keyphrase Cloud Generation of Broadcast News.**
    Luis Marujo, Márcio Viveiros, João Paulo da Silva Neto.
    *In Proceedings of Interspeech 2011.*

13. **Human-competitive tagging using automatic keyphrase extraction.**
    O. Medelyan, E. Frank, I. H. Witten.
    *In Proceedings of EMNLP 2009.*

14. **TALN Archives: a digital archive of French research articles in Natural
    Language Processing.**
    Florian Boudin.
    *In Proceedings of TALN 2013.*

15. **Deep Keyphrase Generation.**
    R. Meng, S. Zhao, S. Han, D. He, P. Brusilovsky, Y. Chi.
    *In Proceedings of ACL 2017*