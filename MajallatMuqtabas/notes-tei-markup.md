---
title: "Notes for TEI mark-up"
author: Till Grallert
date: 2015-08-27
---

# Issues to be solved
## Serialised articles

While the technical linking by means of attributes is simple, how should the human-readible information contained in the print copies be encoded?

## Typographic marks

Early-twentieth century periodicals contain a lot of typographic markers indicating foreign words, technical terms, proper names, and the end of a section.

# Gaps in the transcription

Gaps in the transcription as copied from shamela are marked as `<gap resp="#org_MS" unit="pages" quantity="1"/>`. Many, if not most of these originated as the gap between two halves of a single line of a *qaṣīda*.

# Structure

Each issue is conceived of as a single `<text>` that is then grouped into volumes and a complete edition of all issues by means of xPointer.

## The periodical issue

The main structural unit are `<div>`s, as usual.

~~~{.xml}
<text type="issue">
    <front>
    <!-- some bibliographic data commonly found in the masthead -->
    </front>
    <body>
        <div type="article">
            <head></head>
            <p></p>
            <!-- ... -->
        </div>
        <div type="section">
            <head></head>
            <div type="article">
            <head></head>
            <p></p>
            <!-- ... -->
        </div>
        </div>
    </body>
</text>
~~~

The bibliographic meta data in the `<front>` is not necessarily found in the issue itself, as after Ramadan 1327 / September 1909 issues carried no date whatsoever.^["*al-Muqtabas* appeared regularly at the beginning of every Arab month only when it was published in Cairo (between *Muharram* 1324 / Februrary 1906 and *Dhul-hijja* 1909). When it was removed to Damascus and because of frequent official harassment, it appeared irregularly and somewhat haphazardly. Although after 1909, as indeed before it, each volume contained twelve numbers, nevertheless publication of each separate issue did not necessarily occur on time at the start of every month of the Muslim calendar. Indeed the last issue to which a specific month was affixed was *Ramadan* 1327 / September 1909. After that Kurd 'Ali merely numbered his journal by year, volume and issue. Because of this feature reference to *al-Muqtabas* in this study will throughout follow its owner's method of enumeration." {Seikaly 1981@126}]

##  Divisions: `<div>`

Divisions can be of various types (`@type`), using a semi-controlled vocabulary of attribute values

- advert
- article
- bill
- section
- verse

<!-- needs revisions -->
As paragraphs (`<p>`) cannot interlace with `<div>`s after the first `<div>` child of a parent `<div>`, `<div @type="article">` is commonly the lowest level of tesselation but in the case of very long articles that might themselves contain `@type="section"` children.

The common structure of an issue would be a mix of `<div @type="article">` and `<div @type="section">`


## Page, line, and column breaks

Only page breaks should are recorded (`<pb>`). The page breaks found in *al-maktaba al-shāmila*, however, do not correspond to those in the origial printed copies. They were therefore marked as `<pb ed="shamila">`. The page breaks corresponding to the original printed edition are identified by `@ed="print"`.
Dār Ṣādir in Beirut published a reprint in 1992, which is entirely unmarked as such but for the information on the binding itself. Checking this reprint against the originl, it appeared to be a facsimile reprint: pagination, font, layout --- everything is identical.

1. Printed original copy: `<pb ed="print"/>`
2. Transcription from *al-maktaba al-shāmila*: `<pb ed="shamela"/>`

## Lists

## Notes

Unfortunately, *al-maktaba al-shāmila* did NOT include the sometimes abundant footnotes in their transcription.


## Tables

## Verse

Each line of a *qaṣīda* is encoded as `<lg type="bayt"/>`

~~~ {.xml}
<lg type="bayt">
    <l>وكذا الزراعة والصناعة والتجارة</l>
    <l>عززت في نجمها مبداكِ</l>
</lg>
~~~

There are cases when words are split between the two lines of the *qaṣīda*:

![example for split line of a *qaṣīda*](material/qasida-bayt.png)

How should this be encoded?

~~~ {.xml}
<lg type="bayt">
    <l>أبرموا أمرهم عشاء فلما </l>
    <l> أصبحوا أصبحت لهم ضوضاء</l>
</lg>
<lg type="bayt">
    <l>من منادٍ ومن مجيبٍ ومن تص</l>
    <l>هالٍ خليل خلال ذاك رغاء</l>
</lg>
~~~

# Facsimiles

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
> 
>Note: There are no restrictions on use of text transcribed from the images, or paraphrased or translated using the images.

## Mark-up

Facsimiles are linked through the `<facsimile>` child of `<TEI>`:

