<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" name="text"/>
    <xsl:strip-space elements="*"/>

    <!-- this stylesheet generates a Bibtex file with bibliographic metadata for each <div> in the body of the TEI source file. File names are based on the source's @xml:id and the @xml:id of the <div>. -->
    <!-- to do:
        + add information on edition: i.e. TEI edition
        + add information on collaborators on the digital edition
        comment: this information cannot be added to BibTeX for articles appart from the generic "annote" tag -->
    
    <xsl:include href="Tei2BibTex-functions.xsl"/>
    
  <!-- all parameters and variables are set in Tei2BibTex-functions.xsl -->

    <xsl:template match="/">
            <xsl:apply-templates select="descendant::tei:text/tei:body/descendant::tei:div"/>
    </xsl:template>

    
    <xsl:template
        match="tei:div[@type = 'section'][not(ancestor::tei:div[@type = 'article'])][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'article'][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'bill']">
        <xsl:result-document href="../metadata/{concat($vFileId,'-',@xml:id)}.bib" method="text">
            <xsl:call-template name="tBibHead"/>
            <xsl:call-template name="tDiv2Bib">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>


</xsl:stylesheet>
