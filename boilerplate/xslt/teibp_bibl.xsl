<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" 
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    exclude-result-prefixes="xsl tei xd eg #default">
    
    <!-- This stylesheet provides structured bibliographic metat data and links to such data -->
    
    
    <xsl:param name="pgLang" select="'ar'"/>
    <xsl:variable name="vgBiblStructSource" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
    <xsl:variable name="vgPublicationTitle" select="$vgBiblStructSource/tei:monogr/tei:title[@xml:lang=$pgLang]"/>
    <xsl:variable name="vgPublicationDate" select="$vgBiblStructSource/tei:monogr/tei:imprint/tei:date[1]/@when"/>
    <xsl:variable name="vgEditor" select="$vgBiblStructSource/tei:monogr/tei:editor/tei:persName[@xml:lang=$pgLang]"/>

    <!-- the output of the template is "Journal title 1(2)" -->
    <xsl:template name="t_metadata-file">
        <xsl:param name="p_input" select="$vgBiblStructSource"/>
    	<!-- add title, volume, issue, date -->
    	<title>
    	    <xsl:value-of select="$p_input/tei:monogr/tei:title[@xml:lang=$pgLang][not(@type = 'sub')]"/>
    	    <xsl:text> </xsl:text>
    	    <!-- include @from and @to -->
    	    <xsl:choose>
    	        <!-- test for singular item -->
    	        <xsl:when test="$p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@from = $p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@to">
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@from"/>
    	        </xsl:when>
    	        <!-- test for range -->
    	        <xsl:when test="$p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@from != $p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@to">
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@from"/>
    	            <xsl:text>–</xsl:text>
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@to"/>
    	        </xsl:when>
    	        <!-- default to @n -->
    	        <xsl:otherwise>
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'volume']/@n"/>
    	        </xsl:otherwise>
    	    </xsl:choose>
    		<xsl:text>(</xsl:text>
    	    <!-- include @from and @to -->
    	    <xsl:choose>
    	        <!-- test for singular item -->
    	        <xsl:when test="$p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@from = $p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@to">
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@from"/>
    	        </xsl:when>
    	        <!-- test for range -->
    	        <xsl:when test="$p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@from != $p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@to">
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@from"/>
    	            <xsl:text>–</xsl:text>
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@to"/>
    	        </xsl:when>
    	        <!-- default to @n -->
    	        <xsl:otherwise>
    	            <xsl:value-of select="$p_input/tei:monogr/tei:biblScope[@unit = 'issue']/@n"/>
    	        </xsl:otherwise>
    	    </xsl:choose>
    		<xsl:text>) </xsl:text>
    		<!-- <xsl:value-of select="$vgPublicationDate"/> -->
    	</title>
    </xsl:template>
    
    <xsl:template name="t_metadata-dc-file">
        <xsl:param name="pLang" select="$pgLang"/>
        <meta name="dc.language" content="{$pLang}" />
        <meta name="dc.type" content="text" />
        <meta name="dc.title" content="{$vgPublicationTitle}" />
        <meta name="dc.creator" content="{$vgEditor}"/>
        <meta name="dc.date" content="{$vgPublicationDate}" />
    </xsl:template>
    
    <xsl:template name="t_metadata-dc-article">
        <xsl:param name="pInput"/>
        <xsl:variable name="vArticleTitle" select="$pInput/tei:head"/>
        <xsl:variable name="vAuthor" select="$pInput/tei:byline/descendant::tei:persName"/>
        <meta name="dc.type" content="text" />
        <meta name="dc.title" content="{$vArticleTitle}" />
        <meta name="dc.creator">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space($vgEditor)"/>
            </xsl:attribute>
        </meta>
        <meta name="dc.creator">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space($vgEditor)"/>
            </xsl:attribute>
        </meta>
        <meta name="dc.date" content="{$vgPublicationDate}" />
    </xsl:template>
    
    <xsl:template name="t_metadata-schema-article">
        <xsl:param name="p_input"/>
        <xsl:variable name="vArticleTitle" select="$p_input/tei:head"/>
        <xsl:variable name="vAuthor" select="$p_input/tei:byline/descendant::tei:persName"/>
        <meta name="dc.type" content="text" />
        <meta name="dc.title" content="{$vArticleTitle}" />
        <meta name="dc.creator">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space($vgEditor)"/>
            </xsl:attribute>
        </meta>
        <meta name="dc.creator">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space($vgEditor)"/>
            </xsl:attribute>
        </meta>
        <meta name="dc.date" content="{$vgPublicationDate}" />
    </xsl:template>
    
    <xsl:template name="templBiblDataLinks">
        <xsl:param name="pBiblUrl"/>
        <xsl:param name="pLabelText"/>
        <span class="c_links" lang="en">
            <xsl:value-of select="$pLabelText"/>
            <!-- link to the BibTex file for this article. NOTE: these must have been pregenerated -->
            <a href="{$pBiblUrl}.bib" download="{$pBiblUrl}.bib" target="_blank" class="c_links c_link-bibtex" title="Link to bibliographic metadata as BibTeX">BibTeX</a>
            <!-- link to the MODS file for this article. NOTE: these must have been pregenerated -->
            <a href="{$pBiblUrl}.MODS.xml" download="{$pBiblUrl}.MODS.xml" target="_blank" class="c_links c_link-bibtex" title="Link to bibliographic metadata as MODS XML">MODS</a>
        </span>
    </xsl:template>
    
    <xsl:template name="t_source-reference-for-div">
        <!-- input is a div -->
        <xsl:param name="p_input"/>
        <!-- get basic information from sourceDesc -->
        <xsl:variable name="v_reference">
        <xsl:call-template name="t_metadata-file">
            <xsl:with-param name="p_input" select="$p_input/ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct[1]"/>
        </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$v_reference"/>
        <!-- add page range -->
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$p_input/preceding::tei:pb[@ed = 'print'][1]/@n"/>
        <xsl:text>–</xsl:text>
        <xsl:value-of select="$p_input/descendant::tei:pb[@ed = 'print'][last()]/@n"/>
        
    </xsl:template>
</xsl:stylesheet>