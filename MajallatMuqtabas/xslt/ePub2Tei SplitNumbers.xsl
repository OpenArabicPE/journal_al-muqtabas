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
            <xd:p>This stylesheet will transform an ePub from shamela.ws to TEI P5</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
   
    
    <!-- some variables -->
    <xsl:variable name="vDateTodayIso" select="format-date( current-date(),'[Y0001]-[M01]-[D01]')"/>
    
    <!-- the templates -->
    <xsl:template match="/">
        <xsl:result-document href="{ substring-before(base-uri(),'.TEIP5')}-SplitNumbers.TEIP5.xml">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- convert <body> to <group> -->
    <xsl:template match="tei:body">
        <group>
            <xsl:apply-templates select="@* | node()"/>
        </group>
    </xsl:template>
    
    <!-- create a <text> for each issue -->
    <xsl:template match="tei:div[./tei:div/tei:head/tei:bibl]">
        <text>
            <xsl:attribute name="n" select="concat('i',./tei:div/tei:head/tei:bibl/tei:biblScope/@n)"/>
            <front>
                <div>
                    <xsl:apply-templates select="descendant::tei:head/tei:bibl" mode="mFront"/>
                </div>
            </front>
            <body>
                <xsl:apply-templates select="@* | node()"/>
            </body>
        </text>
    </xsl:template>
    
    <!-- generate structured metadata in the front of each issue -->
    <xsl:template match="tei:bibl" mode="mFront">
        <biblStruct>
            <monogr>
                <title level="j">المقتبس</title>
                <editor>محمد كرد علي</editor>
                <imprint>
                    <pubPlace>دمشق</pubPlace>
                    <xsl:copy-of select="./tei:date"/>
                    <xsl:copy-of select="./tei:biblScope"/>
                </imprint>
            </monogr>
        </biblStruct>
    </xsl:template>

    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}">Divided the <gi>body</gi> into a <gi>group</gi> of <gi>text</gi>s along the issues of this periodical.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>