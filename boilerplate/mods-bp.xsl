<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    exclude-result-prefixes="xsl tei xd eg fn #default" 
    extension-element-prefixes="exsl
    msxsl" 
    version="1.0"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:eg="http://www.tei-c.org/ns/Examples" 
    xmlns:exsl="http://exslt.org/common"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3">


    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- import stylesheet setting all the parameters -->
    <xsl:include href="mods-parameters.xsl"/>

    <!-- variables -->
    <xsl:variable name="vMimeType" select="'image/jpeg'"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Match document root and create and html5 wrapper for the TEI document, which is copied, with some modification, into the
                HTML document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:key match="//*" name="ids" use="@xml:id"/>
    <xsl:template match="/" name="htmlShell" priority="99">
        <html>
            <xsl:call-template name="htmlHead"/>
            <body ontouchstart="">
                <div id="wrapper">
                    <xsl:apply-templates/>
                </div>
                <xsl:copy-of select="$htmlFooter"/>
            </body>
        </html>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Basic copy template, copies all attribute nodes from source XML tree to output document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Template for elements, which handles style and adds an @xml:id to every element. Existing @xml:id attributes are retained
                unchanged.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="*" name="teibp-default">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="addID"/>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Template to omit processing instructions from output.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="processing-instruction()" priority="10"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Template moves value of @rend into an html @style attribute. Stylesheet assumes CSS is used in @rend to describe
                renditions, i.e., styles.</xd:p>
        </xd:desc>
    </xd:doc>
   
  
    <xsl:template match="@xml:id">
        <!-- @xml:id is copied to @id, which browsers can use for internal links. -->
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="addID">
        <xsl:if test="not(ancestor::eg:egXML)">
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="generate-unique-id">
                            <xsl:with-param name="root" select="generate-id()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="generate-unique-id">
        <xsl:param name="root"/>
        <xsl:param name="suffix"/>
        <xsl:variable name="id" select="concat($root, $suffix)"/>
        <xsl:choose>
            <xsl:when test="key('ids', $id)">
                <xsl:call-template name="generate-unique-id">
                    <xsl:with-param name="root" select="$root"/>
                    <xsl:with-param name="suffix" select="concat($suffix, 'f')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$id"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

   
 
    <xd:doc>
        <xd:desc>
            <xd:p>Template for adding /html/head content.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="htmlHead">
        <head>
            <meta charset="UTF-8"/>
            <link href="{$modsbpCSS}" id="maincss" rel="stylesheet" type="text/css"/>
          <!--  <link href="{$customCSS}" id="customcss" rel="stylesheet" type="text/css"/>-->

            <title><!-- don't leave empty. --></title>
        </head>
    </xsl:template>
   
    
    <xd:doc>
        <xd:desc>
            <xd:p>Template for adding footer to html document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="htmlFooter">
        <footer>
            <span>Powered by MODS Boilerplate</span>
        </footer>
    </xsl:variable>
   

    <xd:doc>
        <xd:desc>
            <xd:p>This template adds support for rtl-languages such as Arabic. It generates a HTML @lang attribute based on the containing
                element's @xml:lang attribute. It is called in the for every element in the "teipb-default" template</xd:p>
        </xd:desc>
        <xd:param name="pInput">Any node() or text()</xd:param>
    </xd:doc>
    <xsl:template name="templHtmlAttrLang">
        <xsl:param name="pInput"/>
        <xsl:choose>
            <xsl:when test="$pInput/@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="$pInput/@xml:lang"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="lang">
                    <xsl:value-of select="$pInput/ancestor::node()[@xml:lang != ''][1]/@xml:lang"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- mods -->
    <xsl:template match="mods:modsCollection"> 
       <div>
           <p lang="en">
               <xsl:value-of select="count(mods:mods)"/>
               <xsl:text> bibliographic items</xsl:text>
           </p>
            <ol lang="ar">
                <xsl:apply-templates>
                    <xsl:sort select="mods:titleInfo"/>
                    <xsl:sort select="descendant::mods:name[mods:role/mods:roleTerm[@authority='marcrelator']/text()='aut']"/><xsl:sort select="mods:titleInfo"/>

                </xsl:apply-templates>
            </ol>
        </div>
    </xsl:template>
    <xsl:template match="mods:mods">
        <li>
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:name[mods:role/mods:roleTerm[@authority='marcrelator']/text()='aut']"/>
            <xsl:apply-templates select="mods:name[mods:role/mods:roleTerm[@authority='marcrelator']/text()='edt']"/>
            <xsl:apply-templates select="descendant::mods:originInfo"/>
        </li>
    </xsl:template>
    
    <!-- titles: generate links -->
    <xsl:template match="mods:titleInfo/mods:title">
        <a href="{ancestor::mods:mods/mods:location/mods:url}" target="_blank">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </a>
    </xsl:template>
    
    <xsl:template match="mods:originInfo">
        <xsl:apply-templates select="mods:place"/>
<!--        <xsl:text>: </xsl:text>-->
        <xsl:apply-templates select="mods:publisher"/>
        <xsl:apply-templates select="mods:dateIssued"/>
        <xsl:apply-templates select="mods:dateOther"/>
    </xsl:template>
    
    <xsl:template match="mods:name">
        <span class=" {name()} {mods:role/mods:roleTerm[@authority='marcrelator']/text()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- basic templates -->
    <xsl:template match="mods:*">
        <xsl:if test="descendant::text()">
            <span class=" {name()}">
                <xsl:apply-templates select="@*"/>
                <!--<xsl:call-template name="templHtmlAttrLang">
                    <xsl:with-param name="pInput" select="."/>
                </xsl:call-template>-->
                <xsl:attribute name="lang">
                <xsl:choose>
                    <xsl:when test="@xml:lang">
                            <xsl:value-of select="@xml:lang"/>
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:value-of select="'en'"/>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates select="node()"/>
            </span>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>
