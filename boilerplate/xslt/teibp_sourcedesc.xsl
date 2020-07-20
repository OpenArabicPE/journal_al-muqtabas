<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
   xmlns="http://www.w3.org/1999/xhtml" 
   xmlns:html="http://www.w3.org/1999/xhtml" 
   exclude-result-prefixes="xsl tei xd eg #default">

    <!-- provide information based on the sourceDesc in the teiHeader-->

    <xsl:template match="tei:sourceDesc">
        <div>
            <xsl:apply-templates/>
            <!-- $vFileId has been defined in the main stylesheet -->
            <xsl:call-template name="templBiblDataLinks">
                <xsl:with-param name="pBiblUrl" select="concat('../metadata/',$vFileId)"/>
                <xsl:with-param name="pLabelText" select="'Bibliographic metadata for this item: '"/>
            </xsl:call-template>
            <!-- add licence information -->
            <span class="c_links" lang="en">
                <a href="{ancestor::tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target}">Licence information</a>
            </span>
                <!-- add link to Zenodo and display DOI -->
                <xsl:if test="tei:biblStruct/tei:idno[@type='zenodo']">
                    <p>
                    <span class="c_links" lang="en">
                        <a href="https://zenodo.org/badge/latestdoi/{tei:biblStruct/tei:idno[@type='zenodo']}"><img src="https://zenodo.org/badge/{tei:biblStruct/tei:idno[@type='zenodo']}.svg" alt="DOI"/></a>
                    </span>
                    </p>
                </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc/tei:biblStruct[child::tei:monogr/tei:title]">
        <div class="cSource">
            <xsl:for-each select="child::tei:monogr/tei:title[not(@type = 'sub')]">
                <xsl:apply-templates select="." mode="mBibl"/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
