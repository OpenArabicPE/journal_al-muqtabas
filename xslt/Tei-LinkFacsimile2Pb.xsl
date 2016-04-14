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
            <xd:p>This stylesheet links existing <tei:gi>pb</tei:gi> with existing <tei:gi>surface</tei:gi> elements through the <tei:att>facs</tei:att> attribute.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    <!-- new and much better approach: instead of trying to establish the link through @n, a set-off parameter, and @xml:id, one could just go by the sequence of <pb> and <surface> -->
    <!--<!-\- the page set-off is condition by the scans from HathiTrust and different for each volume:
        - vol. 4: 12
        - vol. 6: 4 -\->
    <xsl:param name="pPageSetOff" select="12"/>-->
    <!-- identify the author of the change by means of a @xml:id -->
    <xsl:param name="pAuthorXmlId" select="'pers_TG'"/>
    
    <!-- copy everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- document the changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#',$pAuthorXmlId)"/>
                <xsl:text>Linked all </xsl:text><tei:tag>pb ed="print"</tei:tag><xsl:text> to the corresponding facsimile</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:pb[@ed='print']">
        <xsl:variable name="vPosPb" select="count(preceding::tei:pb[@ed = 'print']) +1"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="not(@facs)">
                    <!--<xsl:attribute name="facs" select="concat('#facs_', @n + $pPageSetOff)"/>-->
                    <xsl:attribute name="facs">
                        <xsl:value-of select="concat('#',$vFacs/descendant::tei:surface[$vPosPb]/@xml:id)"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="vFacs" select="//tei:facsimile"/>
</xsl:stylesheet>