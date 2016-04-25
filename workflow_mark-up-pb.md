---
layout: post
title: "Workflow: Mark-up of page breaks"
author: Till Grallert
date: 2016-04-11 16:51:31
tags:
- documentation
- how to
- tei
- workflow
- xml
- xslt
---

The following semi-automatic workflow allows to quickly mark-up page breaks and link them to facsimiles. Changes should be committed to GitHub after every step at the absolute minimum.

Note that running XSLT 2.0 stylesheets requires some processing engine, most likely the open source [Saxon](https://sourceforge.net/projects/saxon/) processor. It comes built-in into many commercial XML editing tools, but currently I am not aware of any open-source and free-of-cost implementation. But as this project is envisioned as a collaboration, let's collaborate. As long as someone commits TEI files with mannually added page breaks (see step 2.1 below) and then sends us a pull request, another collaborator with access to commercial software can run the transformations.


# 1. Mark-up

## 1.1 Page breaks

Page breaks are recorded with the empty milestone element `<pb/>`. If a page break separates block level elements such as `<div>`, `<p>` or `<lg>`, the empty `<pb/>` is placed between the two elements and on the same level within the XML tree.

~~~{.xml}
<pb/>
<div>
    <p>Some text in a paragraph <pb/> that spans across pages</p>
    <p>Some text in a paragraph that does not span across pages</p>
    <pb/>
    <p>
        <!--  -->
    </p>
</div>
<pb/>
<div>
    <p></p>
    <!-- -->
</div>
~~~


Page breaks found in *al-maktaba al-shāmila* do not correspond to those in the original printed copies. They were therefore marked as `<pb ed="shamila">`. Page breaks corresponding to the original printed edition are identified by `@ed="print"`.

Dār Ṣādir in Beirut published a reprint in 1992, which is entirely unmarked as such but for the information on the binding itself. Checking this reprint against the original, it appeared to be a facsimile reprint: pagination, font, layout --- everything is identical.

1. Printed original copy: `<pb ed="print"/>`
    - the page number is recorded in the `@n` attribute
    - These page breaks are then linked through the `@facs` attribute to the `@xml:id` of a `<surface>` element; i.e. `<pb ed="print" n="78" facs="#facs_78"/>`
2. Transcription from *al-maktaba al-shāmila*: `<pb ed="shamela"/>`

## 1.2 Facsimiles

Facsimiles are linked through the `<facsimile>` child of `<TEI>`:

~~~{.xml}
<facsimile>
    <surface xml:id="facs_445">
        <graphic xml:id="facs_445-g_1" url="../images/oclc-4770057679_v6/njp-32101073250910_img-445.tif" mimeType="image/tiff"/>
        <graphic xml:id="facs_445-g_2" url="../images/oclc-4770057679_v6/njp-32101073250910_img-445.jpg" mimeType="image/jpeg"/>
        <graphic xml:id="facs_445-g_3" url="http://babel.hathitrust.org/cgi/imgsrv/image?id=njp.32101073250910;seq=445" mimeType="image/jpeg"/>
        <graphic xml:id="facs_445-g_4" url="http://eap.bl.uk/EAPDigitalItems/EAP119/EAP119_1_4_5-EAP119_muq191108_441_L.jpg" mimeType="image/jpeg"/>
    </surface>
</facsimile>
~~~

- The `@url` of `<graphic>` links to local downloads of the image as well as to the image hosted on HathiTrust and EAP servers.

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

<!-- The stylesheet allows for a set-off to be specified between the page number recorded in the `@n` attribute of `<pb ed="print"/>` and the facsimile that might  -->

Note that, when this stylesheet is run from oXygen's transformation pane in [`MajallatMuqtabas.xpr`](MajallatMuqtabas.xpr), the output is written to the subfolder [`xml/linked-pb/`](xml/linked-pb/) to protect the source files. Once the result of step 1 above has been committed to GitHub, the files from [`xml/linked-pb/`](xml/linked-pb/) can be copied back to [`xml/`](xml/)

1. Before:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة <pb ed="print" n="4"/>عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~

2. After:

~~~{.xml}
<seg> بن زكريا ابن حيويه الحزاز قراءة <pb ed="print" n="4" facs="#facs_8"/>عليه في يوم الأربعاء النصف من شهر رمضان سنة إحدى وثمانين</seg>
~~~
