<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xpath-default-namespace="http://www.loc.gov/mods/v3" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no" version="1.0"/>
    <!--<xsl:strip-space elements="*"/>-->
    <xsl:preserve-space elements="tei:head tei:bibl"/>

    <xsl:include href="Tei2Mods-functions.xsl"/>
    <xsl:include href="https://rawgit.com/tillgrallert/xslt-calendar-conversion/master/date-function.xsl"/>

    <xsl:template match="tei:bibl">
        <xsl:variable name="v_type">
            <xsl:choose>
                <xsl:when test="descendant::tei:title/@level = 'm'">
                    <xsl:text>m</xsl:text>
                </xsl:when>
                <xsl:when test="descendant::tei:title/@level = 'a'">
                    <xsl:text>a</xsl:text>
                </xsl:when>
                <xsl:when test="descendant::tei:title/@level = 'j'">
                    <xsl:text>j</xsl:text>
                </xsl:when>
                <xsl:when test="descendant::tei:title/@level = 's'">
                    <xsl:text>m</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="t_bibl-mods">
            <xsl:with-param name="p_type" select="$v_type"/>
            <xsl:with-param name="p_lang" select="'ar'"/>
            <xsl:with-param name="p_author" select="descendant::tei:author"/>
            <xsl:with-param name="p_editor" select="descendant::tei:editor"/>
            <xsl:with-param name="p_edition" select="descendant::tei:edition"/>
            <xsl:with-param name="p_title-article" select="descendant::tei:title[@level = 'a']"/>
            <xsl:with-param name="p_title-publication">
                <xsl:choose>
                    <xsl:when test="$v_type = 'm'">
                        <xsl:copy-of select="descendant::tei:title[@level = 'm']"/>
                    </xsl:when>
                    <xsl:when test="$v_type = 'j' or $v_type = 'a'">
                        <xsl:copy-of select="descendant::tei:title[@level = 'j'][not(@type='sub')]"/>
                        <xsl:text>: </xsl:text>
                        <xsl:copy-of select="descendant::tei:title[@level = 'j'][@type='sub']"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="p_publisher" select="descendant::tei:publisher"/>
            <xsl:with-param name="p_place-publication" select="descendant::tei:pubPlace"/>
            <!-- this needs to be changed to reflect the changes in the called template -->
            <xsl:with-param name="p_date-publication">
                <xsl:choose>
                    <xsl:when test="descendant::tei:date[1]/@when != ''">
                        <xsl:value-of select="descendant::tei:date[1]/@when"/>
                    </xsl:when>
                    <xsl:when test="descendant::tei:date[1][@when-custom]/@calendar = '#cal_islamic'">
                        <xsl:analyze-string select="descendant::tei:date[1][@calendar = '#cal_islamic']/@when-custom" regex="(\d{{4}})">
                            <xsl:matching-substring>
                                <xsl:call-template name="funcDateHY2G">
                                    <xsl:with-param name="pYearH" select="regex-group(1)"/>
                                </xsl:call-template>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="p_volume" select="descendant::tei:biblScope[@unit = 'volume']/@n"/>
            <xsl:with-param name="p_issue" select="descendant::tei:biblScope[@unit = 'issue']/@n"/>
            <xsl:with-param name="p_pages" select="descendant::tei:biblScope[@unit = 'page']"/>

            <!-- empty params that are node sets need to be set -->
            <xsl:with-param name="p_idno" select="descendant::tei:idno"/>
            <xsl:with-param name="p_url-licence"/>
            <xsl:with-param name="p_url-self"
                select="concat('https://rawgit.com/tillgrallert/digital-muqtabas/master/xml/', tokenize(base-uri(), '/')[last()], '#', @xml:id)"
            />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="/">
        <xsl:result-document href="../metadata/{$vgFileId}-bibl.MODS.xml">
            <xsl:value-of select="'&lt;?xml-stylesheet type=&quot;text/xsl&quot; href=&quot;../boilerplate/mods-bp.xsl&quot;?&gt;'" disable-output-escaping="yes"/>
            <modsCollection xsi:schemaLocation="http://www.loc.gov/mods/v3 {$vgSchemaLocation}">
                <xsl:apply-templates select=".//tei:body//tei:bibl[ancestor::tei:div/tei:head/text() = 'مخطوطات ومطبوعات']"/>
            </modsCollection>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
