---
title: "Mark-up of page breaks"
author: Till Grallert
date: 2016-04-11 16:51:31
---

The following semi-automatic workflow allows to quickly mark-up page breaks and link them to facsimiles. Changes should be committed to GitHub after every step at the absolute minimum.

# 1. Mark-up

## 1.1 Page breaks

Page breaks are recorded with the empty milestone element `<pb/>`.  Page breaks found in *al-maktaba al-shāmila*, however, do not correspond to those in the original printed copies. They were therefore marked as `<pb ed="shamila">`. Page breaks corresponding to the original printed edition are identified by `@ed="print"`.

Dār Ṣādir in Beirut published a reprint in 1992, which is entirely unmarked as such but for the information on the binding itself. Checking this reprint against the original, it appeared to be a facsimile reprint: pagination, font, layout --- everything is identical.

1. Printed original copy: `<pb ed="print"/>`
    - the page number is recorded in the `@n` attribute
    - These page breaks are then linked through the `@facs` attribute to the `@xml:id` of a `<surface>` element; i.e. `<pb ed="print" n="78" facs="#facs_78"/>`
2. Transcription from *al-maktaba al-shāmila*: `<pb ed="shamela"/>`

# 2. Workflow
## 2.1 Manually place `<pb/>` tags

The tag `<pb/>`, marking a page break in TEI, must be manually placed into the text string:

1. Before:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~

2. After:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة <pb/>عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~

## 2.2 Automatically number `<pb/>`s

On the assumption that all page breaks in an issue have been marked and that the sequence of pages is uninterrupted, one can automatically number page breaks by running the XSLT stylesheet [`xslt/Tei-NumberPb.xsl`](xslt/Tei-NumberPb.xsl).

Note that, when this stylesheet is run from oXygen's transformation pane in [`MajallatMuqtabas.xpr`](MajallatMuqtabas.xpr), the output is written to the subfolder [`xml/numbered-pb/`](xml/numbered-pb/) to protect the source files. Once the result of step 1 above has been committed to GitHub, the files from [`xml/numbered-pb/`](xml/numbered-pb/) can be copied back to [`xml/`](xml/)

1. Before:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة <pb/>عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~

2. After:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة <pb ed="print" n="4"/>عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~

## 2.3 Automatically link `<pb/>`s

If a `<facsimile>` containing `<surface>` child elements has been added to the TEI files, these can be automatically linked to all `<pb ed="print"/>` that carry the `@n` attribute. This is done through transforming the XML with the XSLT stylesheet [`xslt/Tei-LinkFacsimile2Pb.xsl`](xslt/Tei-LinkFacsimile2Pb.xsl).

Note that, when this stylesheet is run from oXygen's transformation pane in [`MajallatMuqtabas.xpr`](MajallatMuqtabas.xpr), the output is written to the subfolder [`xml/linked-pb/`](xml/linked-pb/) to protect the source files. Once the result of step 1 above has been committed to GitHub, the files from [`xml/linked-pb/`](xml/linked-pb/) can be copied back to [`xml/`](xml/)

1. Before:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة <pb ed="print" n="4"/>عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~

2. After:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة <pb ed="print" n="4" facs="#facs_8"/>عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~
