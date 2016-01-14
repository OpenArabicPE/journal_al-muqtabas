<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" 
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:exsl="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    extension-element-prefixes="exsl msxsl"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    exclude-result-prefixes="xsl tei xd eg fn #default">
    
    
    <xsl:param name="pgLang" select="'ar'"/>
    <xsl:variable name="vgBiblStructSource" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
    <xsl:variable name="vgPublicationTitle" select="$vgBiblStructSource/tei:monogr/tei:title[@xml:lang=$pgLang]"/>
    <xsl:variable name="vgPublicationDate" select="$vgBiblStructSource/tei:monogr/tei:imprint/tei:date[1]/@when"/>
    <xsl:variable name="vgEditor" select="$vgBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang=$pgLang]"/>
    
    <xsl:template name="templMetadataDCFile">
        <xsl:param name="pLang" select="$pgLang"/>
        <meta name="dc.language" content="{$pLang}" />
        <meta name="dc.type" content="text" />
        <meta name="dc.title" content="{$vgPublicationTitle}" />
        <meta name="dc.creator" content="{$vgEditor}"/>
        <meta name="dc.date" content="{$vgPublicationDate}" />
    </xsl:template>
    
    <xsl:template name="templMetadataDCArticle">
        <xsl:param name="pInput"/>
        <xsl:variable name="vArticleTitle" select="./tei:head"/>
        <xsl:variable name="vAuthor" select="./tei:byline/descendant::tei:persName"/>
        <meta name="dc.type" content="text" />
        <meta name="dc.title" content="{$vArticleTitle}" />
        <meta name="dc.creator">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space($vgEditor)"/>
            </xsl:attribute>
        </meta>
        <meta name="dc.creator">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space($vgEditor)"/>
            </xsl:attribute>
        </meta>
        <meta name="dc.date" content="{$vgPublicationDate}" />
    </xsl:template>
</xsl:stylesheet>