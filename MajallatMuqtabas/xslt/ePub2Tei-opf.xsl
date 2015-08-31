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
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet will transform an ePub from shamela.ws to TEI P5</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    <xsl:include href="ePub2Tei%20pages.xsl"/>
    
    <!-- some variables -->
    <xsl:variable name="vDateTodayIso" select="format-date( current-date(),'[Y0001]-[M01]-[D01]')"/>
    
    <!-- the templates -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="opf:package">
        <xsl:result-document href="/BachUni/projekte/XML/EPub2Tei/output/a.TEIP5.xml">
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title><xsl:value-of select="child::opf:metadata/dc:title"/></title>
                            <title type="sub">TEI edition</title>
                            <author><xsl:value-of select="child::opf:metadata/dc:creator[@opf:role='aut']"/></author>
                        </titleStmt>
                        <publicationStmt>
                            <p>Unpulished TEI edition</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>
                                <xsl:copy-of select="child::opf:metadata/child::node()"/>
                            </p>
                        </sourceDesc>
                    </fileDesc>
                    <revisionDesc>
                        <change when="{$vDateTodayIso}">Created this TEI P5 file by automatic conversion from ePub.</change>
                    </revisionDesc>
                </teiHeader>
                <text>
                    <body>
                        <div>
                            <xsl:for-each select="opf:manifest/opf:item[@media-type='application/xhtml+xml'][starts-with(@id,'P')]">
                                <xsl:apply-templates select="doc(concat(substring-before(base-uri(),'content.opf'),@href))/descendant::html:div[@id='book-container']"/>
                            </xsl:for-each>
                        </div>
                    </body>
                </text>
            </TEI>
            
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>