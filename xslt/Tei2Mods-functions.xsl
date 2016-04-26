<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns="http://www.loc.gov/mods/v3"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xpath-default-namespace="http://www.loc.gov/mods/v3" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no" version="1.0"/>
<!--    <xsl:strip-space elements="*"/>-->
<!--    <xsl:preserve-space elements="tei:head tei:bibl"/>-->


    <!-- this stylesheet generates a MODS XML file with bibliographic metadata for each <div> in the body of the TEI source file. File names are based on the source's @xml:id and the @xml:id of the <div>. -->
    <!-- to do:
        + add information on edition: i.e. TEI edition
        + add information on collaborators on the digital edition -->
    <xsl:include href="https://rawgit.com/tillgrallert/xslt-calendar-conversion/master/date-function.xsl"/>


    <!-- parameter to select the language of some fields (if available): 'ar-Latn-x-ijmes', 'ar', 'en' etc. -->
    <xsl:param name="pLang" select="'ar'"/>

    <xsl:variable name="vgFileId" select="tei:TEI/@xml:id"/>
    <xsl:variable name="vgFileUrl"
        select="concat('https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/', tokenize(base-uri(), '/')[last()])"/>
    <xsl:variable name="vgSchemaLocation" select="'http://www.loc.gov/standards/mods/v3/mods-3-6.xsd'"/>


    <xsl:template name="templDiv2Mods">
        <xsl:param name="pInput"/>
        <xsl:variable name="vLang" select="$pLang"/>
        <!-- variables identifying the digital surrogate -->
        <xsl:variable name="vFileDesc" select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc"/>
        <!-- variables identifying the original source -->
        <xsl:variable name="vBiblStructSource" select="$vFileDesc/tei:sourceDesc/tei:biblStruct"/>
        <xsl:call-template name="t_bibl-mods">
            <xsl:with-param name="p_lang" select="$pLang"/>
            <xsl:with-param name="p_title-publication" select="$vBiblStructSource/tei:monogr/tei:title[@level = 'j'][@xml:lang = $vLang][not(@type = 'sub')]"/>
            <xsl:with-param name="p_title-article">
                <xsl:if test="@type = 'article' and ancestor::tei:div[@type = 'section']">
                    <xsl:apply-templates select="ancestor::tei:div[@type = 'section']/tei:head" mode="m_plain-text"/>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="./tei:head" mode="m_plain-text"/>
            </xsl:with-param>
            <xsl:with-param name="p_url-self" select="concat($vgFileUrl, '#', @xml:id)"/>
            <xsl:with-param name="p_url-licence" select="$vFileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"/>
            <xsl:with-param name="p_volume" select="$vBiblStructSource//tei:biblScope[@unit = 'volume']/@n"/>
            <xsl:with-param name="p_issue" select="$vBiblStructSource//tei:biblScope[@unit = 'issue']/@n"/>
            <xsl:with-param name="p_date-publication" select="$vBiblStructSource/tei:monogr/tei:imprint/tei:date[1]"/>
            <xsl:with-param name="p_date-accessed" select="ancestor::tei:TEI/tei:teiHeader/tei:revisionDesc/tei:change[1]/@when"/>
            <xsl:with-param name="p_publisher"
                select="$vBiblStructSource/tei:monogr/tei:imprint/tei:publisher/tei:orgName[@xml:lang = $vLang]"/>
            <xsl:with-param name="p_place-publication"
                select="$vBiblStructSource/tei:monogr/tei:imprint/tei:pubPlace/tei:placeName[@xml:lang = $vLang]"/>
            <xsl:with-param name="p_author" select="tei:byline/descendant::tei:persName"/>
            <xsl:with-param name="p_editor" select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]"/>
            <xsl:with-param name="p_pages">
                <tei:biblScope unit="pages">
                    <xsl:attribute name="from" select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
                    <xsl:attribute name="to">
                        <xsl:choose>
                            <xsl:when test="preceding::tei:pb[@ed = 'print'][1]/@n != descendant::tei:pb[@ed = 'print'][last()]/@n">
                                <xsl:value-of select="descendant::tei:pb[@ed = 'print'][last()]/@n"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </tei:biblScope>
            </xsl:with-param>
            <xsl:with-param name="p_idno" select="$vBiblStructSource/tei:idno"/>
        </xsl:call-template>
    </xsl:template>

    <!-- prevent output from sections of articles and divisions of legal texts -->
    <xsl:template match="tei:div[ancestor::tei:div[@type = 'article']] | tei:div[ancestor::tei:div[@type = 'bill']] | tei:div[not(@type)]"/>

    <!-- the MODS output -->
    <xsl:template name="t_bibl-mods">
        <!-- possible values are 'a' and 'm' similar to the @level attribute on <tei:title>  -->
        <xsl:param name="p_type" select="'a'"/>
        <xsl:param name="p_lang" select="'ar'"/>
        <xsl:param name="p_title-article"/>
        <xsl:param name="p_title-publication"/>
        <xsl:param name="p_publisher"/>
        <!-- publication dates are formatted as <tei:date when="" calendar="" when-custom=""/> -->
        <xsl:param name="p_date-publication"/>
        <xsl:param name="p_date-accessed" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
        <xsl:param name="p_place-publication"/>
        <xsl:param name="p_volume"/>
        <xsl:param name="p_issue"/>
        <!-- page range is formatted as <tei:biblScope unit="page" from="1" to="10"> -->
        <xsl:param name="p_pages"/>
        <!-- children: tei:persName -->
        <xsl:param name="p_author"/>
        <xsl:param name="p_editor"/>

        <!-- these must be resolving URLs -->
        <xsl:param name="p_url-licence"/>
        <xsl:param name="p_url-self"/>
        <!--  -->
        <xsl:param name="p_edition">
            <xsl:text>digital TEI edition, </xsl:text>
            <xsl:value-of select="year-from-date(current-date())"/>
        </xsl:param>
        <xsl:param name="p_idno"/>
        
        <!-- variables -->
        <xsl:variable name="v_originInfo">
            <originInfo>
                <!-- information on the edition: it would be weird to mix data of the original source and the digital edition -->
                <edition xml:lang="en">
                    <xsl:apply-templates select="$p_edition" mode="m_plain-text"/>
                </edition>
                <place>
                    <placeTerm type="text" xml:lang="{$p_lang}">
                        <xsl:apply-templates select="$p_place-publication" mode="m_plain-text"/>
                    </placeTerm>
                </place>
                <publisher xml:lang="{$p_lang}">
                    <xsl:apply-templates select="$p_publisher" mode="m_plain-text"/>
                </publisher>
                <dateIssued>
                    <xsl:if test="$p_date-publication/@when!=''">
                        <xsl:attribute name="encoding" select="'w3cdtf'"/>
                    </xsl:if>
                    <xsl:value-of select="$p_date-publication/@when"/>
                </dateIssued>
                <!-- add hijri dates -->
                <xsl:if test="$p_date-publication/@calendar='#cal_islamic'">
                    <dateOther type="hijri">
                        <xsl:value-of select="$p_date-publication[@calendar = '#cal_islamic']/@when-custom"/>
                    </dateOther>
                    <!-- this still needs work -->
                    <dateOther>
                        <xsl:value-of select="$p_date-publication[@calendar = '#cal_islamic']/@when-custom"/>
                        <xsl:text> [</xsl:text>
                        <xsl:choose>
                            <xsl:when test="$p_date-publication[@calendar = '#cal_islamic'][@when-custom]/@when">
                                <xsl:value-of select="$p_date-publication[@calendar = '#cal_islamic'][@when-custom]/@when"/>
                            </xsl:when>
                            <xsl:when test="$p_date-publication[@calendar = '#cal_islamic'][@when-custom]">
                                <xsl:analyze-string select="$p_date-publication[@calendar = '#cal_islamic'][@when-custom]/@when-custom" regex="(\d{{4}})$|(\d{{4}}-\d{{2}}-\d{{2}})$">
                                    <xsl:matching-substring>
                                        <xsl:if test="regex-group(1)">
                                            <xsl:call-template name="funcDateHY2G">
                                                <xsl:with-param name="pYearH" select="regex-group(1)"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="regex-group(2)">
                                            <xsl:call-template name="funcDateH2G">
                                                <xsl:with-param name="pDateH" select="regex-group(2)"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:value-of select="$p_date-publication[@calendar = '#cal_islamic']/@when-custom"/>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:text>]</xsl:text>
                    </dateOther>
                </xsl:if>
                <issuance>
                    <xsl:choose>
                        <xsl:when test="$p_type='a' or $p_type='j'">                        
                            <xsl:text>continuing</xsl:text>
                        </xsl:when>
                        <xsl:when test="$p_type='m'">
                            <xsl:text>monographic</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </issuance>
            </originInfo>
        </xsl:variable>
        <xsl:variable name="v_part">
            <part>
                <detail type="volume">
                    <number>
                        <xsl:value-of select="$p_volume"/>
                    </number>
                </detail>
                <detail type="issue">
                    <number>
                        <xsl:value-of select="$p_issue"/>
                    </number>
                </detail>
                <xsl:if test="$p_pages/descendant-or-self::tei:biblScope[@from][@to]">
                    <extent unit="pages">
                        <start>
                            <xsl:value-of select="$p_pages/descendant-or-self::tei:biblScope/@from"/>
                        </start>
                        <end>
                            <xsl:value-of select="$p_pages/descendant-or-self::tei:biblScope/@to"/>
                        </end>
                    </extent>
                </xsl:if>
            </part>
        </xsl:variable>
        <xsl:variable name="v_editor">
            <!-- pull in information on editor -->
            <!-- for each editor -->
            <xsl:if test="$p_editor/descendant-or-self::tei:persName">
                <xsl:for-each select="$p_editor/descendant-or-self::tei:persName">
                    <name type="personal" xml:lang="{$p_lang}">
                        <xsl:choose>
                            <xsl:when test="tei:surname">
                                <xsl:apply-templates select="tei:surname" mode="m_tei2mods">
                                    <xsl:with-param name="p_lang" select="$p_lang"/>
                                </xsl:apply-templates>
                                <xsl:apply-templates select="tei:forename" mode="m_tei2mods">
                                    <xsl:with-param name="p_lang" select="$p_lang"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- what should happen if there is neither surname nor forename? -->
                                <xsl:apply-templates select="self::tei:persName" mode="m_tei2mods">
                                    <xsl:with-param name="p_lang" select="$p_lang"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                        <role>
                            <roleTerm authority="marcrelator" type="code">edt</roleTerm>
                        </role>
                    </name>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>

        <mods ID="{concat($vgFileId,'-',@xml:id,'-mods')}">
            <titleInfo xml:lang="{$p_lang}">
                <title>
                    <xsl:choose>
                        <xsl:when test="$p_type='a'">
                            <xsl:apply-templates select="$p_title-article" mode="m_plain-text"/>
                        </xsl:when>
                        <xsl:when test="$p_type='m' or $p_type='j'">
                            <xsl:apply-templates select="$p_title-publication" mode="m_plain-text"/>
                        </xsl:when>
                    </xsl:choose>
                </title>
            </titleInfo>
            <!--<mods:titleInfo>
                <mods:title type="abbreviated">
                    <xsl:value-of select="$vShortTitle"/>
                </mods:title>
            </mods:titleInfo>-->
            <typeOfResource>
                <xsl:text>text</xsl:text>
            </typeOfResource>
            <xsl:choose>
                <xsl:when test="$p_type='a'">                        
                    <genre authority="local" xml:lang="en">journalArticle</genre>
                    <genre authority="marcgt" xml:lang="en">article</genre>
                </xsl:when>
                <xsl:when test="$p_type='m'">
                    <genre authority="local">book</genre>
                    <genre authority="marcgt">book</genre>
                </xsl:when>
                <xsl:when test="$p_type='j'">
                    <genre authority="local">periodical</genre>
                    <genre authority="marcgt">periodical</genre>
                </xsl:when>
            </xsl:choose>
            <!-- for each author -->
            <xsl:if test="$p_author/descendant-or-self::tei:persName">
                <xsl:for-each select="$p_author/descendant-or-self::tei:persName">
                    <name type="personal" xml:lang="{$p_lang}">
                        <xsl:choose>
                            <xsl:when test="tei:surname">
                                <xsl:apply-templates select="tei:surname" mode="m_tei2mods">
                                    <xsl:with-param name="p_lang" select="$p_lang"/>
                                </xsl:apply-templates>
                                <xsl:apply-templates select="tei:forename" mode="m_tei2mods">
                                    <xsl:with-param name="p_lang" select="$p_lang"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- what should happen if there is neither surname nor forename? -->
                                <xsl:apply-templates select="self::tei:persName" mode="m_tei2mods">
                                    <xsl:with-param name="p_lang" select="$p_lang"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                        <role>
                            <roleTerm authority="marcrelator" type="code">aut</roleTerm>
                        </role>
                    </name>
                </xsl:for-each>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$p_type='a'">
            <relatedItem type="host">
                <titleInfo>
                    <title xml:lang="{$p_lang}">
                        <xsl:apply-templates select="$p_title-publication" mode="m_plain-text"/>
                    </title>
                </titleInfo>
                <genre authority="marcgt">journal</genre>
                <xsl:copy-of select="$v_editor"/>
                <xsl:copy-of select="$v_originInfo"/>
                <xsl:copy-of select="$v_part"/>
                <xsl:apply-templates select="$p_idno/descendant-or-self::tei:idno" mode="m_tei2mods"/>
            </relatedItem>
                </xsl:when>
                <xsl:when test="$p_type='m' or $p_type='j'">
                    <xsl:copy-of select="$v_editor"/>
                    <xsl:copy-of select="$v_originInfo"/>
                    <xsl:copy-of select="$v_part"/>
                </xsl:when>
            </xsl:choose>
            <accessCondition>
                <xsl:value-of select="$p_url-licence"/>
            </accessCondition>
            <location>
                <url dateLastAccessed="{$p_date-accessed}" usage="primary display">
                    <xsl:value-of select="$p_url-self"/>
                </url>
            </location>
            <language>
                <languageTerm type="code" authorityURI="http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry">
                    <xsl:value-of select="$p_lang"/>
                </languageTerm>
            </language>
        </mods>
    </xsl:template>

    <!-- plain text output -->
    <xsl:template match="text()" mode="m_plain-text">
        <!--<xsl:text> </xsl:text>-->
        <xsl:value-of select="normalize-space(.)"/>
        <!--<xsl:text> </xsl:text>-->
    </xsl:template>
    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="m_plain-text">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- prevent notes in div/head from producing output -->
    <xsl:template match="tei:head/tei:note" mode="m_plain-text"/>

    <!-- transform TEI names to MODS -->
    <xsl:template match="tei:surname | tei:persName" mode="m_tei2mods">
        <xsl:param name="p_lang"/>
        <namePart type="family" xml:lang="{$p_lang}">
            <xsl:apply-templates select="." mode="m_plain-text"/>
        </namePart>
    </xsl:template>
    <xsl:template match="tei:forename" mode="m_tei2mods">
        <xsl:param name="p_lang"/>
        <namePart type="given" xml:lang="{$p_lang}">
            <xsl:apply-templates select="." mode="m_plain-text"/>
        </namePart>
    </xsl:template>
<!--    <xsl:template match="tei:persName" mode="m_tei2mods">
        <xsl:param name="p_lang"/>
        <namePart type="family" xml:lang="{$p_lang}">
            <xsl:value-of select="."/>
        </namePart>
    </xsl:template>-->
    <!--  -->
    <xsl:template match="tei:idno" mode="m_tei2mods">
        <identifier type="{@type}">
            <xsl:apply-templates select="." mode="m_plain-text"/>
        </identifier>
    </xsl:template>


</xsl:stylesheet>
