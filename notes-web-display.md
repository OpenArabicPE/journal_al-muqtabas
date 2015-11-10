---
title: "Exposing the edition to the world"
author: Till Grallert
date: 2015-09-26
---

# Web display: TEI Boilerplate

To allow a quick review of the mark-up and read the journal's content, I decided to customise [TEI Boilerplate](http://dcl.slis.indiana.edu/teibp/) for a first display of the TEI files in the browser without need for pre-processed HTML and host this heavily customised boilerplate view as a seperate branch of the GitHub repository. For a first impression see [here](https://rawgit.com/tillgrallert/ArabicTeiEdition/boilerplate/MajallatMuqtabas/xml/oclc_4770057679_i60.TEIP5.xml).

## Bibliographic metadata

The web display should contain automatically generated metadata down to the article level to ease harvesting/ crawling of bibliographic metadata.

### the `<meta>` tag

the `<meta>` tag in the HTML head allows to include RDF ontologies such as [Dublin Core, DC-HTML Prefixed Name as attribute value (XHTML)](dublincore.org/documents/2008/08/04/dc-html/), which are supported by Zotero etc. The syntax is documented [here](http://www.metatags.org/dublin_core_metadata_element_set) This is a quick solution for information on the issue level.

### [OpenURL COinS: A Convention to Embed Bibliographic Metadata in HTML](http://ocoins.info/)

## Navigation

I implemented a simple navigation with `<ul>` and `<li>` inside the `<nav>` tag. The list is generated on the fly by XSLT 1 and styled with CSS.

## Images

Images are still displayed using TEI boilerplate's standard behaviour, which means that clicking on a thumbnail image opens a new browser window/ tab.