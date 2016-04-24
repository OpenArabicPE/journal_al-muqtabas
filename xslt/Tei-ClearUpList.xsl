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
            <xd:p>This stylesheet generates clears up groups of <p/>s wrapped in <list/> by transforming them into <item/>s.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml"  omit-xml-declaration="no" version="1.0"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:list/tei:p">
        <xsl:element name="item">
<!--            <xsl:element name="p">-->
                <xsl:apply-templates select="node()"/>
            <!--</xsl:element>-->
        </xsl:element>
    </xsl:template>
    
    <!-- correct tables -->
    <xsl:template match="tei:table/tei:p">
        <xsl:element name="row">
            <xsl:attribute name="role" select="'data'"/>
            <xsl:element name="cell">
                <xsl:apply-templates select="node()"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>