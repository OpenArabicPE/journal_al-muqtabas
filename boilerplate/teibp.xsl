<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xd eg fn #default" extension-element-prefixes="exsl
    msxsl" version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:eg="http://www.tei-c.org/ns/Examples" xmlns:exsl="http://exslt.org/common"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 17, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> John A. Walsh</xd:p>
            <xd:p>TEI Boilerplate stylesheet: Copies TEI document, with a very few modifications
                into an html shell, which provides access to javascript and other features from the
                html/browser environment.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:include href="xml-to-string.xsl"/>
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>
    <xsl:param name="teibpHome" select="'http://dcl.slis.indiana.edu/teibp/'"/>
    <xsl:param name="inlineCSS" select="true()"/>
    <xsl:param name="includeToolbox" select="false()"/>
    <xsl:param name="includeAnalytics" select="true()"/>
    <xsl:param name="displayPageBreaks" select="true()"/>
    <!-- special characters -->
    <xsl:param name="quot">
        <text>"</text>
    </xsl:param>
    <xsl:param name="apos">
        <text>'</text>
    </xsl:param>
    <!-- interface text -->
    <xsl:param name="pbNote">
        <span class="-teibp-pbNote">
            <xsl:attribute name="lang">
                <xsl:text>en</xsl:text>
            </xsl:attribute>
            <text>page: </text>
        </span>
    </xsl:param>
    <xsl:param name="altTextPbFacs">
        <text>view page image(s)</text>
    </xsl:param>
    <!-- parameters for file paths or URLs -->
    <!-- modify filePrefix to point to files on your own server, 
		or to specify a relatie path, e.g.:
		<xsl:param name="filePrefix" select="'http://dcl.slis.indiana.edu/teibp'"/>
		
	-->
    <xsl:param name="filePrefix" select="'../..'"/>
    <xsl:param name="teibpCSS" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="customCSS" select="concat($filePrefix, '/css/custom.css')"/>
    <xsl:param name="jqueryJS" select="concat($filePrefix, '/js/jquery/jquery.min.js')"/>
    <xsl:param name="jqueryBlockUIJS"
        select="concat($filePrefix, '/js/jquery/plugins/jquery.blockUI.js')"/>
    <xsl:param name="teibpJS" select="concat($filePrefix, '/js/teibp.js')"/>
    <xsl:param name="theme.default" select="concat($filePrefix, '/css/teibp.css')"/>
    <xsl:param name="theme.sleepytime" select="concat($filePrefix, '/css/sleepy.css')"/>
    <xsl:param name="theme.terminal" select="concat($filePrefix, '/css/terminal.css')"/>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Match document root and create and html5 wrapper for the TEI document, which is
                copied, with some modification, into the HTML document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:key match="//*" name="ids" use="@xml:id"/>
    <xsl:template match="/" name="htmlShell" priority="99">
        <html>
            <xsl:call-template name="htmlHead"/>
            <body>
                <xsl:if test="$includeToolbox = true()">
                    <xsl:call-template name="teibpToolbox"/>
                </xsl:if>
                <xsl:copy-of select="$vNav"/>
                <div id="tei_wrapper">
                    <xsl:apply-templates/>
                </div>
                <xsl:copy-of select="$vNotes"/>
                <xsl:copy-of select="$htmlFooter"/>
            </body>
        </html>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Basic copy template, copies all attribute nodes from source XML tree to output
                document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Template for elements, which handles style and adds an @xml:id to every element.
                Existing @xml:id attributes are retained unchanged.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="*" name="teibp-default">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="addID"/>
            <xsl:call-template name="rendition"/>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>A hack because JavaScript was doing weird things with &lt;title>, probably due to
                confusion with HTML title. There is no TEI namespace in the TEI Boilerplate output
                because JavaScript, or at least JQuery, cannot manipulate the TEI
                elements/attributes if they are in the TEI namespace, so the TEI namespace is
                stripped from the output. As far as I know, &lt;title> elsewhere does not cause any
                problems, but we may need to extend this to other occurrences of &lt;title> outside
                the Header.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:teiHeader//tei:title">
        <tei-title>
            <xsl:call-template name="addID"/>
            <xsl:apply-templates select="@* | node()"/>
        </tei-title>
    </xsl:template>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Template to omit processing instructions from output.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="processing-instruction()" priority="10"/>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Template moves value of @rend into an html @style attribute. Stylesheet assumes
                CSS is used in @rend to describe renditions, i.e., styles.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@rend">
        <xsl:choose>
            <xsl:when test="$inlineCSS = true()">
                <xsl:attribute name="style">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="rendition">
        <xsl:if test="@rendition">
            <xsl:attribute name="rendition">
                <xsl:value-of select="@rendition"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@xml:id">
        <!-- @xml:id is copied to @id, which browsers can use
			for internal links.
		-->
        <!--
		<xsl:attribute name="xml:id">
			<xsl:value-of select="."/>
		</xsl:attribute>
		-->
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
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="rendition"/>
            <xsl:apply-templates select="@* | node()"/>
            <!-- <xsl:apply-templates select="node()"/> -->
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
            <xsl:call-template name="rendition"/>
            <xsl:value-of select="normalize-space(@target)"/>
        </a>
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
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
		<xd:desc>
			<xd:p>Transforms TEI figure/head to HTML figcaption</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="tei:figure/tei:head">
		<figcaption><xsl:apply-templates/></figcaption>
	</xsl:template>
	-->
    <!--
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
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
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>The generate-id() function does not guarantee the generated id will not conflict
                with existing ids in the document. This template checks for conflicts and appends a
                number (hexedecimal 'f') to the id. The template is recursive and continues until no
                conflict is found</xd:p>
        </xd:desc>
        <xd:param name="root">The root, or base, id used to check for conflicts</xd:param>
        <xd:param name="suffix">The suffix added to the root id if a conflict is
            detected.</xd:param>
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
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Template for adding /html/head content.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="htmlHead">
        <head>
            <meta charset="UTF-8"/>
            <link href="{$teibpCSS}" id="maincss" rel="stylesheet" type="text/css"/>
            <link href="{$customCSS}" id="customcss" rel="stylesheet" type="text/css"/>
            <script src="{$jqueryJS}" type="text/javascript"/>
            <script src="{$jqueryBlockUIJS}" type="text/javascript"/>
            <script src="{$teibpJS}" type="text/javascript"/>
            <script type="text/javascript">
				$(document).ready(function() {
					$("html > head > title").text($("TEI > teiHeader > fileDesc > titleStmt > title:first").text());
					$.unblockUI();	
				});
			</script>
            <xsl:call-template name="tagUsage2style"/>
            <xsl:call-template name="rendition2style"/>
            <title><!-- don't leave empty. --></title>
            <xsl:if test="$includeAnalytics = true()">
                <xsl:call-template name="analytics"/>
            </xsl:if>
        </head>
    </xsl:template>
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
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Template for adding footer to html document.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="htmlFooter">
        <footer> Powered by <a href="{$teibpHome}">TEI Boilerplate</a>. TEI Boilerplate is licensed
            under a <a href="http://creativecommons.org/licenses/by/3.0/">Creative Commons
                Attribution 3.0 Unported License</a>. <a
                href="http://creativecommons.org/licenses/by/3.0/"><img alt="Creative Commons
                    License" src="http://i.creativecommons.org/l/by/3.0/80x15.png"
                    style="border-width:0;"/></a>
        </footer>
    </xsl:variable>
    <xsl:template name="teibpToolbox">
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
    </xsl:template>
    <xsl:template name="analytics">
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
    </xsl:template>
    <xsl:template name="pb-handler">
        <xsl:param name="n"/>
        <xsl:param name="facs"/>
        <xsl:param name="id"/>
        <!-- dealing with pointers instead of full URLs in @facs -->
        <xsl:variable name="vFacs">
            <xsl:choose>
                <xsl:when test="starts-with($facs, '#')">
                    <xsl:variable name="vFacsID" select="substring-after($facs, '#')"/>
                    <xsl:variable name="vMimeType" select="'image/jpeg'"/>
                    <xsl:value-of
                        select="ancestor::tei:TEI/tei:facsimile/tei:surface[@xml:id = $vFacsID]/tei:graphic[@mimeType = $vMimeType][1]/@url"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$facs"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span class="-teibp-pageNum">
            <!-- <xsl:call-template name="atts"/> -->
            <xsl:copy-of select="$pbNote"/>
            <xsl:value-of select="@n"/>
            <xsl:text> </xsl:text>
        </span>
        <span class="-teibp-pbFacs">
            <a class="gallery-facs" rel="prettyPhoto[gallery1]">
                <xsl:attribute name="onclick">
                    <xsl:value-of
                        select="concat('showFacs(', $apos, $n, $apos, ',', $apos, $vFacs, $apos, ',', $apos, $id, $apos, ')')"
                    />
                </xsl:attribute>
                <img alt="{$altTextPbFacs}" class="-teibp-thumbnail">
                    <xsl:attribute name="src">
                        <xsl:value-of select="$vFacs"/>
                    </xsl:attribute>
                </img>
            </a>
        </span>
    </xsl:template>
    <xsl:template match="tei:pb[@facs]">
        <xsl:param name="pn">
            <xsl:number count="//tei:pb" level="any"/>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="$displayPageBreaks = true()">
                <!-- add @lang="en" to ensure correct ltr rendering -->
                <span class="-teibp-pb" lang="en">
                    <xsl:call-template name="addID"/>
                    <xsl:call-template name="pb-handler">
                        <xsl:with-param name="n" select="@n"/>
                        <xsl:with-param name="facs" select="@facs"/>
                        <xsl:with-param name="id">
                            <xsl:choose>
                                <xsl:when test="@xml:id">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="generate-id()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="eg:egXML">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:call-template name="addID"/>
            <xsl:call-template name="xml-to-string">
                <xsl:with-param name="node-set">
                    <xsl:copy-of select="node()"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template match="eg:egXML//comment()">
        <xsl:comment>
			<xsl:value-of select="."/>
		</xsl:comment>
    </xsl:template>
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template adds support for rtl-languages such as Arabic. It generates a HTML @lang attribute based on the containing element's @xml:lang attribute. It is called in the for every element in the "teipb-default" template</xd:p>
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
    <xsl:variable name="vNav">
        <xsl:if test="/descendant::tei:body/descendant::tei:head">
            <nav>
                <ul>
                    <xsl:apply-templates mode="mToc" select="/descendant::tei:body/tei:div"/>
                </ul>
            </nav>
        </xsl:if>
    </xsl:variable>

    <!-- create a sub-list and list item (li) for each bill, section, or article -->
    <!-- the type attributes are dependent on the schema tei_jaraid.rng -->
    <!--  <xsl:template match="tei:div[@type='bill'] | tei:div[@type='section'] | tei:div[@type='article']" mode="mToc"> -->
    <xsl:template match="tei:div" mode="mToc">
        <li>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="./tei:head" mode="mToc"/>
            <xsl:if test="./tei:div">
                <ul>
                    <xsl:apply-templates select="./tei:div" mode="mToc"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    <!-- create the clickable links to heads in the  toc -->
    <xsl:template match="tei:head" mode="mToc">
        <a href="#{generate-id()}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <!-- omit all nodes that are not explicitly dealt with -->
    <xsl:template match="node()" mode="mToc"/>
    <!-- create the anchors in the text -->
    <xsl:template match="tei:div/tei:head">
        <xsl:element name="{local-name()}">
            <xsl:attribute name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <!-- with a slide-out navigation back links are not necessary -->
            <!--<a href="#toc-{generate-id()}">-->
            <xsl:apply-templates/>
            <!--</a>-->
        </xsl:element>
        <!-- link to the top of the page, content can be provided by css -->
        <a class="cBackToTop cInterface" href="#" title="To the top of this page"> </a>
    </xsl:template>

    <!-- do something with notes -->
    <xsl:variable name="vNotes">
        <div id="teibp_notes">
            <xsl:apply-templates select="/descendant::tei:body/descendant::tei:note" mode="mNotes"/>
        </div>
    </xsl:variable>
    <xsl:template match="tei:note" mode="mNotes">
        <p class="cNote" id="fn-{generate-id()}">
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <a href="#fn-mark-{generate-id()}" class="cFnMark cContent">
                <xsl:value-of select="count(preceding::tei:note[ancestor::tei:body]) + 1"/>
            </a>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:body//tei:note">
        <a href="#fn-{generate-id()}" id="fn-mark-{generate-id()}" class="cFnMark cContent">
            <xsl:value-of select="count(preceding::tei:note[ancestor::tei:body]) + 1"/>
        </a>
    </xsl:template>
</xsl:stylesheet>
