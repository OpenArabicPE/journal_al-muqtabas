<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no" name="xml"/>
    <xsl:output method="text" encoding="UTF-8" indent="yes" name="text"/>

    <!-- This transformation maps the bibliographic metadate of articles in the TEI edition of Arabic periodicals to Sente XML -->
    <!-- TO DO:
        - If all elements in the TEI source, especially <tei:div>s, which are mapped to <tss:reference>, had an @xml:id attribute, one could construct a URL of the full text to be linked to from the Sente XML -->

    <xsl:include href="../Functions/BachFunctions%20v3.xsl"/>

    <xsl:variable name="vgFileUrl"
        select="concat('https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/', tokenize(base-uri(), '/')[last()])"/>
    <xsl:variable name="vN" select="'&#x0A;'"/>

    <xsl:template match="tei:TEI">
        <xsl:result-document href="{substring-before(base-uri(),'.TEIP5')}.TSS.xml" method="xml">
            <xsl:element name="tss:senteContainer">
                <xsl:attribute name="version">1.0</xsl:attribute>
                <xsl:element name="tss:library">
                    <xsl:element name="tss:references">
                        <xsl:apply-templates select="child::tei:text/tei:body/descendant::tei:div" mode="mBiblSente"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="{substring-before(base-uri(),'.TEIP5')}.bib" method="text">
            <xsl:apply-templates select="child::tei:text/tei:body/descendant::tei:div" mode="mBiblBibTex"/>
        </xsl:result-document>
    </xsl:template>

    <!-- Create Sente reference for each div -->
    <xsl:template
        match="tei:div[@type = 'section'][not(ancestor::tei:div[@type = 'article'])] | tei:div[@type = 'article'][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'bill']" mode="mBiblSente">
        <xsl:variable name="vLang" select="'ar-Latn-x-ijmes'"/>
        <xsl:variable name="vBiblStructSource"
            select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
        <xsl:variable name="vPublDate"
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:date[1]"/>
        <xsl:variable name="vPublicationType" select="'Newspaper article'"/>
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
        <xsl:variable name="vPages">
            <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
            <xsl:if
                test="preceding::tei:pb[@ed = 'print'][1]/@n != descendant::tei:pb[@ed = 'print'][last()]/@n">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="descendant::tei:pb[@ed = 'print'][last()]/@n"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="vPubPlace"
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:pubPlace/tei:placeName[@xml:lang = 'en']"/>
        <xsl:variable name="vPublisher" select="$vBiblStructSource/tei:monogr/tei:imprint/tei:publisher/tei:orgName[@xml:lang = $vLang]"/>
        <!-- construct the Sente XML -->
        <tss:reference>
            <tss:publicationType name="{$vPublicationType}"/>
            <xsl:element name="tss:authors">
                <xsl:choose>
                    <xsl:when test="child::tei:byline/tei:persName/tei:surname">
                        <xsl:element name="tss:author">
                            <xsl:attribute name="role" select="'Author'"/>
                            <!-- in many instances, the author name is only mark-up with tei:persName and not the more detailed surname and forename tags -->
                            <xsl:element name="tss:surname">
                                <xsl:value-of select="child::tei:byline/tei:persName/tei:surname"/>
                            </xsl:element>
                            <xsl:element name="tss:forenames">
                                <xsl:value-of select="child::tei:byline/tei:persName/tei:forename"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="child::tei:byline/tei:persName">
                        <xsl:element name="tss:author">
                            <xsl:attribute name="role" select="'Author'"/>
                            <!-- in many instances, the author name is only mark-up with tei:persName and not the more detailed surname and forename tags -->
                            <!--<xsl:call-template name="funcStringNER">
                            <xsl:with-param name="pInput" select="child::tei:byline/tei:persName"/>
                        </xsl:call-template>-->
                            <xsl:element name="tss:surname">
                                <xsl:value-of select="child::tei:byline/tei:persName"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
                <xsl:element name="tss:author">
                    <xsl:attribute name="role" select="'Editor'"/>
                    <xsl:element name="tss:surname">
                        <xsl:value-of
                            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:surname"
                        />
                    </xsl:element>
                    <xsl:element name="tss:forenames">
                        <xsl:value-of
                            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:forename"
                        />
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <tss:dates>
                <tss:date type="Publication" year="{year-from-date($vPublDate/@when)}"
                    month="{month-from-date($vPublDate/@when)}"
                    day="{day-from-date($vPublDate/@when)}"/>
            </tss:dates>
            <tss:characteristics>
                <tss:characteristic name="publicationTitle">
                    <xsl:value-of select="$vPublicationTitle"/>
                </tss:characteristic>
                <tss:characteristic name="publicationCountry">
                    <xsl:value-of select="$vPubPlace"/>
                </tss:characteristic>
                <tss:characteristic name="publisher">
                    <xsl:value-of
                        select="$vPublisher"
                    />
                </tss:characteristic>
                <tss:characteristic name="volume">
                    <xsl:value-of select="$vVolume"/>
                </tss:characteristic>
                <tss:characteristic name="issue">
                    <xsl:value-of select="$vIssue"/>
                </tss:characteristic>
                <!-- al-Muqtabas has Hijri dates  -->
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">Date Hijri</xsl:attribute>
                    <xsl:variable name="vDateHijriFormated">
                        <xsl:call-template name="funcDateFormatTei">
                            <xsl:with-param name="pDate"
                                select="$vPublDate[@datingMethod = '#cal_islamic']/@when-custom"/>
                            <xsl:with-param name="pCal" select="'H'"/>
                            <xsl:with-param name="pOutput" select="'formatted'"/>
                            <xsl:with-param name="pWeekday" select="'n'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$vDateHijriFormated"/>
                </xsl:element>
                <tss:characteristic name="pages">
                    <xsl:value-of select="$vPages"/>
                </tss:characteristic>
                <tss:characteristic name="language">
                    <xsl:value-of select="@xml:lang"/>
                </tss:characteristic>
                <!-- article title: in case of articles in sections, the section title should appear as well. -->
                <tss:characteristic name="articleTitle">
                    <xsl:value-of select="$vArticleTitle"/>
                </tss:characteristic>
                <tss:characteristic name="URL">
                    <xsl:value-of select="$vUrl"/>
                </tss:characteristic>
                <xsl:call-template name="templID"/>
            </tss:characteristics>
            <xsl:element name="tss:attachments">
                <xsl:element name="tss:attachmentReference">
                    <xsl:element name="URL">
                        <xsl:value-of select="$vUrl"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </tss:reference>
    </xsl:template>
    <xsl:template
        match="tei:div[@type = 'section'][not(ancestor::tei:div[@type = 'article'])] | tei:div[@type = 'article'][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'bill']" mode="mBiblBibTex">
        <xsl:variable name="vLang" select="'ar-Latn-x-ijmes'"/>
        <xsl:variable name="vBiblStructSource"
            select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
        <xsl:variable name="vPublDate"
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:date[1]"/>
        <xsl:variable name="vPublicationType" select="'Newspaper article'"/>
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
        <xsl:variable name="vPages">
            <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
            <xsl:if
                test="preceding::tei:pb[@ed = 'print'][1]/@n != descendant::tei:pb[@ed = 'print'][last()]/@n">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="descendant::tei:pb[@ed = 'print'][last()]/@n"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="vPubPlace"
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:pubPlace/tei:placeName[@xml:lang = 'en']"/>
        <xsl:variable name="vPublisher" select="$vBiblStructSource/tei:monogr/tei:imprint/tei:publisher/tei:orgName[@xml:lang = $vLang]"/>
        <!-- construct BibText -->
        <xsl:text>@ARTICLE{</xsl:text>
        <!-- BibTextKey -->
        <xsl:value-of select="@xml:id"/><xsl:text>, </xsl:text><xsl:value-of select="$vN"/>
        <!-- author information -->
        <xsl:if test="child::tei:byline/tei:persName">
            <xsl:text>author = {</xsl:text>
            <xsl:choose>
                <xsl:when test="child::tei:byline/tei:persName/tei:surname">
                    <xsl:value-of select="child::tei:byline/tei:persName/tei:surname"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="child::tei:byline/tei:persName/tei:forename"/>
                </xsl:when>
                <xsl:when test="child::tei:byline/tei:persName">
                    <xsl:value-of select="child::tei:byline/tei:persName"/>
                </xsl:when>
            </xsl:choose>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        </xsl:if>
        <!-- editor information -->
        <xsl:text>editor = {</xsl:text>
        <xsl:value-of
            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:surname"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of
            select="$vBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang = $vLang]/tei:forename"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <!-- titles -->
        <xsl:text>title = {</xsl:text>
        <xsl:value-of select="$vArticleTitle"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>journal = {</xsl:text>
        <xsl:value-of select="$vPublicationTitle"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <!-- imprint -->
        <xsl:text>volume = {</xsl:text>
        <xsl:value-of select="$vVolume"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>issue = {</xsl:text>
        <xsl:value-of select="$vIssue"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>pages = {</xsl:text>
        <xsl:value-of select="$vPages"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>publisher = {</xsl:text>
        <xsl:value-of select="$vPublisher"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>address = {</xsl:text>
        <xsl:value-of select="$vPubPlace"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>language = {</xsl:text>
        <xsl:value-of select="@xml:lang"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <!-- publication dates -->
        <xsl:text>day = {</xsl:text>
        <xsl:value-of select="day-from-date($vPublDate/@when)"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>month = {</xsl:text>
        <xsl:value-of select="month-from-date($vPublDate/@when)"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>year = {</xsl:text>
        <xsl:value-of select="year-from-date($vPublDate/@when)"/>
        <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
        <xsl:text>}</xsl:text><xsl:value-of select="$vN"/>
    </xsl:template>

    <!-- prevent output from sections of articles -->
    <xsl:template match="tei:div[@type = 'section'][ancestor::tei:div[@type = 'article']]" mode="mBiblBibTex mBiblSente"/>

    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="mPlainText">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- prevent notes in div/head from producing output -->
    <xsl:template match="tei:head/tei:note" mode="mPlainText"/>

    <!-- IDs -->
    <xsl:template name="templID">
        <xsl:apply-templates select=".//idno[@type = 'BibTex']"/>
        <xsl:apply-templates select=".//idno[@type = 'RIS reference number']"/>
        <xsl:apply-templates select=".//idno[@type = 'OCLCID']"/>
        <xsl:apply-templates select=".//idno[@type = 'SenteUUID']"/>
        <xsl:apply-templates select=".//idno[@type = 'CitationID']"/>
        <xsl:apply-templates select=".//idno[@type = 'callNumber']"/>
    </xsl:template>

    <xsl:template match="idno[@type = 'BibTex']">
        <xsl:element name="tss:characteristic">
            <xsl:attribute name="name">BibTex cite tag</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="idno[@type = 'RIS reference number']">
        <xsl:element name="tss:characteristic">
            <xsl:attribute name="name">RIS reference number</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="idno[@type = 'OCLCID']">
        <xsl:element name="tss:characteristic">
            <xsl:attribute name="name">OCLCID</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="idno[@type = 'SenteUUID']">
        <xsl:element name="tss:characteristic">
            <xsl:attribute name="name">UUID</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="idno[@type = 'CitationID']">
        <xsl:element name="tss:characteristic">
            <xsl:attribute name="name">Citation identifier</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="idno[@type = 'callNumber']">
        <xsl:element name="tss:characteristic">
            <xsl:attribute name="name">call-Num</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