~~~{.xml}
<facsimile>
    <surface xml:id="facs_v6_i1_445">
        <graphic xml:id="facs_v6_i1_445_g_1" url="../images/oclc-4770057679_v6/njp-32101073250910_img-445.tif" mimeType="image/tiff"/>
        <graphic xml:id="facs_v6_i1_445_g_2" url="../images/oclc-4770057679_v6/njp-32101073250910_img-445.jpg" mimeType="image/jpeg"/>
        <graphic xml:id="facs_v6_i1_445_g_3" url="http://babel.hathitrust.org/cgi/imgsrv/image?id=njp.32101073250910;seq=445" mimeType="image/jpeg"/>
</facsimile>
~~~

- The `@url` of `<graphic>` links to local downloads of the image as well as to the image hosted on HathiTrust's servers



# Metadata

## bibliographic information

All bibliographic information pertaining to the file and the individual periodical issue should be encoded in a `<biblStruct>`


1. In the `<teiHeader>` information should be provided in Latin script
2. In the `<front>` information should be provided in Arabic, just as it would in the masthead of the actual issue

### volume

### issue

All information on the individual issue is part of the *monographic* level of bibliographic metadata. Journals and anthologies are treated as monographs (`<monogr>`). The structure is as follows:

1. title and subtitle:
    - `<title level="j">` indicates a journal title
    - `<title level="j" type="sub">` indicates the subtitle
2. authors, editors, other persons in some way responsible for the content
    - `<editor>`
4. imprint: `<imprint>`
    1. place of publication: `<pubPlace>`
    2. publisher: `<publisher>`
    3. date of publication: `<date>`
5. scope of item (volume, issue, pages)
    - `<biblScope>` with `@unit` attribute of "volume", "issue", "pages" and `@n`, `@from`, `@to` indicating the actual extent. The element should have no `text()` content to avoid language-specificity

Current structure of the `<biblStruct>` in `<sourceDesc>`:

~~~{.xml}
<biblStruct>
    <monogr>
        <title level="j" xml:lang="ar">المقتبس</title>
        <title level="j" type="sub" xml:lang="ar">مجلة تبحث في التربية والتعليم والاجتماع والاقتصاد والاداب والتاريخ والآثار واللغة و تدبير المنزل والصحة والكتب وحضارة العرب والغرب</title>
        <title level="j" type="sub" xml:lang="ar">تصدر في كل شهر عربي بدمشق</title>
        <title level="j" xml:lang="ar-Latn-x-ijmes">[Majallat] al-Muqtabas</title>
        <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">Majalla tabḥath fī al-tarbiyya wa-l-taʿlīm wa-l-ijtimāʿ wa-l-iqtiṣād wa-l-adab wa-l-tārīkh wa-l-āthār wa-l-llugha wa tadbīr al-manzil wa-l-ṣaḥḥa wa-l-kutub wa ḥaḍāra al-ʿarab wa ḥadāra al-gharb</title>
        <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">tuṣadir fī kull shar ʿarabī bi-Dimashq</title>
        <title level="j" xml:lang="fr">Al-Moktabas</title>
        <title level="j" type="sub" xml:lang="fr">Revue mensuelle paraissant à Damas (Syrie)</title>
        <title level="j" type="sub" xml:lang="fr">Pédagogie, sociologie, économie politique, littérature, histoire, archéologie, philologie, ménagerie, hygiène, bibliographie, civilisation arabe et occidentale</title>
        <editor xml:lang="ar">
            <persName>
                <forename>محمد</forename>
                <surname>كرد علي</surname>
            </persName>
        </editor>
        <editor xml:lang="ar-Latn-x-ijmes" ref="https://viaf.org/viaf/32272677">
            <forename>Muḥammad</forename>
            <surname>Kurd ʿAlī</surname>
        </editor>
        <imprint>
            <publisher notAfter="1914" notBefore="1908" xml:lang="ar">
                <orgName>مطبعة المقتبس</orgName>
            </publisher>
            <publisher notAfter="1914" notBefore="1908">
                <orgName xml:lang="ar-Latn-x-ijmes">Maṭbaʿa al-Muqtabas</orgName>
            </publisher>
            <pubPlace xml:lang="ar" notBefore="1908" notAfter="1914">
                <placeName>دمشق</placeName>
            </pubPlace>
            <pubPlace xml:lang="en" notBefore="1908" notAfter="1914">
                <placeName>Damascus</placeName>
            </pubPlace>
            <date xml:lang="ar" when-custom="1329-01-01" datingMethod="#cal_islamic" calendar="#cal_islamic" when="1911-01-02">١ محرم ١٣٢٩</date>
            <date xml:lang="ar-Latn-x-ijmes" when-custom="1329-01-01" datingMethod="#cal_islamic" calendar="#cal_islamic" when="1911-01-02">1 Muḥ 1329</date>
        </imprint>
        <biblScope unit="volume" n="6"/>
        <biblScope unit="issue" n="1"/>
        <biblScope unit="page" from="1" to="88"/>
    </monogr>
    <idno type="oclc">4770057679</idno>
    <idno type="oclc">79440195</idno>
    <idno type="aucr">07201136864</idno>
    <idno type="shamela">26523</idno>
