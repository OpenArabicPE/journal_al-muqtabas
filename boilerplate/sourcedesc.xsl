<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exsl="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:fn="http://www.w3.org/2005/xpath-functions" extension-element-prefixes="exsl msxsl"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl tei xd eg fn #default">

    <!-- provide information based on the sourceDesc in the teiHeader-->

    <xsl:template match="tei:sourceDesc">
        <div>
            <xsl:apply-templates/>
            <!-- $vFileId has been defined in the main stylesheet -->
            <xsl:call-template name="templBiblDataLinks">
                <xsl:with-param name="pBiblUrl" select="concat('../metadata/',$vFileId)"/>
                <xsl:with-param name="pLabelText" select="'Bibliographic metadata for this item: '"/>
            </xsl:call-template>
            <span class="cLinks" lang="en">
                <a href="{ancestor::tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target}">Licence information</a>
            </span>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc/tei:biblStruct[child::tei:monogr/tei:title[@level = 'j']]">
        <div class="cSource">
            <xsl:for-each select="child::tei:monogr/tei:title[@level = 'j'][not(@type = 'sub')]">
                <xsl:apply-templates select="." mode="mBibl"/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
<!--    <xsl:template match="tei:monogr/tei:title[@level = 'j'][not(@type = 'sub')]">
        <xsl:text>hello</xsl:text>
    </xsl:template>-->
    
    <xsl:template match="tei:monogr/tei:title[@level = 'j'][not(@type = 'sub')]" mode="mBibl">
        <xsl:variable name="vLang" select="@xml:lang"/>
        <div>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <title>
                <xsl:value-of select="."/>
            </title>
            <xsl:for-each select="parent::tei:monogr/tei:title[@level = 'j'][@type = 'sub'][@xml:lang = $vLang]">
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
            <xsl:if test="parent::tei:monogr/tei:biblScope[@unit = 'page']">
                <xsl:text>, </xsl:text>
                <span class="cBiblScope">
                    <xsl:choose>
                        <xsl:when test="$vLang = 'ar'">
                            <xsl:text>ص </xsl:text>
                        </xsl:when>
                        <xsl:when test="$vLang = 'en'">
                            <xsl:text>pp. </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>pp. </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'page']/@from"/>
                    <xsl:text>–</xsl:text>
                    <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'page']/@to"/>
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
                            <xsl:text/>
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
            <!-- publisher and place of publication -->
            <span class="cImprint">
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="parent::tei:monogr/tei:imprint/tei:pubPlace/tei:placeName[@xml:lang = $vLang]"/>
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="parent::tei:monogr/tei:imprint/tei:publisher/tei:orgName[@xml:lang = $vLang]"/>
                <xsl:text>, </xsl:text>
                <!-- publication date -->
                <xsl:apply-templates select="parent::tei:monogr/tei:imprint/tei:date[1]" mode="mBibl">
                    <xsl:with-param name="pLang" select="$vLang"/>
                </xsl:apply-templates>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="tei:imprint/tei:date" mode="mBibl">
        <xsl:param name="pLang"/>
        <xsl:variable name="vYear" select="substring(@when-custom, 1, 4)"/>
        <xsl:variable name="vMonth" select="number(substring(@when-custom, 6, 2))"/>
        <xsl:variable name="vDay" select="number(substring(@when-custom, 9, 2))"/>
        <xsl:choose>
            <xsl:when test="@calendar = '#cal_islamic'">
                <xsl:value-of select="$vDay"/>
                <xsl:text> </xsl:text>
                <xsl:call-template name="templMonthNames">
                    <xsl:with-param name="pCal" select="'H'"/>
                    <xsl:with-param name="pLang" select="$pLang"/>
                    <xsl:with-param name="pMonthNumber" select="$vMonth"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$vYear"/>
                <xsl:choose>
                    <xsl:when test="$pLang = 'ar'">
                        <xsl:text>هـ </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> H</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@when">
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="@when"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="templMonthNames">
        <xsl:param name="pCal"/>
        <xsl:param name="pLang"/>
        <xsl:param name="pMonthNumber"/>
        <xsl:choose>
            <xsl:when test="$pCal = 'H'">
                <xsl:choose>
                    <xsl:when test="$pLang = 'ar'">
                        <xsl:if test="$pMonthNumber = 1">
                            <xsl:text>محرم</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 2">
                            <xsl:text>صفر</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 3">
                            <xsl:text>ربيع الاول</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 4">
                            <xsl:text>ربيع الثاني</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 5">
                            <xsl:text>جمادى الاولى</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 6">
                            <xsl:text>جمادى الآخرة</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 7">
                            <xsl:text>رجب</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 8">
                            <xsl:text>شعبان</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 9">
                            <xsl:text>رمضان</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 10">
                            <xsl:text>شوال</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 11">
                            <xsl:text>ذو القعدة</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 12">
                            <xsl:text>ذو الحجة</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="$pMonthNumber = 1">
                            <xsl:text>Muḥarram</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 2">
                            <xsl:text>Ṣafar</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 3">
                            <xsl:text>Rabīʿ al-Awwal</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 4">
                            <xsl:text>Rabīʿ al-Thānī</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 5">
                            <xsl:text>Jumādā al-Ūlā</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 6">
                            <xsl:text>Jumādā al-Ākhira</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 7">
                            <xsl:text>Rajab</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 8">
                            <xsl:text>Shaʿbān</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 9">
                            <xsl:text>Ramaḍān</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 10">
                            <xsl:text>Shawwāl</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 11">
                            <xsl:text>Dhū al-Qaʿda</xsl:text>
                        </xsl:if>
                        <xsl:if test="$pMonthNumber = 12">
                            <xsl:text>Dhū al-Ḥijja</xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$pCal = 'G'"> </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!--<!-\- link heads back to themselves -\->
    <xsl:template match="tei:head">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <a href="#{parent::node()/@xml:id}" class="cLinkSelf"><xsl:apply-templates select="."/></a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="."/>
                    </xsl:otherwise>
                </xsl:choose>
        </xsl:copy>
    </xsl:template>-->
</xsl:stylesheet>
