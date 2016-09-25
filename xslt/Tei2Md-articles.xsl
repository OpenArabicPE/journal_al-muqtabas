<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" name="text"/>
    <xsl:strip-space elements="*"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet produces a simple markdown file from TEI XML input for every div in the body of the document</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:variable name="vFileId" select="tei:TEI/@xml:id"/>
    <!--<xsl:variable name="vgFileUrl"
        select="concat('https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/', tokenize(base-uri(), '/')[last()])"/>-->
    <xsl:variable name="vgFileUrl" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='url']"/>
    <xsl:variable name="vN" select="'&#x0A;'"/>
    <xsl:param name="pLang" select="'ar'"/>

    <xsl:template match="/">
            <xsl:apply-templates select="descendant::tei:text/tei:body/descendant::tei:div"/>
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
        
        <!-- generate the md file -->
<!--        <xsl:result-document href="../jekyll/_posts/{concat($vPublDate/@when,'-',translate($vArticleTitle,' ','-'),'-',$vFileId,'-',@xml:id)}.md" method="text">-->
        <xsl:result-document href="../md/{concat($vFileId,'-',@xml:id)}.md" method="text">
            
            <!-- some metadata on the file itself: YAML. In order to support pandoc conversions etc. the Yaml block should also containe a link to the BibTeX file identifying this article. -->
            <xsl:text>---</xsl:text><xsl:value-of select="$vN"/>
            <xsl:text>title: "*</xsl:text><xsl:value-of select="$vArticleTitle"/><xsl:text>*. </xsl:text><xsl:value-of select="$vPublicationTitle"/><xsl:text> </xsl:text><xsl:value-of select="$vVolume"/><xsl:text>(</xsl:text><xsl:value-of select="$vIssue"/><xsl:text>)</xsl:text><xsl:text>"</xsl:text><xsl:value-of select="$vN"/>
            <xsl:text>author: </xsl:text><xsl:value-of select="$vAuthor"/><xsl:value-of select="$vN"/>
            <xsl:text>date: </xsl:text><xsl:value-of select="$vPublDate/@when"/><xsl:value-of select="$vN"/>
            <xsl:text>bibliography: </xsl:text><xsl:value-of select="concat($vFileId,'-',@xml:id,'.bib')"/><xsl:value-of select="$vN"/>
            <xsl:text>---</xsl:text><xsl:value-of select="$vN"/><xsl:value-of select="$vN"/>
            <xsl:apply-templates mode="mPlainText"/>
        </xsl:result-document>
    </xsl:template>
    
    <!-- heads -->
    
    <xsl:template match="tei:head">
        <!-- establish the level of nesting -->
        <xsl:variable name="v_level" select="number(count(ancestor::tei:div))"/>
        <xsl:choose>
            <xsl:when test="$v_level =1">
                <xsl:text># </xsl:text>
            </xsl:when>
            <xsl:when test="$v_level =2">
                <xsl:text>## </xsl:text>
            </xsl:when>
            <xsl:when test="$v_level =3">
                <xsl:text>### </xsl:text>
            </xsl:when>
            <xsl:when test="$v_level =4">
                <xsl:text>#### </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="."/><xsl:value-of select="$vN"/>
        <xsl:value-of select="$vN"/>
    </xsl:template>
    
    <!-- paragraphs, lines -->
    <xsl:template match="tei:p | tei:l" mode="mPlainText">
        <xsl:value-of select="$vN"/>
        <xsl:apply-templates mode="mPlainText"/>
        <xsl:value-of select="$vN"/>
    </xsl:template>
    
    <!-- segments of a line -->
    <xsl:template match="tei:l[@type='bayt']/tei:seg" mode="mPlainText">
        <xsl:apply-templates mode="mPlainText"/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <!-- prevent output from sections of articles -->
    <xsl:template match="tei:div[@type = 'section'][ancestor::tei:div[@type = 'article']]"/>

    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="mPlainText">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="text()" mode="mPlainText">
        <!--<xsl:text> </xsl:text>--><xsl:value-of select="normalize-space(.)"/><!--<xsl:text> </xsl:text>-->
    </xsl:template>

    <!-- prevent notes in div/head from producing output -->
    <xsl:template match="tei:head/tei:note" mode="mPlainText"/>


</xsl:stylesheet>
