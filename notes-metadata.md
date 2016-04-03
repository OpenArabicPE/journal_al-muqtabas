---
title: "Notes on bibliographic metadata"
author: Till Grallert
date: 2016-03-09 14:44:12
---

# Zotero

Zotero, for instance, imports the following formats:

- Zotero RDF
- MODS (Metadata Object Description Schema)
- BibTeX
- BibLaTeX
- RIS
- Refer/BibIX
- Unqualified Dublin Core RDF

BibTeX, which has been around for more than 30 years seems to be the safest bet to preserve and exchange bibliographic data. There are, however, a number of problems:

- The standard and thus the tools implementing it aren't really strict
- Only basic information can be included: 
    + information on publication dates is commonly limited to year and month only
    + periodicals are not perceived as having different editions or print-runs
    + non-Gregorian calendars cannot be added.

Some of these shortcomings, such as dates and editions, are remedied by the more recent BibLaTeX standard, but Zotero's support is far from perfect, removing `langid`, `edition`, `rights` upon import and generating a new BibTeX key. 

## Zotero fork [Juris-M](https://juris-m.github.io/)

Duncan Paterson pointed me to the Zotero fork [Juris-M](https://juris-m.github.io/) that provides support for multiple language resources, multiple calendars etc. at the Dixit2 convention

# MODS (Metadata Object Description Schema)

The [MODS standard](http://www.loc.gov/standards/mods/) is maintained by the [Network Development and MARC Standards Office](http://www.loc.gov/marc/ndmso.html) of the Library of Congress with input from users.
It is written in XML.

I have written an XSLT stylesheet to generate MODS from the TEI source: [`Tei2Mods-issues.xsl`](xslt/Tei2Mods-issues.xsl)

# BibTeX

The repository includes two XSLT stylesheets [Tei2BibTex-issues.xsl](xslt/Tei2BibTex-issues.xsl) and [Tei2BibTex-articles.xsl](xslt/Tei2BibTex-articles.xsl) that generate BibTeX files from the TEI XML.

- The [official description of the BibTeX format](http://www.bibtex.org/Format/) is to be found on the [BibTeX website](). I is fairly short and since development of BibTeX stalled between 1988 and 2010, it is most definitely not the most current or detailed.
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

# BibLaTeX