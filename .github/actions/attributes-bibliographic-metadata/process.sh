#!/bin/bash
# this selector is ignorant of the triggering file. The action will run on all files not just the ones recently changed
for file in `ls tei/oclc_*.TEIP5.xml`
do
    echo "Add @xml:id to all new elements"
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/tools/xslt/tei_generate-xml-id.xsl -o:"$file" p_id-editor='github'
    echo "Add @xml:lang to all new elements"
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/tools/xslt/tei_generate-xml-lang.xsl -o:"$file" p_id-editor='github'
    # echo "Update sitemap.xml for Google's programmable search"
    # saxon -s:"$file" -xsl:https://openarabicpe.github.io/tools/xslt/generate_sitemap.xsl p_github-action=true
    echo "Update / generate bibliographic metadata"
    echo "MODS"
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/convert_tei-to-bibliographic-data/xslt/convert_tei-to-mods_issues.xsl p_github-action=true
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/convert_tei-to-bibliographic-data/xslt/convert_tei-to-mods_articles.xsl p_github-action=true
    echo "BibTeX"
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/convert_tei-to-bibliographic-data/xslt/convert_tei-to-bibtex_issues.xsl p_github-action=true
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/convert_tei-to-bibliographic-data/xslt/convert_tei-to-bibtex_articles.xsl p_github-action=true
    echo "YAML"
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/convert_tei-to-bibliographic-data/xslt/convert_tei-to-yaml_issues.xsl p_github-action=true
    echo "Zotero RDF"
    saxon -s:"$file" -xsl:https://openarabicpe.github.io/convert_tei-to-bibliographic-data/xslt/convert_tei-to-zotero-rdf_issues.xsl p_github-action=true
done