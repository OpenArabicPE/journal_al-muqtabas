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
            <xd:p>This stylesheet assign @type="article" to all divs without a type attribute</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- set language -->
    <xsl:variable name="vLang" select="'ar'"/>
    <!-- retrieve bibliographic information from the teiHeader -->
    <xsl:variable name="vBiblSource" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
    <!-- move the first page break before the <front> -->
    <xsl:template match="tei:text">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:copy-of select="following::tei:pb[@ed='print'][1]"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:pb[@ed='print']">
        <!-- supress the first tei:pb in tei:text -->
            <xsl:if test="preceding::tei:pb[@ed='print']">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                </xsl:copy>
            </xsl:if> 
    </xsl:template>

    <!-- generate a new <front> -->
    <xsl:template match="tei:front">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <div type="masthead">
                <bibl>
                    <!--<xsl:copy-of select="$vBiblSource//tei:biblScope[@unit='issue']"/>-->
                    <xsl:element name="tei:biblScope">
                        <xsl:attribute name="unit" select="'issue'"/>
                        <xsl:attribute name="n" select="$vBiblSource//tei:biblScope[@unit='issue']/@n"/>
                        <xsl:choose>
                            <xsl:when test="$vLang = 'ar'">
                                <xsl:text>الجزء </xsl:text>
                            </xsl:when>
                            <xsl:when test="$vLang = 'en'">
                                <xsl:text>issue </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>issue </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="$vBiblSource//tei:biblScope[@unit='issue']/@n"/>
                    </xsl:element>
<!--                    <xsl:copy-of select="$vBiblSource//tei:biblScope[@unit='volume']"/>-->
                    <xsl:element name="tei:biblScope">
                        <xsl:attribute name="unit" select="'volume'"/>
                        <xsl:attribute name="n" select="$vBiblSource//tei:biblScope[@unit='volume']/@n"/>
                        <xsl:choose>
                            <xsl:when test="$vLang = 'ar'">
                                <xsl:text>المجلد </xsl:text>
                            </xsl:when>
                            <xsl:when test="$vLang = 'en'">
                                <xsl:text>volume </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>volume </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="$vBiblSource//tei:biblScope[@unit='volume']/@n"/>
                    </xsl:element>
                    <lb/>
                    <xsl:copy-of select="$vBiblSource//tei:title[@level='j'][@xml:lang='ar'][not(@type='sub')]"/>
                </bibl>
            </div>
        </xsl:copy>
    </xsl:template>
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="'#pers_TG'"/>
                <xsl:text>Generated a new </xsl:text><tei:gi>front</tei:gi><xsl:text> based on the </xsl:text><tei:gi>sourceDesc</tei:gi><xsl:text> that matches the information found in the masthead of the actual issues.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>