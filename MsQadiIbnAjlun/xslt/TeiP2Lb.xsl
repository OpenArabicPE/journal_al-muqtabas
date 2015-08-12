<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-16" omit-xml-declaration="no"/>
    
    <!-- this stylesheet converts all <p> into <lb/> -->
    
    <!-- copy everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* |node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- convert <p> to <lb/> -->
    <xsl:template match="p">
        <xsl:element name="lb"/>
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>