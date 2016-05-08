<?xml version="1.0" encoding="UTF-8"?>
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
    
    <!-- ATTENTION: this stylesheet is not yet ready for production. It removes too many page breaks -->
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet corrects potentially erroneously located tei:pb elements by moving them from the beginning or end of block-level elements to a location between those elements on the same level of the xml tree.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <xsl:param name="pEditor" select="'pers_TG'"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- Block level elements that start with a tei:pb children: -->
    <xsl:template match="tei:div[child::node()[not(name()='')][1]=tei:pb] | tei:p[child::node()[1]=tei:pb]">
        <xsl:copy-of select="child::tei:pb[1]"/>
        <xsl:copy>
            <xsl:apply-templates select="@*  | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- Block level elements that end with a tei:pb children: -->
     <xsl:template match="tei:p[child::node()[position()=last()]=tei:pb]">
        <xsl:copy>
            <xsl:apply-templates select="@* |node()"/>
        </xsl:copy>
        <xsl:copy-of select="child::tei:pb[position()=last()]"/>
    </xsl:template>
    <!-- output for the relocated pbs must be prevented, which particularly difficult for the trailing pbs -->
    <xsl:template match="tei:pb[parent::tei:div | parent::tei:p]">
        <xsl:variable name="v_self" select="."/>
        <xsl:choose>
            <xsl:when test="parent::tei:div/child::node()[not(name()='')][1]=$v_self"/>
            <xsl:when test="parent::tei:p and position()=1"/>
           <!-- <xsl:when test="parent::tei:div/child::node()[not(name()='')][last()]=$v_self"/>-->
            <xsl:when test="parent::tei:p and position()=last()"/>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*  | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>