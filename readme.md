---
title: "Readme: Digial Muqtabas"
author: Till Grallert
date: 2016-01-14
---

# Digital *Muqtabas*: An open, collaborative, and scholarly digital edition of Muḥammad Kurd ʿAlī's early Arabic periodical *Majallat al-Muqtabas* (1906--1917/18)

In the context of the current onslaught cultural artifacts in the Middle East face from the iconoclasts of the Islamic State, from the institutional neglect of states and elites, and from poverty and war, digital preservation efforts promise some relief as well as potential counter narratives. They might also be the only resolve for future education and rebuilding efforts once the wars in Syria, Iraq or Yemen come to an end. 

Early Arabic periodicals, such as Butrus al-Bustānī's *al-Jinān* (Beirut, 1876--86), Yaʿqūb Ṣarrūf, Fāris Nimr, and Shāhīn Makāriyūs' *al-Muqtaṭaf* (Beirut and Cairo, 1876--1952), Muḥammad Kurd ʿAlī's *al-Muqtabas* (Cairo and Damascus, 1906--16) or Rashīd Riḍā's *al-Manār* (Cairo, 1898--1941) are at the core of the Arabic renaissance (*al-nahḍa*), Arab nationalism, and the Islamic reform movement. Due to the state of Arabic OCR and the particular difficulties of low-quality fonts, inks, and paper employed at the turn of the twentieth century, they can only be digitised by human transcription. Yet despite of their cultural significance and unlike for valuable manuscripts and high-brow literature, funds for transcribing the tens to hundreds of thousands of pages of an average mundane periodical are simply not available. Consequently, we still have not a single digital scholarly edition of any of these journals. But some of the best-funded scanning projects, such as [Hathitrust](http://catalog.hathitrust.org/), produced digital imagery of numerous Arabic periodicals, while gray online-libraries of Arabic literature, namely [*shamela.ws*](http://shamela.ws/), provide access to a vast body of Arabic texts including transcriptions of unknown provenance, editorial principals, and quality for some of the mentioned periodicals. In addition, these gray "editions" lack information linking the digital representation to material originals, namely bibliographic meta-data and page breaks, which makes them almost impossible to employ for scholarly research.

With the [GitHub-hosted TEI edition of *Majallat al-Muqtabas*](https://github.com/tillgrallert/digital-muqtabas 'current state of the project') we want to show that through re-purposing available and well-established open software and by bridging the gap between immensely popular, but non-academic (and, at least under US copyright laws, occasionally illegal) online libraries of volunteers and academic scanning efforts as well as editorial expertise, one can produce scholarly editions that remedy the short-comings of either world with very little funding: We use [digital texts from *shamela.ws*](http://shamela.ws/index.php/book/26523), transform them into TEI XML, add light structural mark-up for articles, sections, authors, and bibliographic metadata, and link them to facsimiles provided through the [British Library's "Endangered Archives Programme"](http://eap.bl.uk/database/overview_project.a4d?projID=EAP119;r=63) and [HathiTrust](http://catalog.hathitrust.org/Record/100658549) (in the process of which we also make first corrections to the transcription). The digital edition (TEI XML and a basic web display) is then hosted as a GitHub repository with a [CC BY-SA 4.0 licence](http://creativecommons.org/licenses/by-sa/4.0/).

By linking images to the digital text, every reader can validate the quality of the transcription against the original, thus overcoming the greatest limitation of crowd-sourced or gray transcriptions and the main source of disciplinary contempt among historians and scholars of the Middle East. Improvements of the transcription and mark-up can be crowd-sourced with clear attribution of authorship and version control using .git and GitHub's core functionality. Editions will be referencable down to the word level for scholarly citations, annotation layers, as well as web-applications through a documented URI scheme.[^3] The [web-display](https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/oclc_4770057679-i_60.TEIP5.xml) is implemented through a customised adaptation of the [TEI Boilerplate XSLT stylesheets](http://dcl.slis.indiana.edu/teibp/); it can be downloaded, distributed and run locally without any internet connection---a necessity for societies outside the global North. Finally, by sharing all our code (mostly XSLT) in addition to the XML files, we hope to facilitate similar projects and digital editions of further periodicals, namely Rashīd Riḍā's *al-Manār*.

[^3]:Currently we provide stable URLs down to the paragraph level. For more details see the [documentation of the mark-up](notes-tei-markup.md)

# Scope of the project

The purpose and scope of the project is to provide an open, collaborative, referencable, scholarly digital edition of Muḥammad Kurd ʿAlī's journal *al-Muqtabas*, which includes the full text, semantic mark-up, and digital imagery.

The digital edition will be provided as TEI P5 XML with its own schema. All files are hosted on [GitHub](https://www.github.com) 

The project will open avenues for re-purposing code for similar projects, i.e. for transforming full-text transcriptions from some HTML or XML source, such as [*al-Maktaba al-Shamela*](http://www.shamela.ws), into TEI P5 XML, linking them to digital imagery from other open repositories, such as [EAP](http://eap.bl.uk/) and [HathiTrust](https://www.hathitrust.org), and generating a web display by, for instance, adapting the code base of [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/). 

The most likely candidates for such follow-up projects are 

- Muḥammad Rashīd Riḍā's journal *al-Manār*. A stub is already available on [GitHub](https://www.github.com/tillgrallert/digital-manar)
    + [full text from shamela](http://shamela.ws/index.php/book/6947): 8605 views
    + [imagery from hathitrust](http://catalog.hathitrust.org/Record/008882663),[imagery / PDFs from the Internet Archive](https://archive.org/details/almanaralmanar), which are linked from [*al-Maktaba al-Waqfiyya*](http://waqfeya.com/book.php?bid=7374)
- ʿAbdallah al-Nadīm's *majallat al-ustādh*, Cairo, 24 Aug 1892
    + [full text from shamela](http://shamela.ws/index.php/book/35118): 11337 views.
- ʿAbd al-Qādir bin Muḥammad Salīm al-Kaylānī al-Iskandarānī's *majallat al-ḥaqāʾiq (al-dimashqiyya)*, 1910
    + [full text from shamela](http://shamela.ws/index.php/book/29676): 5134 views.


# The journal *al-Muqtabas*

Muḥammad Kurd ʿAlī published the monthly journal *al-Muqtabas* between 1906 and 1917/18. After the Young Turk Revolution of July 1908, publication moved from Cairo to Damascus in the journal's third year.

There is some confusion as to the counting of issues and their publication dates. Samir Seikaly argues that Muḥammad Kurd ʿAlī was wrong in stating in his memoirs that he had published 8 volumes of 12 issues each and two independent issues.[^1] But the actual hard copies at the [Orient-Institut Beirut](http://www.orient-institut.org) and the digital facsimiles from HathiTrust and EAP show that Kurd ʿAlī was right insofar as volume 9 existed and comprised 2 issues only. As it turns out, *al-Muqtabas* also published a number of double issues: [Vol. 4 no. 5/6](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_41.TEIP5.xml) and [Vol. 8 no. 11/12](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_94.TEIP5.xml).

[^1]:{KurdAli 1928@424}, {Seikaly 1981@128}

According to the masthead and the cover sheet, *al-Muqtabas*'s publication schedule followed the Islamic *hijrī* calendar (from the journal itself it must remain open whether the recorded publication dates were the actual publication dates). Sometimes the printers made errors: [issue 2 of volume 4](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_38.TEIP5.xml), for instance, carries Rab I 1327 aH as publication date on the cover sheet, but Ṣaf 1327 aH in its masthead. The latter would correspond to the official publication schedule. External sources, such as reports in the daily newspaper *al-Muqtabas*, also published by Muḥammad Kurd ʿAlī in Damascus, indicate that the actual publication sequence was indeed not too tightly tied to the monthly publication schedule:

- *Thamarāt al-Funūn* 29 Jan. 1906 / 4 Dhu II 1323 aH (#1548) announced the publication of [no.2 of *Majallat al-Muqtabas*](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_2.TEIP5.xml) two months earlier than the date indicated in the issue's masthead: Ṣafar 1324 aH.[^5] This also contradicts Muḥammad Kurd ʿAlī's memoirs, where he states that publication of *Muqtabas* commenced in early 1324 aH.[^11]

[^11]:{KurdAli 1928@415}

- *al-Muqtabas* 16 May 1910 / 7 Jum I 1328 aH (#371) announced the publication of a "no. 10" of *Majallat al-Muqtabas*. [No.10 of the fifth volume](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_57.TEIP5.xml) would have been published for/in Shaw 1328 aH (Oct/Nov 1910), thus the short note must refer to [no.10 of the fourth volume](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_45.TEIP5.xml) that should have been published for/in Shaw 1327 aH (Oct/Nov 1909)! This assumption is confirmed by the short description of the issue's content provided in the announcement.[^4]
- *al-Muqtabas* 2 Jul. 1910 (#411) confirmed the overall delay in publication and announced [issue 12 of vol.4](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_47.TEIP5.xml), which should have appeared for/in Dhu II 1327 aH (Dec 1909/ Jan 1910).[^6]

- Muḥammad Kurd ʿAlī and his staff seemingly entered a productive period in fall 1910, publishing eight "monthly" issues in three months:
    - *al-Muqtabas* 13 Sep. 1910 (#473) announced [no.3 of vol. 5](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_50.TEIP5.xml) that should have been published for/in Rab I 1328 aH (Mar/Apr 1910).[^7] But publication speed picked up and
    - only eleven days later, *al-Muqtabas* 24 Sep. 1910 (#482) announced the publication of [no.4 of vol.5](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_51.TEIP5.xml).[^8]
    - *al-Muqtabas* 12 Dec. 1910 (#548) announced the publication of [no.10 of vol.5](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_57.TEIP5.xml) of Shaw 1328 aH (Oct/Nov 1910).[^9]
- *al-Muqtabas* 18 Jun. 1911 (#706) advertised Jamāl al-Dīn al-Qāsimī's three-partite article *al-fatwā fī al-islām* ([part one](https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/oclc_4770057679-i_61.TEIP5.xml#div_2.d1e1517), [two](https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/oclc_4770057679-i_62.TEIP5.xml#div_2.d1e1491), and [three](https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/oclc_4770057679-i_63.TEIP5.xml#div_7.d1e1810)) published from no.2 of vol.6 (Ṣafar 1329 / Feb 1911) onwards and mentioned that the copy of *Majallat al-Muqtabas* was sold for 1.5 *beşlik*s.[^10]
- *al-Muqtabas* 1 Jul. 1911 / 4 Raj 1329 aH (#717) announced the publication of two issues, [no.5](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_64.TEIP5.xml) and [6 of vol.6](https://rawgit.com/tillgrallert/ArabicTeiEdition/master/MajallatMuqtabas/xml/oclc_4770057679-i_65.TEIP5.xml), which according to the publication schedule should have been published in late April and late May respectively.[^2]

[^10]:[{muqtabas 274-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=7029;r=17843)
[^2]:[{muqtabas 283-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=7038;r=9551)
[^4]:[{muqtabas 100-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6855;r=6738)
[^5]:{tf-oib 1548@5}
[^6]:[{muqtabas 128-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6883;r=18866)
[^7]:[{muqtabas 184-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6939;r=1883)
[^8]:[{muqtabas 188-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6943;r=5230)
[^9]:[{muqtabas 200-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6955;r=4592)

Similar confusion shrouds the end of publication in mystery. As no publication dates were actually provided in the mastheads of individual issues and since the issue wrappers were mostly discarded upon binding the issues into volumes, the only surviving explicit dating is provided by the volumes' cover sheets. According to its covers sheet, volume 8 was published through 1332 aH, i.e. between December 1913 and November 1914. However an [article in issue 9](xml/oclc_4770057679-i_91.TEIP5.xml#p_98.d1e2707) reports on the inauguration of a Mosque in Berlin at the end of Ram 1333 aH (mid-August 1915). The same issue reviews a number of books printed in 1333 aH and [one book published in 1334 aH](xml/oclc_4770057679-i_91.TEIP5.xml#div_24.d1e3028) in addition to the announcement of a publication on the ["first year of the war"](xml/oclc_4770057679-i_91.TEIP5.xml#div_26.d1e3075), which would mean that it was not published before November 1915 (Muḥarram 1334 aH) and most likely in 1916. Issue 12 of the same volume even recorded a [notebook for the year 1917](xml/oclc_4770057679-i_94.TEIP5.xml#p_384.d1e4223) in the section on new books and publications, which also listed further books published in 1334 aH. The following issue continues this trend by publishing an [obituary for Shaykh ʿAbd al-Razzāq al-Bayṭār](xml/oclc_4770057679-i_95.TEIP5.xml#div_16.d1e2869), who died in Damascus on 10 Rab 1335 [4 January 1917].

In addition to the original edition, at least one reprint appeared: In 1992 Dār Ṣādir in Beirut published a facsimile edition, which is entirely unmarked as such but for the information on the binding itself. Checking this reprint against the original, it appeared to be a facsimile reprint: pagination, font, layout --- everything is identical. But as Samir Seikaly remarked in 1981 that he used "two separate compilations of *al-Muqtabas* [...] in this study" there must be at least one other print edition that I have not yet seen.[^12]

[^12]:{Seikaly 1981@128}

# Digital imagery

Image files are available from the [*al-Aqṣā* Mosque's library in Jerusalem through the British Library's "Endangered Archives Project" (vols. 2-7)](http://eap.bl.uk/database/overview_project.a4d?projID=EAP119;r=63), [HathiTrust (vols. 1-6, 8)](http://catalog.hathitrust.org/Record/100658549), and [Institut du Monde Arabe](http://ima.bibalex.org/IMA/presentation/periodic/list.jsf?pid=9C82C139F9785E99D30089727B40A269). Due to its open access licence, preference is given to facsimiles from EAP.

## EAP119

- links to volumes:
    + [Vol. 2](http://eap.bl.uk/database/overview_item.a4d?catId=809;r=12316)
    + [Vol. 3](http://eap.bl.uk/database/overview_item.a4d?catId=812;r=3035)
    + [Vol. 4](http://eap.bl.uk/database/overview_item.a4d?catId=813;r=22190)
    + [Vol. 5](http://eap.bl.uk/database/overview_item.a4d?catId=814;r=1842)
    + [Vol. 6](http://eap.bl.uk/database/overview_item.a4d?catId=810;r=288)
    + [Vol. 7](http://eap.bl.uk/database/overview_item.a4d?catId=811;r=30106)
- access:
    + the journal is in the public domain and the images can be freely accessed without restrictions. EAP does not provide a download button.
    + Terms of access for material provided by the British Library can be found [here](http://www.bl.uk/aboutus/terms/index.html)

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
> 
> Note: There are no restrictions on use of text transcribed from the images, or paraphrased or translated using the images.


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

Sombody uploaded the text from *shamela* to WikiSource. Unfortunately it is impossible to browse the entire journal. Instead one has to adress each individual and consecutively numbered issue, e.g. Vol. 4, No. 1 is listed as [No. 37](https://ar.wikisource.org/wiki/%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D9%85%D9%82%D8%AA%D8%A8%D8%B3/%D8%A7%D9%84%D8%B9%D8%AF%D8%AF_37)

# TEI edition

The main challenge is to combine the full text and the images in a TEI edition. As *al-maktabat al-shāmila* did not reproduce page breaks true to the print edition, every single one of the more than 6000 page breaks must be added manually and linked to the digital image of the page.

## General design

The edition should be conceived of as a corpus of tei files that are grouped by means of xinclude. This way, volumes can be constructed as single TEI files containing a `<group/>` of TEI files and a volume specific `<front/>` and `<back/>`

Detailled description and notes on the mark-up are kept in a separate [file](notes-tei-markup.md).

## Quality control

A simple way of controlling the quality of the basic structural mark-up would be to cross check any automatically generated table of content or index against the published tables of content at the end of each volume and against the index of *al-Muqtabas* published by [Riyāḍ ʿAbd al-Ḥamīd Murād in 1977](http://hdl.handle.net/2027/umn.31951d008457474). 


# Web display: TEI Boilerplate

To allow a quick review of the mark-up and read the journal's content, I decided to customise [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/) for a first display of the TEI files in the browser without need for pre-processed HTML and to host this heavily customised boilerplate view as part of the [GitHub repository](https://www.github.com/tillgrallert/digital-muqtabas). For a first impression see [here](https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/oclc_4770057679-i_60.TEIP5.xml). It is important to note that at the moment there is no front-end beyond the GitHub repository that allows for searching and browsing across files.

A detailed description of the web display is available [here](notes-web-display.md).

# To do

1. Mark-up: The basic structural mark-up of individual issues is far from complete. All features encoded in HTML by *shamela.ws* have been translated into TEI XML, but these are limited to the main article / section headers. What needs to be done is:
    - splitting articles into sections and sections into individual articles
    - mark-up of authors with `<byline>`
2. Text-image linking: while the links to the facsimiles can be automatically generated for each issue, establishing page breaks (`<pb>`) must be done manually for all 6.000+ of them