</biblStruct>
~~~

Better and shorter idea, without loosing any information:

~~~{.xml}
<biblStruct>
    <monogr>
        <title level="j" xml:lang="ar">المقتبس</title>
        <title level="j" type="sub" xml:lang="ar">مجلة تبحث في التربية والتعليم والاجتماع والاقتصاد والاداب والتاريخ والآثار واللغة و تدبير المنزل والصحة والكتب وحضارة العرب والغرب</title>
        <title level="j" type="sub" xml:lang="ar">تصدر في كل شهر عربي بدمشق</title>
        <title level="j" xml:lang="ar-Latn-x-ijmes">[Majallat] al-Muqtabas</title>
        <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">Majalla tabḥath fī al-tarbiyya wa-l-taʿlīm wa-l-ijtimāʿ wa-l-iqtiṣād wa-l-adab wa-l-tārīkh wa-l-āthār wa-l-llugha wa tadbīr al-manzil wa-l-ṣaḥḥa wa-l-kutub wa ḥaḍāra al-ʿarab wa ḥadāra al-gharb</title>
        <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">tuṣadir fī kull shar ʿarabī bi-Dimashq</title>
        <title level="j" xml:lang="fr">Al-Moktabas</title>
        <title level="j" type="sub" xml:lang="fr">Revue mensuelle paraissant à Damas (Syrie)</title>
        <title level="j" type="sub" xml:lang="fr">Pédagogie, sociologie, économie politique, littérature, histoire, archéologie, philologie, ménagerie, hygiène, bibliographie, civilisation arabe et occidentale</title>
        <editor ref="https://viaf.org/viaf/32272677">
            <persName xml:lang="ar">
                <forename>محمد</forename>
                <surname>كرد علي</surname>
            </persName>
            <persName xml:lang="ar-Latn-x-ijmes" >
                <forename>Muḥammad</forename>
                <surname>Kurd ʿAlī</surname>
            </persName>
        </editor>
        <imprint>
            <publisher notAfter="1914" notBefore="1908">
                <orgName xml:lang="ar">مطبعة المقتبس</orgName>
                <orgName xml:lang="ar-Latn-x-ijmes">Maṭbaʿa al-Muqtabas</orgName>
            </publisher>
            <pubPlace notBefore="1908" notAfter="1914">
                <placeName xml:lang="ar">دمشق</placeName>
                <placeName xml:lang="en">Damascus</placeName>
            </pubPlace>
            <date xml:lang="ar" when-custom="1329-01-01" datingMethod="#cal_islamic" calendar="#cal_islamic" when="1911-01-02">١ محرم ١٣٢٩</date>
            <date xml:lang="ar-Latn-x-ijmes" when-custom="1329-01-01" datingMethod="#cal_islamic" calendar="#cal_islamic" when="1911-01-02">1 Muḥ 1329</date>
        </imprint>
        <biblScope unit="volume" n="6"/>
        <biblScope unit="issue" n="1"/>
        <biblScope unit="page" from="1" to="88"/>
    </monogr>
    <idno type="oclc">4770057679</idno>
    <idno type="oclc">79440195</idno>
    <idno type="aucr">07201136864</idno>
    <idno type="shamela">26523</idno>
</biblStruct>
~~~

~~~{.xml}
<biblStruct>
    <monogr>
        <title level="j">المقتبس</title>
        <editor>محمد كرد علي</editor>
        <imprint>
            <pubPlace>دمشق</pubPlace>
            <publisher>المطبعة المقتبس</publisher>
            <date when-custom="1329-01-01" datingMethod="#cal_islamic" calendar="#cal_islamic" when="1911-01-02">١ محرم ١٣٢٩</date>
        </imprint>
        <biblScope unit="volume" n="6">المجلد السادس</biblScope>
        <biblScope unit="issue" n="1">الجزء الاول</biblScope>
        <biblScope unit="page" from="1" to="88"/>
    </monogr>
</biblStruct>
~~~

## Languages: `@xml:id`

