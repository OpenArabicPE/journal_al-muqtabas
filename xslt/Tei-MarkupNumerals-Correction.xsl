<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:html="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs xd html"
    version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet analyses all text() for numerals and wraps them in a
                    <tei:gi>num</tei:gi> element with the <tei:att>value</tei:att> attribute stating
                the value in normalised form. The numeral is then converted into Arabic script to
                reflect the original type-setting conventions of the time.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no"
        version="1.0"/>

    <xsl:param name="pUrlInput" select="'../xml'"/>
    <!-- identify the author of the change by means of a @xml:id -->
    <xsl:param name="pAuthorXmlId" select="'pers_TG'"/>
    
    <xsl:variable name="vUrlInput" select="concat($pUrlInput, '?select=*.xml;recurse=yes')"/>


    <xsl:variable name="vStringTranscribeFromIjmes" select="'btḥḫjdrzsṣḍṭẓʿfqklmnhāūīwy0123456789'"/>
    <xsl:variable name="vStringTranscribeToArabic" select="'بتحخجدرزسصضطظعفقكلمنهاويوي٠١٢٣٤٥٦٧٨٩'"/>
    <xsl:decimal-format grouping-separator="." decimal-separator="," name="ar_default"/>

    <!--    <!-\- safe as new file -\->
    <xsl:template match="/">
        <!-\-<xsl:result-document href="{substring-before(base-uri(),'.TEIP5.xml')}_MarkupNumerals.TEIP5.xml">-\->
            <xsl:copy>
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        <!-\-</xsl:result-document>-\->
    </xsl:template>-->
    <!-- reproduce everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- document the changes  -->
    <xsl:template match="tei:revisionDesc" priority="100">
        <xsl:copy>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#',$pAuthorXmlId)"/>
                <xsl:text>Corrected the faulty mark-up of numbers containing commas or group separatours for thousands (i.e. ".") by grouping successive </xsl:text><tei:gi>num</tei:gi><xsl:text> elements separated by " . " into a single </xsl:text><tei:gi>num</tei:gi><xsl:text> element. The </xsl:text><tei:att>resp</tei:att><xsl:text> and </xsl:text><tei:att>type</tei:att><xsl:text> indicate the responsible editor and the automated mark-up; i.e. the string "٣١.٦٧٠،٤٠" is marked up as </xsl:text><tei:tag>num resp="#pers_TG" type="auto-markup" value="31670.40"</tei:tag><xsl:text>.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <!-- test for commatta in numbers -->
    <xsl:template
        match="tei:num[following-sibling::node()[1] = '. ' and name(following-sibling::node()[2]) = 'tei:num']">
        <xsl:variable name="val1" select="@value"/>
        <xsl:variable name="val2" select="following-sibling::node()[2]/@value"/>
        <xsl:variable name="value" select="number(concat($val1, '.', $val2))"/>
        <xsl:element name="tei:num">
            <xsl:attribute name="type" select="'auto-markup'"/>
            <xsl:attribute name="resp" select="concat('#',$pAuthorXmlId)"/>
            <xsl:attribute name="value" select="$value"/>
            <xsl:attribute name="xml:lang" select="'ar'"/>
            <xsl:value-of select="translate(format-number($value,'###.##0,##','ar_default'),$vStringTranscribeFromIjmes,$vStringTranscribeToArabic)"/>
        </xsl:element>
    </xsl:template>
    <!-- omit output for following tei:num -->
    <xsl:template
        match="tei:num[preceding-sibling::node()[1] = '. ' and name(preceding-sibling::node()[2]) = 'tei:num']"/>
    <!-- omit output for following text()='. ' -->
    <xsl:template
        match="node()[self::text() = '. ' and name(preceding-sibling::node()[1]) = 'tei:num' and name(following-sibling::node()[1]) = 'tei:num']"/>

    <!-- test for large numbers divided into groups of three integers by a point. -->
    <xsl:template
        match="tei:num[following-sibling::node()[1] = ' . ' and name(following-sibling::node()[2]) = 'tei:num']"
        priority="6">
        <xsl:variable name="val1" select="@value"/>
        <xsl:variable name="val2" select="following-sibling::node()[2]/@value"/>
        <xsl:variable name="value" select="number(concat($val1, $val2))"/>
        <xsl:element name="tei:num">
            <xsl:attribute name="type" select="'auto-markup'"/>
            <xsl:attribute name="resp" select="concat('#',$pAuthorXmlId)"/>
            <xsl:attribute name="value" select="$value"/>
            <xsl:attribute name="xml:lang" select="'ar'"/>
            <xsl:value-of select="translate(format-number($value,'###.###,##','ar_default'),$vStringTranscribeFromIjmes,$vStringTranscribeToArabic)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template
        match="tei:num[following-sibling::node()[1] = ' . ' and name(following-sibling::node()[2]) = 'tei:num' and following-sibling::node()[3] = ' . ' and name(following-sibling::node()[4]) = 'tei:num']"
        priority="8">
        <xsl:variable name="val1" select="@value"/>
        <xsl:variable name="val2" select="following-sibling::node()[2]/@value"/>
        <xsl:variable name="val3" select="following-sibling::node()[4]/@value"/>
        <xsl:variable name="value" select="number(concat($val1, $val2, $val3))"/>
        <xsl:element name="tei:num">
            <xsl:attribute name="type" select="'auto-markup'"/>
            <xsl:attribute name="resp" select="concat('#',$pAuthorXmlId)"/>
            <xsl:attribute name="value" select="$value"/>
            <xsl:attribute name="xml:lang" select="'ar'"/>
            <xsl:value-of select="translate(format-number($value,'###.###,##','ar_default'),$vStringTranscribeFromIjmes,$vStringTranscribeToArabic)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template
        match="tei:num[following-sibling::node()[1] = ' . ' and name(following-sibling::node()[2]) = 'tei:num' and following-sibling::node()[3] = ' . ' and name(following-sibling::node()[4]) = 'tei:num' and following-sibling::node()[5] = ' . ' and name(following-sibling::node()[6]) = 'tei:num']"
        priority="10">
        <xsl:variable name="val1" select="@value"/>
        <xsl:variable name="val2" select="following-sibling::node()[2]/@value"/>
        <xsl:variable name="val3" select="following-sibling::node()[4]/@value"/>
        <xsl:variable name="val4" select="following-sibling::node()[6]/@value"/>
        <xsl:variable name="value" select="number(concat($val1, $val2, $val3, $val4))"/>
        <xsl:element name="tei:num">
            <xsl:attribute name="type" select="'auto-markup'"/>
            <xsl:attribute name="resp" select="concat('#',$pAuthorXmlId)"/>
            <xsl:attribute name="value" select="$value"/>
            <xsl:attribute name="xml:lang" select="'ar'"/>
            <xsl:value-of select="translate(format-number($value,'###.###,##','ar_default'),$vStringTranscribeFromIjmes,$vStringTranscribeToArabic)"/>
        </xsl:element>
    </xsl:template>
    
    <!-- omit output for following tei:num -->
    <xsl:template
        match="tei:num[preceding-sibling::node()[1] = ' . ' and name(preceding-sibling::node()[2]) = 'tei:num']" priority="7"/>
    <xsl:template
        match="tei:num[preceding-sibling::node()[1] = ' . ' and name(preceding-sibling::node()[2]) = 'tei:num' and preceding-sibling::node()[3] = ' . ' and name(preceding-sibling::node()[4]) = 'tei:num']" priority="9"/>
    <xsl:template
        match="tei:num[preceding-sibling::node()[1] = ' . ' and name(preceding-sibling::node()[2]) = 'tei:num' and preceding-sibling::node()[3] = ' . ' and name(preceding-sibling::node()[4]) = 'tei:num' and preceding-sibling::node()[5] = ' . ' and name(preceding-sibling::node()[6]) = 'tei:num']" priority="11"/>
    
    <!-- omit output for following text()=' . ' -->
    <xsl:template
        match="node()[self::text() = ' . ' and name(preceding-sibling::node()[1]) = 'tei:num' and name(following-sibling::node()[1]) = 'tei:num']"/>
    
    <!-- add the additional attributes to existing tei:num -->
    <xsl:template match="tei:num" priority="1">
        <xsl:copy>
            <xsl:attribute name="type" select="'auto-markup'"/>
            <xsl:attribute name="resp" select="concat('#',$pAuthorXmlId)"/>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- mark up numerals -->
    <!--<xsl:template match="text()[ancestor-or-self::tei:text]">
        <xsl:analyze-string select="." regex="(\d+)">
            <xsl:matching-substring>
                <!-\- somtimes in shamela's transcription numerals are not surrounded by whitespace -\->
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
    </xsl:template>-->


</xsl:stylesheet>
