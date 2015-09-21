<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:eg="http://www.tei-c.org/ns/Examples" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    extension-element-prefixes="exsl msxsl" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl tei xd eg fn #default">

    <!-- import teibp.xsl, which allows templates, 
         variables, and parameters from teibp.xsl 
         to be overridden here. -->
    <xsl:import href="teibp.xsl"/>

    <!-- provide information based on the sourceDesc -->
    <!--    <xsl:template match="tei:sourceDesc">
        <div class="cSource">
            <xsl:apply-templates select="descendant::tei:biblStruct"/>
        </div>
    </xsl:template>-->
    <xsl:template match="tei:biblStruct[tei:monogr/tei:title[@level = 'j']]">
        <div class="cSource">
            <xsl:for-each select="tei:monogr/tei:title[@level = 'j'][not(@type = 'sub')]">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="tei:monogr/tei:title[@level = 'j'][not(@type = 'sub')]">
        <xsl:variable name="vLang" select="@xml:lang"/>
        <div>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <title>
                <xsl:value-of select="."/>
            </title>
            <xsl:for-each
                select="parent::tei:monogr/tei:title[@level = 'j'][@type = 'sub'][@xml:lang = $vLang]">
                <xsl:text>: </xsl:text>
                <span class="cSubTitle">
                    <xsl:value-of select="."/>
                </span>
            </xsl:for-each>
            <!-- volume and issue information -->
            <xsl:if test="parent::tei:monogr/tei:biblScope[@unit = 'volume']">
                <xsl:text>, </xsl:text>
                <span class="cBiblScope">
                    <xsl:choose>
                        <xsl:when test="$vLang = 'ar'">
                            <xsl:text>المجلد </xsl:text>
                        </xsl:when>
                        <xsl:when test="$vLang = 'en'">
                            <xsl:text>volume </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>volume </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'volume']/@n"/>
                </span>
            </xsl:if>
            <xsl:if test="parent::tei:monogr/tei:biblScope[@unit = 'issue']">
                <xsl:text>, </xsl:text>
                <span class="cBiblScope">
                    <xsl:choose>
                        <xsl:when test="$vLang = 'ar'">
                            <xsl:text>الجزء </xsl:text>
                        </xsl:when>
                        <xsl:when test="$vLang = 'en'">
                            <xsl:text>issue </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>issue </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'issue']/@n"/>
                </span>
            </xsl:if>
            <!-- editors -->
            <xsl:if test="parent::tei:monogr/tei:editor[./tei:persName/@xml:lang = $vLang]">
                <span class="cAuthors">
                    <xsl:text>, </xsl:text>
                    <xsl:choose>
                        <xsl:when test="$vLang = 'en'">
                            <xsl:text>edited by </xsl:text>
                        </xsl:when>
                        <xsl:when test="$vLang = 'ar-Latn-x-ijmes'">
                            <xsl:text>edited by </xsl:text>
                        </xsl:when>
                        <xsl:when test="$vLang = 'ar'">
                            <xsl:text></xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>edited by </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="parent::tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]">
                        <xsl:apply-templates select="node()"/>
                        <xsl:if test="not(position() = last())">, </xsl:if>
                    </xsl:for-each>
                </span>
            </xsl:if>
            <!-- publiser and place of publication -->
            <span class="cImprint">
                <xsl:text>, </xsl:text>
                <xsl:apply-templates
                    select="parent::tei:monogr/tei:imprint/tei:pubPlace[@xml:lang = $vLang]"/>
                <xsl:text>, </xsl:text>
                <xsl:apply-templates
                    select="parent::tei:monogr/tei:imprint/tei:publisher[@xml:lang = $vLang]"/>
                <xsl:text>, </xsl:text>
                <xsl:apply-templates
                    select="parent::tei:monogr/tei:imprint/tei:date[@xml:lang = $vLang]"/>
            </span>
        </div>
    </xsl:template>

</xsl:stylesheet>
