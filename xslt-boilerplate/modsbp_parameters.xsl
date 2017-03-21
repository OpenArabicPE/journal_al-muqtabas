<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl tei xd eg fn #default" extension-element-prefixes="exsl msxsl" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:eg="http://www.tei-c.org/ns/Examples" 
    xmlns:exsl="http://exslt.org/common"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- import the main stylesheet -->
    <xsl:include href="modsbp_main.xsl"/>
 
    <!-- select whether you want to use inline CSS for the display -->
    <xsl:param name="inlineCSS" select="true()"/>

  
    <!-- special characters -->
    <xsl:param name="quot">
        <text>"</text>
    </xsl:param>
    <xsl:param name="apos">
        <text>'</text>
    </xsl:param>
    <xsl:param name="p_separator">
        <xsl:text>. </xsl:text>
    </xsl:param>
    <!-- parameters for file paths or URLs -->
    <!-- modify filePrefix to point to boilerplate files on your own server, 
		or to specify a relative path, e.g.:
		<xsl:param name="filePrefix" select="'http://dcl.slis.indiana.edu/teibp'"/>
	-->
    <xsl:param name="p_path-base" select="'..'"/>
    <xsl:param name="p_path-css" select="concat($p_path-base, '/css/modsbp.css')"/>
</xsl:stylesheet>