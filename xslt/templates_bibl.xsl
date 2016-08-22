<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- parameter to select the language of some fields (if available): 'ar-Latn-x-ijmes', 'ar', 'en' etc. -->
    <xsl:param name="pLang" select="'ar'"/>
    <xsl:variable name="vgFileId" select="tei:TEI/@xml:id"/>
    <xsl:variable name="vgFileUrl" select="concat('https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/', tokenize(base-uri(), '/')[last()])"/>
    <xsl:template name="t_bibl-html">
        <xsl:param name="p_lang"/>
        <xsl:param name="p_title-article"/>
        <xsl:param name="p_title-publication"/>
        <xsl:param name="p_publisher"/>
        <!-- dates are formatted as tei:date with @when attribute -->
        <xsl:param name="p_date-publication"/>
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
        <!-- content -->
        <h3 xml:lang="{$p_lang}">
            <xsl:value-of select="$p_title-publication"/>
        </h3>
        <xsl:if test="$p_author != ''">
            <p lang="{$p_lang}">
                <xsl:text>مؤلف: </xsl:text>
                <xsl:value-of select="$p_author"/>
            </p>
        </xsl:if>
        <xsl:if test="$p_publisher != ''">
            <p lang="{$p_lang}">
                <xsl:text>ناشر: </xsl:text>
                <xsl:value-of select="$p_publisher"/>
            </p>
        </xsl:if>
        <xsl:if test="$p_place-publication != ''">
            <p lang="{$p_lang}">
                <xsl:text>مكان: </xsl:text>
                <xsl:value-of select="$p_place-publication"/>
            </p>
        </xsl:if>
        <xsl:if test="$p_date-publication != ''">
            <p lang="{$p_lang}">
                <xsl:text>تاريج: </xsl:text>
                <xsl:value-of select="$p_date-publication"/>
            </p>
        </xsl:if>
    </xsl:template>
    
    <!-- MODS -->
    <xsl:template name="t_bibl-mods">
        <!-- possible values are 'a' and 'm' similar to the @level attribute on <tei:title>  -->
        <xsl:param name="p_type" select="'a'"/>
        <xsl:param name="p_lang" select="'ar'"/>
        <xsl:param name="p_title-article"/>
        <xsl:param name="p_title-publication"/>
        <xsl:param name="p_publisher"/>
        <!-- dates are formatted as iso compliant yyyy-mm-yy or yyyy -->
        <xsl:param name="p_date-publication"/>
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
                    <xsl:value-of select="$p_edition"/>
                </edition>
                <place>
                    <placeTerm type="text" xml:lang="{$p_lang}">
                        <xsl:value-of select="$p_place-publication"/>
                    </placeTerm>
                </place>
                <publisher xml:lang="{$p_lang}">
                    <xsl:value-of select="$p_publisher"/>
                </publisher>
                <dateIssued>
                    <xsl:value-of select="$p_date-publication"/>
                </dateIssued>
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
                            <xsl:value-of select="$p_title-article"/>
                        </xsl:when>
                        <xsl:when test="$p_type='m' or $p_type='j'">
                            <xsl:value-of select="$p_title-publication"/>
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
                                <xsl:value-of select="$p_title-publication"/>
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
                <url dateLastAccessed="{format-date(current-date(),'[Y0001]-[M01]-[D01]')}" usage="primary display">
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
    <xsl:template match="tei:surname" mode="m_tei2mods">
        <xsl:param name="p_lang"/>
        <namePart type="family" xml:lang="{$p_lang}">
            <xsl:value-of select="."/>
        </namePart>
    </xsl:template>
    <xsl:template match="tei:forename" mode="m_tei2mods">
        <xsl:param name="p_lang"/>
        <namePart type="given" xml:lang="{$p_lang}">
            <xsl:value-of select="."/>
        </namePart>
    </xsl:template>
    <xsl:template match="tei:persName" mode="m_tei2mods">
        <xsl:param name="p_lang"/>
        <namePart type="family" xml:lang="{$p_lang}">
            <xsl:value-of select="."/>
        </namePart>
    </xsl:template>
    <!--  -->
    <xsl:template match="tei:idno" mode="m_tei2mods">
        <identifier type="{@type}">
            <xsl:value-of select="."/>
        </identifier>
    </xsl:template>
</xsl:stylesheet>