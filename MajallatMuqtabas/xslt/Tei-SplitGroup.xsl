<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet will split a large TEI file containing a group of TEI files into a set of small files linked together by xPointers.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    <!-- some variables -->
    <xsl:variable name="vDateTodayIso" select="format-date( current-date(),'[Y0001]-[M01]-[D01]')"/>
    <xsl:variable name="vFileNameBase" select="'oclc_4770057679_'"/>
    
    
    <!-- the templates -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- split -->
    <xsl:template match="tei:group">
        <xsl:copy>
            <xsl:apply-templates select="node()" mode="mPoint"/>
            <xsl:apply-templates select="node()" mode="mFile"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:group/tei:text" mode="mPoint">
       <xsl:element name="xi:include">
           <xsl:attribute name="href" select="concat($vFileNameBase,@n,'.TEIP5.xml')"/>
           <xsl:attribute name="xpointer" select="concat($vFileNameBase,@n,'_text')"/>
           <xsl:attribute name="parse" select="'xml'"/>
       </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:group/tei:text" mode="mFile">
        <xsl:result-document href="{concat($vFileNameBase,@n,'.TEIP5.xml')}">
            <TEI>
                <!-- dopy the original header -->
                <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader"/>
                <!-- copy the current <text> node -->
                <xsl:copy>
                    <xsl:attribute name="xml:id" select="concat($vFileNameBase,@n,'_text')"/>
                    <xsl:attribute name="xml:lang" select="'ar'"/>
                    <xsl:attribute name="type" select="'issue'"/>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    
    <!-- create a new master file -->
    <xsl:template match="/">
        <xsl:result-document href="{concat($vFileNameBase,'master.TEIP5.xml')}">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>
    
    <!-- document changes -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <change when="{$vDateTodayIso}" who="pers_TG">Created this file by splitting <ref target="{base-uri()}">the master file</ref> into individual files for each issue that are linked to the master file by means of xPointer.</change>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>