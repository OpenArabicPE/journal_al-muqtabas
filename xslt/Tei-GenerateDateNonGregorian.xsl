<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="no" version="1.0"/>
    <xsl:include href="https://cdn.rawgit.com/tillgrallert/xslt-calendar-conversion/master/date-function.xsl"/>
    
    <xsl:template match="@* |node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:imprint/tei:date[@xml:lang='en'][@when]">
        <xsl:variable name="v_date" select="@when"/>
        <xsl:variable name="v_date-h">
            <xsl:call-template name="funcDateG2H">
                <xsl:with-param name="pDateG" select="$v_date"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="v_date-m">
            <xsl:call-template name="funcDateG2M">
                <xsl:with-param name="pDateG" select="$v_date"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@when"/>
            <xsl:attribute name="calendar" select="'cal_gregorian'"/>
            <xsl:attribute name="datingMethod" select="'cal_gregorian'"/>
        </xsl:copy>
        <xsl:element name="date">
            <xsl:apply-templates select="@when"/>
            <xsl:attribute name="calendar" select="'cal_islamic'"/>
            <xsl:attribute name="datingMethod" select="'cal_islamic'"/>
            <xsl:attribute name="when-custom" select="$v_date-h"/>
        </xsl:element>
        <xsl:element name="date">
            <xsl:apply-templates select="@when"/>
            <xsl:attribute name="calendar" select="'cal_ottomanfiscal'"/>
            <xsl:attribute name="datingMethod" select="'cal_ottomanfiscal'"/>
            <xsl:attribute name="when-custom" select="$v_date-m"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>