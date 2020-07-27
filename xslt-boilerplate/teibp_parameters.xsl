<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xd eg  #default"  version="1.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:eg="http://www.tei-c.org/ns/Examples" 
     xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet is the entry point into the TEI boilerplate for the display of (mainly Arabic) periodicals in any modern web browser using XSLT 1. The system has been adopted from the original TEI boilerplate.</xd:p>
            <xd:p>As well as loading all other stylesheets, this stylesheet defines global parameters.</xd:p>
            
        </xd:desc>
    </xd:doc>
    
    <!-- Load all other stylesheets -->
    <!-- import the standard TEI Boilerplate stylesheets. If you link to versions hosted on GitHub make sure to point to a stable version to ensure that future changes won't break your set-up -->
    <xsl:include href="../boilerplate/xslt/teibp_main.xsl"/>
    <xsl:include href="../boilerplate/xslt/teibp_sourcedesc.xsl"/>
    <!-- <xsl:include href="xml-to-string.xsl"/> -->
    <!-- import the stylesheet formatting all bibliographic metadata -->
    <xsl:include href="../boilerplate/xslt/teibp_bibl.xsl"/>
    <!-- import the stylesheet dealing with the display of <pb> and facsimiles -->
    <xsl:include href="../boilerplate/xslt/teibp_pb.xsl"/>
    
    <!-- PARAMETERS -->
    <!-- select whether you want to display page breaks and facsimiles; default: true() -->
    <xsl:param name="p_display-page-breaks" select="true()"/>
    <!-- select whether you want to display online or local facsimiles; default: true() -->
    <xsl:param name="p_display-online-facsimiles" select="true()"/>
    <!-- select whether you want to display line breaks; default: false() -->
    <xsl:param name="p_display-line-breaks" select="false()"/>
    <!-- select whether you want to display editorial changes; default: false() -->
    <xsl:param name="p_display-editorial-changes" select="false()"/>
    <!-- select whether you want to process XInclude; default: true()  -->
    <xsl:param name="p_process-xinclude" select="true()"/>
    <!-- select whether you want to use inline CSS for the display; default: true() -->
    <xsl:param name="p_use-inline-css" select="true()"/>
    <!-- select whether the language of the interface should follow the main language of the text; default: false() -->
    <xsl:param name="p_lang-interface-same-as-text" select="true()"/>
    <!-- select the colour scheme for heads; currently available options: red, blue, green -->
    <xsl:param name="p_color-scheme" select="'red'"/>
    <!-- parameter to select the mimeType. In some cases tiff might be more efficient than jpeg -->
    <xsl:param name="p_mimetype" select="'image/tiff'"/>
    
    <!-- original TEI Boilerplate stuff -->
    <xsl:param name="teibpHome" select="'http://dcl.slis.indiana.edu/teibp/'"/>
    
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
                    <xsl:text>view facsimile at</xsl:text>
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
    <!-- not yet ready for production -->
    <xsl:param name="p_text-open">
        <xsl:choose>
            <xsl:when test="$v_lang-interface = 'ar'">
                <xsl:text>empty</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Open</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="p_text-new-window">
        <xsl:choose>
            <xsl:when test="$v_lang-interface = 'ar'">
                <xsl:text>empty</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>in new window</xsl:text>
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
    <xsl:param name="p_text-nav_top">
        <span lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>أعلى الصفحة</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Top of the page</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>
    <xsl:param name="p_text-nav_bottom">
        <span lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>اسفل الصفحة</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Bottom of the page</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>

    <!-- menu -->
    <xsl:param name="p_text-menu_contents">
        <span lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>فهرس</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Contents</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>
    <xsl:param name="p_text-menu_search">
        <span lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>بحث</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Search</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>
    <xsl:param name="p_text-menu_settings">
        <span lang="{$v_lang-interface}">
            <xsl:choose>
                <xsl:when test="$v_lang-interface = 'ar'">
                    <xsl:text>الإعدادات</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Settings</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:param>
    
    
    <!-- parameters for file paths or URLs -->
    <!-- modify filePrefix to point to boilerplate files on your own server, or to specify a relative path, e.g.: <xsl:param name="filePrefix" select="'http://dcl.slis.indiana.edu/teibp'"/>. 
        Remember: relative paths are relative to the file they are called from
	-->
    <xsl:param name="filePrefix" select="'../boilerplate'"/>
    <!-- the following parameters should not be changed unless the folder structure and file names have been changed -->
    <xsl:param name="teibpCSS" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="customCSS" select="concat($filePrefix, '/css/teibp_custom.css')"/>
    
    <xsl:param name="jqueryJS" select="concat($filePrefix, '/js/jquery/jquery.min.js')"/>
    <!--<xsl:param name="jqueryBlockUIJS" select="concat($filePrefix, '/js/jquery/plugins/jquery.blockUI.js')"/>
    <xsl:param name="teibpJS" select="concat($filePrefix, '/js/teibp.js')"/>-->
    <xsl:param name="p_js-slideout" select="concat($filePrefix,'/js/nav-slideout.js')"/>
    <xsl:param name="p_js" select="concat($filePrefix,'/js/script.js')"/>
    <xsl:param name="theme.default" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="theme.sleepytime" select="concat($filePrefix, '/css/sleepy.css')"/>
    <xsl:param name="theme.terminal" select="concat($filePrefix, '/css/terminal.css')"/>
</xsl:stylesheet>