---
title: "TEI edition of *al-majallat al-muqtabas*"
author: Till Grallert
date: 2015-08-24
---

# To do

## Conceptual level

- URI design: each part of the edition down to, at least, the paragraph level should be addressable for reference in scholarly work.
    1. I decided to start with an existing identifier for *al-Muqtabas*, the OCLC number, and
    2. a continuous issue counter from 1 to 96
    
- Semantic web: it would be great to link at least references to books to existing records or to provide a means to do so.

## Mark-up

1. Mark-up: The basic structural mark-up of individual issues is far from complete
    - headlines
    - splitting articles into sections and sections into individual articles
    - mark-up of authors with `<byline>`
2. Text-image linking: while the links to the facsimiles can be automatically generated for each issue, establishing page breaks (`<pb>`) must be done manually for all 6.000+ of them

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

Somebody took the pains to create fully searchable text files and uploaded everything to [al-Maktaba al-Shamela](http://shamela.ws/index.php/book/26523) and to [WikiSource](https://ar.wikisource.org/wiki/%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D9%85%D9%82%D8%AA%D8%A8%D8%B3/%D8%A7%D9%84%D8%B9%D8%AF%D8%AF_1).


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

The edition should be conceived of as a corpus of tei files that are grouped by means of xinclude. This way, volumes can be constructed as single Tei files containing a `<group/>` of tei files and a volume specific `<front/>` and `<back/>`

## Challenges

+ There seems to be no ready-made converter from ePub to TEI P5. [OxGarage](http://www.tei-c.org/oxgarage/) provides a tool for the opposite direction.
+ Writing the XSLT could be trivial though. The ePub container contains a single xhtml file per page.

### example xhtml

~~~ {.xml}
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link href="../style.css" rel="stylesheet" type="text/css" />
<title>مجلة المقتبس</title>
</head>
<body class="rtl">
<div id="book-container">
<hr/>
<a id='C482'></a>
بسم الله الرحمن الرحيم<br /><br /><span class="title">سنتنا الرابعة</span><br />يفتتح المقتبس عامه الرابع بحمد الله ثناؤه والشكر على ما وفق إليه من نشر الحقائق التي يهديه إليها البحث والدرس لاهجاً بالدعوة التي طالما دعا إليها مجملاً ومفصلاً من أن مقصده نبث دفائن المدينة العربية وبث خزائن الحضارة الغربية مع ما يقتضي لذلك من النظر في تاريخنا وتاريخ الغربيين وآدابنا وآدابهم ومناحينا وأعمالنا وأعمالهم ناعياً عَلَي الجامدين عَلَى القديم إذ الاقتصار عليه وحده هو العقم بعينه داعياً إلى تناول الضروري من الحديث لأن القديم وحده يبلى ولا حديث لمن لا قديم له ومن لم يحرص على جديده فهو أقرب إلى الزهد كل حين بقديمه.<br />ندعو إلى الأخذ بمعارف الغربيين لأن ما أصاب هذا الشرق من ضعف العقول والملكات نشأ عن انصراف القلوب عن الاهتداء بهديهم ونهج سبيلهم في مادياتهم ومعنوياتهم والوقوف عند حد ما رسمه المخرفون والمخرقون فصدونا عن سبيل الانتفاع بالماضي وبالحاضر وحرموا بالتعصب الممقوت ما لم يحرمه عقل ولا نقل وسدوا الآذان عن سماع داعي المدنية وغضبوا عن الإبصار عن النظر في بدائع العلم والصناعة.<br />وإن المقتبس ليغتبط اليوم بصدوره من ضفاف بردى بعد أن انتشر عَلَى ضفاف النيل ثلاث سنين ولئن كان بردى بعض جداول النيل وترعه فإن المسك بعض دم الغزال ولئن قدر لمصر اليوم أن تسبق الشام في قوتها الأدبية والعلمية فليس ذلك من الجديد لما عرف به قديمها وإن كان وادي النيل أفسح وأخصب فوادي جلق الفيحاء أثمر وأعشب والسر في السكان لا في المكان. فعسى أن لا تكون أرض الشام أقل استعداداً لقطف ثمرات العلوم والمعارف وأن يظل مؤازرونا على إتحاف هذه المجلة بنتائج عقولهم فلا تعظم فائدة العمل إذا استقل به الفكر الواحد ولا تتنزع بفرد أفانين الفنون والآداب ونسأله تعالى تسديدنا وهدايتنا.
</div>
<hr/>
<div class="center">الجزء: 37 ¦ الصفحة: 1</div>
</body>
</html>
~~~


### example XSLT 
~~~ {.xslt}
<xsl:template match="html:div[@id='book-container']">
        <!-- pb -->
        <xsl:element name="tei:pb">
            <xsl:attribute name="n">
                <xsl:analyze-string select="following-sibling::html:div[@class='center']" regex="(الجزء\s*:\s*)(\d+).+(الصفحة\s*:\s*)(\d+)">
                    <xsl:matching-substring>
                        <xsl:value-of select="concat('n',regex-group(2),'-p',regex-group(4))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:attribute>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
~~~

## ePub conversion

- ePub container:
    + META-INF
    + OEBPS
        * img
        * xhtml
        * .listing
        * content.opf: contains a simple list of all packaged xhtml files
        * style.css
        * toc.ncx
    + mimetype
- encoding principles in *shamela* epub:
    + paragraphs are encoded as double line breaks: `<br/><br/>`
    + page and issue numbers are only encoded in human-readable form: `<div class="center">الجزء: 37 ¦ الصفحة: 1</div>`
        * see below for the example xslt to extract this information
    + seeming gaps in the transcription marked as `<span class="red">...</span>` indicate for a large part the break between the two parts of a verse (*bayt*) of a *qaṣīda*.
        * Verse and poetry are covered in [chapter 6 of the TEI guidelines](http://www.tei-c.org/release/doc/tei-p5-doc/en/html/VE.html)

- **problems** in *shamela* xhtml:
    + some entity references are not escaped: `&` instead of `&amp;`
- where to keep the bibliographic information from the ePub?

~~~{.xml}
<dc:title xmlns="http://www.idpf.org/2007/opf">مجلة المقتبس</dc:title> 
<dc:creator xmlns="http://www.idpf.org/2007/opf" opf:role="aut">محمد كرد علي</dc:creator> 
<dc:publisher xmlns="http://www.idpf.org/2007/opf">http://shamela.ws</dc:publisher> 
<dc:language xmlns="http://www.idpf.org/2007/opf">ar</dc:language> 
<dc:identifier xmlns="http://www.idpf.org/2007/opf" id="BookID" opf:scheme="UUID">urn:uuid:4caf7b615c3e7278c0cc1fcc2e80c7ec</dc:identifier> 
~~~



- necessary regex to clean up the data quickly
    + move the `<pb>` at the beginning of a new article inside the `<div>`
        1. `(<pb\sn=".[^"]+")\s*\n*\s*(corresp=".+\.xhtml"/>)\s*\n*\s*(</p></div><div>)(<head>)`
        2. `$3$1 $2$4`
    + split numbers into divs
        1. `(<div><head>العدد\s*\d+\s*</head>)`
        2. `</div><div>$1`
    + normalisation and mark-up for publication dates
        1. `(<head>)(العدد\s*)(\d+)(\s*</head>\s*<p>)(.+)(بتاريخ:\s*)(\d{1,2})\s\-\s(\d{1,2})\s\-\s(\d{4})`
        2. `<head><bibl><biblScope n="$3" unit="issue">$2$3</biblScope> <date when="$9-$8-$7">$6$7 - $8 - $9</date></bibl></head><p>`
        3. e.g. `<head>العدد 2</head><p> - بتاريخ: 26 - 3 - 1906`
        4. e.g. `<head><bibl><biblScope n="9" unit="issue">العدد 9</biblScope> <date when="1906-10-18">بتاريخ: 18 - 10 - 1906</date></bibl></head><p>`
    + translate line breaks into paragraphs
        1. `<lb/>`
        2. `</p><p>`
        3. delete all empty parapragphs: `<p>\s*</p>`

## Presentation by means of TEI Boilerplate

I chose TEI Boilerplate for a first display of the TEI files in the browser without need for pre-processed HTML. I have adapted TEI Boilerplate to my needs and made significant alterations to the functionality and look. For a first impression see [here](https://rawgit.com/tillgrallert/ArabicTeiEdition/boilerplate/MajallatMuqtabas/xml/oclc_4770057679_i60.TEIP5.xml).

# Web display

To allow a quick review of the mark-up and read the journal's content, I decided to customise [TEI Boilerplate]() and host this heavily altered boilerplate view as a seperate branch of the GitHub repository.

## Bibliographic metadata

The web display should contain automatically generated metadata down to the article level to ease harvesting/ crawling of bibliographic metadata.

### the `<meta>` tag

the `<meta>` tag in the HTML head allows to include RDF ontologies such as [Dublin Core, DC-HTML Prefixed Name as attribute value (XHTML)](dublincore.org/documents/2008/08/04/dc-html/), which are supported by Zotero etc. The syntax is documented [here](http://www.metatags.org/dublin_core_metadata_element_set) This is a quick solution for information on the issue level.

## [OpenURL COinS: A Convention to Embed Bibliographic Metadata in HTML](http://ocoins.info/)