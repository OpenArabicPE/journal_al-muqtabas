---
title: "Readme: Digial Muqtabas"
author: Till Grallert
date: 2021-09-03
ORCID: orcid.org/0000-0002-5739-8094
---

# Digital *Muqtabas*: An open, collaborative, and scholarly digital edition of Muḥammad Kurd ʿAlī's early Arabic periodical *Majallat al-Muqtabas* (1906--1917/18)

[![GitHub release](https://img.shields.io/github/release/openarabicpe/journal_al-muqtabas.svg)](https://github.com/openarabicpe/journal_al-muqtabas/releases)
[![DOI](https://zenodo.org/badge/45922152.svg)](https://zenodo.org/badge/latestdoi/45922152)

Quick links:

- [Blog](https://openarabicpe.github.io),
- [Webview *al-Muqtabas* 1(1) (text, facsimile)](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_1.TEIP5.xml): works most reliably with Chrome and Safari
- [Zotero group "OpenArabicPE/digital-muqtabas" (bibliographic metadata)](https://www.zotero.org/groups/openarabicpe/items/collectionKey/8SINFUW9)

In the context of the current onslaught cultural artifacts in the Middle East face from the iconoclasts of the Islamic State, from the institutional neglect of states and elites, and from poverty and war, digital preservation efforts promise some relief as well as potential counter narratives. They might also be the only resolve for future education and rebuilding efforts once the wars in Syria, Iraq or Yemen come to an end.

Early Arabic periodicals, such as Butrus al-Bustānī's *al-Jinān* (Beirut, 1876--86), Yaʿqūb Ṣarrūf, Fāris Nimr, and Shāhīn Makāriyūs' *al-Muqtaṭaf* (Beirut and Cairo, 1876--1952), Muḥammad Kurd ʿAlī's *al-Muqtabas* (Cairo and Damascus, 1906--16) or Rashīd Riḍā's *al-Manār* (Cairo, 1898--1941) are at the core of the Arabic renaissance (*al-nahḍa*), Arab nationalism, and the Islamic reform movement. Due to the state of Arabic OCR and the particular difficulties of low-quality fonts, inks, and paper employed at the turn of the twentieth century, they can only be digitised by human transcription. Yet despite of their cultural significance and unlike for valuable manuscripts and high-brow literature, funds for transcribing the tens to hundreds of thousands of pages of an average mundane periodical are simply not available. Consequently, we still have not a single digital scholarly edition of any of these journals. But some of the best-funded scanning projects, such as [Hathitrust](http://catalog.hathitrust.org/), produced digital imagery of numerous Arabic periodicals, while gray online-libraries of Arabic literature, namely [*shamela.ws*](http://shamela.ws/), provide access to a vast body of Arabic texts including transcriptions of unknown provenance, editorial principals, and quality for some of the mentioned periodicals. In addition, these gray "editions" lack information linking the digital representation to material originals, namely bibliographic meta-data and page breaks, which makes them almost impossible to employ for scholarly research.

With the [GitHub-hosted TEI edition of *Majallat al-Muqtabas*](https://github.com/openarabicpe/journal_al-muqtabas 'current state of the project') we want to show that through re-purposing available and well-established open software and by bridging the gap between immensely popular, but non-academic (and, at least under US copyright laws, occasionally illegal) online libraries of volunteers and academic scanning efforts as well as editorial expertise, one can produce scholarly editions that remedy the short-comings of either world with very little funding: We use [digital texts from *shamela.ws*](http://shamela.ws/index.php/book/26523), transform them into TEI XML, add light structural mark-up for articles, sections, authors, and bibliographic metadata, and link them to facsimiles provided through the [British Library's "Endangered Archives Programme"](http://eap.bl.uk/database/overview_project.a4d?projID=EAP119;r=63) and [HathiTrust](http://catalog.hathitrust.org/Record/100658549) (in the process of which we also make first corrections to the transcription). The digital edition (TEI XML and a basic web display) is then hosted as a GitHub repository with a [CC BY-SA 4.0 licence](http://creativecommons.org/licenses/by-sa/4.0/).

By linking images to the digital text, every reader can validate the quality of the transcription against the original, thus overcoming the greatest limitation of crowd-sourced or gray transcriptions and the main source of disciplinary contempt among historians and scholars of the Middle East. Improvements of the transcription and mark-up can be crowd-sourced with clear attribution of authorship and version control using .git and GitHub's core functionality. Editions will be referencable down to the word level for scholarly citations, annotation layers, as well as web-applications through a documented URI scheme.[^3] The [web-display](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_60.TEIP5.xml) is implemented through a customised adaptation of the [TEI Boilerplate XSLT stylesheets](http://dcl.slis.indiana.edu/teibp/); it can be downloaded, distributed and run locally without any internet connection---a necessity for societies outside the global North. Finally, by sharing all our code (mostly XSLT) in addition to the XML files, we hope to facilitate similar projects and digital editions of further periodicals, namely Rashīd Riḍā's *al-Manār*.

[^3]:Currently we provide stable URLs down to the paragraph level. For more details see the [documentation of the mark-up](documentation_tei-markup.md)


# 1. Scope and deliverables of the project

The purpose and scope of the project is to provide an open, collaborative, referencable, and scholarly digital edition of Muḥammad Kurd ʿAlī's journal *al-Muqtabas*, which includes the full text, semantic mark-up, bibliographic metadata, and digital imagery. All files but the digital facsimiles are hosted on [GitHub](https://www.github.com).

All deliverables and milestones will be covered in more detail in the following sections.

## 1.1 Deliverables

- Current deliverables:
    - Full text of 96 issues (c. 7000 pages) with semantic mark-up as TEI P5 XML with its own schema.
    - The text of digital edition links to open-access digital facsimiles if available (see below).
    - [A webview](https://github.com/tillgrallert/tei-boilerplate-arabic-editions), based on [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/), shows digital text and images side by side. It provides an automatically generated table of content and links to the bibliographic metadata of every article.
    - Bibliographic metadata for every article in *Majallat al-Muqtabas* is provided as individual MODS and BibTeX files in the sub-folder `metadata`. The metadata includes a URL pointing to the webview of this item and the webview includes a link to the metadata files for every article.
        + To ease browsing the journal, we have set up the public Zotero group [Digital Muqtabas](https://www.zotero.org/groups/digital-muqtabas/items). This group is updated by means of the MODS XML files.
- Possible / planned deliverables
    + Scans of issues not currently available in open-access repositories, namely of vol. 9, which we hold at [Orient-Institut Beirut](http://www.orient-institut.org).

The project will open avenues for re-purposing code for similar projects, i.e. for transforming full-text transcriptions from some HTML or XML source, such as [*al-Maktaba al-Shamela*](http://www.shamela.ws), into TEI P5 XML, linking them to digital imagery from other open repositories, such as [EAP](http://eap.bl.uk/) and [HathiTrust](https://www.hathitrust.org), and generating a web display by, for instance, adapting the code base of [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/).

The most likely candidates for such follow-up projects are

- Muḥammad Rashīd Riḍā's journal *al-Manār*. A stub is already available on [GitHub](https://www.github.com/tillgrallert/digital-manar)
    + [full text from shamela](http://shamela.ws/index.php/book/6947): 8605 views
    + [imagery from hathitrust](http://catalog.hathitrust.org/Record/008882663),[imagery / PDFs from the Internet Archive](https://archive.org/details/almanaralmanar), which are linked from [*al-Maktaba al-Waqfiyya*](http://waqfeya.com/book.php?bid=7374)
- ʿAbd al-Qādir bin Muḥammad Salīm al-Kaylānī al-Iskandarānī's *majallat al-ḥaqāʾiq (al-dimashqiyya)*, 1910. Using the code and experiences from *Digital Muqtabas*, [*Digital Ḥaqāʾiq*](https://www.github.com/tillgrallert/digital-haqaiq) was created within only a single day's work.
    + [full text from shamela](http://shamela.ws/index.php/book/29676): 5134 views.
    + [imagery of vol. 1 (1910) from hathitrust](http://hdl.handle.net/2027/njp.32101036074001), vol. 2 and 3 are available at AUB.
- ʿAbdallah al-Nadīm's *majallat al-ustādh*, Cairo, 24 Aug 1892
    + [full text from shamela](http://shamela.ws/index.php/book/35118): 11337 views.

## 1.2 Milestones

1. Design a basic TEI schema; *done*
2. Import everything from shamela and convert it to TEI XML; *done*
3. Improve TEI mark-up: The following steps are independent of each other, need to be done on the issue / file level, and can be distributed across different editors.
    - Bibliographic metadata: volume, issue, page range
    - Basic structural mark-up: sections, articles, heads, authors
    - Page breaks and links to facsimiles
4. Adapt TEI Boilerplate to the needs of Arabic periodicals; *done*
5. Write XSLT to extract bibliographic metadata for every article in *al-Muqtabas*
    1. Basic: BibTeX; *done*
    2. Advanced: MODS; *done*
6. Presentations to solicit feedback
    - Leipzig, Germany, December 2015: DH Workshop Persian and Arabic
    - Cologne, Germany, March 2016: DiXiT Convention 2 <!-- provide link to blog post / programme -->
    - Cairo, Egypt, April 2016: Webinar at AUC library <!-- provide link to blog post / programme -->
    - Beirut, Lebanon, May 2016: Conference "Books in Motion" <!-- provide link to blog post / programme -->
    - Krakow, Poland, August 2016: DH2016 *cancelled (due to parental leave)*

## 1.3 Timeline / scheduled releases

There is no proper release schedule yet but I conceive of version 1.0 as the first complete edition.

- version 0.1 shall be the first "official" release. It is scheduled for May/June 2016 and will include
    1. TEI files of all at least one volume of *al-Muqtabas* (i.e. 12 issues / files) with structural mark-up of mastheads, sections, articles, and with page breaks linked to the facsimiles; for no other reason but interes in their content, we have started work on vol. 5 and 6, which are therefore the most likely release candidates;
    2. MODS / BibTeX files for all issues, sections, and articles;
    3. XSLT stylesheets for all necessary initial and periodic conversions;
    4. XSLT, JS, and CSS for a webview.
- versions 0.1 - 0.x: each completed volume of 11 to 12 issues / TEI files will warant an incremental release.
- version 1.0 shall include
    1. TEI files of all 96 issues of *al-Muqtabas* with structural mark-up of mastheads, sections, articles, and with page breaks linked to the facsimiles;
    2. all the components of version 0.1

<!-- - Project start: August 2015
- Initial schema design: August 2015
- Initial conversion: August 2015
- Improvement of TEI XML: since September 2015
- Initial adaptation of TEI Boilerplate: September/October 2015 -->


# 2. The journal *al-Muqtabas*

Muḥammad Kurd ʿAlī published the monthly journal *al-Muqtabas* between 1906 and 1917/18. After the Young Turk Revolution of July 1908, publication moved from Cairo to Damascus in the journal's third year.

## 2.1 Publication schedule and number of issues

There is some confusion as to the counting of issues and their publication dates. Samir Seikaly argues that Muḥammad Kurd ʿAlī was wrong in stating in his memoirs that he had published 8 volumes of 12 issues each and two independent issues.[^1] But the actual hard copies at the [Orient-Institut Beirut](http://www.orient-institut.org) and the digital facsimiles from HathiTrust and EAP show that Kurd ʿAlī was right insofar as volume 9 existed and comprised 2 issues only. As it turns out, *al-Muqtabas* also published a number of double issues: [Vol. 4 no. 5/6](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_41.TEIP5.xml) and [Vol. 8 no. 11/12](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_94.TEIP5.xml).

[^1]:{KurdʿAlī 1928@424}, {Seikaly 1981@128}

According to the masthead and the cover sheet, *al-Muqtabas*'s publication schedule followed the Islamic *hijrī* calendar (from the journal itself it must remain open whether the recorded publication dates were the actual publication dates). Sometimes the printers made errors: [no. 4/2](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_38.TEIP5.xml), for instance, carries Rab I 1327 aH as publication date on the cover sheet, but Ṣaf 1327 aH in its masthead. The latter would correspond to the official publication schedule. External sources, such as reports in the daily newspaper *al-Muqtabas*, also published by Muḥammad Kurd ʿAlī in Damascus, indicate that the actual publication sequence was indeed not too tightly tied to the monthly publication schedule already at the very beginning:

*Thamarāt al-Funūn* 29 Jan. 1906 / 4 Dhu II 1323 aH (#1548) announced the publication of [no.2 of *Majallat al-Muqtabas*](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_2.TEIP5.xml) two months earlier than the date indicated in the issue's masthead: Ṣafar 1324 aH.[^5] This also contradicts Muḥammad Kurd ʿAlī's memoirs, where he states that publication of *Muqtabas* commenced in early 1324 aH.[^11]

[^11]:{KurdʿAlī 1928@415}

An article in [no. 4(2)](https://github.com/openarabicpe/journal_al-muqtabas/blob/master/xml/oclc_4770057679-i_38.TEIP5.xml#div_25.d1e4565) scheduled for February/March 1909 was referenced in the newspaper [*al-Quds* #60 of 11 June 1909, p.4](http://www.palestine.mei.columbia.edu/alquds-issues/2017/2/21/issue-60).[^16] The back cover of no.4(4), available at OIB, announces the hope that no. 4(5) and 4(6) will be published as a double issue in mid-Shaʿbān (1327) or mid-August 1909. No. 4(5) was scheduled for Jum I 1327 (May/June 1909).

[^16]: {al-quds-1-60@4}

By Summer 1909, *al-Muqtabas* was lagging severely behind its publication schedule. [No. 4/7](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_42.TEIP5.xml), scheduled for Rajab 1327 aH (Jul/Aug 1909) was published only in the first week of April 1910 but it took only another week for [No. 4/8](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_43.TEIP5.xml) to appear.[^14] No. 4/9 and [4/10](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_45.TEIP5.xml) were then published within another month.[^4] Nevertheless there were still rather late (the latter should have been published in Shawwāl 1327 aH (Oct/Nov 1909)). [No. 4/12 (Dhu II 1327 aH [Dec 1909/ Jan 1910])](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_47.TEIP5.xml) was published at the beginning of July 1910, some seven months behind the schedule.[^6]

Muḥammad Kurd ʿAlī and his staff seemingly entered another productive period in fall 1910, publishing eight "monthly" issues in three months:

- *al-Muqtabas* 13 Sep. 1910 (#473) announced [no. 5/3](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_50.TEIP5.xml) that should have been published for/in Rab I 1328 aH (Mar/Apr 1910).[^7] But publication speed picked up and
- only eleven days later, *al-Muqtabas* 24 Sep. 1910 (#482) announced the publication of [no. 5/4](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_51.TEIP5.xml), which contains [a speech delivered by Rafīq Bey al-ʿAẓm to the al-Quwwatlī Club on 14 Shaʿbān 1328 / 21 August 1910](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_51.TEIP5.xml#div_2.d1e1392).[^8]
- *al-Muqtabas* 12 Dec. 1910 (#548) announced the publication of [no. 5/10](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_57.TEIP5.xml) of Shaw 1328 aH (Oct/Nov 1910).[^9]

Production seemingly followed a monthly pattern as it took slightly less then six months to publish the next six issues (5/11 - 6/4):

- *al-Muqtabas* 18 Jun. 1911 (#706) advertised Jamāl al-Dīn al-Qāsimī's three-partite article *al-fatwā fī al-islām* ([part one](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_61.TEIP5.xml#div_2.d1e1517), [two](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_62.TEIP5.xml#div_2.d1e1491), and [three](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_63.TEIP5.xml#div_7.d1e1810)) published in [no. 6/2 (Ṣafar 1329 / Feb 1911)](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_61.TEIP5.xml), [6/3](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_62.TEIP5.xml), and [6/4](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_63.TEIP5.xml) and mentioned that the copy of *Majallat al-Muqtabas* was sold for 1.5 *beşlik*s.[^10]
- *al-Muqtabas* 1 Jul. 1911 / 4 Raj 1329 aH (#717) announced the publication of two issues, [no.6/5](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_64.TEIP5.xml) and [6/6](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_65.TEIP5.xml), which according to the publication schedule should have been published in late April and late May respectively.[^2]

[^14]:[{muqtabas 76-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6831;r=10426). It is important to note that an article in [4/2](https://github.com/openarabicpe/journal_al-muqtabas/blob/master/xml/oclc_4770057679-i_38.TEIP5.xml) scheduled for February/March 1909 was referenced in the newspaper [*al-Quds* #60 of 11 June 1909](http://www.palestine.mei.columbia.edu/alquds-issues/2017/2/21/issue-60).
[^10]:[{muqtabas 274-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=7029;r=17843)
[^2]:[{muqtabas 283-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=7038;r=9551)
[^4]:[{muqtabas 100-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6855;r=6738)
[^5]:{tf-oib 1548@5}
[^6]:[{muqtabas 128-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6883;r=18866)
[^7]:[{muqtabas 184-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6939;r=1883)
[^8]:[{muqtabas 188-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6943;r=5230)
[^9]:[{muqtabas 200-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6955;r=4592). *al-Ḥaqāʾiq* 1(10),  1 Jum I 1329 aH, 17 Nīs 1327 R [30 Apr. 1911]:369-74 replied to an article in this issue of *al-Muqtabas*.

- In April 1912 the newspaper *al-Muqtabas* was banned from publication and an attempt was made to arrest Muḥammad Kurd ʿAlī over the re-print of a *qaṣīda* by Shaykh Ibrāhīm al-Uskūbī that had been previously published in the two Beiruti papers of *al-Waṭan* and *al-Balagh* without any repercussion from the censors. However, Muḥammad Kurd ʿAlī was seemingly warned by the arrest party itself and managed to escape to Egypt; his brother Aḥmad was arrested on in his stead and as the responsible editor of the newspaper *al-Muqtabas*. As a consequence, the publication of the journal *al-Muqtabas* moved to Cairo with [No. 7/6](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_77.TEIP5.xml).

- World War I
    + an article titled *General War* (*al-ḥarb al-ʿāmm*) in no. 8(7) mentions the Austrian attack on Serbia on 28 July 1914 as the beginning of the war and tracks the entry of countries by date into November 1914, continues well into 1915, mentions "at the end of 1915" and events on 31 May 1916

Similar confusion shrouds the end of publication in mystery. As no publication dates were actually provided in the mastheads of individual issues and since the issue wrappers were mostly discarded upon binding the issues into volumes, the only surviving explicit dating is provided by the volumes' cover sheets. According to its covers sheet, volume 8 was published through 1332 aH, i.e. between December 1913 and November 1914. However an [article in no. 8(9)](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_91.TEIP5.xml#p_98.d1e2707) reports on the inauguration of a Mosque in Berlin at the end of Ram 1333 aH (mid-August 1915). The same issue reviews a number of books printed in 1333 aH and [one book published in 1334 aH](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_91.TEIP5.xml#div_24.d1e3028) in addition to the announcement of a publication on the ["first year of the war"](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_91.TEIP5.xml#div_26.d1e3075), which would mean that it was not published before November 1915 (Muḥarram 1334 aH) and most likely in 1916. Issue 12 of the same volume even recorded a [notebook for the year 1917](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_94.TEIP5.xml#p_384.d1e4223) in the section on new books and publications, which also listed further books published in 1334 aH. The following issue continues this trend by publishing an [obituary for Shaykh ʿAbd al-Razzāq al-Bayṭār](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_95.TEIP5.xml#div_16.d1e2869), who died in Damascus on 10 Rab 1335 [4 January 1917].

## 2.2 Moving publication between Cairo and Damascus.

After the constitiutional revolution in the Ottoman Empire in July 1908, Muḥammad Kurd ʿAlī moved *al-Muqtabas* from Cairo to Damascus with the publication of no. [4/1](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_37.TEIP5.xml). <!-- After his initial enthusiasm for the Your Turks' project and the CUP vanished he  --> In consequence of Muḥammad Kurd ʿAlī being prosecuted over a reprinted article in the newspaper *al-Muqtabas* in April 1912, he fled to Cairo and (temporarily) moved the publication of the journal *al-Muqtabas* to the same location with no. [7/6](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_77.TEIP5.xml#div_14.d1e4462). Muḥammad Kurd ʿAlī provides the first account of these events in the same issue in an article titled [*Between Damascus and Cairo*](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_77.TEIP5.xml#div_10.d1e3876).

## 2.3 Known editions

In addition to the original edition, at least one reprint appeared: In 1992 Dār Ṣādir in Beirut published a facsimile edition, which is entirely unmarked as such but for the information on the binding itself. Checking this reprint against the original, it appeared to be a facsimile reprint: pagination, font, layout --- everything is identical. But as Samir Seikaly remarked in 1981 that he used "two separate compilations of *al-Muqtabas* [...] in this study" there must be at least one other print edition that I have not yet seen.[^12]

[^12]:{Seikaly 1981@128}

# 3. Input:

## 3.1 Digital imagery

Image files are available from the [*al-Aqṣā* Mosque's library in Jerusalem through the British Library's "Endangered Archives Project" (vols. 2-7)](http://eap.bl.uk/database/overview_project.a4d?projID=EAP119;r=63), [HathiTrust (vols. 1-6, 8)](http://catalog.hathitrust.org/Record/100658549), and [Institut du Monde Arabe](http://ima.bibalex.org/IMA/presentation/periodic/list.jsf?pid=9C82C139F9785E99D30089727B40A269). Due to its open access licence, preference is given to facsimiles from EAP.

### 3.1.1 [EAP119](http://eap.bl.uk/)

- IMPORTANT NOTE: EAP has changed its website and **ALL** links at some point in September 2017. Thus, all links to facsimiles are broken.

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

### 3.1.2 [HathiTrust](https://www.hathitrust.org/)

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

- PDFs from HathiTrust are shared by the anonymous blog ["Wanderer Above the Mist"](http://oldbooksandjournals.blogspot.de)
    - [vol. 1](http://download1325.mediafire.com/a6po86oua28g/qnc68dj1np3nufc/al-Muqtabas_v.1.pdf)
    - [vol. 2](http://download947.mediafire.com/rvmpvm8bx1ug/wv0uzhvxcsl763c/al-Muqtabas_v.2.pdf)
    - [vol. 3](http://download1490.mediafire.com/7nvo8i620tmg/6o4dg91sm44h94w/al-Muqtabas_v.3.pdf)
    - [vol. 4](http://download1638.mediafire.com/8h1btyxxqwng/ob5ltcw8y31u4gm/al-Muqtabas_v.4.pdf)
    - [vol. 5](http://download844.mediafire.com/n75opv8x2yxg/zbsul962j3tzfmg/al-Muqtabas_v.5.pdf)
    - [vol. 6](http://download1648.mediafire.com/odvuqafwb7tg/4edrgomncf5y84i/al-Muqtabas_v.6.pdf)
    - [vol. 8](http://download1322.mediafire.com/f3atj47uqy5g/uxgmhzxb2k97g4j/al-Muqtabas_v.8.pdf)
    - [index](http://download1472.mediafire.com/oz4edojz52zg/k4bpx2v733xcic9/al-Muqtabas_Index.pdf)


### 3.1.3 [arshīf al-majallāt al-adabiyya wa-l-thaqafiyya al-ʿarabiyya (archive.sakhrit.co)](archive.sakhrit.co)

Recently, a colleague pointed me to another gray online library of Arabic material---one that was entirely dedicated to cultural and literary journals: [arshīf al-majallāt al-adabiyya wa-l-thaqafiyya al-ʿarabiyya (archive.sakhrit.co)](archive.sakhrit.co). I have posted a review of the website on [my blog](https://tillgrallert.github.io/blog/2016/04/22/review-archive-sakhrit/).

Among their collection is also the journal [*al-Muqtabas*](http://archive.sakhrit.co/newmagazineYears/125) and they provide:

1. Partially watermarked digital imagery
2. Functional tables of content for each issue, including author, title, page number
3. Some bibliographic metadata on the issue level

After some assessment it turned out that at least volumes [4](http://archive.sakhrit.co/MagazinePages/Magazine_JPG/AL_moqtabs/Al_moqtabs_1909/Issue_1/001.JPG) and  [5](http://archive.sakhrit.co/MagazinePages/Magazine_JPG/AL_moqtabs/Al_moqtabs_1910/Issue_1/001.JPG), were indeed rendered from a modern digital text, namely shamela's transcription!

Therefore archive.sakhrit is even more problematic than shamela in terms of scholarly use. The user is always aware of reading a derivative with an unknown relation to an assumed original while accessing a text from shamela. At archive.sakhrit, on the other hand, the user is deceived by a seemingly faithful representation of a fake original.

In the future we will link to the archive.sakhrit's digital facsimiles for those volumes that have been scanned from the original. These are:

- Vol. 1: links to this volume are of particular importance as no scans are availble from EAP and those from HathiTrust remain unaccessible to the majority of potential users.

### 3.1.3 other sources

- Institut du Monde Arabe: bibliothèque numérique.
    + The website was built quite some time ago and is not meant for large screens. All digitised materials are served through a tiny pop-up window (740 x 570 px) even though the proprietary viewer allows for much larger views.
    + The scans are of a terrible quality
    + [vol. 1](http://viewer2.bibalex.org/BookViewer/?book_id=DAF-Job:224412&locale=en&EnableLogin=True)
    + [vol. 3](http://viewer2.bibalex.org/BookViewer/?book_id=DAF-Job:224413&locale=en&EnableLogin=True)
    + [vol. 4](http://viewer2.bibalex.org/BookViewer/?book_id=DAF-Job:224414&locale=en&EnableLogin=True)
    + [vol. 5](http://viewer2.bibalex.org/BookViewer/?book_id=DAF-Job:224415&locale=en&EnableLogin=True)

## 3.2 Full text

Somebody took the pains to create fully searchable text files and uploaded everything to [al-Maktaba al-Shamela](http://shamela.ws/index.php/book/26523) and  [WikiSource](https://ar.wikisource.org/wiki/%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D9%85%D9%82%D8%AA%D8%A8%D8%B3/%D8%A7%D9%84%D8%B9%D8%AF%D8%AF_1).


### 3.2.1 [al-Maktaba al-Shāmila](http://www.shamela.ws)

The digital text of [*al-Muqtabas* on *shamela.ws*](http://shamela.ws/index.php/book/26523) comprises all 96 issues totalling some 1.9 million words. It was transcribed from either digital facsimiles or original copies by anonymous transcribers following undocumented editing principles. Comparison with the original print edition allows us to discern common transcription errors, such as missing lines or characters, which indicate that *shamela.ws*'s text was indeed transcribed by humans without quality control through double-keying usually required for scholarly transcriptions (see [no. 4(2), p.82](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_38.TEIP5.xml#p_60.d1e2238), [no. 4(3), p.158](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_39.TEIP5.xml#gap_1.d1e3111), and [no. 6(12), pp.799--800](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_71.TEIP5.xml#pb_126.d1e4373) for examples). The comparison also reveals that *shamela.ws* principally omitted mastheads, all words in Latin script (mainly technical terms and proper nouns) and all footnotes.

The transcription has a number of substantial and unmarked gaps, ranging from a single paragraph to multiple pages (see [no. 5(7), pp. 463--466](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_54.TEIP5.xml#pb_61.d1e2036) and [no. 5(12), pp. 761--765](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_59.TEIP5.xml#pb_51.d1e2281) for examples). Some of these could be due to pages missing from the original from which the transcribers worked or page-turning errors. Others remain enigmatic and might have been driven by editorial choices. Someone copy edited the transcription, adding punctuation marks absent from the original and *hamza*s not commonly found in the original and thus, inter alia, differentiating between *inna* and *anna*. Some geographic names were normalised.

In terms of structural mark-up, *shamela.ws* did not provide but an ecclectic selection of top-level headers. Bibliographic metadata is all but nonexisting, since *shamela.ws* supplied faulty Gregorian publication dates and its own consecutive issue count that ignores the original collation into volumes.

- Transcribers, editors: Apparently, they have been typed and copy-edited by unnamed humans.
- Features edition: paragraphs, page breaks, some headlines.
- Features interface:
    + all issues can be browsed for headlines and searched
    + all pages can be individually adressed in the browser: [http://shamela.ws/browse.php/book-26523#page-2290](http://shamela.ws/browse.php/book-26523#page-2290)

### 3.2.2 WikiSource

Somebody uploaded the text from *shamela* to WikiSource. Unfortunately it is impossible to browse the entire journal. Instead one has to adress each individual and consecutively numbered issue, e.g. Vol. 4, No. 1 is listed as [No. 37](https://ar.wikisource.org/wiki/%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D9%85%D9%82%D8%AA%D8%A8%D8%B3/%D8%A7%D9%84%D8%B9%D8%AF%D8%AF_37)

# 4. Deliverable: TEI edition

The main challenge is to combine the full text and the images in a TEI edition. As *al-maktabat al-shāmila* did not reproduce page breaks true to the print edition, every single one of the more than 6000 page breaks must be added manually and linked to the digital image of the page.

## 4.1 General design

The edition is conceived of as a corpus of TEI files that are grouped by means of XInclude. This way, volumes can be constructed as single TEI files containing a `<group/>` of TEI files and a volume specific `<front/>` and `<back/>`

Detailled description and notes on the mark-up are kept in a separate [file (`documentation_tei-markup`)](documentation_tei-markup.md).

## 4.2 Quality control

A simple way of controlling the quality of the basic structural mark-up would be to cross check any automatically generated table of content or index against the published tables of content at the end of each volume and against the index of *al-Muqtabas* published by [Riyāḍ ʿAbd al-Ḥamīd Murād in 1977](http://hdl.handle.net/2027/umn.31951d008457474).

## 4.3 To do

1. Mark-up: The basic structural mark-up of individual issues is far from complete. All features encoded in HTML by *shamela.ws* have been translated into TEI XML, but these are limited to the main article / section headers. What needs to be done is:
    - splitting articles into sections and sections into individual articles
    - mark-up of authors with `<byline>`
2. Text-image linking: while the links to the facsimiles can be automatically generated for each issue, establishing page breaks (`<pb>`) must be done manually for all 6.000+ of them


# 5. Deliverable: A [web display](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_1.TEIP5.xml) adapting TEI Boilerplate

To allow a quick review of the mark-up and read the journal's content, I decided to customise [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/) for a first display of the TEI files in the browser without need for pre-processed HTML and to host this heavily customised boilerplate view as another [GitHub repository](https://www.github.com/tillgrallert/tei-boilerplate-arabic-editions) to be re-used.

The webview provides a parallel display of either online or local facsimiles and the text of *al-Muqtabas*. It includes a fully functional table of contents, stable links to all section and article heads, and links to bibliographic metadata for every article. For a first impression see [*al-Muqtabas* 6(2)](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_62.TEIP5.xml).

![webview of [*al-Muqtabas* 6(2)](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_62.TEIP5.xml)](assets/boilerplate_muqtabas-1.jpg)

![webview of [*al-Muqtabas* 6(2)](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_62.TEIP5.xml) with expanded table of content](assets/boilerplate_muqtabas-2.jpg)

A detailed description of the web display is available [here](notes-web-display.md).

User will, of course, want to search the edition for specific terms and will immediately recognise the lack of a dedicated search field in the webview. But behold, individual issues can be searched through the built-in search function in browsers; just hit `ctrl+f` (windows) or `cmd+f` (macintosh) to search individual periodical issues for literal strings. To search across the entire periodical, there are three instantly available options:

- the [GitHub repository](https://github.com/openarabicpe/journal_al-muqtabas), which allows for browsing and searching and displays search results in context.

![Search the GitHub repository](assets/search-github.jpg)

- Google's web search provides a [`site:` operator](https://moz.com/blog/25-killer-combos-for-googles-site-operator) that can be extensively manipulated:
    + [`site:https://github.com/openarabicpe/journal_al-muqtabas/blob/master search string`](site:https://github.com/openarabicpe/journal_al-muqtabas/blob/master) will search all files in the Digital Muqtabas repository.
    + add [`filetype:xml`](site:https://github.com/openarabicpe/journal_al-muqtabas/blob/master filetype:xml) to search only XML files. Other options would be `filetype:md` for plain text markdown files, `filetype.bib` for BibTeX files etc.

![Search Google with the `site:` operator](assets/search-google.jpg)

- a public [Zotero group](https://www.zotero.org/groups/digital-muqtabas/items/) comprising bibliographic metadata for all articles and sections, including author names, titles, publication dates, volume and issue numbers etc., including links to the webview.

# 6. Deliverable: Bibliographic metadata / index

Bibliographic metadata for every article in Majallat al-Muqtabas is provided in two formats: BibTeX and MODS in the sub-folder [`metadata`](metadata/). The metadata includes a URL pointing to the webview of this item and the webview, in turn, includes links to the metadata files for every article.

## 6.1 BibTeX

<!-- Added reference to principles of minimal computing etc.  -->
[BibTeX](http://www.bibtex.org/Format/) is a plain text format which has been around for more than 30 years and which is widely supported by reference managers. Thus it seems to be a safe bet to preserve and exchange minimal bibliographic data. OpenArbicPE maintains a number of [XSLT stylesheets to automatically generate BibTeX files](https://github.com/OpenArabicPE/convert_tei-to-bibtex) from the TEI source:

1. `Tei2BibTex-articles.xsl`: generates one BibTeX file for each article and section of a periodical issue.
2. `Tei2BibTex-issues.xsl`: generates one BibTeX file per periodical issue, comprising entries for every article and section.


There are, however, a number of problems with the format:

- The format and thus the tools implementing it aren't really strict.
- The [format description](http://www.bibtex.org/Format/) is fairly short and since development of BibTeX stalled between 1988 and 2010, it is most definitely not the most current or detailed when it comes to bibliographic metadata descriptions.[^13]
- Only basic information can be included:
    + information on publication dates is commonly limited to year and month only
    + periodicals are not perceived as having different editions or print-runs
    + non-Gregorian calendars cannot be added.

## 6.2 MODS (Metadata Object Description Schema)

The [MODS standard](http://www.loc.gov/standards/mods/) is expressed in XML and maintained by the [Network Development and MARC Standards Office](http://www.loc.gov/marc/ndmso.html) of the Library of Congress with input from users. Compared to BibTeX MODS has he advantage of being properly standardised, human and machine readable, and much better suited to include all the needed bibliographic information.

OpenArabicPE maintains a number of [XSLT stylesheets to automatically generate MODS XML files](https://github.com/OpenArabicPE/convert_tei-to-mods) from the TEI source:

1. `Tei2Mods-articles.xsl`: generates one MODS file for each article and section of a periodical issue.
2. `Tei2Mods-issues.xsl`: generates one MODS file per periodical issue, comprising entries for every article and section.

MODS also serves as the intermediary format for the free [bibutils suite](https://sourceforge.net/projects/bibutils/) of conversions between bibliographic metadata formats (including BibTeX) which is under constant development and released under a GNU/GPL (General Public License). `Tei2Mods-issues.xsl` and `bibutils` provide a means to automatically generate a large number of bibliographic formats to suit the reference manager one is working with; e.g.:

- to generate EndNote (refer-format) one only needs the following terminal command: `$ xml2end MODS.xml > output_file.end`
- to generate BibTex: `$ xml2bib MODS.xml > output_file.bib`


## 6.3 Index by means of a Zotero group

As the webview or reading edition is implemented on the issue level and as we have currently no plans to implement and host a database on the backend, *Digital Muqtabas* needed a way to navigate and browse all articles, authors etc. To this end, we have set up the public [Zotero group OpenArabicPE](ttps://www.zotero.org/groups/openarabicpe/items/). It can be updated by means of the MODS or BibTeX files. Updating from MODS is the preferred method since it is the more expressive format.

[Zotero groups](https://www.zotero.org/groups) are great way to share bibliographic metadata. Hosted by the Roy Rosenzweig Center for History and Media, they allow for public access to structured bibliographic metadata through a web interface. Of course they also integrate with the free and open-source reference manager [Zotero](https://www.zotero.org). All one needs is a free Zotero account and either the Zotero plug-in for the Firefox and Chrome browsers or the Zotero standalone version for Mac OSX and Linux. One can then join the group and sync all data to the local installation of Zotero, which means that, similar to the webview and all other components of this edition, bibliographic metadata can be browsed and searched through a graphical user interface without a continuous internet connection.


<!-- NOTES -->
[^1]:{KurdʿAlī 1928@424}, {Seikaly 1981@128}
[^2]:[{muqtabas 283-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=7038;r=9551)
[^4]:[{muqtabas 100-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6855;r=6738)
[^5]:{tf-oib 1548@5}
[^6]:[{muqtabas 128-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6883;r=18866). See also Muḥammad Kurd ʿAlī's article on the [scientific institutions of Paris](https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_47.TEIP5.xml#div_10.d1e3322) in his "Oddities of the West" printed in the same issue that refers to events in early December 1909 as past history.
[^7]:[{muqtabas 184-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6939;r=1883)
[^8]:[{muqtabas 188-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6943;r=5230)
[^9]:[{muqtabas 200-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6955;r=4592). *al-Ḥaqāʾiq* 1(10),  1 Jum I 1329 aH, 17 Nīs 1327 R [30 Apr. 1911]:369-74 replied to an article in this issue of *al-Muqtabas*.
[^10]:[{muqtabas 274-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=7029;r=17843)
[^11]:{KurdʿAlī 1928@415}
[^12]:{Seikaly 1981@128}
[^13]:[Wikipedia](https://en.wikipedia.org/wiki/BibTeX) has a better description than the official website.
[^14]:[{muqtabas 76-eap@3}](http://eap.bl.uk/database/overview_item.a4d?catId=6831;r=10426). It is important to note that an article in [4/2](https://github.com/openarabicpe/journal_al-muqtabas/blob/master/xml/oclc_4770057679-i_38.TEIP5.xml) scheduled for February/March 1909 was referenced in the newspaper [*al-Quds* #60 of 11 June 1909](http://www.palestine.mei.columbia.edu/alquds-issues/2017/2/21/issue-60).
[^15]: كرد علي, محمد (ed.). 1910. خاتمة السنة الخامسة. المقتبس, 5 (12), p. 800. Available at https://openarabicpe.github.io/journal_al-muqtabas/tei/oclc_4770057679-i_59.TEIP5.xml#div_9.d1e3208 [Accessed April 24, 2016].