<!--    <xsl:template match="tei:monogr/tei:title[@level = 'j'][not(@type = 'sub')]">
        <xsl:text>hello</xsl:text>
    </xsl:template>-->
    
    <xsl:template match="tei:monogr/tei:title[not(@type = 'sub')]" mode="mBibl">
        <xsl:variable name="vLang" select="@xml:lang"/>
        <div>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <title>
                <xsl:value-of select="."/>
            </title>
            <xsl:for-each select="parent::tei:monogr/tei:title[@type = 'sub'][@xml:lang = $vLang]">
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
                        <!--<xsl:when test="$vLang = 'en'">
                            <xsl:text>volume </xsl:text>
                        </xsl:when>-->
                        <xsl:otherwise>
                            <xsl:text>volume </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- include @from and @to -->
                    <xsl:choose>
                        <!-- test for singular item -->
                        <xsl:when test="parent::tei:monogr/tei:biblScope[@unit = 'volume']/@from = parent::tei:monogr/tei:biblScope[@unit = 'volume']/@to">
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'volume']/@from"/>
                        </xsl:when>
                        <!-- test for range -->
                        <xsl:when test="parent::tei:monogr/tei:biblScope[@unit = 'volume']/@from != parent::tei:monogr/tei:biblScope[@unit = 'volume']/@to">
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'volume']/@from"/>
                            <xsl:text>–</xsl:text>
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'volume']/@to"/>
                        </xsl:when>
                        <!-- default to @n -->
                        <xsl:otherwise>
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'volume']/@n"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:if>
            <xsl:if test="parent::tei:monogr/tei:biblScope[@unit = 'issue']">
                <xsl:text>, </xsl:text>
                <span class="cBiblScope">
                    <xsl:choose>
                        <xsl:when test="$vLang = 'ar'">
                            <xsl:text>الجزء </xsl:text>
                        </xsl:when>
                        <!--<xsl:when test="$vLang = 'en'">
                            <xsl:text>issue </xsl:text>
                        </xsl:when>-->
                        <xsl:otherwise>
                            <xsl:text>issue </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- include @from and @to -->
                    <xsl:choose>
                        <!-- test for singular item -->
                        <xsl:when test="parent::tei:monogr/tei:biblScope[@unit = 'issue']/@from = parent::tei:monogr/tei:biblScope[@unit = 'issue']/@to">
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'issue']/@from"/>
                        </xsl:when>
                        <!-- test for range -->
                        <xsl:when test="parent::tei:monogr/tei:biblScope[@unit = 'issue']/@from != parent::tei:monogr/tei:biblScope[@unit = 'issue']/@to">
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'issue']/@from"/>
                            <xsl:text>–</xsl:text>
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'issue']/@to"/>
                        </xsl:when>
                        <!-- default to @n -->
                        <xsl:otherwise>
                            <xsl:value-of select="parent::tei:monogr/tei:biblScope[@unit = 'issue']/@n"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:if>
            <xsl:if test="parent::tei:monogr/tei:biblScope[@unit = 'page']">
                <xsl:text>, </xsl:text>
                <span class="cBiblScope">
                    <xsl:choose>
                        <xsl:when test="$vLang = 'ar'">
                            <xsl:text>ص </xsl:text>
                        </xsl:when>
                        <!--<xsl:when test="$vLang = 'en'">
                            <xsl:text>pp. </xsl:text>
                        </xsl:when>-->
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
                <!-- publication date(s) -->
                <xsl:apply-templates select="parent::tei:monogr/tei:imprint/tei:date" mode="mBibl">
                    <xsl:with-param name="pLang" select="$vLang"/>
                </xsl:apply-templates>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="tei:imprint/tei:date" mode="mBibl">
        <xsl:param name="pLang"/>
        <xsl:variable name="v_date-string">
            <xsl:choose>
                <xsl:when test="@when-custom">
                    <xsl:value-of select="@when-custom"/>
                </xsl:when>
                <xsl:when test="@when">
                    <xsl:value-of select="@when"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vYear" select="substring($v_date-string, 1, 4)"/>
        <xsl:variable name="vMonth" select="number(substring($v_date-string, 6, 2))"/>
        <xsl:variable name="vDay" select="number(substring($v_date-string, 9, 2))"/>
        <xsl:value-of select="$vDay"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="t_month-names">
            <xsl:with-param name="p_lang" select="$pLang"/>
            <xsl:with-param name="p_month" select="$vMonth"/>
            <xsl:with-param name="p_calendar">
                <xsl:choose>
                    <xsl:when test="@datingMethod">
                        <xsl:value-of select="@datingMethod"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>#cal_julian</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$vYear"/>
        <xsl:choose>
            <xsl:when test="@datingMethod = '#cal_islamic'">
                <xsl:choose>
                    <xsl:when test="$pLang = 'ar'">
                        <xsl:text>هـ </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> H</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="@datingMethod = ('#cal_islamic' or '#cal_ottomanfiscal' or '#cal_julian')">
            <xsl:if test="@when">
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="@when"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
        </xsl:if>
        <xsl:if test="following-sibling::tei:date">
            <xsl:text> / </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="t_month-names">
        <xsl:param name="p_month"/>
        <xsl:param name="p_calendar"/>
        <xsl:param name="p_lang"/>
        <!--<xsl:if test="$v_month-names-and-numbers/descendant-or-self::tei:listNym[@corresp = $p_calendar]/tei:nym[@n = $p_month]/tei:form[@xml:lang = $p_lang]">-->
            <xsl:value-of select="exsl:node-set($v_month-names-and-numbers)/tei:listNym[@corresp = $p_calendar]/tei:nym[@n = $p_month]/tei:form[@xml:lang = $p_lang][1]"/>
        <!--</xsl:if>-->
    </xsl:template>
    
    <xsl:variable name="v_month-names-and-numbers">
            <tei:listNym corresp="#cal_islamic">
                <tei:nym n="1">
                    <!-- <tei:form xml:lang="tr">Mart</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Muḥarram</tei:form>
                    <tei:form xml:lang="ar">محرم</tei:form>
                    <tei:form xml:lang="ar">المحرم</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">M</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Muḥ</tei:form>
                </tei:nym>
                <tei:nym n="2">
                    <!-- <tei:form xml:lang="tr">Nisan</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Ṣafar</tei:form>
                    <tei:form xml:lang="ar">صفر</tei:form>
