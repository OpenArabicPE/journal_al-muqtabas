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
            <xd:p>This stylesheet generates a <tei:att>xml:id</tei:att> on the root note in accordance with my URI scheme and changes the file names accordingly.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <xsl:variable name="vFileName" select="tokenize(substring-before(base-uri(),'.TEIP5'),'/')[last()]"/>
    <xsl:param name="pBaseUri" select="'https://github.com/tillgrallert/digital-muqtabas/blob/master/xml/'"/>
    
    <!--<xsl:template match="/">
        <xsl:result-document href="{$vUri}.TEIP5.xml">
            <xsl:copy>
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>-->
    
    <!-- copy everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:copy>
            <xsl:if test="not(@xml:id)">
                <xsl:attribute name="xml:id" select="$vFileName"/>  
            </xsl:if>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <!-- check if tei:idno/@type='url' is present -->
                <xsl:if test="not(child::tei:idno[@type='url'])">
                    <xsl:element name="tei:idno">
                        <xsl:attribute name="type" select="'url'"/>
                        <xsl:value-of select="concat($pBaseUri,$vFileName,'.TEIP5.xml')"/>
                    </xsl:element>
                </xsl:if>
        </xsl:copy>
    </xsl:template>
    
    <!-- document the changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:text>Created </xsl:text><tei:att>xml:id</tei:att><xsl:text> for </xsl:text><tei:gi>TEI</tei:gi><xsl:text> and added </xsl:text><tei:tag>idno type="url"</tei:tag><xsl:text> containing the file's URL on GitHub to </xsl:text><tei:gi>publicationStmt</tei:gi>
                <!--<xsl:text> and changed the file name to reflect my URI design.</xsl:text>-->
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>