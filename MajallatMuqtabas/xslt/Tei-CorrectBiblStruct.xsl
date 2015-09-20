<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd html"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet moves any <tei:gi>biblScope</tei:gi> from inside <tei:gi>imprint</tei:gi> to its paren <tei:gi>monograph</tei:gi> in order to comply with TEI encoding practices.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <!-- reproduce everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- document the changes -->
    <xsl:template match="tei:revisionDesc" priority="100">
        <xsl:copy>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:text>Corrected </xsl:text><tei:gi>biblStruct</tei:gi><xsl:text> by moving all </xsl:text><tei:gi>biblScope</tei:gi><xsl:text> from </xsl:text><tei:gi>imprint</tei:gi><xsl:text> to </xsl:text><tei:gi>monogr</tei:gi><xsl:text>.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- generate @xml:lang -->
    <xsl:template match="tei:monogr[./tei:imprint/tei:biblScope]">
        <xsl:copy>
           <xsl:apply-templates select="@* | node()"/>
            <xsl:apply-templates select="descendant::tei:biblScope"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:imprint[./tei:biblScope]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()[not(ancestor-or-self::tei:biblScope)]"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:result-document href="{substring-before(base-uri(),'.TEIP5.xml')}_corrected-biblStruct.TEIP5.xml">
            <xsl:copy>
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>