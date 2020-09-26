---
title: 'tipitaka: An R package for analyzing the Pali Canon'
tags:
  - R
  - Tipitaka
  - Pali
  - Buddhism
authors:
  - name: Dan Zigmond
    orcid: 0000-0001-7138-5612
    affiliation: 1 
affiliations:
 - name: Jikoji Zen Center, Los Gatos, CA
   index: 1
date: September 26, 2020
bibliography: references.bib
---

# Summary

The *Tipiṭaka* or Pali Canon is the canonical scripture of Theravadin Buddhists worldwide. It purports to record the direct teachings of the historical Buddha. It was first recorded in written form in what is now Sri Lanka, likely around 100 BCE, in the Pali language, a Middle Indo-Aryan dialect. The goal of the `tipitaka` package is to make these texts available to students and researchers and allow them to apply the tools of computational linguistics using R. 

# Statement of need 

The title itself of the Pali Canon, *Tipiṭaka*, can be translated roughly as “three baskets” and the Canon is composed of three distinct sets of scriptures: 

*	*Vinaya Piṭaka*, Basket of Discipline, describing the rules for the Buddhist monastic order.
*	*Sutta Piṭaka*, Basket of Discourses, primarily recounting the direct teachings of the Buddha.
*	*Abhidhamma Piṭaka*, Basket of Special Teachings,  summarizing and systematizing the Buddha’s teachings.

Each of these is composed of several books, which in turn are often divided into chapters and verses. The *Sutta Piṭaka* is the most widely studied and so its divisions have particular significance. It contains four major collections of *suttas* or discourses (*Dīgha Nikāya*, *Majjhima Nikāya*, *Saṃyutta Nikāya*, and *Aṅguttara Nikāya*), plus a fifth collection (*Khuddaka Nikāya*) with a wide variety of generally shorter material. 

Although the *Tipiṭaka* has been studied for nearly 2,000 years, it is not widely available in electronic form. The Pali Text Society (PTS) began publishing the Canon in Roman-script editions in the late 19th century [@PTS]. While these have become the standard reference for Western scholarship, they are not available electronically. In part for this reason, there are few published studies using the techniques of modern text mining and computational linguistics applied to these texts.

The version of the *Tipiṭaka* included here is based the Chattha Sangāyana Tipiṭaka version 4.0 (CST4) published by the Vipassana Research Institute and received from them in April 2020 [@VRI]. This edition originated at the Sixth Buddhist Council, held in Burma from 1954 to 1956. Originally published after the Council meetings in Burmese script, the Vipassana Research Institute in India began printing this edition in Devanagari and eventually Roman (and several other) scripts in 1990 and later published the results electronically as well. While the Vipassana Research Institute maintains interactive web-based access to these files, they cannot easily be downloaded for computational analysis. The `tipitaka` aims to rectify this.

# Package contents

The `tipitaka` package primarily consists of the texts of the Tipitaka in various electronic forms, plus a few simple functions and data structures for working with the Pali language. 

I have made a few edits to the CST4 files in creating this package:

* Where volumes were split across multiple files, they are here are combined as a single volume.

* Where volume numbering was inconsistent with the widely-used PTS scheme, I have tried to conform with PTS (but see below for exceptions).

* A very few typos that were found while processing have been corrected.

There is no universal script for Pali. Traditionally each Buddhist country ususes its own script to write Pali phonetically: in Thai script in Thailand, Burmese in Burma, Sinhalese in Sri Lanka, etc. This package uses the Roman script and the diacritical system developed by the PTS, based on the system commonly used for transliterating Sanskrit. 

The contents are organized into the following data structures:

* `tipitaka_raw`: the complete text of the *Tipiṭaka*.
* `tipitaka_long`: the complete *Tipiṭaka* in "long" form
* `tipitaka_wide`: the complete *Tipiṭaka* in "wide" form
* `tipitaka_names`: the names and abbreviation of each book of the *Tipiṭaka*
* `sutta_pitaka`: the names and abbreviations of each volume of the S*utta Pitaka*
* `vinaya_pitaka`: the names and abbrviation of each volume of the *Vinaya Pitaka*
* `abhidhamma_pitaka`: the names of each volume of the *Abhidhamma Pitaka*
* `sati_sutta_raw`: the somplete text of the *Mahāsatipatthāna Sutta*
* `sati_sutta_long`: the *Mahāsatipatthāna Sutta* in "long" form

The `_raw` forms are the unparsed text of the *Tipiṭaka*, with each volume provided as a separate row. The `_long` forms process the texts such that each row provides the count of one unique Pali word in one volume of the *Tipiṭaka*. For example, the first three rows are:

