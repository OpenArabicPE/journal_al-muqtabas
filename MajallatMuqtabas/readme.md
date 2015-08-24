---
title: "TEI edition of *al-majallat al-muqtabas*"
author: Till Grallert
date: 2015-08-24
---

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
    + [Index](http://hdl.handle.net/2027/umn.31951d008457474)
- access
    + The journal is in the public domain in the US and can be freely accessed and downloaded
    + Outside the US, access is restricted.
    + Formal [licence](https://www.hathitrust.org/access_use#pd-us-google): 
> Public Domain or Public Domain in the United States, Google-digitized: In addition to the terms for works that are in the Public Domain or in the Public Domain in the United States above, the following statement applies: The digital images and OCR of this work were produced by Google, Inc. (indicated by a watermark on each page in the PageTurner). Google requests that the images and OCR not be re-hosted, redistributed or used commercially. The images are provided for educational, scholarly, non-commercial purposes.
>Note: There are no restrictions on use of text transcribed from the images, or paraphrased or translated using the images.


# Full text

Somebody took the pains to create fully searchable text files and uploaded everything [al-Maktaba al-Shamela](http://shamela.ws/index.php/book/26523) and to [WikiSource](https://ar.wikisource.org/wiki/%D9%85%D8%AC%D9%84%D8%A9_%D8%A7%D9%84%D9%85%D9%82%D8%AA%D8%A8%D8%B3/%D8%A7%D9%84%D8%B9%D8%AF%D8%AF_1).


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

The main challenge is to combine the full text and the images in a TEI edition.

- Challenges
    + There seems to be no ready-made converter from ePub to TEI P5. [OxGarage](http://www.tei-c.org/oxgarage/) provides a tool for the opposite direction.
    + Writing the XSLT could be trivial though. The ePub container contains a single xhtml file per page.
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

## example xhtml

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

- encoding principles in *shamela* epub:
    + paragraphs are encoded as double line breaks: `<br/><br/>`
    + page and issue numbers are only encoded in human-readable form: `<div class="center">الجزء: 37 ¦ الصفحة: 1</div>`
        * the xslt to extract that information from above would be 

~~~ {.xsl}
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