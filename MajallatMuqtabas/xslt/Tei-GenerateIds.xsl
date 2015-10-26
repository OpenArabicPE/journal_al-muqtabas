<xsl:stylesheet 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd html"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet generates a <tei:att>xml:id</tei:att> on the root note in accordance with my URI scheme and changes the file names accordingly.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <xsl:variable name="vFileName" select="substring-before(base-uri(),'.TEIP5')"/>
    <xsl:variable name="vElement" select="'head'"/>
    
    
    <xsl:template match="/">
        <xsl:result-document href="{$vFileName}-IDs.TEIP5.xml">
            <xsl:copy>
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>
    
    <!-- reproduce everything as is -->
    <xsl:template match="@* |node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- number the selected element -->
    <xsl:template match="tei:text//node()">
        <xsl:variable name="vName" select="if(starts-with(name(),'tei:')) then(substring-after(name(),'tei:')) else(name())"/>
        <xsl:copy>
            <xsl:choose>
                <!-- if an xml:id is already present, it should never (!) be changed -->
                <xsl:when test="@xml:id">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@* "/>
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="concat($vName,'_',generate-id())"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="'#pers_TG'"/>
                <xsl:text>Added automated </xsl:text>
                <xsl:element name="att">xml:id</xsl:element>
                <xsl:text>s for every element that is a descendant of </xsl:text>
                <xsl:element name="gi">tei:text</xsl:element>
                <xsl:text>and had no existing </xsl:text>
                <xsl:element name="att">xml:id</xsl:element>
                <xsl:text>following the pattern "name()_generate-id()"</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
