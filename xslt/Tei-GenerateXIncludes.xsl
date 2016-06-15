<xsl:stylesheet 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd html"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet generates <tei:att>xi:includes</tei:att> for <gi>tei:endodingDesc</gi> and <gi>tei:profileDesc</gi></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="no" method="xml" name="xml" omit-xml-declaration="no" version="1.0" />
    
    <!-- identify the author of the change by means of a @xml:id -->
    <xsl:param name="pAuthorXmlId" select="'pers_TG'"/>

    
    <!-- reproduce everything as is -->
    <xsl:template match="@* |node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- number the selected element -->
    <xsl:template match="tei:encodingDesc">
        <xsl:element name="xi:include">
            <xsl:attribute name="href" select="'oclc_4770057679-master_teiHeader.TEIP5.xml'"/>
            <xsl:attribute name="xpointer" select="'encodingDesc'"/>
            <xsl:attribute name="parse" select="'xml'"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:profileDesc">
        <xsl:element name="xi:include">
            <xsl:attribute name="href" select="'oclc_4770057679-master_teiHeader.TEIP5.xml'"/>
            <xsl:attribute name="xpointer" select="'profileDesc'"/>
            <xsl:attribute name="parse" select="'xml'"/>
        </xsl:element>
    </xsl:template>
    
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="$pAuthorXmlId"/>
                <xsl:text>Replaced </xsl:text>
                <xsl:element name="gi">encodingDesc</xsl:element><xsl:text> and </xsl:text><xsl:element name="gi">profileDesc</xsl:element>
                <xsl:text>with XPointers pointing to a master file.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