The use of language codes as values for `@xml:id` follows [BCP 47](http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) and specifies that the language code is to be followed by information on the script, if the latter is not the common script for this language, followed by information on the transribing convention.

~~~{.xml}
<langUsage>
    <language ident="ar">Arabic</language>
    <language ident="ar-Latn-x-ijmes">Arabic transcribed into Latin script following the IJMES conventions</language>
    <language ident="ar-Latn-EN">Arabic transcribed into Latin script following common English practices</language>
    <language ident="ar-Latn-FR">Arabic transcribed into Latin script following common French practices</language>
    <language ident="en">English</language>
    <language ident="en-Arab-AR">English transcribed into Arabic script following common Levantine Arabic practices</language>
    <language ident="fa">Farsi</language>
    <language ident="fa-Latn-x-ijmes">Farsi transcribed into Latin script following the IJMES conventions</language>
    <language ident="fr">French</language>
    <language ident="fr-Arab-AR">French transcribed into Arabic script following common Levantine Arabic practices</language>
    <language ident="ota">Ottoman</language>
    <language ident="ota-Latn-x-ijmes">Ottoman transcribed into Latin script following the IJMES conventions</language>
    <language ident="tr">Turkish</language>
</langUsage>
~~~

### Words in other alphabets than Arabic

Unfortunately, *al-maktaba al-shāmila* did NOT include these words, often technical terms in articles on science and medicine, in their transcription.

# non-structural phenomena of interest to the historian

## Measures and prices

For the moment I would settle for the following pattern: 

~~~ {.xml}
Imagine, someone bought <measureGrp><measure commodity="wheat" quantity="2" unit="kile">two kile of wheat</measure> at the price of <measure commodity="currency" quantity="3" unit="ops">Ps 3</measure></measureGrp>.
~~~

- for **prices**, I suggest using `@commodity="currency"`. 
    + The `@unit` then follows standard three-letter shorthand for currencies. 
        * Ottoman piasters shall be recorded as `@unit="ops"`
        * Ottoman pound (£T) shall be recorded as `@unit="lt"`
    + the `@quantity` attribute has some restrictions as to its value and cannot contain the string 8-2-4 to signify, for instance, £ 8"2"4 or 8l 2s 4d. Yet it would be extremely tedious to encode all the fractions of non-metrical currencies as individual measures. One way of doing it would be on-the-spot conversion into decimal values, but this needs computing on the side of the encoder.
    + non metrical values can be recorded without `@quantity`
- for **wages**, I suggest the same as for prices of commodities, but instead of, for instance, wheat, `@commodity="labor"` would be counted in `@unit="day"` or `@unit="month"`
- to ease data entry, I wrote small **snippets in aText**:
    + $measg expands into `<measureGrp/>`and copies the content of the clipboard between the tags
    + $price expands into `<measure commodity="currency">` etc. and copies the content of the clipboard between the tags
    + $meas expands into `<measure commodity="">` etc. and copies the content of the clipboard between the tags

## Persons, Places, Organisations

1. Persons:`<persName>`
    + How to encode this string: "حسين كاظم بك والي حلب الحالي" ? Should the information on his position be included in the `<persName>`?
2. Places: `<placeName>`
    + How to encode this string: "فبفطر الراكب في الصباح في الفيحاء ويتعشى في حاضرة سورية البيضاء"? الفيحاء or الشهباء are clearly references to places by name, but are they a `<placeName>`?
3. Organisations: `<orgName>`

## Dates and calendars

1. `@calendar="#cal_gregorian"`
2. `@calendar="#cal_islamic"`
3. `@calendar="#cal_julian"`
4. `@calendar="#cal_ottomanfiscal"`

## references to intellectual works
### 1. encoding with `<title>`

References to titles of intellectual works, such as books, periodicals etc., could be encoded with `<title>` using the `@level` attribute for some granularity.

~~~{.xml}
حتى بلغ المطبوع منها مليون نسخة وأصبحت اليوم تطبع مليوناً ومائتي ألف نسخة في حين تطبع <title level="j">التيمس</title> 55 ألفاً فقط و<title level="j">الديلي اكسبرس</title> 700 ألف و<title level="j">الديلي تلغراف</title> 350 ألفاً والديلي نيوز 300 ألف والمورنن ليدر 350 والستاندارد 120 ألفاً
~~~

### 2. encoding with `<rs>`

References to intellectual works, such as books, periodicals, laws, etc. should be encoded using `<rs>` with the `@type="work"` and a more specific `@subtype` attribute:

1. Books: `<rs type="work" subtype="book">`
2. Periodicals: `<rs type="work" subtype="periodical">`
3. Laws, bills: `<rs type="work" subtype="bill">`



