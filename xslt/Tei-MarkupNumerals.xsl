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
    <xsl:output encoding="UTF-8" indent="no" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <!-- identify the author of the change by means of a @xml:id -->
    <xsl:param name="p_id-editor" select="'pers_TG'"/>
    <!--<xsl:param name="pUrlInput" select="'../xml'"/>
    <xsl:variable name="vUrlInput" select="concat($pUrlInput,'?select=*.xml;recurse=yes')"/>-->
    
    
    <xsl:variable name="v_string-transcribe-ijmes" select="'btḥḫjdrzsṣḍṭẓʿfqklmnhāūīwy0123456789'"/>
    <xsl:variable name="v_string-transcribe-arabic" select="'بتحخجدرزسصضطظعفقكلمنهاويوي٠١٢٣٤٥٦٧٨٩'"/>
    <xsl:decimal-format grouping-separator="." decimal-separator="," name="ar_default"/>
    
    <!-- replicate everything -->
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
                <xsl:attribute name="who" select="concat('#',$p_id-editor)"/>
                <xsl:text>Wrapped all numerals in </xsl:text><tei:gi>num</tei:gi><xsl:text> with </xsl:text><tei:att>value</tei:att><xsl:text> recording their value in standardised form and converted them into Arabic numerals to reflect the original text.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- mark up numerals in the text of the documents body only -->
    <xsl:template match="node()[ancestor-or-self::tei:body][not(self::tei:num)]/text()">
        <xsl:analyze-string select="." regex="(\d)(\d*)">
            <xsl:matching-substring>
                <!-- \d now also matches numbers in Arabic script -->
                <!-- somtimes in shamela's transcription numerals are not surrounded by whitespace -->
                <xsl:text> </xsl:text>
                <xsl:element name="tei:num">
                    <xsl:variable name="v_value">
                        <xsl:choose>
                            <!-- check if there are numbers in Arabic script -->
                            <xsl:when test="contains($v_string-transcribe-arabic,regex-group(1))">
                                <xsl:value-of select="number(translate(concat(regex-group(1),regex-group(2)),$v_string-transcribe-arabic,$v_string-transcribe-ijmes))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="number(concat(regex-group(1),regex-group(2)))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="type" select="'auto-markup'"/>
                    <xsl:attribute name="resp" select="concat('#',$p_id-editor)"/>
                    <xsl:attribute name="value" select="$v_value"/>
                    <xsl:attribute name="xml:lang" select="'ar'"/>
                    <xsl:value-of select="translate(format-number($v_value,'###.##0,##','ar_default'),$v_string-transcribe-ijmes,$v_string-transcribe-arabic)"/>
                    <!--<xsl:value-of select=" translate(., $vStringTranscribeFromIjmes,$vStringTranscribeToArabic)"/>-->
                </xsl:element>
                <xsl:text> </xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
  
</xsl:stylesheet>