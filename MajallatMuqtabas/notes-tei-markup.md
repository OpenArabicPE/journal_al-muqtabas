---
title: "Notes for TEI mark-up"
author: Till Grallert
date: 2015-08-27
---

# Gaps in the transcription

Gaps in the transcription as copied from shamela are marked as `<gap resp="#org_MS" unit="pages" quantity="1"/>`

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

Only page breaks should are recorded (`<pb>`). The page breaks found in *al-maktaba al-shāmila*, however, do not correspond to those in the printed copies. They were therefore marked as `<pb ed="shamila">`. The page breaks corresponding to the printed edition are identified by `@ed="print"`.

1. Printed original copy:
2. Transcription from *al-maktaba al-shāmila*:

## Lists

## Notes

Unfortunately, *al-maktaba al-shāmila* did NOT include the sometimes abundant footnotes in their transcription.

## Words in other alphabets than Arabic

Unfortunately, *al-maktaba al-shāmila* did NOT include these words, often technical terms in articles on science and medicine, in their transcription.

## Tables

## Verse

Each line of a *qaṣīda* is encoded as `<lg type="bayt"/>`

~~~ {.xml}
<lg type="bayt">
    <l>وكذا الزراعة والصناعة والتجارة</l>
    <l>عززت في نجمها مبداكِ</l>
</lg>
~~~

# Typographic marks



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
    + How to encode this string "حسين كاظم بك والي حلب الحالي" ? Should the information on his position be included in the `<persName>`?
2. Places: `<placeName>`
3. Organisations: `<orgName>`

## references to intellectual works

References to intellectual works, such as books, periodicals, laws, etc. should be encoded using `<rs>` with the `@type="work"` and a more specific `@subtype` attribute:

1. Books: `<rs type="work" subtype="book">`
2. Periodicals: `<rs type="work" subtype="periodical">`
3. Laws, bills: `<rs type="work" subtype="bill">`

