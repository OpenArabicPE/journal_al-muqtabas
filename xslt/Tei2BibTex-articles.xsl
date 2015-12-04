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


    <xsl:variable name="vFileId" select="tei:TEI/@xml:id"/>
    <xsl:variable name="vgFileUrl"
        select="concat('https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/', tokenize(base-uri(), '/')[last()])"/>
    <xsl:variable name="vN" select="'&#x0A;'"/>

    <xsl:template match="tei:TEI">
            <xsl:apply-templates select="child::tei:text/tei:body/descendant::tei:div"/>
    </xsl:template>

    
    <xsl:template
        match="tei:div[@type = 'section'][not(ancestor::tei:div[@type = 'article'])] | tei:div[@type = 'article'][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'bill']">
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
        
        <xsl:result-document href="../metadata/{concat($vFileId,'-',@xml:id)}.bib">
            <!-- construct BibText -->
            <xsl:text>@ARTICLE{</xsl:text>
            <!-- BibTextKey -->
            <xsl:value-of select="concat($vFileId,'-',@xml:id)"/><xsl:text>, </xsl:text><xsl:value-of select="$vN"/>
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
        </xsl:result-document>
    </xsl:template>

    <!-- prevent output from sections of articles -->
    <xsl:template match="tei:div[@type = 'section'][ancestor::tei:div[@type = 'article']]"/>

    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="mPlainText">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- prevent notes in div/head from producing output -->
    <xsl:template match="tei:head/tei:note" mode="mPlainText"/>


</xsl:stylesheet>
