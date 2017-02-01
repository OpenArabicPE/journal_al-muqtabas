<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xd eg fn #default" extension-element-prefixes="exsl     msxsl" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:eg="http://www.tei-c.org/ns/Examples" xmlns:exsl="http://exslt.org/common"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- construct the image URL on the fly -->
    <xsl:variable name="v_volume" select="$vgBiblStructSource/tei:monogr/tei:biblScope[@unit = 'volume']/@n"/>
    <xsl:variable name="v_issue" select="$vgBiblStructSource/tei:monogr/tei:biblScope[@unit = 'issue']/@n"/>

    <!-- could also select pb[@facs] -->
    <xsl:template match="tei:pb[@ed = 'print']">
        <!--<xsl:param name="pn">
            <xsl:number count="//tei:pb" level="any"/>
        </xsl:param>-->
        <xsl:choose>
            <xsl:when test="$p_display-page-breaks = true()">
                <!-- add @lang="en" to ensure correct ltr rendering -->
                    <xsl:call-template name="t_handler-pb">
                        <xsl:with-param name="p_pb" select="."/>
                    </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="t_handler-pb">
        <xsl:param name="p_pb"/>
<!--        <xsl:variable name="v_n" select="@n"/>-->
        <xsl:variable name="v_facs" select="$p_pb/@facs"/>
        <xsl:variable name="v_id">
            <xsl:choose>
                <xsl:when test="$p_pb/@xml:id">
                    <xsl:value-of select="$p_pb/@xml:id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="generate-id()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="v_mimetype" select="'image/jpeg'"/>
        <xsl:variable name="v_id-facs" select="substring-after($v_facs, '#')"/>
        <xsl:variable name="v_graphic" select="ancestor::tei:TEI/tei:facsimile/tei:surface[@xml:id = $v_id-facs]/tei:graphic"/>
        <!-- select which online facsimile to display based on the order of preference: EAP, sakhrit, HathiTrust, other; and https over http -->
        <xsl:variable name="v_url-graphic">
            <xsl:choose>
                <xsl:when test="$v_graphic[starts-with(@url, 'https://eap.')]">
                    <xsl:value-of select="$v_graphic[starts-with(@url, 'https://eap.')][1]/@url"/>
                </xsl:when>
                <xsl:when test="$v_graphic[starts-with(@url, 'http://eap.')]">
                    <xsl:value-of select="$v_graphic[starts-with(@url, 'http://eap.')][1]/@url"/>
                </xsl:when>
                <xsl:when test="$v_graphic[starts-with(@url, 'http://archive.sakhrit.co')]">
                    <xsl:value-of select="$v_graphic[starts-with(@url, 'http://archive.sakhrit.co')][1]/@url"/>
                </xsl:when>
                <xsl:when test="$v_graphic[starts-with(@url, 'https://babel.hathitrust.org')]">
                    <xsl:value-of select="$v_graphic[starts-with(@url, 'https://babel.hathitrust.org')][1]/@url"/>
                </xsl:when>
                <xsl:when test="$v_graphic[starts-with(@url, 'http://babel.hathitrust.org')]">
                    <xsl:value-of select="$v_graphic[starts-with(@url, 'http://babel.hathitrust.org')][1]/@url"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$v_graphic[starts-with(@url, 'http')][1]/@url"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- dealing with pointers instead of full URLs in @facs -->
        <xsl:variable name="v_url-facs">
            <xsl:choose>
                <xsl:when test="starts-with($v_facs, '#')">
                    <!-- Preference:  -->
                    <xsl:choose>
                        <xsl:when test="$p_display-online-facsimiles = true()">
                            <xsl:value-of select="$v_url-graphic"/>
                        </xsl:when>
                        <!-- select the local file -->
                        <xsl:otherwise>
                            <xsl:value-of select="$v_graphic[@mimeType = $v_mimetype][1]/@url"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$v_facs"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="v_url-facs-online">
            <xsl:choose>
                <xsl:when test="starts-with($v_facs, '#')">
                    <xsl:value-of select="$v_url-graphic"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$v_facs"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- constructing a link for every graphic element -->
        <xsl:variable name="v_facs-links">
            <xsl:for-each select="$v_graphic[starts-with(@url, 'http')]">
                <a href="{@url}" target="_blank">
                    <xsl:call-template name="t_url-to-name">
                        <xsl:with-param name="p_input" select="@url"/>
                    </xsl:call-template>
                </a>
                <xsl:if test="position()!=last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <!-- construct the final output -->
        <span class="c_teibp-pb" lang="en">
            <xsl:call-template name="addID"/>
            <!-- span to draw a horizontal divider -->
            <span class="c_teibp-pbLine"> </span>
            <!-- span to act as container for information and facsimiles-->
        <span class="c_teibp-pbImgInfo">
            <!-- span containing all information on the page and the facsimile -->
            <span class="c_teibp-pageNum" lang="{$v_lang-interface}">
                <!-- this should be a back-link -->
                <a class="c_link-self" href="{concat('#',$v_id)}" title="{concat($p_text-permalink,$p_text-name-element_pb)}">
                    <xsl:copy-of select="$p_text-page"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$p_pb/@n"/>
                </a>
                <!-- provide link to online facsimile no matter what -->
                <xsl:if test="$v_facs = true()">
                    <xsl:text> - </xsl:text>
                    <xsl:copy-of select="$p_text-facs-link"/>
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="$v_facs-links"/>
                </xsl:if>
            </span>
            <!-- span containing the actual image -->
            <xsl:if test="$v_facs = true()">
                <span class="c_teibp-pbFacs" lang="en">
                    <a class="gallery-facs" lang="en" href="{$v_url-facs}" target="_blank">
                        <img src="{$v_url-facs}" class="c_teibp-thumbnail"/>
                    </a>
                </span>
            </xsl:if>
        </span>
        </span>
    </xsl:template>
    
    <xsl:template name="t_url-to-name">
        <xsl:param name="p_input"/>
        <xsl:choose>
            <xsl:when test="contains($p_input, '://eap.')">
                <span lang="en">EAP</span>
            </xsl:when>
            <xsl:when test="contains($p_input, '://archive.sakhrit.co')">
                <span lang="en">archive.sakhrit.co</span>
            </xsl:when>
            <xsl:when test="contains($p_input, '://babel.hathitrust.org')">
                <span lang="en">HathiTrust</span>
            </xsl:when>
            <xsl:otherwise>
                <span lang="en"><xsl:value-of select="substring-before(substring-after($p_input,'://'),'/')"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
