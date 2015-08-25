---
title: "Pilot project: TEI edition of an Arabic Manuscript"
author: Till Grallert
date: 2015-07-15
---


# Summary
## Goals:

1. Scholarly goals: make important historical sources accessible to the wider scholarly community and the general public
    - pilot project: a short unpublished manuscript by al-Qāḍī Ibn ʿAjlūn
    - prepare digital representations of analogue source documents for analytical purposes. This means first and foremost *diplomatic* editions
    - publish the edition as well as all source files and code under a creative commons licence on the web
2. Technical goals: proof of concept for an Arabic, TEI-based, digital edition 
3. Personal / ethical goals: 
    - establish our authorship and expertise in both fields 
    - give credit to credit is due: all people involved and their contribution to the project must be credited in all future re-use of the source

## Features / tools

- core deliverables:
    + a reliable, addressable digital representation of the text in TEI XML under CC license
    + website hosting a html view as well as the xml

- wishful thinking / dreams 
    - mark-up of named entities
    - links to external ontologies
    - mapping of places

## Persons involved

- Torsten Wollina: expertise for Ibn Ṭulūn, Ibn Qāḍī ʿAjlūn, Mamluk Damascus, Arabic manuscripts, ms editing
- Till Grallert: expertise for late Ottoman Damascus, Arabic newspapers; technical expertise, XML, TEI

# Workflow

## 1. Decide which MS to edit

1. Necessary: ascertain the rights to publish the transcription
2. Potentially: ascertain the rights to publish facsimiles

## 2. Produce a TEI edition

1. Decide which features should be recorded: Torsten and Till
2. Produce guidelines of editing principles
    1. human-readible text: Torsten
        * As some prose text
        * As TEI `<editorialDecl>` to be used for the header of the final XML files: Till
    2. formalised version: Till
        * design a TEI schema to enforce the editing principles in schema-aware software, such as oXygen
        * this can then be used as the basis for the display of certain features in oXygen's author mode
3. Produce a transcription that includes basic structural mark-up (such as headers, line breaks, page breaks etc.) from the very beginning: Torsten
    1. Initial transcriptions will most likely be done by interns etc. in a text edition software, probably Microsoft word.
        * We need a template with paragraph styles to be used for the transcription
    2. Conversion of the initial transcription into TEI xml: Till
        * the first step woule be using OxGarage
        * further features that have been recorded by the transcribers or the conversion of paragraphs into linebreaks can be automatised through XSLT
4. Add metadata on the source, the recording process, the editing principles, editors etc.: Torsten und Till
5. Add further mark-up. While we might start with a very limit set of tags, we might want to encode references to persons, places, dates, etc. or even linguistic features at some future point in time.: Torsten und Till


## 3. Produce a website

1. Find a hosting service!
2. Decide which features of the Mss. should be displayed
3. Decide how they should be displayed
4. Write the code etc.

# Detailed description for TEI edition

## 1. Features to be recorded
### 1.1. Metadata of ms

1. Collection, shelfmark, and numbers of relevant folios (if in a majmuʿa)
2. "Official title" and title given in the Ms.
3. Names of author and copyist plus life dates if available
4. Other manuscripts and/or editions of the same text
5. Short description of the content
6. Short description of the Ms. (i.e. state of paper and binding, remarks in the margins? (folio number), text complete?, catchwords?)

### 1.2. Text features

1. Structural features
    - line breaks
    - page breaks
    - headings
    - text in the margins
2. Writing styles
    - colour of ink
    - hand shifts

### 1.3. Damaged, illegible parts, normalisation

1. illegible words
2. damages to the ms
3. normalisation

## 2. Guidelines of editing principles
## 2.1. Rules for (easy) transcription
<!--We want to keep the language to indicate variants in the reading of the text and to translate visual elements in the text as slim, simple and clear as possible -->
1. General Formatting:
	- use templates to mark title, text body, quotes etc.
	- Apply page break / line break in document when there is page break / line break in the original text
2. Inks and Text Revisions
	- transcribe coloured inks in coloured letters
	- crossed out sections should be transcribed as far as readable and also be formatted as crossed out
	- If words or passages are not legible, mark by {no. of words; interpretation}
	- Missing / superfluous diacriticals should be left missing; z.b.
		+ علي statt  على  
		+ حسبة für حسبه
3. Text Body and Readings
	- word which clearly belong to the text but stand out from the text body:
		+ words outside the text body, mark with / before
		+ words above the line or added by way of "footnote", mark by underlining

## 2.2. Formalised rules

The [manual for cataloguing Arabic manuscripts in TEI](http://www.fihrist.org.uk/manual/) for the [Fihrist project](http://www.fihrist.org.uk/) could be used for inspiration---at least for recording metadata.

## 2.3. Suggestions for tools and formats

1. Initial transcription can be done in the text editor / word-processing software of the transcriber's choice
    - Plain text and markdown / mmd
    - CriticMarkup for editorial choices, comments, etc.

# literature / links
## Examples

- [Livingstone's 1871 Field Diary: A Multispectral Critical Edition](http://livingstone.library.ucla.edu/1871diary/xml_coding.htm)
- [Emma B. Andrews: Diary Project](http://depts.washington.edu/ebadiary/toolstech.php)
- [Gallipoli Diary](http://nzetc.victoria.ac.nz/tm/scholarly/tei-CoxDiar.html)
- [Extracts from the Diary of Robert Graves](http://web.uvic.ca/hrd/graves/)

## Tutorials

- Certainly not the best, but I share the slides for my introduction to markup, TEI, and XML [here](http://tillgrallert.github.io/teaching.html).