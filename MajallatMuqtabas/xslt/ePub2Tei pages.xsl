<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd opf dc html tei"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet will transform individual pages of an ePub, which are represented by single XHTML files, into fragments of TEI P5 XML.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    <!-- only needed if run on its own -->
<!--    <xsl:template match="/">
        <xsl:apply-templates select="descendant::html:div[@id='book-container']"/>
    </xsl:template>-->
    
    <!-- div content per page -->
    <xsl:template match="html:div[@id='book-container']">
        <!-- pb -->
        <xsl:element name="pb">
            <!-- construct an ID from the issue and page numbers provided in human-readible form only -->
            <xsl:attribute name="n">
                <xsl:analyze-string select="following-sibling::html:div[@class='center']" regex="(الجزء\s*:\s*)(\d+).+(الصفحة\s*:\s*)(\d+)|(الصفحة\s*:\s*)(\d+)">
                    <xsl:matching-substring>
                        <xsl:choose>
                            <xsl:when test="'(الجزء\s*:\s*)(\d+).+(الصفحة\s*:\s*)(\d+)'">
                                <xsl:value-of select="concat('n',regex-group(2),'-p',regex-group(4))"/>
                            </xsl:when>
                            <xsl:when test="matches(.,'(الصفحة\s*:\s*)(\d+)')">
                                <xsl:value-of select="concat('p',regex-group(6))"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:attribute>
            <!-- point to the source file -->
            <xsl:attribute name="corresp" select="base-uri()"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- br to lb -->
    <xsl:template match="html:br">
        <xsl:element name="lb"/>
    </xsl:template>
    
    <!-- head lines / titles -->
    <xsl:template match="html:span[@class='title']">
        <xsl:element name="head">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- gaps -->
    <xsl:template match="html:span[@class='red'][text()='...']" priority="2">
        <gap/>
    </xsl:template>
    <xsl:template match="html:span[@class='red']" priority="1">
        <hi style="color:red;">
            <xsl:apply-templates/>
        </hi>
    </xsl:template>
</xsl:stylesheet>