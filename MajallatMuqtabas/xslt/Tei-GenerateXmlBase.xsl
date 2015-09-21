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
            <xd:p>This stylesheet generates a <tei:att>xml:base</tei:att> on the basis of the file name</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <xsl:variable name="vFileName" select="tokenize(base-uri(.),'/')[last()]"/>
    <!-- safe as new file -->
    <xsl:template match="/">
        <!--<xsl:result-document href="{substring-before(base-uri(),'.TEIP5.xml')}_BaseUri.TEIP5.xml">-->
            <xsl:copy>
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        <!--</xsl:result-document>-->
    </xsl:template>
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
                <xsl:text>Corrected all </xsl:text><tei:att>xml:id</tei:att><xsl:text>s based on a scheme of </xsl:text><tei:att>xml:base</tei:att><xsl:text> and local URIs</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- mark up numerals -->
    <xsl:template match="tei:TEI">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="xml:base" select="$vFileName"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
  
</xsl:stylesheet>