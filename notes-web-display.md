---
title: "Exposing the edition to the world"
author: Till Grallert
date: 2015-09-26
---

To allow a quick review of the mark-up and read the journal's content, I decided to customise [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/) for a first display of the TEI files in the browser without need for pre-processed HTML and to host this heavily customised boilerplate view as part of the [GitHub repository]()https://www.github.com/tillgrallert/digital-muqtabas). For a first impression see [here](https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/oclc_4770057679-i_60.TEIP5.xml). It is important to note that at the moment there is no front-end beyond the GitHub repository that allows for searching and browsing across files.

# Navigation
## Inside the file
I implemented a simple navigation with `<ul>` and `<li>` inside the native HTML `<nav>` tag. 
It provides hierarchival links to all `tei:div/tei:head` in the source XML using either already existing `@xml:id` or IDs generated on the fly through the `generate-id()` XPath function.

All heads link back to themselves using the stable URL based on their `@xml:id` if available. This URL can be used for reference and pointers in external sites and scholarly works.

The XLST also generates paragraph numbers computing every paragraph's position as descendant of `<tei:body>`. Again back links use the stable URL based on the paragraph's `@xml:id` and can be used for external reference.

## outside the file

Small buttons providing links to the previous and following issues were implemented in the same style as the internal navigation.

# Bibliographic metadata

The web display should contain automatically generated metadata down to the article level to ease harvesting/ crawling of bibliographic metadata.

## the `<meta>` tag

the `<meta>` tag in the HTML head allows to include RDF ontologies such as [Dublin Core, DC-HTML Prefixed Name as attribute value (XHTML)](dublincore.org/documents/2008/08/04/dc-html/), which are supported by Zotero etc. The syntax is documented [here](http://www.metatags.org/dublin_core_metadata_element_set) This is a quick solution for information on the issue level.

## [OpenURL COinS: A Convention to Embed Bibliographic Metadata in HTML](http://ocoins.info/)


# Images

Images are still displayed using TEI boilerplate's standard behaviour, which means that clicking on a thumbnail image opens a new browser window/ tab.

# Index / content of all volumes

I began writing an XSLT stylesheet for producing a static toc / index: `Tei2Html-toc.xsl`

- to do:
    + information on volume and issue for the entries
    + author information is not coming through
    + heads for the different lists are still missing
    + long lists should be broken down along the beginning letter