<!--                    <tei:form xml:lang="ar">صفار</tei:form>-->
                    <tei:form xml:lang="ota-Latn-x-boa">S</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ṣaf</tei:form>
                </tei:nym>
                <tei:nym n="3">
                    <!-- <tei:form xml:lang="tr">Mayıs</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Rabīʿ al-awwal</tei:form>
                    <tei:form xml:lang="ar">ربيع الاول</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ra</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Rab I</tei:form>
                </tei:nym>
                <tei:nym n="4">
                    <!-- <tei:form xml:lang="tr">Haziran</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Rabīʿ al-thānī</tei:form>
                    <tei:form xml:lang="ar">ربيع الثاني</tei:form>
                    <tei:form xml:lang="ar">ربيع الآخر</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">R</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Rab II</tei:form>
                </tei:nym>
                <tei:nym n="5">
                    <!-- <tei:form xml:lang="tr">Temmuz</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Jumāda al-ulā</tei:form>
                    <tei:form xml:lang="ar">جمادى الاولى</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ca</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Jum I</tei:form>
                </tei:nym>
                <tei:nym n="6">
                    <!-- <tei:form xml:lang="tr">Ağustos</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Jumāda al-thāniya</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Jumāda al-ākhira</tei:form>
                    <tei:form xml:lang="ar">جمادى الآخرة</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">C</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Jum II</tei:form>
                </tei:nym>
                <tei:nym n="7">
                    <!-- <tei:form xml:lang="tr">Eylül</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Rajab</tei:form>
                    <tei:form xml:lang="ar">رجب</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">B</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Raj</tei:form>
                </tei:nym>
                <tei:nym n="8">
                    <!-- <tei:form xml:lang="tr">Ekim</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Shaʿbān</tei:form>
                    <tei:form xml:lang="ar">شعبان</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ş</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Shaʿ</tei:form>
                </tei:nym>
                <tei:nym n="9">
                    <!-- <tei:form xml:lang="tr">Kasım</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Ramaḍān</tei:form>
                    <tei:form xml:lang="ar">رمضان</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">N</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ram</tei:form>
                </tei:nym>
                <tei:nym n="10">
                    <!-- <tei:form xml:lang="tr">Aralık</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Shawwāl</tei:form>
                    <tei:form xml:lang="ar">شوال</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">L</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Shaw</tei:form>
                </tei:nym>
                <tei:nym n="11">
                    <!-- <tei:form xml:lang="tr">Ocak</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Dhū al-qaʿda</tei:form>
                    <tei:form xml:lang="ar">ذو القعدة</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Za</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Dhu I</tei:form>
                </tei:nym>
                <tei:nym n="12">
                    <!-- <tei:form xml:lang="tr">Şubat</tei:form> -->
                    <tei:form xml:lang="ar-Latn-x-ijmes">Dhū al-ḥijja</tei:form>
                    <tei:form xml:lang="ar">ذو الحجة</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Z</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Dhu II</tei:form>
                </tei:nym>
            </tei:listNym>
            <tei:listNym corresp="#cal_ottomanfiscal">
                <tei:nym n="1">
                    <tei:form xml:lang="tr">Mart</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Mārt</tei:form>
                    <tei:form xml:lang="ar">مارت</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ar</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Mārt</tei:form>
                </tei:nym>
                <tei:nym n="2">
                    <tei:form xml:lang="tr">Nisan</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Nīsān</tei:form>
