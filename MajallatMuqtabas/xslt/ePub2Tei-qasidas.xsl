<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet will paragraphs with a single gap node in the center into line groups.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    
    
    <!-- some variables -->
    <xsl:variable name="vDateTodayIso" select="format-date( current-date(),'[Y0001]-[M01]-[D01]')"/>
    
    <!-- the templates -->
    <xsl:template match="/">
        <xsl:result-document href="{ substring-before(base-uri(),'.TEIP5')}-Qasidas.TEIP5.xml">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:p[count(child::node())=3][child::tei:gap[@resp='#org_MS']]">
        <lg type="bayt">
            <xsl:for-each select="child::text()">
                <l><xsl:value-of select="."/></l>
            </xsl:for-each>
        </lg>
    </xsl:template>
    
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}">Converted the mark-up of <foreign xml:lang="ar-Latn-x-ijmes">qaṣīda</foreign>s from <gi>p</gi>s divided by a <gi>gap</gi> to <gi>lg</gi> of <att>type</att>="bayt" comprising two <gi>l</gi> nodes.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>