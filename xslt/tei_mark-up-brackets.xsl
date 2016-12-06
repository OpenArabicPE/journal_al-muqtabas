<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="no"/>
    
    <xsl:param name="p_id-editor" select="'pers_TG'"/>
    
    <!-- reproduce everything as is -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- find nodes surrounded by brackets -->
    <xsl:template match="node()[ancestor::tei:text][matches(preceding-sibling::text()[1],'.*\(\s*$')][matches(following-sibling::text()[1],'\s*\).*')]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="@rend">
                    <xsl:attribute name="rend" select="concat(.,' brackets')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rend" select="'brackets'"/>
            </xsl:otherwise>
            </xsl:choose>
           <!-- <xsl:if test="not(@type)">
                <xsl:attribute name="type" select="'auto-markup'"/>
                <xsl:attribute name="resp" select="concat('#',$p_responsible-editor)"/>
            </xsl:if>-->
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- find brackets in text strings -->
    <xsl:template match="text()[ancestor::tei:text]">
        <!-- 1. find strings surrounded by brackets -->
        <xsl:analyze-string select="." regex="\((.*?)\)">
            <xsl:matching-substring>
                <!--<xsl:message>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:message>-->
                <xsl:element name="q">
                    <xsl:attribute name="rend" select="'brackets'"/>
                    <xsl:attribute name="type" select="'auto-markup'"/>
                    <xsl:attribute name="resp" select="concat('#',$p_id-editor)"/>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <!-- 2. find leading or trailing brackets to be deleted -->
                 <!--<xsl:analyze-string select="." regex="(\s*\))?(.+)(\(\s*)?$">
                    <xsl:matching-substring>
                        <xsl:if test="matches(.,'(\s*\))?(.+)(\(\s*)?$')">
                            <xsl:message>
                                <xsl:text>string framed by closing and opening bracket</xsl:text>
                            </xsl:message>
                        </xsl:if>
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string> -->
                <!--<xsl:analyze-string select="." regex="(\s*\))?(.+)(\(\s*)?$|(.*?)(\(\s*)$|(\s*\))(.*?) ">
                    <xsl:matching-substring>
                        <xsl:choose>
                            <xsl:when test="matches(.,'(\s*\))?(.+)(\(\s*)?$')">
                                <xsl:value-of select="regex-group(2)"/>
                            </xsl:when>
                            <xsl:when test="matches(.,'(.*?)(\(\s*)$')">
                                <xsl:value-of select="regex-group(4)"/>
                            </xsl:when>
                            <xsl:when test="matches(.,'(\s*\))(.*?)')">
                                <xsl:value-of select="regex-group(7)"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>-->
                <!-- individual opening and closing brackets work -->
                <xsl:analyze-string select="." regex="(.*?)(\(\s*)|(\s*\))(.*?)">
                    <xsl:matching-substring>
                        <xsl:if test="matches(.,'(.*?)(\(\s*)')">
                           <!-- <xsl:message>
                                    <xsl:text>opening bracket after "</xsl:text><xsl:value-of select="regex-group(1)"/><xsl:text>"</xsl:text>
                                </xsl:message>-->
                                <xsl:value-of select="regex-group(1)"/>
                        </xsl:if>
                        <xsl:if test="matches(.,'(\s*\))(.*?)')">
                           <!-- <xsl:message>
                                <xsl:text>closing bracket before "</xsl:text><xsl:value-of select="regex-group(4)"/><xsl:text>"</xsl:text>
                            </xsl:message>-->
                            <xsl:value-of select="regex-group(4)"/>
                        </xsl:if>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>                
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="$p_id-editor"/>
                <xsl:text>Added automated mark-up of strings wrapped in brackets with </xsl:text>
                <xsl:element name="tag">tei:q rend="brackets"</xsl:element>
                <xsl:text> and </xsl:text>
                <xsl:element name="att">rend</xsl:element>
                <xsl:text> on existing nodes.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>