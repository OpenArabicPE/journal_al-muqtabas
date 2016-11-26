<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xd eg fn #default" extension-element-prefixes="exsl
    msxsl" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:eg="http://www.tei-c.org/ns/Examples" xmlns:exsl="http://exslt.org/common"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xd:doc scope="stylesheet">
        <xd:desc>
             <xd:p>This stylesheet is the entry point into the TEI boilerplate for the display of (mainly Arabic) periodicals in any modern web browser using XSLT 1. The system has been adopted from the original TEI boilerplate.</xd:p>
            <xd:p>As well as loading all other stylesheets, this stylesheet defines global parameters.</xd:p>
            
        </xd:desc>
    </xd:doc>
    
    <!-- Load all other stylesheets -->
    <!-- import the standard TEI Boilerplate stylesheets -->
    <xsl:include href="teibp_main.xsl"/>
    <xsl:include href="teibp_sourcedesc.xsl"/>
    <xsl:include href="xml-to-string.xsl"/>
    <!-- import the stylesheet formatting all bibliographic metadata -->
    <xsl:include href="teibp_bibl.xsl"/>
    <!-- import the stylesheet dealing with the display of <pb> and facsimiles -->
    <xsl:include href="teibp_pb.xsl"/>

    <!-- select whether you want to display page breaks and facsimiles -->
    <xsl:param name="p_display-page-breaks" select="true()"/>
    <!-- select whether you want to display online or local facsimiles -->
    <xsl:param name="p_display-online-facsimiles" select="true()"/>
    <!-- select whether you want to display line breaks -->
    <xsl:param name="p_display-line-breaks" select="true()"/>
    <!-- select whether you want to use inline CSS for the display -->
    <xsl:param name="p_use-inline-css" select="true()"/>
    <!-- select whether the language of the interface should follow the main language of the text -->
    <xsl:param name="p_lang-interface-same-as-text" select="false()"/>
    <!-- select the colour scheme for heads -->
    <xsl:param name="p_display-dark-heads" select="false()"/>

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
        <span class="c_teibp-pbNote" lang="{$v_lang-interface}">
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
        <span class="c_teibp-pbNote" lang="{$v_lang-interface}">
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
    <xsl:param name="p_text-name-element_pb">
        <xsl:choose>
            <xsl:when test="$v_lang-interface = 'ar'">
                <xsl:text>هذه الصفحة</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>this page break</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="p_text-notes">
        <xsl:choose>
            <xsl:when test="$v_lang-interface = 'ar'">
                <xsl:text>ملاحظات</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Notes</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    
    <xsl:param name="p_text-nav_next-issue">
        <span lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>الجزء التالي</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Next issue</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>

    <xsl:param name="p_text-nav_previous-issue">
        <span lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>الجزء السابق</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Previous issue</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>
    
    <!-- parameters for file paths or URLs -->
    <!-- modify filePrefix to point to boilerplate files on your own server, or to specify a relative path, e.g.: <xsl:param name="filePrefix" select="'http://dcl.slis.indiana.edu/teibp'"/>
	-->
    <xsl:param name="filePrefix" select="'..'"/>
    <!-- the following parameters should not be changed unless the folder structure and file names have been changed -->
    <xsl:param name="teibpCSS" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="customCSS" select="concat($filePrefix, '/css/teibp_custom.css')"/>
    <xsl:variable name="v_css-heads">
        <xsl:choose>
            <xsl:when test="$p_display-dark-heads = true()">
                <xsl:value-of select="concat($filePrefix,'/css/teibp_heads-dark.css')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($filePrefix,'/css/teibp_heads-light.css')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:param name="jqueryJS" select="concat($filePrefix, '/js/jquery/jquery.min.js')"/>
    <xsl:param name="jqueryBlockUIJS" select="concat($filePrefix, '/js/jquery/plugins/jquery.blockUI.js')"/>
    <xsl:param name="teibpJS" select="concat($filePrefix, '/js/teibp.js')"/>
    <xsl:param name="theme.default" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="theme.sleepytime" select="concat($filePrefix, '/css/sleepy.css')"/>
    <xsl:param name="theme.terminal" select="concat($filePrefix, '/css/terminal.css')"/>
</xsl:stylesheet>