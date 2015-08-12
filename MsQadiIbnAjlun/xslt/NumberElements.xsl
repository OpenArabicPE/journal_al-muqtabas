<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-16" omit-xml-declaration="no"/>
    
    <!-- this stylesheet numbers elements by means of the @n attribute -->
    
    <xsl:variable name="vElement" select="'row'"/>
    
    <!-- reproduce everything as is -->
    <xsl:template match="@* |node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- number the selected element -->
    <xsl:template match="tei:text//node()[name()=$vElement]">
        <xsl:copy>
            <xsl:attribute name="n">
                <xsl:value-of select="count(preceding::node()[name()=$vElement]) +1"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name()='n')] | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:text>Added automated numbers of </xsl:text>
                <xsl:element name="gi"><xsl:value-of select="$vElement"/></xsl:element>
                <xsl:text>s by means of </xsl:text>
                <xsl:element name="att">n</xsl:element>
                <xsl:text> and based on their absolute position in the file</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
