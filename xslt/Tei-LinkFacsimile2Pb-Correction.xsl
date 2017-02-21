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
            <xd:p>This stylesheet corrects the offset between <tei:gi>pb</tei:gi> and <tei:gi>surface</tei:gi> elements through selective correction of the <tei:att>facs</tei:att> attribute.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    <!-- the page set-off is condition by the scans from HathiTrust and different for each volume:
        - vol. 4: 12
        - vol. 5: 14, 16 
        - vol. 6: 4 -->
    <xsl:param name="pPageSetOff" select="16"/>
    <!-- identify the author of the change by means of a @xml:id -->
    <xsl:param name="p_id-editor" select="'pers_TG'"/>
    <!-- select a range of <pb>s to be corrected -->
    <xsl:param name="pPbStart" select="210"/>
    <xsl:param name="pPbStop"/>
    <xsl:variable name="vPbStop">
        <xsl:choose>
            <xsl:when test="$pPbStop=''">
                <xsl:value-of select="max(tei:TEI/descendant::tei:pb[@ed='print']/@n)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pPbStop"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
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
                <xsl:attribute name="who" select="concat('#',$p_id-editor)"/>
                <xsl:text>Corrected the links between </xsl:text>
                <xsl:element name="tei:tag">
                    <xsl:text>pb ed="print"</xsl:text>
                </xsl:element>
                <xsl:text> and the corresponding facsimile from </xsl:text>
                <xsl:element name="tei:tag">
                    <xsl:text>pb ed="print" n="</xsl:text>
                    <xsl:value-of select="$pPbStart"/>
                    <xsl:text>"</xsl:text>
                </xsl:element>
                <xsl:text> to </xsl:text>
                <xsl:element name="tei:tag">
                    <xsl:text>pb ed="print" n="</xsl:text>
                    <xsl:value-of select="$vPbStop"/>
                    <xsl:text>"</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:pb[@ed='print']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="not(@facs)">
                    <xsl:attribute name="facs" select="concat('#facs_', @n + $pPageSetOff)"/>
                </xsl:when>
                <xsl:when test="(@n &gt;= $pPbStart) and (@n &lt;= $vPbStop)">
                    <xsl:attribute name="facs" select="concat('#facs_', @n + $pPageSetOff)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>