<!--                    <tei:form xml:lang="ar-Latn-x-ijmes">Nīs</tei:form>-->
                    <tei:form xml:lang="ar">نيسان</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ni</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Nīs</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Nis</tei:form>
                </tei:nym>
                <tei:nym n="3">
                    <tei:form xml:lang="tr">Mayıs</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Māyis</tei:form>
                    <tei:form xml:lang="ar">مايس</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ma</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Māy</tei:form>
                    
                </tei:nym>
                <tei:nym n="4">
                    <tei:form xml:lang="tr">Haziran</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Ḥazīrān</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ḥaz</tei:form>
                    <tei:form xml:lang="ar">حزيران</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ha</tei:form>
                </tei:nym>
                <tei:nym n="5">
                    <tei:form xml:lang="tr">Temmuz</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Tammūz</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Tam</tei:form>
                    <tei:form xml:lang="ar">تموز</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Te</tei:form>
                </tei:nym>
                <tei:nym n="6">
                    <tei:form xml:lang="tr">Ağustos</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Aghusṭūs</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Agh</tei:form>
                    <tei:form xml:lang="ar">اغسطوس</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ağ</tei:form>
                </tei:nym>
                <tei:nym n="7">
                    <tei:form xml:lang="tr">Eylül</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Aylūl</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ayl</tei:form>
                    <tei:form xml:lang="ar">ايلول</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ey</tei:form>
                </tei:nym>
                <tei:nym n="8">
                    <tei:form xml:lang="tr">Ekim</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Tishrīn al-awwal</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Tish I</tei:form>
                    <tei:form xml:lang="ar">تسرين الاول</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Tş</tei:form>
                </tei:nym>
                <tei:nym n="9">
                    <tei:form xml:lang="tr">Kasım</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Tishrīn al-thānī</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Tish II</tei:form>
                    <tei:form xml:lang="ar">تسرين الثاني</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Tn</tei:form>
                </tei:nym>
                <tei:nym n="10">
                    <tei:form xml:lang="tr">Aralık</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Kānūn al-awwal</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kān I</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kan I</tei:form>
                    <tei:form xml:lang="ar">كانون الاول</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ke</tei:form>
                </tei:nym>
                <tei:nym n="11">
                    <tei:form xml:lang="tr">Ocak</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Kānūn al-thānī</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kān II</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kan II</tei:form>
                    <tei:form xml:lang="ar">كانون الثاني</tei:form>
                    <tei:form xml:lang="ota-Latn-x-boa">Ks</tei:form>
                </tei:nym>
                <tei:nym n="12">
                    <tei:form xml:lang="tr">Şubat</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Shubāṭ</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Shub</tei:form>
                    <tei:form xml:lang="ar">شباط</tei:form>
                </tei:nym>
            </tei:listNym>
            <tei:listNym corresp="#cal_julian">
                <tei:nym n="1">
                    <tei:form xml:lang="tr">Ocak</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Kānūn al-thānī</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kān II</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kan II</tei:form>
                    <tei:form xml:lang="ar">كانون الثاني</tei:form>
                    <tei:form xml:lang="ar-EG">يناير</tei:form>
                    <tei:form xml:lang="en">January</tei:form>
                    <tei:form xml:lang="en">Jan</tei:form>
                </tei:nym>
                <tei:nym n="2">
                    <tei:form xml:lang="tr">Şubat</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Shubāṭ</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Shub</tei:form>
                    <tei:form xml:lang="ar">شباط</tei:form>
                    <tei:form xml:lang="ar-EG">فبراير</tei:form>
                    <tei:form xml:lang="en">February</tei:form>
                    <tei:form xml:lang="en">Feb</tei:form>
                </tei:nym>
                <tei:nym n="3">
                    <tei:form xml:lang="tr">Mart</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Ādhār</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ādhār</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Adhar</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Mār</tei:form>
                    <tei:form xml:lang="ar">آذار</tei:form>
                    <tei:form xml:lang="ar-EG">مارس</tei:form>
                    <tei:form xml:lang="en">March</tei:form>
                    <tei:form xml:lang="en">Mar</tei:form>
                </tei:nym>
                <tei:nym n="4">
                    <tei:form xml:lang="tr">Nisan</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Nīsān</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Nīs</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Nis</tei:form>
                    <tei:form xml:lang="ar">نيسان</tei:form>
                    <tei:form xml:lang="ar-EG">ابريل</tei:form>
                    <tei:form xml:lang="en">April</tei:form>
                    <tei:form xml:lang="en">Apr</tei:form>
                </tei:nym>
                <tei:nym n="5">
                    <tei:form xml:lang="tr">Mayıs</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Ayyār</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ayyār</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ayyar</tei:form>
                    <tei:form xml:lang="ar">ايار</tei:form>
                    <tei:form xml:lang="ar-EG">مايو</tei:form>
                    <tei:form xml:lang="en">May</tei:form>
                </tei:nym>
                <tei:nym n="6">
                    <tei:form xml:lang="tr">Haziran</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Ḥazīrān</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ḥaz</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Haz</tei:form>
                    <tei:form xml:lang="ar">حزيران</tei:form>
                    <tei:form xml:lang="ar-EG">يونيو</tei:form>
                    <tei:form xml:lang="ar-EG">يونيه</tei:form>
                    <tei:form xml:lang="en">June</tei:form>
                    <tei:form xml:lang="en">Jun</tei:form>
                </tei:nym>
                <tei:nym n="7">
                    <tei:form xml:lang="tr">Temmuz</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Tammūz</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Tam</tei:form>
                    <tei:form xml:lang="ar">تموز</tei:form>
                    <tei:form xml:lang="ar-EG">يوليو</tei:form>
                    <tei:form xml:lang="en">July</tei:form>
                    <tei:form xml:lang="en">Jul</tei:form>
                </tei:nym>
                <tei:nym n="8">
                    <tei:form xml:lang="tr">Ağustos</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Āb</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Āb</tei:form>
                    <tei:form xml:lang="ar">آب</tei:form>
                    <tei:form xml:lang="ar-EG">اغسطس</tei:form>
                    <tei:form xml:lang="en">August</tei:form>
                    <tei:form xml:lang="en">Aug</tei:form>
                </tei:nym>
                <tei:nym n="9">
                    <tei:form xml:lang="tr">Eylül</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Aylūl</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Ayl</tei:form>
                    <tei:form xml:lang="ar">ايلول</tei:form>
                    <tei:form xml:lang="ar-EG">سبتمبر</tei:form>
                    <tei:form xml:lang="en">September</tei:form>
                    <tei:form xml:lang="en">Sep</tei:form>
                </tei:nym>
                <tei:nym n="10">
                    <tei:form xml:lang="tr">Ekim</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Tishrīn al-awwal</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Tish I</tei:form>
                    <tei:form xml:lang="ar">تسرين الاول</tei:form>
                    <tei:form xml:lang="ar-EG">اكتوبر</tei:form>
                    <tei:form xml:lang="en">October</tei:form>
                    <tei:form xml:lang="en">Oct</tei:form>
                </tei:nym>
                <tei:nym n="11">
                    <tei:form xml:lang="tr">Kasım</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Tishrīn al-thānī</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Tish II</tei:form>
                    <tei:form xml:lang="ar">تسرين الثاني</tei:form>
                    <tei:form xml:lang="ar-EG">نوفمبر</tei:form>
                    <tei:form xml:lang="ar-EG">نوڤمبر</tei:form>
                    <tei:form xml:lang="en">November</tei:form>
                    <tei:form xml:lang="en">Nov</tei:form>
                </tei:nym>
                <tei:nym n="12">
                    <tei:form xml:lang="tr">Aralık</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Kānūn al-awwal</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kān I</tei:form>
                    <tei:form xml:lang="ar-Latn-x-sente">Kan I</tei:form>
                    <tei:form xml:lang="ar">كانون الاول</tei:form>
                    <tei:form xml:lang="ar-EG">دسمبر</tei:form>
                    <tei:form xml:lang="ar-EG">ديسمبر</tei:form>
                    <tei:form xml:lang="en">December</tei:form>
                    <tei:form xml:lang="en">Dec</tei:form>
                </tei:nym>
            </tei:listNym>
            <tei:listNym corresp="#cal_coptic">
                <tei:nym n="1">
                    <tei:form xml:lang="ar">توت</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Tūt</tei:form>
                </tei:nym>
                <tei:nym n="2">
                    <tei:form xml:lang="ar">بابة</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Bāba</tei:form>
                </tei:nym>
                <tei:nym n="3">
                    <tei:form xml:lang="ar">هاتور</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Hātūr</tei:form>
                </tei:nym>
                <tei:nym n="4">
                    <tei:form xml:lang="ar">كيهك</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Kiyahk</tei:form>
                </tei:nym>
                <tei:nym n="5">
                    <tei:form xml:lang="ar">طوبة</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Ṭūba</tei:form>
                </tei:nym>
                <tei:nym n="6">
                    <tei:form xml:lang="ar">امشير</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Amshīr</tei:form>
                </tei:nym>
                <tei:nym n="7">
                    <tei:form xml:lang="ar">برمهات</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Baramhāt</tei:form>
                </tei:nym>
                <tei:nym n="8">
                    <tei:form xml:lang="ar">برمودة</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Baramūda</tei:form>
                </tei:nym>
                <tei:nym n="9">
                    <tei:form xml:lang="ar">بشنس</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Bashans</tei:form>
                </tei:nym>
                <tei:nym n="10">
                    <tei:form xml:lang="ar">بؤونة</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Baʾūna</tei:form>
                </tei:nym>
                <tei:nym n="11">
                    <tei:form xml:lang="ar">أبيب</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Abīb</tei:form>
                </tei:nym>
                <tei:nym n="12">
                    <tei:form xml:lang="ar">مسرى</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Masrā</tei:form>
                </tei:nym>
                <tei:nym n="13">
                    <tei:form xml:lang="ar">نسيء</tei:form>
                    <tei:form xml:lang="ar-Latn-x-ijmes">Nasīʾ</tei:form>
                </tei:nym>
            </tei:listNym>
        </xsl:variable>


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
