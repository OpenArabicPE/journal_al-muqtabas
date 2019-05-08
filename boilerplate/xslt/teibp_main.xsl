<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xd eg fn #default"
    extension-element-prefixes="exsl     msxsl" version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:eg="http://www.tei-c.org/ns/Examples" xmlns:exsl="http://exslt.org/common"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 17, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> John A. Walsh</xd:p>
            <xd:p>TEI Boilerplate stylesheet: Copies TEI document, with a very few modifications into an html shell, which provides access
                to javascript and other features from the html/browser environment.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Match document root and create and html5 wrapper for the TEI document, which is copied, with some modification, into the
                HTML document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:key match="//*" name="ids" use="@xml:id"/>
    <!-- main HTML wrapper -->
    <xsl:template match="/" name="htmlShell" priority="99">
        <html id="html">
            <xsl:copy-of select="$v_html-head"/>
            <body ontouchstart="" id="body">
                <!-- removed the toolbox altogether -->
                <!--<xsl:if test="$includeToolbox = true()">
                    <xsl:call-template name="teibpToolbox"/>
                </xsl:if>-->
                <!-- to prepare for the slideout, navigation and content are wrapped in divs  -->
                <xsl:copy-of select="$v_navigation"/>

                <!-- add a settings panel  -->
                <xsl:copy-of select="$v_settings"/>

                <div class="c_content" id="content">
                    <!-- the button design is not yet done -->
                    <xsl:copy-of select="$v_buttons"/>
                    <!-- this is the actual content -->
                    <div id="tei_wrapper">
                        <xsl:apply-templates/>
                    </div>
                    <!-- this was moved to the back of the TEI document -->
                    <!--<xsl:copy-of select="$v_notes"/>-->
                    <xsl:copy-of select="$htmlFooter"/>
                </div>
                <!-- <script type="text/javascript" src="{$p_js-slideout}"></script> -->
                <!-- <script src="../js/script.js"></script> -->
                <script src="{$p_js}" type="text/javascript"/>
            </body>
        </html>
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
            <xd:p>Basic copy template, copies all attribute nodes from source XML tree to output document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
    <!-- add notes to the <back> element -->
    <xsl:template match="tei:text">
        <xsl:copy>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="child::node()[not(self::tei:back)]"/>
            <xsl:choose>
                <xsl:when test="child::tei:back">
                    <xsl:apply-templates select="child::tei:back"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="back">
                        <xsl:call-template name="templHtmlAttrLang">
                            <xsl:with-param name="pInput" select="."/>
                        </xsl:call-template>
                        <xsl:copy-of select="$v_notes"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:back">
        <xsl:copy>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
            <xsl:copy-of select="$v_notes"/>
        </xsl:copy>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>A hack because JavaScript was doing weird things with &lt;title>, probably due to confusion with HTML title. There is no
                TEI namespace in the TEI Boilerplate output because JavaScript, or at least JQuery, cannot manipulate the TEI
                elements/attributes if they are in the TEI namespace, so the TEI namespace is stripped from the output. As far as I know,
                &lt;title> elsewhere does not cause any problems, but we may need to extend this to other occurrences of &lt;title> outside
                the Header.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:teiHeader//tei:title">
        <tei-title>
            <xsl:call-template name="addID"/>
            <xsl:apply-templates select="@* | node()"/>
        </tei-title>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Template to omit processing instructions from output.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="processing-instruction()" priority="10"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Template replicates value of @style into an html @style attribute. Stylesheet assumes CSS is used in @style to describe
                renditions, i.e., styles.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@style">
        <xsl:choose>
            <xsl:when test="$p_use-inline-css = true()">
                <xsl:attribute name="style">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@xml:id">
        <!-- @xml:id is copied to @id, which browsers can use for internal links. -->
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Transforms TEI ref element to html a (link) element.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:ref[@target]" priority="99">
        <a href="{@target}">
            <xsl:apply-templates select="@* | node()"/>
        </a>
    </xsl:template>
    <!-- prevent @target from being reproduced here -->
    <xsl:template match="tei:ref/@target"/>
    <xd:doc>
        <xd:desc>
            <xd:p>Transforms TEI ptr element to html a (link) element.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:ptr[@target]" priority="99">
        <a href="{@target}">
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="normalize-space(@target)"/>
        </a>
    </xsl:template>
    <!-- wrap all elements with @corresp in a link: this is a bad idea! Sometimes entire <div>s would become links -->
    <xsl:template match="tei:*[not(self::tei:pb[@ed = 'shamela'])][@corresp]">
        <xsl:apply-templates/>
        <a href="{@corresp}" class="c_corresp c_linked-data"
            title="{concat($p_text-open,' ',@corresp,' ',$p_text-new-window)}" target="_blank"
            lang="en">
            <xsl:copy-of select="document('../assets/icons/external-link.svg')"/>
            <!--<xsl:text>external link</xsl:text>-->
        </a>
        <!--        <a href="{@corresp}" class="c_corresp" title="Open {@corresp} in new window" target="_blank">external link</a>-->
    </xsl:template>
    <!-- need something else for images with captions -->
    <xd:doc>
        <xd:desc>
            <xd:p>Transforms TEI figure element to html img element.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:figure[tei:graphic[@url]]" priority="99">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="addID"/>
            <figure>
                <img alt="{normalize-space(tei:figDesc)}" src="{tei:graphic/@url}"/>
                <xsl:apply-templates select="*[not(self::tei:graphic | self::tei:figDesc)]"/>
            </figure>
        </xsl:copy>
    </xsl:template>
    <!--
	<xd:doc>
		<xd:desc>
			<xd:p>Transforms TEI figure/head to HTML figcaption</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="tei:figure/tei:head">
		<figcaption><xsl:apply-templates/></figcaption>
	</xsl:template>
	-->
    <!--
	<xd:doc>
		<xd:desc>
			<xd:p>Adds some javascript just before end of root tei element. Javascript sets the
				/html/head/title element to an appropriate title selected from the TEI document.
				This could also be achieved through XSLT but is here to demonstrate some simple
				javascript, using JQuery, to manipulate the DOM containing both html and TEI.</xd:p>
		</xd:desc>
	</xd:doc>
	
	
	<xsl:template match="tei:TEI" priority="99">
		<xsl:element name="{local-name()}">
			<xsl:call-template name="addID"/>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	-->
    <xsl:template name="addID">
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
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>The generate-id() function does not guarantee the generated id will not conflict with existing ids in the document. This
                template checks for conflicts and appends a number (hexedecimal 'f') to the id. The template is recursive and continues
                until no conflict is found</xd:p>
        </xd:desc>
        <xd:param name="root">The root, or base, id used to check for conflicts</xd:param>
        <xd:param name="suffix"
            >The suffix added to the root id if a conflict is detected.</xd:param>
    </xd:doc>
    <xsl:template name="generate-unique-id">
        <xsl:param name="root"/>
        <xsl:param name="suffix"/>
        <xsl:variable name="id" select="concat($root, $suffix)"/>
        <xsl:choose>
            <xsl:when test="key('ids', $id)">
                <!--
				<xsl:message>
					<xsl:value-of select="concat('Found duplicate id: ',$id)"/>
				</xsl:message>
				-->
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
    <xsl:variable name="v_html-head">
        <head>
            <meta charset="UTF-8"/>
            <xsl:call-template name="t_metadata-dc-file"/>
            <!-- normalize all styles -->
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.3/normalize.css"/>
            <link href="{$teibpCSS}" id="maincss" rel="stylesheet" type="text/css"/>
            <link href="{$customCSS}" id="customcss" rel="stylesheet" type="text/css"/>
            <link href="{$v_css-color}" id="css-color" rel="stylesheet" type="text/css"/>
            <!-- re-added jquery -->
            <script src="{$jqueryJS}" type="text/javascript"/>
            <!--<script src="{$jqueryBlockUIJS}" type="text/javascript"/>
            <script src="{$teibpJS}" type="text/javascript"/>
            <script type="text/javascript">
				$(document).ready(function() {
					$("html > head > title").text($("TEI > teiHeader > fileDesc > titleStmt > title:first").text());
					$.unblockUI();	
				});
			</script>-->
            <xsl:call-template name="tagUsage2style"/>
            <xsl:call-template name="rendition2style"/>
            <!-- <title>don't leave empty.</title> -->
            <xsl:call-template name="t_metadata-file"/>
            <!-- removed analytics -->
            <!--<xsl:if test="$includeAnalytics = true()">
                <xsl:call-template name="analytics"/>
            </xsl:if>-->
        </head>
    </xsl:variable>
    <xsl:template name="rendition2style">
        <style type="text/css">
            <xsl:apply-templates mode="rendition2style" select="//tei:rendition"/>
        </style>
    </xsl:template>
    <!-- tag usage support -->
    <xsl:template name="tagUsage2style">
        <style id="tagusage-css" type="text/css">
      <xsl:for-each select="//tei:namespace[@name = 'http://www.tei-c.org/ns/1.0']/tei:tagUsage">
        <xsl:value-of select="concat('&#x000a;', @gi, ' { ')"/>
        <xsl:call-template name="tokenize">
          <xsl:with-param name="string" select="@render"/>
        </xsl:call-template>
        <xsl:value-of select="'}&#x000a;'"/>
      </xsl:for-each>
    </style>
    </xsl:template>
    <xsl:template name="tokenize">
        <xsl:param name="string"/>
        <xsl:param name="delimiter" select="' '"/>
        <xsl:choose>
            <xsl:when test="$delimiter and contains($string, $delimiter)">
                <xsl:call-template name="grab-css">
                    <xsl:with-param name="rendition-id"
                        select="substring-after(substring-before($string, $delimiter), '#')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="tokenize">
                    <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                    <xsl:with-param name="delimiter" select="$delimiter"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="grab-css">
                    <xsl:with-param name="rendition-id" select="substring-after($string, '#')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="grab-css">
        <xsl:param name="rendition-id"/>
        <xsl:value-of select="normalize-space(key('ids', $rendition-id)/text())"/>
    </xsl:template>
    <xsl:template match="tei:rendition[@xml:id and @scheme = 'css']" mode="rendition2style">
        <xsl:value-of select="concat('[rendition~=&quot;#', @xml:id, '&quot;]')"/>
        <xsl:if test="@scope">
            <xsl:value-of select="concat(':', @scope)"/>
        </xsl:if>
        <xsl:value-of select="concat('{ ', normalize-space(.), '}&#x000A;')"/>
    </xsl:template>
    <xsl:template match="tei:rendition[not(@xml:id) and @scheme = 'css' and @corresp]"
        mode="rendition2style">
        <xsl:value-of
            select="concat('[rendition~=&quot;#', substring-after(@corresp, '#'), '&quot;]')"/>
        <xsl:if test="@scope">
            <xsl:value-of select="concat(':', @scope)"/>
        </xsl:if>
        <xsl:value-of select="concat('{ ', normalize-space(.), '}&#x000A;')"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Template for adding footer to html document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="htmlFooter">
        <footer id="footer">
            <span>Powered by <a href="{$teibpHome}"
                >TEI Boilerplate</a>. TEI Boilerplate is licensed under a <a
                href="http://creativecommons.org/licenses/by/3.0/"
                >Creative Commons Attribution 3.0 Unported License</a>. <a
                href="http://creativecommons.org/licenses/by/3.0/"><img
                alt="Creative Commons License" src="http://i.creativecommons.org/l/by/3.0/80x15.png"
                style="border-width:0;"/></a></span>
            <span>
                <a href="http://www.tei-c.org/">
                    <img src="http://www.tei-c.org/About/Badges/We-use-TEI.png" alt="We use TEI"
                        style="border-width:0;"/>
                </a>
            </span>
        </footer>
    </xsl:variable>
    <!-- removed the toolbox -->
    <!--<xsl:template name="teibpToolbox">
        <div id="teibpToolbox">
            <h1>Toolbox</h1>
            <label for="pbToggle">Hide page breaks</label>
            <input id="pbToggle" type="checkbox"/>
            <div>
                <h3>Themes:</h3>
                <select id="themeBox" onchange="switchThemes(this);">
                    <option value="{$theme.default}">Default</option>
                    <option value="{$theme.sleepytime}">Sleepy Time</option>
                    <option value="{$theme.terminal}">Terminal</option>
                </select>
            </div>
        </div>
    </xsl:template>-->
    <!-- removed analytics -->
    <!--<xsl:template name="analytics">
        <script type="text/javascript">
		  var _gaq = _gaq || [];
		  //include analytics account below.
		  _gaq.push(['_setAccount', 'UA-XXXXXXXX-X']);
		  _gaq.push(['_trackPageview']);
		
		  (function() {
		    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
		</script>
    </xsl:template>-->

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
                    <xsl:value-of select="ancestor::node()[@xml:lang != ''][1]/@xml:lang"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- provide a toc-style navigation -->
    <xsl:variable name="v_navigation">
        <div class="c_sidenav" id="navigation">
            <xsl:if test="/descendant::tei:body/descendant::tei:head">
                <nav lang="ar">
                    <ul>
                        <xsl:apply-templates mode="mToc" select="/descendant::tei:body/tei:div"/>
                    </ul>
                </nav>
            </xsl:if>
        </div>
    </xsl:variable>

    <!-- provide a settings panel -->
    <xsl:variable name="v_settings">
        <div class="c_sidenav" id="settings">
            <!--<ul lang="en">
            <li>-->
            <div class="c_button c_button-toggle c_off c_toggle-lb">
                <span class="c_icon c_on" lang="en">
                    <xsl:copy-of select="document('../assets/icons/circle.svg')"/>
                </span>
                <span class="c_icon c_off" lang="en">
                    <xsl:copy-of select="document('../assets/icons/check-circle.svg')"/>
                </span>
                <span class="c_label" lang="en">Toggle line breaks</span>
            </div>
            <!--</li>
        </ul>-->
        </div>
    </xsl:variable>

    <!-- create a sub-list and list item (li) for each bill, section, or article -->
    <!-- the type attributes are dependent on the schema tei_jaraid.rng -->
    <!--  <xsl:template match="tei:div[@type='bill'] | tei:div[@type='section'] | tei:div[@type='article']" mode="mToc"> -->
    <xsl:template match="tei:div" mode="mToc">
        <li>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
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
                <xsl:apply-templates select="child::tei:head" mode="mToc"/>
                <xsl:text> (</xsl:text>
                <!-- add author names and pages if available -->
                <xsl:if
                    test="tei:byline/descendant::tei:persName or tei:opener/tei:byline/descendant::tei:persName or descendant::tei:note[@type = 'bibliographic']/tei:bibl">
                    <xsl:choose>
                        <xsl:when test="@xml:lang = 'ar'">
                            <xsl:text>تأليف: </xsl:text>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="tei:byline/descendant::tei:persName">
                            <xsl:for-each select="descendant::tei:byline/descendant::tei:persName">
                                <xsl:apply-templates mode="mToc"/>
                                <xsl:if test="not(last())">
                                    <xsl:text>،</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:author">
                            <xsl:for-each select="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:author">
                                <xsl:apply-templates select="descendant::tei:persName" mode="mToc"/>
                                <xsl:if test="not(last())">
                                    <xsl:text>،</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:title[@level = 'j']">
                            <xsl:for-each select="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:title[@level = 'j']">
                                <xsl:apply-templates select="." mode="mToc"/>
                                <xsl:if test="not(last())">
                                    <xsl:text>،</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>،</xsl:text>
                </xsl:if>
                <!-- add page numbers -->
                <xsl:choose>
                    <xsl:when test="@xml:lang = 'ar'">
                        <xsl:text>ص </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="preceding::tei:pb[@ed = 'print'][1]/@n"/>
                <xsl:if
                    test="preceding::tei:pb[@ed = 'print'][1]/@n != descendant::tei:pb[@ed = 'print'][last()]/@n">
                    <xsl:text>–</xsl:text>
                    <xsl:value-of select="descendant::tei:pb[@ed = 'print'][last()]/@n"/>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </a>
            <xsl:if test="./tei:div">
                <ul>
                    <xsl:apply-templates select="./tei:div" mode="mToc"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    <xsl:template match="tei:persName" mode="mToc">
        <!-- if there is more than forename and surname, strip that out -->
        <xsl:choose>
            <xsl:when test="child::tei:surname and child::tei:forename">
                <xsl:apply-templates mode="mToc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:surname | tei:forename | tei:nameLink" mode="mToc">
        <xsl:text> </xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text> </xsl:text>
    </xsl:template>

    <!-- omit all nodes that are not explicitly dealt with -->
    <xsl:template match="tei:head" mode="mToc">
        <xsl:apply-templates mode="mToc"/>
    </xsl:template>
    <xsl:template match="tei:note | tei:addName | tei:roleName" mode="mToc"/>
    <xsl:template match="tei:lb | tei:cb" mode="mToc">
        <xsl:text> </xsl:text>
    </xsl:template>
    <!-- toggle the display of line breaks -->
    <!-- <xsl:template match="tei:lb">
        <xsl:choose>
            <xsl:when test="$p_display-line-breaks = true()">
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> -->
    <xsl:template match="tei:cb">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- create the anchors in the text -->
    <xsl:template match="tei:div">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="generate-id()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <!-- head: there are some divs without heads. they should nevertheless have a place-holder head -->
            <!--            <xsl:apply-templates select="tei:head"/>-->
            <xsl:if test="not(@type = 'masthead' or @subtype = 'masthead')">
                <tei:head>
                    <xsl:apply-templates select="tei:head/@*"/>
                    <xsl:call-template name="templHtmlAttrLang">
                        <xsl:with-param name="pInput" select="tei:head"/>
                    </xsl:call-template>
                    <!-- content of the head -->
                    <span class="c_content">
                        <xsl:call-template name="templHtmlAttrLang">
                            <xsl:with-param name="pInput" select="tei:head"/>
                        </xsl:call-template>
                        <!-- provide back link to the article -->
                    <xsl:choose>
                        <xsl:when test="@xml:id">
                            <a href="#{@xml:id}" class="c_link-self"
                                title="{concat($p_text-permalink, $p_text-name-element_div)}">
                                <!-- text of the head -->
                                <xsl:for-each select="tei:head">
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:for-each>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- text of the head -->
                                <xsl:for-each select="tei:head">
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates/>
                                </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    </span>
                    <span class="c_metadata">
                        <!-- links to bibliographic metadata -->
                    <xsl:choose>
                        <!-- specify in which cases not to provide links to bibliographic metadata -->
                        <xsl:when test="@type = 'section' and ancestor::tei:div[@type = 'item']"/>
                        <xsl:when test="@type = 'section' and (ancestor::tei:div[@type = 'article'] or ancestor::tei:div[@type = 'bill'])"/>
                        <xsl:when test="(@type = 'article' or @type = 'item') and ancestor::tei:div[@type = 'bill']"/>
                        <xsl:otherwise>
                            <xsl:variable name="vBiblUrl" select="concat('../metadata/', $vFileId, '-', @xml:id)"/>
                            <xsl:call-template name="templBiblDataLinks">
                                <xsl:with-param name="pBiblUrl" select="$vBiblUrl"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- potentially provide links to previous / next article in a series -->
                    <xsl:if test="@next or @prev">
                        <span class="c_links">
                    <xsl:if test="@next">
                        <a href="{@next}" title="next article in this series">
                            <span class="c_icon">
                            <xsl:copy-of select="document('../assets/icons/chevron-right.svg')"/>
                        </span>
                        </a>
                    </xsl:if>
                            <xsl:if test="@prev">
                            <a href="{@prev}" title="previous article in this series">
                            <span class="c_icon">
                                <xsl:copy-of select="document('../assets/icons/chevron-left.svg')"/>
                            </span>
                        </a>
                    </xsl:if>
                        </span>
                    </xsl:if>
                    </span>
                </tei:head>
            </xsl:if>
            <!-- inject some author information -->
            <!-- BUG: this doesn't reliably work if there is more than one preceding <tei:head> -->
            <xsl:if
                test="(tei:byline/preceding-sibling::*[1] != tei:head and tei:byline/descendant::tei:persName) or descendant::tei:note[@type = 'bibliographic']/tei:bibl">
                <span class="c_byline">
                    <xsl:choose>
                        <xsl:when test="@xml:lang = 'ar'">
                            <xsl:attribute name="lang">
                                <xsl:text>ar</xsl:text>
                            </xsl:attribute>
                            <xsl:text>[</xsl:text>
                            <xsl:text>تأليف: </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="lang">
                                <xsl:text>en</xsl:text>
                            </xsl:attribute>
                            <xsl:text>[</xsl:text>
                            <xsl:text>author: </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                     <xsl:choose>
                        <xsl:when test="tei:byline/descendant::tei:persName">
                            <xsl:for-each select="descendant::tei:byline/descendant::tei:persName">
                                <xsl:apply-templates select="."/>
                                <xsl:if test="not(last())">
                                    <xsl:text>،</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:author">
                            <xsl:for-each select="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:author">
                                <xsl:apply-templates select="tei:persName"/>
                                <xsl:if test="not(last())">
                                    <xsl:text>،</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:title[@level = 'j']">
                            <xsl:for-each select="descendant::tei:note[@type = 'bibliographic']/tei:bibl/tei:title[@level = 'j']">
                                <xsl:apply-templates select="."/>
                                <xsl:if test="not(last())">
                                    <xsl:text>،</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:if>
            <!-- body of the div -->
            <xsl:apply-templates select="node()[not(self::tei:head)]"/>
        </xsl:copy>
    </xsl:template>
   


    <!-- omit line breaks in heads: all breaks have been omitted -->
    <!--  <xsl:template match="tei:head/tei:lb | tei:head/tei:cb">
        <xsl:text> </xsl:text>
    </xsl:template>
    -->
    <!-- provide paragraph count independent of css implementation -->
    <xsl:template match="tei:p">
        <xsl:variable name="vCount" select="count(preceding::tei:p[ancestor::tei:body]) + 1"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <span class="c_id" lang="en">
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <a href="#{@xml:id}" class="c_link-self"
                            title="{concat($p_text-permalink, $p_text-name-element_p)}">
                            <span class="c_link-self c_number" lang="en">
                                <xsl:value-of select="$vCount"/>
                            </span>
                        </a>
                        <!--<a href="#{@xml:id}" class="c_link-self" title="{concat($p_text-permalink, $p_text-name-element_p)}">
                            <span class="c_link-self c_number" lang="en"><xsl:value-of select="$vCount"/></span>
                            <!-\- generate a pop-up label -\->
                            <span class="c_link-self c_id c_hidden" lang="en">
                                <!-\-<xsl:value-of select="concat($v_url-file,'#',@xml:id)"/>-\->
                                <xsl:value-of select="concat($p_text-permalink, $p_text-name-element_p,' (#',@xml:id,')')"/>
                            </span>
                        </a>-->
                        <!--<xsl:call-template name="t_link-self">
                            <xsl:with-param name="p_id" select="@xml:id"/>
                            <xsl:with-param name="p_name-element" select="'p'"/>
                            <xsl:with-param name="p_content">
                                <span class="c_link-self c_number" lang="en"><xsl:value-of select="$vCount"/></span>
                            </xsl:with-param>
                        </xsl:call-template>-->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$vCount"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- render foot and end notes-->
    <!-- generate a block of endnotes to be inserted at some point in the result document -->
    <xsl:variable name="v_notes">
        <div id="teibp_notes">
            <head>
                <xsl:call-template name="templHtmlAttrLang">
                    <xsl:with-param name="pInput" select="tei:TEI/tei:text"/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="tei:TEI/tei:text/@xml:lang = 'ar'">
                        <xsl:text>ملاحظات</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Notes</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </head>
            <xsl:apply-templates
                select="/descendant::tei:body/descendant::tei:note[@type = 'footnote' or @type = 'endnote' or not(@place = 'inline')]"
                mode="m_notes"/>
        </div>
    </xsl:variable>
    <xsl:template match="tei:note[@type = 'footnote' or @type = 'endnote' or not(@place = 'inline')]" mode="m_notes">
        <note class="c_note" id="fn-{generate-id()}">
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <a href="#fn-mark-{generate-id()}" class="c_fn-mark" lang="en">
                <xsl:value-of select="count(preceding::tei:note[@type = 'footnote' or @type = 'endnote' or not(@place = 'inline')][ancestor::tei:body]) + 1"/>
            </a>
            <xsl:apply-templates/>
            <!-- add a back link -->
            <a href="#fn-mark-{generate-id()}" class="c_fn-back">
                <!-- an arrow is generated by the CSS -->
                <!-- <xsl:text>&#x21A9;</xsl:text>-->
                <!-- <xsl:text>&#x21AA;</xsl:text>--> </a>
        </note>
    </xsl:template>
    <!-- generate the references to the block of endnotes in the text, including a potential pop-up -->
    <xsl:template match="tei:body//tei:note[@type = 'footnote' or @type = 'endnote' or not(@place = 'inline')]">
        <a href="#fn-{generate-id()}" id="fn-mark-{generate-id()}" class="c_fn cContent c_toggle-popup">
            <!-- one should have the full text of the note hidden by CSS -->
            <span class="c_fn-mark" lang="en">
                <xsl:value-of select="count(preceding::tei:note[@type = 'footnote' or @type = 'endnote' or not(@place = 'inline')][ancestor::tei:body]) + 1"/>
            </span>
            <xsl:call-template name="t_pop-up-note">
                <xsl:with-param name="p_lang">
                    <xsl:call-template name="templHtmlAttrLang">
                        <xsl:with-param name="pInput" select="."/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="p_content">
                    <xsl:choose>
                        <xsl:when test="string-length(.) &gt; 150">
                            <xsl:value-of select="substring(., 1, 150)"/>
                            <xsl:text> [...]</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- to catch all child nodes of a note, one needs apply-templates -->
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </a>
    </xsl:template>

    <!-- this template generates spans with class=c_popup that are intented for a pop-up display of notes additional material -->
    <xsl:template name="t_pop-up-note">
        <xsl:param name="p_content"/>
        <xsl:param name="p_lang"/>
        <span class="c_popup c_hidden" lang="{$p_lang}">
            <xsl:copy-of select="$p_content"/>
        </span>
    </xsl:template>

    <!-- editorial changes to the text: as we are dealing with printed material only, all changes were made by editors of the digital text -->
    <xsl:template match="tei:choice">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <!-- corrections -->
                <xsl:when test="tei:orig and tei:corr[not(@resp = '#org_MS')]">
                    <xsl:choose>
                        <xsl:when test="$p_display-editorial-changes = true()">
                            <xsl:apply-templates select="tei:orig"/>
                            <xsl:apply-templates select="tei:corr"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="tei:orig"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="tei:orig and tei:corr[@resp = '#org_MS']">
                    <xsl:apply-templates select="tei:orig"/>
                </xsl:when>
                <!-- abbreviations -->
                <xsl:when test="tei:abbr and tei:expan">
                    <xsl:apply-templates/>
                </xsl:when>
                <!-- fallback option -->
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!-- editorial changes introduced by the transcribers at shamela.ws should be ignored: -->
    <xsl:template match="tei:add[@resp = '#org_MS'] | tei:supplied[@resp = '#org_MS']"/>
    <xsl:template match="tei:del[@resp = '#org_MS']">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- sometimes the editors at shamela.ws commented on the text. This should also be ignored -->
    <xsl:template match="tei:note[@resp='#org_MS']"/>

    <!-- abbreviations: are dealt with in CSS -->

    <!-- the file's id -->
    <xsl:variable name="vFileId" select="/descendant-or-self::tei:TEI/@xml:id"/>
    <xsl:variable name="vFileIssueNo" select="substring-after($vFileId, '-i_')"/>
    <!-- the file's url -->
    <xsl:variable name="v_url-file">
        <xsl:choose>
            <xsl:when
                test="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'url']">
                <xsl:value-of
                    select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'url']"
                />
            </xsl:when>
            <xsl:otherwise>
                <!-- this needs a better fall-back path -->
                <xsl:value-of
                    select="concat('https://github.com/OpenArabicPE/digital-muqtabas/blob/master/xml/', $vFileId, '.TEIP5.xml')"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- Sidebar buttons -->
    <xsl:variable name="v_buttons">
        <!-- wrap all buttons in a div -->
        <div id="sidebar-buttons" class="c_sidebar">
            <!-- button to toggle settings pane -->
            <div class="c_button c_button-toggle c_off c_button-sidebar" id="toggleSettings">
                <span class="c_icon c_on">
                    <xsl:copy-of select="document('../assets/icons/settings.svg')"/>
                </span>
                <span class="c_icon c_off">
                    <xsl:copy-of select="document('../assets/icons/x.svg')"/>
                </span>
                <span class="c_label" lang="en">Settings</span>
            </div>
            <!-- button to toggle ToC -->
            <div class="c_button c_button-toggle c_off c_button-sidebar" id="toggleNav">
                <span class="c_icon c_on">
                    <xsl:copy-of select="document('../assets/icons/list.svg')"/>
                </span>
                <span class="c_icon c_off">
                    <xsl:copy-of select="document('../assets/icons/x.svg')"/>
                </span>
                <span class="c_label" lang="en">Contents</span>
            </div>
            <!-- link to Github -->
            <div id="xmlSourceLink" class="c_button c_button-sidebar">
                <span class="c_icon">
                    <xsl:copy-of select="document('../assets/icons/download.svg')"/>
                </span>
                <a href="{$v_url-file}" class="c_label" lang="en">
                    <!--<img src="http://www.tei-c.org/About/Logos/TEI-175.jpg" alt="TEI"/>-->
                    <xsl:text>TEI source on GitHub</xsl:text>
                </a>
            </div>
            <!-- links to previous and next issues -->
            <xsl:if test="descendant-or-self::tei:TEI/@next">
                <div id="nextIssue" class="c_button c_button-sidebar">
                    <span class="c_icon">
                        <xsl:copy-of select="document('../assets/icons/chevron-right.svg')"/>
                    </span>
                    <a class="c_label" lang="{$v_lang-interface}">
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="substring-after(descendant-or-self::tei:TEI/@next,'.')='TEIP5.xml'">
                                    <xsl:value-of select="descendant-or-self::tei:TEI/@next"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(descendant-or-self::tei:TEI/@next,'.TEIP5.xml')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:copy-of select="$p_text-nav_next-issue"/>
                    </a>
                </div>
            </xsl:if>
            <xsl:if test="descendant-or-self::tei:TEI/@prev">
                <div id="prevIssue" class="c_button c_button-sidebar">
                    <span class="c_icon">
                        <xsl:copy-of select="document('../assets/icons/chevron-left.svg')"/>
                    </span>
                    <a class="c_label" lang="{$v_lang-interface}">
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="substring-after(descendant-or-self::tei:TEI/@prev,'.')='TEIP5.xml'">
                                    <xsl:value-of select="descendant-or-self::tei:TEI/@prev"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(descendant-or-self::tei:TEI/@prev,'.TEIP5.xml')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:copy-of select="$p_text-nav_previous-issue"/>
                    </a>
                </div>
            </xsl:if>
            <!-- top and bottom -->
            <div id="backToTop" class="c_button c_button-sidebar">
                <span class="c_icon">
                    <xsl:copy-of select="document('../assets/icons/arrow-up.svg')"/>
                </span>
                <a href="#" class="c_label" lang="en">Top of the page</a>
            </div>
            <div id="goToBottom" class="c_button c_button-sidebar">
                <span class="c_icon">
                    <xsl:copy-of select="document('../assets/icons/arrow-down.svg')"/>
                </span>
                <a href="#footer" class="c_label" lang="en">Bottom of the page</a>
            </div>
        </div>
    </xsl:variable>

    <!-- translate tei tables to html tables, which isn't really necessary -->
    <!-- <xsl:template match="tei:table">
        <table>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="tei:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:row[@role='label']/tei:cell">
        <th>
            <xsl:apply-templates/>
        </th>
    </xsl:template>
    <xsl:template match="tei:row[@role='data']/tei:cell">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template> -->

    <!-- provide links to linked data -->
    <xsl:template name="t_link-to-authority-file">
        <xsl:param name="p_content" select="."/>
        <!-- provide a span to dynamically load further content -->
        <span class="c_toggle-popup">
            <!-- wrap everything in a link to external sources -->
            <a class="c_linked-data" lang="en" target="_blank">
                <xsl:choose>
                    <xsl:when test="contains(@ref, 'viaf')">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('https://viaf.org/viaf/', substring-after(@ref, 'viaf:'))"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:text>Link to this entity at VIAF</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(@ref, 'geon')">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('http://www.geonames.org/', substring-after(@ref, 'geon:'))"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:text>Link to this toponym on GeoNames</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                     <xsl:when test="contains(@ref, 'oclc')">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('https://www.worldcat.org/oclc/', substring-after(@ref, 'oclc:'))"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:text>Link to this bibliographic item on WorldCat</xsl:text>
                        </xsl:attribute>
                     </xsl:when>
                </xsl:choose>
                <xsl:copy-of select="$p_content"/>
            </a>
        <!--<xsl:call-template name="t_pop-up-note">
            <xsl:with-param name="p_lang" select="'en'"/>
            <xsl:with-param name="p_content">
                <xsl:text>Test text</xsl:text>
            </xsl:with-param>
        </xsl:call-template>-->
        </span>
    </xsl:template>

    <xsl:template match="tei:persName[ancestor::tei:body]">
        <xsl:variable name="v_icon" select="document('../assets/icons/user.svg')"/>
        <xsl:copy>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:choose>
            <xsl:when test="@ref">
                <xsl:call-template name="t_link-to-authority-file">
                    <xsl:with-param name="p_content">
                        <!-- add icon -->
                        <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <!-- add icon -->
                <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:orgName[ancestor::tei:body]">
        <xsl:variable name="v_icon" select="document('../assets/icons/users.svg')"/>
        <xsl:copy>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:choose>
            <xsl:when test="@ref">
                <xsl:call-template name="t_link-to-authority-file">
                    <xsl:with-param name="p_content">
                        <!-- add icon -->
                        <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <!-- add icon -->
                <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:placeName[ancestor::tei:body]">
        <xsl:variable name="v_icon" select="document('../assets/icons/map-pin.svg')"/>
        <xsl:copy>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:choose>
            <xsl:when test="@ref">
                <xsl:call-template name="t_link-to-authority-file">
                    <xsl:with-param name="p_content">
                        <!-- add icon -->
                        <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <!-- add icon -->
                <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:title[ancestor::tei:body][@level=('m' or 'j')]">
        <xsl:variable name="v_icon" select="document('../assets/icons/book-open.svg')"/>
        <xsl:copy>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:choose>
            <xsl:when test="@ref">
                <xsl:call-template name="t_link-to-authority-file">
                    <xsl:with-param name="p_content">
                        <!-- add icon -->
                        <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <!-- add icon -->
                <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:date[ancestor::tei:body]">
        <xsl:variable name="v_icon" select="document('../assets/icons/calendar.svg')"/>
        <span class="c_toggle-popup">
        <xsl:copy>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
            <!-- add icon -->
        <span class="c_icon-entity"><xsl:copy-of select="$v_icon"/></span>
            <!-- generate a pop-up label -->
            <xsl:if test="@datingMethod != ''">
                <xsl:call-template name="t_pop-up-note">
                    <xsl:with-param name="p_lang" select="'en'"/>
                    <xsl:with-param name="p_content">
                        <span class="c_li">@datingMethod: <xsl:value-of select="@datingMethod"/></span>
                        <xsl:if test="@when-custom">
                            <span class="c_li">@when-custom: <xsl:value-of select="@when-custom"/></span>
                        </xsl:if>
                        <xsl:if test="@when">
                            <span class="c_li">@when: <xsl:value-of select="@when"/></span>
                        </xsl:if>
                        <xsl:if test="@notBefore">
                            <span class="c_li">@notBefore: <xsl:value-of select="@notBefore"/></span>
                        </xsl:if>
                        <xsl:if test="@notAfter">
                            <span class="c_li">@notAfter: <xsl:value-of select="@notAfter"/></span>
                        </xsl:if>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </span>
    </xsl:template>




    <!-- template to provide permalinks to elements -->
    <xsl:template name="t_link-self">
        <!-- passon content of the link -->
        <xsl:param name="p_content"/>
        <!-- the @xml:id to link back to -->
        <xsl:param name="p_id"/>
        <xsl:param name="p_name-element"/>
        <xsl:variable name="v_name-element">
            <xsl:choose>
                <xsl:when test="$p_name-element = 'div'">
                    <xsl:copy-of select="$p_text-name-element_div"/>
                </xsl:when>
                <xsl:when test="$p_name-element = 'p'">
                    <xsl:copy-of select="$p_text-name-element_p"/>
                </xsl:when>
                <xsl:when test="$p_name-element = 'pb'">
                    <xsl:copy-of select="$p_text-name-element_pb"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <a href="#{$p_id}" class="c_link-self c_toggle-popup" title="{concat($p_text-permalink, $v_name-element)}">
            <xsl:copy-of select="$p_content"/>
            <!-- generate a pop-up label -->
            <span class="c_link-self c_id c_hidden" lang="en">
                <!--<xsl:value-of select="concat($v_url-file,'#',@xml:id)"/>-->
                <xsl:value-of select="concat($p_text-permalink, $v_name-element, ' (#', $p_id, ')')"
                />
            </span>
        </a>
    </xsl:template>

    <!-- template to follow XIncludes -->
    <xsl:template match="xi:include">
        <xsl:if test="$p_process-xinclude = true()">
            <xsl:variable name="v_id-element" select="@xpointer"/>
            <!-- provide some source information -->
            <a href="{concat(@href,'#',$v_id-element)}">
            <xsl:call-template name="t_source-reference-for-div">
                <xsl:with-param name="p_input" select="document(@href)//node()[@xml:id = $v_id-element]"/>
            </xsl:call-template>
            </a>
            <!-- add pb preceding the included fragment -->
            <xsl:apply-templates select="document(@href)//node()[@xml:id = $v_id-element]/preceding::tei:pb[@ed = 'print'][1]"/>
            <!-- include the XML fragment -->
            <xsl:apply-templates select="document(@href)//node()[@xml:id = $v_id-element]"/>
        </xsl:if>
    </xsl:template>

    <!-- variable to select CSS for colour schemes -->
    <xsl:variable name="v_css-color">
        <xsl:choose>
            <xsl:when test="$p_color-scheme = 'red'">
                <xsl:value-of select="concat($filePrefix, '/css/teibp_color-red.css')"/>
            </xsl:when>
            <xsl:when test="$p_color-scheme = 'blue'">
                <xsl:value-of select="concat($filePrefix, '/css/teibp_color-blue.css')"/>
            </xsl:when>
            <xsl:when test="$p_color-scheme = 'green'">
                <xsl:value-of select="concat($filePrefix, '/css/teibp_color-green.css')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($filePrefix, '/css/teibp_color-red.css')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


</xsl:stylesheet>
