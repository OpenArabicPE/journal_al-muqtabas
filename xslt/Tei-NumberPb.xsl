<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="vFirstPage" select="//tei:pb[1]/@n"/>
    
    <xsl:template match="tei:pb[not(@ed='shamela')]">
        <xsl:copy>
            <xsl:attribute name="ed">
                <xsl:text>print</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:value-of select="count(preceding::tei:pb[not(@ed='shamela')]) + $vFirstPage"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
<xsl:template match="@* | node()">
    <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
</xsl:template>
    
   <!-- <xsl:template match="text()"/>-->
    
</xsl:stylesheet>