<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:html="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:opf="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xi="http://www.w3.org/2001/XInclude" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd xi dc opf html" version="2.0">
    
    <!-- this stylesheet extracts all <persName> elements from a TEI XML file and groups them into a <listPerson> element. Similarly, it extracts all <placeName> elements and creates a <listPlace> with the toponyms nested as child elements -->
    <xsl:output method="xml" indent="yes" exclude-result-prefixes="#all"/>
    
    <xsl:template match="tei:TEI">
        <xsl:copy>
            <xsl:apply-templates select="child::tei:teiHeader"/>
            <xsl:element name="tei:text">
                <xsl:element name="tei:body">
                    <xsl:element name="tei:p">
                        <xsl:text>This file contains a list of named entities in the teiHeader.</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    <!-- This template replicates attributes as they are found in the source -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:copy>
           <xsl:call-template name="tProfileDesc"/>
           <!-- <xsl:apply-templates select="child::tei:revisionDesc"/>-->
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:profileDesc" name="tProfileDesc">
        <xsl:element name="tei:profileDesc">
            <!-- check for particDesc -->
            <xsl:choose>
                <xsl:when test="child::tei:particDesc">
                    <xsl:apply-templates select="child::tei:particDesc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="tParticDesc"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- check for settingDesc -->
            <xsl:choose>
                <xsl:when test="child::tei:settingDesc">
                    <xsl:apply-templates select="child::tei:settingDesc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="tSettingDesc"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:particDesc" name="tParticDesc">
        <xsl:element name="tei:particDesc">
            <xsl:apply-templates select="descendant-or-self::tei:particDesc/child::node()"/>
            <xsl:element name="tei:listPerson">
                <!-- XPath to limit the result to all personal names that are NOT already in the profileDesc -->
                <!-- be aware that differently encoded names will pop up as names -->
                <xsl:for-each-group
                    select="/tei:TEI//tei:text//tei:persName[not(descendant::text() = /tei:TEI/tei:teiHeader//tei:particDesc//tei:persName/descendant::text())]"
                    group-by=".">
                    <xsl:sort select="." order="ascending"/>
                    <xsl:apply-templates select="." mode="mExtract"/>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:settingDesc" name="tSettingDesc">
        <xsl:element name="tei:settingDesc">
            <xsl:apply-templates select="descendant-or-self::tei:settingDesc/child::node()"/>
            <xsl:element name="tei:listPlace">
                <!-- XPath to limit the result to all personal names that are NOT already in the profileDesc -->
                <!-- be aware that differently encoded names will pop up as names -->
                <xsl:for-each-group
                    select="/tei:TEI//tei:text//tei:placeName[not(descendant::text() = /tei:TEI/tei:teiHeader//tei:settingDesc//tei:placeName/descendant::text())]"
                    group-by=".">
                    <xsl:sort select="." order="ascending"/>
                    <xsl:apply-templates select="." mode="mExtract"/>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- write personal names to the teiHeader -->
    <xsl:template match="tei:persName" mode="mExtract">
        <xsl:element name="tei:person">
            <!-- this generates a unique id, prefixed by 'pers_' for each person element of the result tree -->
            <xsl:attribute name="xml:id" select="concat('pers_', generate-id())"/>
            <xsl:copy>
                <xsl:call-template name="templXmlAttrLang">
                    <xsl:with-param name="pInput" select="."/>
                </xsl:call-template>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="node()" mode="mExtract"/>
            </xsl:copy>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:forename | tei:surname | tei:addName" mode="mExtract">
        <xsl:copy>
            <xsl:call-template name="templXmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- link the personal names in the text to the header -->
    <xsl:template match="tei:persName[ancestor::tei:text]">
        <xsl:copy>
            <xsl:if test="not(@ref)">
                <xsl:attribute name="ref" select="concat('#pers_', generate-id())"/>
            </xsl:if>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()" mode="mExtract"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- write toponyms to the teiHeader -->
    <xsl:template match="tei:placeName" mode="mExtract">
        <xsl:element name="tei:place">
            <!-- generate xml:ids for all toponyms -->
            <xsl:attribute name="xml:id" select="concat('place_', generate-id())"/>
            <xsl:copy>
                <xsl:call-template name="templXmlAttrLang">
                    <xsl:with-param name="pInput" select="."/>
                </xsl:call-template>
                <xsl:apply-templates select="@*[not(name()='xml:id')]"/>
                <xsl:value-of select="normalize-space(.)"/>
<!--                <xsl:apply-templates select="node()" mode="mExtract"/>-->
            </xsl:copy>
        </xsl:element>
    </xsl:template>
    
<!--    <xsl:template match="tei:geogName | tei:geogFeat | tei:country | tei:bloc | tei:region | tei:settlement | tei:district | tei:placeName[parent::tei:placeName]" mode="mExtract">
        <xsl:copy>
            <xsl:call-template name="templXmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()" mode="mExtract"/>
        </xsl:copy>
    </xsl:template>-->
    
    <!-- link the toponyms names in the text to the header: this won't work as names are only recorded once in the header -->
    <!-- <xsl:template match="tei:placeName[ancestor::tei:text]">
        <xsl:copy>
            <xsl:if test="not(@ref)">
                <xsl:attribute name="ref" select="concat('#pl_', generate-id())"/>
            </xsl:if>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template> -->
    
    <!-- this template matches all text nodes (i.e. the text content of any element) and normalize whitespace -->
    <xsl:template match="text()" mode="mExtract">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <!-- add the XML @xml:lang attribute based on the containing element -->
    <xsl:template name="templXmlAttrLang">
        <xsl:param name="pInput"/>
        <xsl:choose>
            <xsl:when test="$pInput/@xml:lang">
                <xsl:attribute name="xml:lang" select="$pInput/@xml:lang"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="ancestor::node()[@xml:lang!=''][1]/@xml:lang"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>