<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xd:doc scope="stylesheet">
    <xd:desc>
        <xd:p>This stylesheet will paragraphs with a single gap node in the center into line groups.</xd:p>
    </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    <!-- copy everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- wrap single lines in <lg> -->
    <xsl:template match="tei:lg[@type='bayt'][not(preceding-sibling::node()[not(text())][1]=tei:lg[@type='bayt'])][not(following-sibling::node()[not(text())][1]=tei:lg[@type='bayt'])]">
        <lg>
            <l type="bayt">
                <xsl:apply-templates select="@*[not(name()='xml:id')] | node()"/>
            </l>
        </lg>
    </xsl:template>
    <!-- find the first line in a line group -->
    <xsl:template match="tei:lg[@type='bayt'][not(preceding-sibling::node()[not(text())][1]=tei:lg[@type='bayt'])][following-sibling::node()[not(text())][1]=tei:lg[@type='bayt']]">
        <lg>
            <l type="bayt">
                <xsl:apply-templates select="@*[not(name()='xml:id')] | node()"/>
            </l>
            <xsl:for-each select="following-sibling::tei:lg[@type='bayt'][preceding-sibling::node()[not(text())][1]=tei:lg[@type='bayt']]">
                <l type="bayt">
                    <xsl:apply-templates select="@*[not(name()='xml:id')] | node()"/>
                </l>
            </xsl:for-each>
        </lg>
    </xsl:template>
    <xsl:template match="tei:lg[@type='bayt'][preceding-sibling::node()[not(text())][1]=tei:lg[@type='bayt']][not(following-sibling::node()[not(text())][1]=tei:lg[@type='bayt'])]"/>
    
    <!-- convert <l> to <seg> -->
    <xsl:template match="tei:lg[@type='bayt']/tei:l">
        <seg>
            <xsl:apply-templates select="@*[not(name()='xml:id')] | node()"/>
        </seg>
    </xsl:template>
    
    
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{format-date( current-date(),'[Y0001]-[M01]-[D01]')}" who="#pers_TG">Converted the mark-up of lines of <foreign xml:lang="ar-Latn-x-ijmes">qaṣīda</foreign>s from <tag>lg type="bayt"</tag>s divided into two <gi>l</gi> to <tag>l type="bayt"</tag>, each consisting of two <gi>seg</gi>.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>