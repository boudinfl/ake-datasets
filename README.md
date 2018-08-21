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

| dataset                | lang | nature       | train | dev | test | gold keyphrases            | keys/doc (test) |
| ---------------------- | ---- | ------------ | -----:| ---:| ----:| --------------------------:| --------------: |
| CSTR [1]               | en   | Full papers  | 130   | -   | 500  | authors                    | 5.4             |
| SemEval-2010 [10]      | en   | Full papers  | 144   | -   | 100  | authors, readers, combined | 3.9, 12.0, 14.7 |
| PubMed [5]             | en   | Full papers  | -     | -   | 1320 | authors                    | 5.4             |
| NUS [3]                | en   | Full papers  | -     | -   | 211  | authors, readers, combined | 4.2, 7.6, 11.0  |
| Inspec [2]             | en   | Abstracts    | 1000  | 500 | 500  | indexers (contr, uncontr)  | 4.5, 9.8        |
| ACM [6]                | en   | Abstracts    | -     | -   | 2304 | authors                    | 5.3             |
| KDD [9]                | en   | Abstracts    | -     | -   | 755  | authors                    | 4.1             |
| WWW [9]                | en   | Abstracts    | -     | -   | 1330 | authors, extra, combined   | 4.8, 4.2, 6.2   |
| DUC-2001 [4]           | en   | News         | -     | -   | 308  | readers                    | 8.1             |
| 500N-KPCrowd [7]       | en   | News         | 450   | -   | 50   | readers                    | 46.2            |
| Wikinews-Keyphrase [8] | fr   | News         | -     | -   | 100  | readers                    | 9.7             |


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











