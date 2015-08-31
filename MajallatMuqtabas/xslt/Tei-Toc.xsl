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
            <xd:p>This stylesheet generates a table of content as <tei:list/> node.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <xsl:variable name="vPbEdition" select="'shamela'"/>
    
    <xsl:template match="/">
        <xsl:element name="tei:list">
            <xsl:apply-templates select="descendant::tei:text[@type='issue']/tei:body/descendant::tei:head">
                <xsl:sort select="if(starts-with(.,'ال')) then( substring(.,3)) else(.)" order="ascending"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <!-- this template creates a list item for each head with a reference to the preceding page number -->
    <xsl:template match="tei:head[parent::tei:div/@type='article'][not(ancestor::tei:div[@type='bill'])]">
        <xsl:element name="tei:item">
            <!-- one could look the @xml:lang up, but we know it's Arabic in the case of al-Muqtabas -->
            <xsl:attribute name="xml:lang" select="'ar'"/>
            <xsl:element name="tei:ref">
                <xsl:attribute name="target" select="concat('#',preceding::tei:pb[@ed=$vPbEdition][1]/@xml:id)"/>
                <xsl:value-of select="preceding::tei:pb[@ed=$vPbEdition][1]/@n"/>
            </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:element name="tei:ref">
                <xsl:attribute name="target" select="concat('#',@xml:id)"/>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>