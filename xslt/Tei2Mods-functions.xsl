<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xpath-default-namespace="http://www.loc.gov/mods/v3" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no" version="1.0"/>
    <!--<xsl:strip-space elements="*"/>-->
    <xsl:preserve-space elements="tei:head tei:bibl"/>


    <!-- this stylesheet generates a MODS XML file with bibliographic metadata for each <div> in the body of the TEI source file. File names are based on the source's @xml:id and the @xml:id of the <div>. -->
    <!-- to do:
        + add information on edition: i.e. TEI edition
        + add information on collaborators on the digital edition -->


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
        <!-- Need information on edition, date of edition, editors, transcribers etc.  -->
        <!-- variables identifying the original source -->
        <xsl:variable name="vBiblStructSource"
            select="$vFileDesc/tei:sourceDesc/tei:biblStruct"/>
        <xsl:variable name="vPublDate"
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:date[1]"/>
        <xsl:variable name="vPublicationTitle"
            select="$vBiblStructSource/tei:monogr/tei:title[@level = 'j'][@xml:lang = $vLang][not(@type = 'sub')]"/>
        <xsl:variable name="vArticleTitle">
            <xsl:if test="@type = 'article' and ancestor::tei:div[@type = 'section']">
                <xsl:apply-templates select="ancestor::tei:div[@type = 'section']/tei:head"
                    mode="mPlainText"/>
                <xsl:text>: </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="./tei:head" mode="mPlainText"/>
        </xsl:variable>
        <xsl:variable name="vUrl" select="concat($vgFileUrl, '#', @xml:id)"/>
        <xsl:variable name="vIssue" select="$vBiblStructSource//tei:biblScope[@unit = 'issue']/@n"/>
        <xsl:variable name="vVolume" select="$vBiblStructSource//tei:biblScope[@unit = 'volume']/@n"/>
        <xsl:variable name="vPubPlace"
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:pubPlace/tei:placeName[@xml:lang = $vLang]"/>
        <xsl:variable name="vPublisher"
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:publisher/tei:orgName[@xml:lang = $vLang]"/>

        <mods ID="{concat($vgFileId,'-',@xml:id,'-mods')}">
            <titleInfo xml:lang="{$vLang}">
                <title>
                    <xsl:value-of select="$vArticleTitle"/>
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
            <genre authority="local" xml:lang="en">journalArticle</genre>
            <genre authority="marcgt" xml:lang="en">article</genre>
            <!-- for each author -->
            <xsl:for-each select="child::tei:byline/descendant::tei:persName">
                <name type="personal" xml:lang="{$vLang}">
                    <xsl:choose>
                        <xsl:when test="child::tei:surname">
                            <namePart type="family" xml:lang="{$vLang}">
                                <xsl:value-of select="child::tei:surname"/>
                            </namePart>
                            <namePart type="given" xml:lang="{$vLang}">
                                <xsl:value-of select="child::tei:forename"/>
                            </namePart>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- what should happen if there is neither surname nor forename? -->
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <role>
                        <roleTerm authority="marcrelator" type="code">aut</roleTerm>
                    </role>
                </name>
            </xsl:for-each>
            <accessCondition>
                <xsl:value-of
                    select="$vFileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"/>
            </accessCondition>
            <location>
                <url dateLastAccessed="{format-date(current-date(),'[Y0001]-[M01]-[D01]')}"
                    usage="primary display">
                    <xsl:value-of select="$vUrl"/>
                </url>
            </location>
            <language>
                <languageTerm type="code" authorityURI="http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry">
                    <xsl:value-of select="@xml:lang"/>
                </languageTerm>
            </language>
            <relatedItem type="host">
                <titleInfo>
                    <title xml:lang="{$vLang}">
                        <xsl:value-of select="$vPublicationTitle"/>
                    </title>
                </titleInfo>
                <genre authority="marcgt">journal</genre>
                <!-- pull in information on editor -->
                <name type="personal">
                    <namePart type="family" xml:lang="{$vLang}">
                        <xsl:value-of
                            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:surname"
                        />
                    </namePart>
                    <namePart type="given" xml:lang="{$vLang}">
                        <xsl:value-of
                            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:forename"
                        />
                    </namePart>
                    <role>
                        <roleTerm authority="marcrelator" type="code">edt</roleTerm>
                    </role>
                </name>
                <originInfo>
                    <!-- information on the edition: it would be weird to mix data of the original source and the digital edition -->
                    <edition xml:lang="en">
                        <xsl:text>digital TEI edition, </xsl:text>
                        <xsl:value-of select="year-from-date(current-date())"/>
                    </edition>
                    <place>
                        <placeTerm type="text" xml:lang="{$vLang}">
                            <xsl:value-of select="$vPubPlace"/>
                        </placeTerm>
                    </place>
                    <publisher  xml:lang="{$vLang}">
                        <xsl:value-of select="$vPublisher"/>
                    </publisher>
                    <dateIssued>
                        <xsl:value-of select="$vPublDate/@when"/>
                    </dateIssued>
                    <issuance>
                        <xsl:text>continuing</xsl:text>
                    </issuance>
                </originInfo>
                <part>
                    <detail type="volume">
                        <number>
                            <xsl:value-of select="$vVolume"/>
                        </number>
                    </detail>
                    <detail type="issue">
                        <number>
                            <xsl:value-of select="$vIssue"/>
                        </number>
                    </detail>
                    <extent unit="pages">
                        <start>
                            <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
                        </start>
                        <end>
                        <xsl:choose>
                            <xsl:when
                            test="preceding::tei:pb[@ed = 'print'][1]/@n != descendant::tei:pb[@ed = 'print'][last()]/@n">
                                <xsl:value-of select="descendant::tei:pb[@ed = 'print'][last()]/@n"
                                />
                        </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        </end>
                    </extent>
                </part>
                <xsl:for-each select="$vBiblStructSource/tei:idno">
                    <identifier type="{@type}"><xsl:value-of select="."/></identifier>
                </xsl:for-each>
            </relatedItem>
        </mods>
           <!-- <xsl:element name="mods">
                <xsl:attribute name="ID" select="concat($vgFileId,'-',@xml:id,'-mods')"/>
                <xsl:element name="titleInfo">
                    <xsl:attribute name="xml:lang" select="$vLang"/>
                    <xsl:element name="title">
                        <xsl:value-of select="$vArticleTitle"/>
                    </xsl:element>
                </xsl:element>

            <!-\-<mods:titleInfo>
                <mods:title type="abbreviated">
                    <xsl:value-of select="$vShortTitle"/>
                </mods:title>
            </mods:titleInfo>-\->
                <xsl:element name="typeOfResource">
                    <xsl:text>text</xsl:text>
                </xsl:element>
                <xsl:element name="genre">
                    <xsl:attribute name="authority" select="'local'"/>
                    <xsl:attribute name="xml:lang" select="'en'"/>
                    <xsl:text>journalArticle</xsl:text>
                </xsl:element>
                <xsl:element name="genre">
                    <xsl:attribute name="authority" select="'marcgt'"/>
                    <xsl:attribute name="xml:lang" select="'en'"/>
                    <xsl:text>article</xsl:text>
                </xsl:element>
            <!-\- for each author -\->
            <xsl:for-each select="child::tei:byline/tei:persName">
                <name type="personal" xml:lang="{$vLang}">
                    <xsl:choose>
                        <xsl:when test="child::tei:surname">
                            <namePart type="family" xml:lang="{$vLang}">
                                <xsl:value-of select="child::tei:surname"/>
                            </namePart>
                        </xsl:when>
                        <xsl:when test="child::tei:forename">
                            <namePart type="given" xml:lang="{$vLang}">
                                <xsl:value-of select="child::tei:forename"/>
                            </namePart>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-\- what should happen if there is neither surname nor forename? -\->
                        </xsl:otherwise>
                    </xsl:choose>
                    <role>
                        <roleTerm authority="marcrelator" type="code">aut</roleTerm>
                    </role>
                </name>
            </xsl:for-each>
            <accessCondition>
                <xsl:value-of
                    select="$vFileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"/>
            </accessCondition>
            <location>
                <url dateLastAccessed="{format-date(current-date(),'[Y0001]-[M01]-[D01]')}"
                    usage="primary display">
                    <xsl:value-of select="$vUrl"/>
                </url>
            </location>
            <language>
                <languageTerm type="code" authorityURI="http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry">
                    <xsl:value-of select="@xml:lang"/>
                </languageTerm>
            </language>
            <relatedItem type="host">
                <titleInfo>
                    <title xml:lang="{$vLang}">
                        <xsl:value-of select="$vPublicationTitle"/>
                    </title>
                </titleInfo>
                <genre authority="marcgt">journal</genre>
                <!-\- pull in information on editor -\->
                <name type="personal">
                    <namePart type="family" xml:lang="{$vLang}">
                        <xsl:value-of
                            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:surname"
                        />
                    </namePart>
                    <namePart type="given" xml:lang="{$vLang}">
                        <xsl:value-of
                            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:forename"
                        />
                    </namePart>
                    <role>
                        <roleTerm authority="marcrelator" type="code">edt</roleTerm>
                    </role>
                </name>
                <originInfo>
                    <!-\- information on the edition: it would be weird to mix data of the original source and the digital edition -\->
                    <edition xml:lang="en">
                        <xsl:text>digital TEI edition, </xsl:text>
                        <xsl:value-of select="year-from-date(current-date())"/>
                    </edition>
                    <place>
                        <placeTerm type="text" xml:lang="{$vLang}">
                            <xsl:value-of select="$vPubPlace"/>
                        </placeTerm>
                    </place>
                    <publisher  xml:lang="{$vLang}">
                        <xsl:value-of select="$vPublisher"/>
                    </publisher>
                    <dateIssued>
                        <xsl:value-of select="$vPublDate/@when"/>
                    </dateIssued>
                    <issuance>
                        <xsl:text>continuing</xsl:text>
                    </issuance>
                </originInfo>
                <part>
                    <detail type="volume">
                        <number>
                            <xsl:value-of select="$vVolume"/>
                        </number>
                    </detail>
                    <detail type="issue">
                        <number>
                            <xsl:value-of select="$vIssue"/>
                        </number>
                    </detail>
                    <extent unit="pages">
                        <start>
                            <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
                        </start>
                        <end>
                            <xsl:choose>
                                <xsl:when
                                    test="preceding::tei:pb[@ed = 'print'][1]/@n != descendant::tei:pb[@ed = 'print'][last()]/@n">
                                    <xsl:value-of select="descendant::tei:pb[@ed = 'print'][last()]/@n"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </end>
                    </extent>
                </part>
                <xsl:for-each select="$vBiblStructSource/tei:idno">
                    <identifier type="{@type}"><xsl:value-of select="."/></identifier>
                </xsl:for-each>
            </relatedItem>
            </xsl:element>-->
    </xsl:template>

    <!-- prevent output from sections of articles and divisions of legal texts -->
    <xsl:template match="tei:div[ancestor::tei:div[@type = 'article']] | tei:div[ancestor::tei:div[@type = 'bill']] | tei:div[not(@type)]"/>

    <!-- plain text output -->
    <xsl:template match="text()" mode="mPlainText">
        <!--<xsl:text> </xsl:text>--><xsl:value-of select="normalize-space(.)"/><!--<xsl:text> </xsl:text>-->
    </xsl:template>
    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="mPlainText">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- prevent notes in div/head from producing output -->
    <xsl:template match="tei:head/tei:note" mode="mPlainText"/>


</xsl:stylesheet>
