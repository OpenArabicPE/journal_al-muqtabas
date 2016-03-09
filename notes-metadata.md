---
title: "Notes on bibliographic metadata"
author: Till Grallert
date: 2016-03-09 14:44:12
---

Zotero, for instance, imports the following formats:

- Zotero RDF
- MODS (Metadata Object Description Schema)
- BibTeX
- RIS
- Refer/BibIX
- Unqualified Dublin Core RDF

BibTeX, which has been around for more than 30 years seems to be the safest bet to preserve and exchange bibliographic data. The standard or at least the tools implementin it aren't really strict and only basic information can be included (in BibTeX' conception, there are no editions of periodicals, for instance.)

# MODS (Metadata Object Description Schema)

The standard is maintained by the [Network Development and MARC Standards Office](http://www.loc.gov/marc/ndmso.html) of the Library of Congress with input from users.
It is written in XML

# BibTeX

- The [official description](http://www.bibtex.org/Format/) is to be found on the [BibTeX website](). I is fairly short and since development of BibTeX stalled between 1988 and 2010, it is most definitely not the most current or detailed.
- The [Wikipedia entry](https://en.wikipedia.org/wiki/BibTeX) is better 
- There is a [description](http://www.openoffice.org/bibliographic/bibtex-defs.html) from the LaTeX book of 1986

## usage for DAPE

1. journal level
2. issue level
3. article level
    + Every text in an issue is considered to be of the "article" type:
    + article
        * An article from a journal or magazine.
        * Required fields: `author`, `title`, `journal`, `year`, `volume`
        * Optional fields: `number`, `pages`, `month`, `note`, `key` 

## fields

