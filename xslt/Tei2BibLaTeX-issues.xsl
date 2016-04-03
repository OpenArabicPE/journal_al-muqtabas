<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" name="text"/>
    <xsl:strip-space elements="*"/>

    <!-- this stylesheet generates a Bibtex file with bibliographic metadata for each <div> in the body of the TEI source file. File names are based on the source's @xml:id and the @xml:id of the <div>. -->
    <!-- to do:
        + add information on edition: i.e. TEI edition
        + add information on collaborators on the digital edition
        comment: this information cannot be added to BibTeX for articles appart from the generic "annote" tag -->
    
    
    <!-- parameter to select the language of some fields (if available): 'ar-Latn-x-ijmes', 'ar', 'en' etc. -->
    <xsl:param name="pLang" select="'ar'"/>

    <xsl:variable name="vFileId" select="tei:TEI/@xml:id"/>
    <xsl:variable name="vgFileUrl"
        select="concat('https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/', tokenize(base-uri(), '/')[last()])"/>
    <xsl:variable name="vN" select="'&#x0A;'"/>

    <xsl:template match="/">
        <xsl:result-document href="../metadata/{$vFileId}.bib" method="text">
            <xsl:text>%% This BibLaTeX bibliography file was created by automatic conversion from TEI XML</xsl:text><xsl:value-of select="$vN"/>
            <!-- some metadata on the file itself -->
            <xsl:text>%% Created at </xsl:text><xsl:value-of select="current-dateTime()"/><xsl:value-of select="$vN"/>
            <xsl:text>%% Saved with string encoding Unicode (UTF-8) </xsl:text><xsl:value-of select="$vN"/><xsl:value-of select="$vN"/>
            <!-- construct BibText -->
            <xsl:apply-templates select="descendant::tei:text/tei:body/descendant::tei:div"/>
        </xsl:result-document>
    </xsl:template>

    
    <xsl:template
        match="tei:div[@type = 'section'][not(ancestor::tei:div[@type = 'article'])] | tei:div[@type = 'article'][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'bill']">
        <xsl:variable name="vLang" select="$pLang"/>
        <!-- variables identifying the digital surrogate -->
        <xsl:variable name="vTitleStmt" select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt"/>
        <!-- Need information on edition, date of edition, editors, transcribers etc.  -->
        <!-- variables identifying the original source -->
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
        <xsl:variable name="vAuthor">
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
            select="$vBiblStructSource/tei:monogr/tei:imprint/tei:pubPlace/tei:placeName[@xml:lang = $vLang]"/>
        <xsl:variable name="vPublisher" select="$vBiblStructSource/tei:monogr/tei:imprint/tei:publisher/tei:orgName[@xml:lang = $vLang]"/>
        <!-- unfortunately BibLaTeX uses a controlled vocabulary for languages that is not the same as @xml:lang or @lang -->
        <xsl:variable name="vLangSource">
            <xsl:choose>
                <xsl:when test="@xml:lang='ar'">
                    <xsl:text>arabic</xsl:text>
                </xsl:when>
                <xsl:when test="@xml:lang='en'">
                    <xsl:text>english</xsl:text>
                </xsl:when>
                <xsl:when test="@xml:lang='fr'">
                    <xsl:text>french</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@xml:lang"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

            <xsl:text>@ARTICLE{</xsl:text>
            <!-- BibTextKey -->
            <xsl:value-of select="concat($vFileId,'-',@xml:id)"/><xsl:text>, </xsl:text><xsl:value-of select="$vN"/>
            <!-- author information -->
            <xsl:if test="child::tei:byline/tei:persName">
                <xsl:text>author = {</xsl:text>
                <xsl:value-of select="$vAuthor"/>
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
            <xsl:text>journaltitle = {</xsl:text>
            <xsl:value-of select="$vPublicationTitle"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <!-- imprint -->
            <xsl:text>volume = {</xsl:text>
            <xsl:value-of select="$vVolume"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <xsl:text>number = {</xsl:text>
            <xsl:value-of select="$vIssue"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <xsl:text>pages = {</xsl:text>
            <xsl:value-of select="$vPages"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <xsl:text>publisher = {</xsl:text>
            <xsl:value-of select="$vPublisher"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <xsl:text>location = {</xsl:text>
            <xsl:value-of select="$vPubPlace"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <xsl:text>langid = {</xsl:text>
            <xsl:value-of select="$vLangSource"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <!-- publication dates -->
            <xsl:text>date = {</xsl:text>
            <xsl:value-of select="$vPublDate/@when"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <!-- URL -->
            <xsl:text>url = {</xsl:text>
            <xsl:value-of select="$vUrl"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
             <xsl:text>urldate = {</xsl:text>
             <xsl:value-of select=" format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
             <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <!-- add information on digital edition -->
            <xsl:text>edition = {</xsl:text>
            <xsl:text>digital TEI edition, </xsl:text><xsl:value-of select="year-from-date(current-date())"/>
            <xsl:text>}, </xsl:text><xsl:value-of select="$vN"/>
            <!-- closing the entry -->
            <xsl:text>}</xsl:text><xsl:value-of select="$vN"/>
        <xsl:value-of select="$vN"/>
    </xsl:template>

    <!-- prevent output from sections of articles -->
    <xsl:template match="tei:div[@type = 'section'][ancestor::tei:div[@type = 'article']]"/>

    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="mPlainText">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- prevent notes in div/head from producing output -->
    <xsl:template match="tei:head/tei:note" mode="mPlainText"/>


</xsl:stylesheet>
