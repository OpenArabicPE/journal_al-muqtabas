<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xd eg fn #default" extension-element-prefixes="exsl
    msxsl" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:eg="http://www.tei-c.org/ns/Examples" xmlns:exsl="http://exslt.org/common"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Match document root and create and html5 wrapper for the TEI document, which is copied, with some modification, into the
                HTML document.</xd:p>
        </xd:desc>
    </xd:doc>

    <!-- select whether you want to display facsimiles -->
    <xsl:param name="displayPageBreaks" select="true()"/>
    <!-- select whether or not you want to display online or local facsimiles -->
    <xsl:param name="pgOnlineFacs" select="false()"/>
    <!-- select whether you want to use inline CSS for the display -->
    <xsl:param name="inlineCSS" select="true()"/>
    <!-- select whether the language of the interface should follow the main language of the text -->
    <xsl:param name="p_lang-interface-same-as-text" select="false()"/>

    <!-- original TEI Boilerplate stuff -->
    <xsl:param name="teibpHome" select="'http://dcl.slis.indiana.edu/teibp/'"/>
    <xsl:param name="includeToolbox" select="false()"/>
    <xsl:param name="includeAnalytics" select="false()"/>
  
    <!-- special characters -->
    <xsl:param name="quot">
        <text>"</text>
    </xsl:param>
    <xsl:param name="apos">
        <text>'</text>
    </xsl:param>
    <!-- language selector -->
    <xsl:variable name="v_lang-interface">
        <xsl:choose>
            <xsl:when test="$p_lang-interface-same-as-text= true() and /tei:TEI/tei:text/@xml:lang">
                <xsl:value-of select="/tei:TEI/tei:text/@xml:lang"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>en</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- interface text -->
    <xsl:param name="p_text-page">
        <span class="-teibp-pbNote" lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>صفحة</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>page</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>
    <xsl:param name="p_text-facs-link">
        <span class="-teibp-pbNote" lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>انظر الى هذه الصورة في</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>view facsimile(s) at</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>
    <xsl:param name="p_text-permalink">
        <xsl:choose>
            <xsl:when test="$v_lang-interface = 'ar'">
                <xsl:text>الرابط الثابت ل</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Permalink to </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="p_text-name-element_div">
        <xsl:choose>
            <xsl:when test="$v_lang-interface = 'ar'">
                <xsl:text>هذه المقالة</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>this article/section</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="p_text-name-element_p">
        <xsl:choose>
            <xsl:when test="$v_lang-interface = 'ar'">
                <xsl:text>هذه الفقرة</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>this paragraph</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <!-- parameters for file paths or URLs -->
    <!-- modify filePrefix to point to boilerplate files on your own server, 
		or to specify a relative path, e.g.:
		<xsl:param name="filePrefix" select="'http://dcl.slis.indiana.edu/teibp'"/>
	-->
    <xsl:param name="filePrefix" select="'..'"/>
    <xsl:param name="teibpCSS" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="customCSS" select="concat($filePrefix, '/css/custom.css')"/>
    <xsl:param name="jqueryJS" select="concat($filePrefix, '/js/jquery/jquery.min.js')"/>
    <xsl:param name="jqueryBlockUIJS" select="concat($filePrefix, '/js/jquery/plugins/jquery.blockUI.js')"/>
    <xsl:param name="teibpJS" select="concat($filePrefix, '/js/teibp.js')"/>
    <xsl:param name="theme.default" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="theme.sleepytime" select="concat($filePrefix, '/css/sleepy.css')"/>
    <xsl:param name="theme.terminal" select="concat($filePrefix, '/css/terminal.css')"/>
</xsl:stylesheet>