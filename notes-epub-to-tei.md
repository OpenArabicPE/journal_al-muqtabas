---
title: "Notes for conversion from EPub to TEI"
author: Till Grallert
date: 2015-08-24
---

# Challenges

+ There seems to be no ready-made converter from ePub to TEI P5. [OxGarage](http://www.tei-c.org/oxgarage/) provides a tool for the opposite direction.
+ Writing the XSLT could be trivial though. The ePub container contains a single xhtml file per page.

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


## example XSLT 
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

# ePub conversion

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
        2. `</div><div type="issue">$1`
    + normalisation and mark-up for publication dates
        1. `(<head>)(العدد\s*)(\d+)(\s*</head>\s*<p>)(.+)(بتاريخ:\s*)(\d{1,2})\s\-\s(\d{1,2})\s\-\s(\d{4})`
        2. `<head><bibl><biblScope n="$3" unit="issue">$2$3</biblScope> <date when="$9-$8-$7">$6$7 - $8 - $9</date></bibl></head><p>`
        3. e.g. `<head>العدد 2</head><p> - بتاريخ: 26 - 3 - 1906`
        4. e.g. `<head><bibl><biblScope n="9" unit="issue">العدد 9</biblScope> <date when="1906-10-18">بتاريخ: 18 - 10 - 1906</date></bibl></head><p>`
    + translate line breaks into paragraphs
        1. `<lb/>`
        2. `</p><p>`
        3. delete all empty parapragphs: `<p>\s*</p>`

- regex for Ḥaqāʾiq
    + split numbers into divs
        1. `(<head>العدد\s*\d+\s*</head>)`
        2. `</div><div type="issue">$1`
    + normalisation and mark-up for publication dates
        1. `(<head>)(العدد\s*)(\d+)(\s*</head>\s*<p>)(.+)(بتاريخ:\s*)(\d{1,2})\s\-\s(\d{1,2})\s\-\s(\d{4})`
        2. `<head><bibl><biblScope n="$3" unit="issue">$2$3</biblScope> <date when="$9-$8-$7">$6$7 - $8 - $9</date></bibl></head>`
        3. e.g. `<head>العدد 2</head><p> - بتاريخ: 26 - 3 - 1906`
        4. e.g. `<head><bibl><biblScope n="9" unit="issue">العدد 9</biblScope> <date when="1906-10-18">بتاريخ: 18 - 10 - 1906</date></bibl></head>`
    + look for all `<head>` that are not the issue head
        * `(<head>\s*.[^<]+</head>)`
        * `<div type="article">$1<p>`
    + provide the closing tags
        * `(</div>)`
        * `</p></div>$1`
        * 
    + correct all dates
        * `(when="\d{4}-)(\d{1})(-)(\d{1})`