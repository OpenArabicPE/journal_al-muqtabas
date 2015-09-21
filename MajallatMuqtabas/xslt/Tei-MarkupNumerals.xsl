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
            <xd:p>This stylesheet analyses all text() for numerals and wraps them in a <tei:gi>num</tei:gi> element with the <tei:att>value</tei:att> attribute stating the value in normalised form. The numeral is then converted into Arabic script to reflect the original type-setting conventions of the time.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <xsl:param name="pUrlInput" select="'../xml'"/>
    <xsl:variable name="vUrlInput" select="concat($pUrlInput,'?select=*.xml;recurse=yes')"/>
    
    
    <xsl:variable name="vStringTranscribeFromIjmes" select="'btḥḫjdrzsṣḍṭẓʿfqklmnhāūīwy0123456789'"/>
    <xsl:variable name="vStringTranscribeToArabic" select="'بتحخجدرزسصضطظعفقكلمنهاويوي٠١٢٣٤٥٦٧٨٩'"/>
    
    <!-- safe as new file -->
    <xsl:template match="/">
        <!--<xsl:result-document href="{substring-before(base-uri(),'.TEIP5.xml')}_MarkupNumerals.TEIP5.xml">-->
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
                <xsl:text>Wrapped all numerals in </xsl:text><tei:gi>num</tei:gi><xsl:text> with </xsl:text><tei:att>value</tei:att><xsl:text> recording their value in standardised form and converted them into Arabic numerals to reflect the original text.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- mark up numerals -->
    <xsl:template match="text()[ancestor-or-self::tei:text]">
        <xsl:analyze-string select="." regex="(\d+)">
            <xsl:matching-substring>
                <!-- somtimes in shamela's transcription numerals are not surrounded by whitespace -->
                <xsl:text> </xsl:text>
                <xsl:element name="tei:num">
                    <xsl:attribute name="value" select="regex-group(1)"/>
                    <xsl:attribute name="xml:lang" select="'ar'"/>
                    <xsl:value-of select=" translate(., $vStringTranscribeFromIjmes,$vStringTranscribeToArabic)"/>
                </xsl:element>
                <xsl:text> </xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
  
</xsl:stylesheet>