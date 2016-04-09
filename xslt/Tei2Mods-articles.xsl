<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mods="http://www.loc.gov/mods/v3" xmlns="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xpath-default-namespace="http://www.loc.gov/mods/v3" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no" version="1.0"/>


    <!-- this stylesheet generates a MODS XML file with bibliographic metadata for each <div> in the body of the TEI source file. File names are based on the source's @xml:id and the @xml:id of the <div>. -->

    <xsl:include href="Tei2Mods-functions.xsl"/>

    <!-- all parameters and variables are set in Tei2Mods-functions.xsl -->

    <xsl:template match="/">
                <xsl:apply-templates select="descendant::tei:text/tei:body/descendant::tei:div"/>
    </xsl:template>

    <xsl:template
        match="tei:div[@type = 'section'][not(ancestor::tei:div[@type = 'article'])][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'article'][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'bill']">
        <xsl:result-document href="../metadata/{concat($vgFileId,'-',@xml:id)}.MODS.xml">
            <xsl:element name="modsCollection">
                <xsl:attribute name="xsi:schemaLocation" select="concat('http://www.loc.gov/mods/v3 ',$vgSchemaLocation)"/>
                <xsl:call-template name="templDiv2Mods">
                    <xsl:with-param name="pInput" select="."/>
                </xsl:call-template>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