|     book  |  word |    n |  total |      freq |
|-----------|-------|------|--------|-----------|
| Abh.VII | paccayo | 13836 | 377230 | 0.03667789 |
| Abh.VII |     pe | 12912 | 377230 | 0.03422845
| Abh.VII |  dhammo | 12880 | 377230 | 0.03414363

This tell us that the word *paccayo* (cause; motive) occurs in the seventh volume of the *Abhidhamma* 13,836 times and represents roughly 3.7% of all words in that volume. This can be useful in creating "wordclouds" and other representations of word frequency per volume.

The `_wide` forms transpose this data such that each row is a volume of the *Tipiṭaka* and each column is a unique Pali word, such that every cell *(x, y)* gives the count of *x* word in *y* volume. This is useful for computing the "distance" between various volumes by word frequency and for clustering volumes using these measures.

The *Mahāsatipatthāna Sutta* is provided separately although it is also included as part of the *Sutta Piṭaka*, simply to give an example of one complete discourse. This is a particularly well-known discourse on the foundations of mindfulness.

Note that the Pali alphabet does *not* follow the alphabetical ordering of English or other Roman-script languages. For this reason, `tipitaka` includes `pali_alphabet` giving the full Pali alphabet in order, and the functions, `pali_lt`, `pali_gt`, `pali_eq`, and `pali_sort` for comparing and sorting Pali strings. Although `pali_sort` is based on Quicksort, this does not mean it is quick. Because of R's copy semantics, `pali_sort` cretaes *many* interemediate data structures and is quite slow for large word sets. It is provided primarily for sorting short lists of words for glossaries and the like. 

This package also includes `pali_stop_words`, a preliminary set of "stop words" for Pali, which is based on the words labeled as "indeclinable" or "participle" in the PTS *Pali-English Dictionary* [@PED], as well as the most common pronouns [@Geiger]. This is useful in semenatic analysis where such very common words should be excluded.

# Limitations and future work

## Volume numbering
As mentioned above, `tipitaka` attempts to match the structure of the PTS edition of the *Tipiṭaka*, but it does not do so perfectly. The PTS and CST4 editions differ in the way they divide the *Tipiṭaka* into volumes. The resulting numbering in `tipitaka` is as follows:

*	Volume numbering within the *Vinaya Piṭaka* has been adjusted to match the PTS order. 
*	Volume numbering within the *Abhidhamma Piṭaka* is consistent between the two editions and is unchanged.
*	Volume numbering within the *Dīgha Nikāya* is also consistent between the two.
*	Volume division and numbering within the *Majjhima Nikāya*, *Saṃyutta Nikāya*, and *Aṅguttara Nikāya* is inconsistent and has been left according to the CST4. 
*	Volumes of the *Khuddaka Nikāya* are listed under their separate titles rather than by number, as is the norm for these works.

A future revision to `tipitaka` will correct these inconsistencies and fully conform to PTS volume numbering.

## Stemming and *sandhi*
Several features of Pali make it a somewhat tricky langauge for computational analysis:

1. Most Pali words exist in numerous declensions, generally based on number, gender, and case. 
2. Consecutive words in Pali sentences can be combined through letter and syllable elision in complex ways known as *sandhi*, forming what can appear to be novel words. 
3. Pali makes substantial use of compound words. 

Taken together, this means that words often appear in the Pali Canon in a vast array of different forms. For example, the *Tipiṭaka* contains 270 variations on the word *bhikkhu* (monk) if one counts all words beginning with the root “*bhikkh*”. 

There are advantages and disadvantages to using the exact Pali syntax found in the Canon as the basis for linguistic analysis. By way of analogy, the English words *monk* and *monks* are obviously distinct, and different texts may vary in the relative frequency of each. On the other hand, something is clearly lost if we treat the two as entirely unrelated, with no more connection than that between *monk* and *mouse*. Yet that is exactly what we are doing when we treat, for example, *bhikkhu* and *bhikkhū* as entirely distinct words.

It would be very useful to provide a function to convert Pali words to their stem forms in addition to having every variant form available. However, developing an accurate Pali stemming algorithm will be a substantial undertaking. Some progress has been made by others (see, for example, @Basapur, @Elwert, and @Alfter), but no complete algorithm appears yet publicly available. This will be tackled in a future release.

## Other tools
Finally, a more efficient `pali_sort` would probably be useful. The current implementation is as much as two orders of magnitude slower than R's native sort. Rewriting the current algorithm in C++ would probbly be sufficient to improve the performnace substantially.

# Acknowledgements

This package draws heavily on the `tidyverse` [@tidy] and `tidytext` [@tidytext] package as well, of course, on the R statistical programming language [@R].

# References
