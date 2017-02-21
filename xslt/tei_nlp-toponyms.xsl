<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:opf="http://www.idpf.org/2007/opf" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" method="xml" indent="no"/>
    <xsl:preserve-space elements="*"/>
    
    <!-- $p_master-toponyms is a TEI XML file containing <listPlace> <place> and <placeName> entities -->
<!--    <xsl:param name="p_master-toponyms" select="doc('../xml/toponyms_Damascus-radius_200.TEIP5.xml')/descendant::tei:listPlace"/>-->
    <xsl:param name="p_master-toponyms" select="doc('../xml/toponyms_extracted.TEIP5.xml')/descendant::tei:listPlace"/>
    <xsl:param name="p_id-editor" select="'pers_TG'"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- replicate everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()[ancestor-or-self::tei:text][not(ancestor::tei:placeName)]">
        <xsl:variable name="v_text" select="."/>
        <xsl:variable name="v_toponyms">
            <xsl:for-each select="$p_master-toponyms/descendant::tei:placeName[@xml:lang='ar']">
                <xsl:value-of select="."/>
                <xsl:if test="position()!=last()">
                    <xsl:text>|</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:analyze-string select="." regex="(\sو?ل?ب?)({$v_toponyms})([\s\.,:\?])">
            <xsl:matching-substring>
                <!--<xsl:message>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:message>-->
                <xsl:variable name="v_toponym" select="regex-group(2)"/>
                <xsl:variable name="v_id">
                    <xsl:value-of select="$p_master-toponyms/descendant::tei:place[child::tei:placeName=$v_toponym]/tei:idno[@type='geon']"/>
                </xsl:variable>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:element name="tei:placeName">
                    <xsl:attribute name="type" select="'auto-markup'"/>
                    <xsl:attribute name="resp" select="concat('#',$p_id-editor)"/>
                    <xsl:if test="$v_id!=''">
                        <xsl:attribute name="ref" select="concat('geon:',$v_id)"/>
                    </xsl:if>
                    <xsl:value-of select="$v_toponym"/>
                </xsl:element>
                <xsl:value-of select="regex-group(3)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
       <!-- <xsl:for-each select="$p_master-toponyms/descendant::tei:placeName[@xml:lang='ar']">
            <xsl:variable name="v_toponym" select="."/>
            <xsl:variable name="v_id" select="ancestor::tei:place/tei:idno[@type='geonames']"/>
            <xsl:analyze-string select="$v_text" regex="({$v_toponym})">
                <xsl:matching-substring>
                    <xsl:element name="tei:placeName">
                        <xsl:attribute name="type" select="'auto-markup'"/>
                        <xsl:attribute name="ref" select="concat('geon:',$v_id)"/>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:element>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:for-each>-->
    </xsl:template>
    
    <!-- link existing placeNames to Geonames -->
    <xsl:template match="tei:placeName[ancestor::tei:text]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="not(@ref)">
                <xsl:variable name="v_id">
                    <xsl:value-of select="$p_master-toponyms/descendant::tei:place[child::tei:placeName=.]/tei:idno[@type='geon']"/>
                </xsl:variable>
                <xsl:attribute name="ref" select="concat('geon:',$v_id)"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="$p_id-editor"/>
                <xsl:text>Added automated mark-up of toponyms as </xsl:text>
                <xsl:element name="gi">tei:placeName</xsl:element>
                <xsl:text>and </xsl:text>
                <xsl:element name="att">ref</xsl:element>
                <xsl:text>pointing to a GeoNames ID.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>