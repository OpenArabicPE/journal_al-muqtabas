<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:html="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd html" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet produces a simple markdown file from TEI XML input</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="no" method="text" name="txt" media-type="text/plain"/>
    <xsl:strip-space elements="*"/>


    <!-- safe as new file -->
    <xsl:template match="/">
        <!--<xsl:result-document href="{substring-before(base-uri(),'.TEIP5.xml')}.md" format="txt">-->
            <xsl:apply-templates/>
        <!--</xsl:result-document>-->
    </xsl:template>

    <!-- provide the content of the TEI file -->
    <xsl:template match="text()[ancestor-or-self::tei:text]">
<xsl:text> </xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="tei:p">
<xsl:text>

</xsl:text>
<xsl:apply-templates/>
<xsl:text>

</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:div/tei:head">
<xsl:text>

</xsl:text>
<xsl:text># </xsl:text><xsl:apply-templates/>
<xsl:text>

</xsl:text>
    </xsl:template>
    <xsl:template match="tei:div/tei:div/tei:head">
<xsl:text>

</xsl:text>
<xsl:text>## </xsl:text><xsl:apply-templates/>
<xsl:text>

</xsl:text>
    </xsl:template>
    <xsl:template match="tei:div/tei:div/tei:div/tei:head">
<xsl:text>

</xsl:text>
<xsl:text>### </xsl:text><xsl:apply-templates/>
<xsl:text>

</xsl:text>
    </xsl:template>
    <xsl:template match="tei:div/tei:div/tei:div/tei:div/tei:head">
<xsl:text>

</xsl:text>
<xsl:text>#### </xsl:text><xsl:apply-templates/>
<xsl:text>

</xsl:text>
    </xsl:template>

    <!-- provide a YAML header -->
    <xsl:template match="tei:teiHeader">
<xsl:text>---
</xsl:text>
<xsl:text>title: "</xsl:text><xsl:value-of select="./tei:fileDesc/tei:titleStmt/tei:title[1]"/>'<xsl:text>"</xsl:text>
        <xsl:for-each select="./tei:fileDesc/tei:titleStmt/tei:author">
<xsl:text>
author: </xsl:text><xsl:apply-templates/>   
        </xsl:for-each>
<xsl:text>
---

</xsl:text> 
    </xsl:template>
    
    <!-- add whitespace for breaking whitespace -->
    <xsl:template match="tei:pb | tei:cb | tei:lb">
<xsl:text> </xsl:text>
    </xsl:template>
    
    <!-- remove elements from output -->
    <xsl:template match="tei:facsimile"/>
</xsl:stylesheet>
