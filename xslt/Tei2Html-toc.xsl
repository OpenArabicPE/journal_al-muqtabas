<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="html" encoding="UTF-16" indent="yes" omit-xml-declaration="yes"  name="html"/>
    
    <!-- 
    + information on volume and issue for the entries
    + author information is not coming through
    + heads for the different lists are still missing
    + long lists should be broken down along the beginning letter
    -->
    
    <xsl:template match="/">
        <xsl:result-document method="html" href="{substring-before(base-uri(),'.TEIP5')}-toc.html">
            <html>
                <head>
                    <style type="text/css">
                        [lang="ar"], [lang="ota"]{
                        direction:rtl;
                        text-align:right;
                        font-family: Serif, Sans-Serif;
                        font-weight:normal;
                        /*In CSS nested relative sizes accumulate*/
                        /*font-size:120%;*/
                        }
                    </style>
                </head>
                <body>
                    <!-- alphabetically sorted list of all heads -->
                    <ul lang="ar">
                        <xsl:apply-templates select="descendant::tei:div[child::tei:head]" mode="mToc">
                        <xsl:sort select="if(starts-with(child::tei:head[1], 'ال')) then(substring-after(child::tei:head[1], 'ال')) else(child::tei:head[1])"/>
                    </xsl:apply-templates>
                    </ul>
                    <!-- alphabetically sorted list of authors -->
                    <ul lang="ar">
                        <xsl:apply-templates select="descendant::tei:div[child::tei:byline/descendant::tei:persName]" mode="mAuthor">
                            <xsl:sort select="child::tei:byline/descendant::tei:persName[1]"/>
                        </xsl:apply-templates>
                    </ul>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <!-- create a sub-list and list item (li) for each bill, section, or article -->
    <!-- the type attributes are dependent on the schema tei_jaraid.rng -->
    <!--  <xsl:template match="tei:div[@type='bill'] | tei:div[@type='section'] | tei:div[@type='article']" mode="mToc"> -->
    <xsl:template match="tei:div" mode="mToc">
        <li lang="ar">
            <!--<xsl:apply-templates select="./tei:head" mode="mToc"/>-->
            <a>
                <!-- generate IDs on the fly if there are non existing. The link should point to the parent::tei:div and not the head -->
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="@xml:id">
                            <xsl:value-of select="concat('#', @xml:id)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('#', generate-id())"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <!-- provide content of head -->
                <xsl:apply-templates select="child::tei:head"/>
            </a>
            <!--<xsl:if test="./tei:div">
                <ul>
                    <xsl:apply-templates select="./tei:div" />
                </ul>
            </xsl:if>-->
        </li>
    </xsl:template>
    
    <xsl:template match="tei:div[child::tei:byline/descendant::tei:persName]" mode="mAuthor">
        <li lang="ar">
            <a>
                <!-- generate IDs on the fly if there are non existing. The link should point to the parent::tei:div and not the head -->
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="@xml:id">
                            <xsl:value-of select="concat('#', @xml:id)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('#', generate-id())"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <!-- provide content of head -->
                <xsl:apply-templates select="child::tei:head"/>
            </a>
        </li>
    </xsl:template>
    
    <!-- omit all nodes that are not explicitly dealt with -->
    <xsl:template match="tei:head">
        <xsl:apply-templates/>
        <!-- add information on section -->
        <xsl:if test="ancestor::tei:div[@type='section']">
            <xsl:choose>
                <xsl:when test="@xml:lang = 'ar'">
                    <xsl:text>، </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="ancestor::tei:div[@type='section']/child::tei:head"/>
        </xsl:if>
        <xsl:text> (</xsl:text>
        <!-- add author names and pages if available -->
        <xsl:if test="tei:byline/tei:persName">
            <xsl:choose>
                <xsl:when test="@xml:lang = 'ar'">
                    <xsl:text>مؤلف: </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="tei:byline/tei:persName"/>
            <xsl:text>،</xsl:text>
        </xsl:if>
        <!-- add page numbers -->
        <xsl:choose>
            <xsl:when test="@xml:lang = 'ar'">
                <xsl:text>ص </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:value-of select="parent::tei:div/preceding::tei:pb[@ed = 'print'][1]/@n"/>
        <xsl:if test="parent::tei:div/preceding::tei:pb[@ed = 'print'][1]/@n != parent::tei:div/descendant::tei:pb[@ed = 'print'][last()]/@n">
            <xsl:text>–</xsl:text>
            <xsl:value-of select="parent::tei:div/descendant::tei:pb[@ed = 'print'][last()]/@n"/>
        </xsl:if>
        <xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:lb | tei:cb">
        <xsl:text> </xsl:text>
    </xsl:template>
    
</xsl:stylesheet>