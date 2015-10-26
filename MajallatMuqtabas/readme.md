---
title: "TEI edition of *majallat al-muqtabas*"
author: Till Grallert
date: 2015-08-24
---


# Scope of the project

The purpose and scope of the project is to provide an open, collaborative, referencable, scholarly digital edition of Muḥammad Kurd ʿAlī's journal *al-Muqtabas*, which includes the full text, semantic mark-up, and digital imagery.

The digital edition will be provided as TEI P5 XML with its own schema. All files are hosted on [GitHub](https://www.github.com) 

The project will open avenues for re-purposing code for similar projects, i.e. for transforming full-text transcriptions from some HTML or XML source, such as [*al-Maktaba al-Shamela*](http://www.shamela.ws), into TEI P5 XML, linking them to digital imagery from other open repositories, such as [HathiTrust](https://www.hathitrust.org), and generating a web display by, for instance, adapting the code base of [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/). 

The most likely candidates for such follow-up projects are 

- Muḥammad Rashīd Riḍā's journal *al-Manār* 
    + [full text from shamela](http://shamela.ws/index.php/book/6947): 8605 views
    + [imagery from hathitrust](http://catalog.hathitrust.org/Record/008882663),[imagery / PDFs from the Internet Archive](https://archive.org/details/almanaralmanar), which are linked from [*al-Maktaba al-Waqfiyya*](http://waqfeya.com/book.php?bid=7374)
- ʿAbdallah al-Nadīm's *majallat al-ustādh*, Cairo, 24 Aug 1892
    + [full text from shamela](http://shamela.ws/index.php/book/35118): 11337 views.
- ʿAbd al-Qādir bin Muḥammad Salīm al-Kaylānī al-Iskandarānī's *majallat al-ḥaqāʾiq (al-dimashqiyya)*, 1910
    + [full text from shamela](http://shamela.ws/index.php/book/29676): 5134 views.


# To do

## Conceptual level
    
- Semantic web: it would be great to link at least references to books to existing records or to provide a means to do so.

## Mark-up

1. Mark-up: The basic structural mark-up of individual issues is far from complete
    - headlines
    - splitting articles into sections and sections into individual articles
    - mark-up of authors with `<byline>`
2. Text-image linking: while the links to the facsimiles can be automatically generated for each issue, establishing page breaks (`<pb>`) must be done manually for all 6.000+ of them

# The journal *al-Muqtabas*

Muḥammad Kurd ʿAlī published the monthly journal *al-Muqtabas* between 1906 and 1914(1916). The publication schedule followed the Muslim *hijrī* calendar and, after the Young Turk Revolution of July 1908, publication moved from Cairo to Damascus in the journal's third year.

There is some confusion as to the counting of issues and their publication dates. According to the masthead and the cover sheet, *al-Muqtabas* was published following the Islamic *hijrī* calendar (from the journal itself it must remain open whether the recorded publication dates were the actual publication dates). Sometimes the printers made errors: issue 2 of volume 4, for instance, carries Rab I 1327 as publication date on the cover sheet, but Ṣaf 1327 in its masthead. The latter would correspond to the official publication schedule.

Samir Seikaly argues that Muḥammad Kurd ʿAlī was wrong in stating in his memoirs that he published 8 volumes of 12 issues each and two independent issues.^[{Seikaly 1981@128}] But the actual hard copies at the [Orient-Institut Beirut](http://www.orient-institut.org) and the digital facsimiles from HathiTrust show that Kurd ʿAlī was right insofar as volume 9 existed and comprised 2 issues only. As it turns out, *al-Muqtabas* published a number of double issues: [Vol. 4 no. 5/6](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_41.TEIP5.xml) and [Vol. 8 no. 11/12](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_94.TEIP5.xml)

In addition to the original edition, at least one reprint appeared: In 1992 Dār Ṣādir in Beirut published a facsimile edition, which is entirely unmarked as such but for the information on the binding itself. Checking this reprint against the original, it appeared to be a facsimile reprint: pagination, font, layout --- everything is identical. But as Samir Seikaly remarked in 1981 that he used "two separate compilations of *al-Muqtabas* [...] in this study" there must be at least one other print edition that I have not yet seen.^[{Seikaly 1981@128}]

# Digital imagery

Image files are available from [Hathitrust](http://catalog.hathitrust.org/Record/100658549) or [Institut du Monde Arabe](http://ima.bibalex.org/IMA/presentation/periodic/list.jsf?pid=9C82C139F9785E99D30089727B40A269).

##  HathiTrust

- links to volumes
    + [Vol. 1](http://hdl.handle.net/2027/umn.319510029968608)
    + [Vol. 2](http://hdl.handle.net/2027/umn.319510029968616)
    + [Vol. 3](http://hdl.handle.net/2027/umn.319510029968624)
    + [Vol. 4](http://hdl.handle.net/2027/umn.319510029968632)
    + [Vol. 5](http://hdl.handle.net/2027/umn.319510029968640)
    + [Vol. 6](http://hdl.handle.net/2027/njp.32101073250910)
    + [Vol. 8](http://hdl.handle.net/2027/njp.32101007615691)
    + [Index](http://hdl.handle.net/2027/umn.31951d008457474)
- access
    + The journal is in the public domain in the US and can be freely accessed and downloaded
    + Outside the US, access is restricted.
    + Formal [licence](https://www.hathitrust.org/access_use#pd-us-google): 
> Public Domain or Public Domain in the United States, Google-digitized: In addition to the terms for works that are in the Public Domain or in the Public Domain in the United States above, the following statement applies: The digital images and OCR of this work were produced by Google, Inc. (indicated by a watermark on each page in the PageTurner). Google requests that the images and OCR not be re-hosted, redistributed or used commercially. The images are provided for educational, scholarly, non-commercial purposes.
>Note: There are no restrictions on use of text transcribed from the images, or paraphrased or translated using the images.


# Full text

Somebody took the pains to create fully searchable text files and uploaded everything to [al-Maktaba al-Shamela](http://shamela.ws/index.php/book/26523) and  [WikiSource](https://ar.wikisource.org/wiki/%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D9%85%D9%82%D8%AA%D8%A8%D8%B3/%D8%A7%D9%84%D8%B9%D8%AF%D8%AF_1).


## [al-Maktaba al-Shāmila](http://www.shamela.ws)

- Extent: According to the main [entry](http://shamela.ws/index.php/book/26523), *shamela* has all 96 issues. 
- Transcribers, editors: Apparently, they have been typed and copy-edited by unnamed humans. 
- Features edition: paragraphs, page breaks, headlines.
- Features interface:
    + all issues can be browsed for headlines and searched
    + all pages can be individually adressed in the browser: [http://shamela.ws/browse.php/book-26523#page-2290](http://shamela.ws/browse.php/book-26523#page-2290)

## WikiSource

It seems that somebody took the pains to upload the tet from *shamela* to WikiSource. Unfortunately it is impossible to browse the entire journal. Instead one has to adress each individual and consecutively numbered issue, e.g. Vol. 4, No. 1 is listed as [No. 37](https://ar.wikisource.org/wiki/%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D9%85%D9%82%D8%AA%D8%A8%D8%B3/%D8%A7%D9%84%D8%B9%D8%AF%D8%AF_37)

# TEI edition

The main challenge is to combine the full text and the images in a TEI edition. As *al-maktabat al-shāmila* did not reproduce page breaks true to the print edition, every single one of the more than 6000 page breaks must be added manually and linked to the digital image of the page.

## Quality control

A simple way of controlling the quality of the basic structural mark-up would be to cross check any automatically generated table of content or index against the published tables of content at the end of each volume and against the index of *al-Muqtabas* published by [Riyāḍ ʿAbd al-Ḥamīd Murād in 1977](http://hdl.handle.net/2027/umn.31951d008457474). 

## General design

The edition should be conceived of as a corpus of tei files that are grouped by means of xinclude. This way, volumes can be constructed as single TEI files containing a `<group/>` of TEI files and a volume specific `<front/>` and `<back/>`

# Web display: TEI Boilerplate

To allow a quick review of the mark-up and read the journal's content, I decided to customise [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/) for a first display of the TEI files in the browser without need for pre-processed HTML and host this heavily customised boilerplate view as a seperate branch of the GitHub repository. For a first impression see [here](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_60.TEIP5.xml).