<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:variable name="v_string-transcribe-from_ijmes" select="'btḥḫjdrzsṣḍṭẓʿfqklmnhāūīwy0123456789'"/>
    <xsl:variable name="v_string-transcribe-to_arabic" select="'بتحخجدرزسصضطظعفقكلمنهاويوي٠١٢٣٤٥٦٧٨٩'"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="descendant::tei:group"/>
    </xsl:template>
    
    <!-- volumes are constructed using XInclude -->
    <xsl:template match="tei:group[descendant::xi:include]">
        <xsl:variable name="v_group">
            <xsl:apply-templates select="descendant::xi:include"/>
        </xsl:variable>
        <tei:div type="section">
            <tei:head xml:lang="ar">فهرس</tei:head>
            <tei:list>
                <tei:item>
                    <xsl:for-each-group select="$v_group/descendant::tei:div" group-by="substring(normalize-space(child::tei:head[1]),1,1)">
                        <xsl:sort select="current-grouping-key()"/>
                        <tei:list type="section">
                            <tei:head xml:lang="ar">
                                <xsl:value-of select="current-grouping-key()"/>
                            </tei:head>
                            <xsl:apply-templates select="current-group()/descendant-or-self::tei:div" mode="m_index">
                                <xsl:sort select="child::tei:head[not(@type='sub')][1]"/>
                            </xsl:apply-templates>
                        </tei:list>
                    </xsl:for-each-group>
                </tei:item>
            </tei:list>
        </tei:div>
    </xsl:template>
    
    <xsl:template match="xi:include">
        <xsl:variable name="v_xpointer" select="@xpointer"/>
        <xsl:copy-of select="document(@href)/descendant::node()[@xml:id=$v_xpointer]"/>
    </xsl:template>
    
    <!-- select all divs to be mentioned in an index -->
    <xsl:template match="tei:div[@type = 'section'][not(ancestor::tei:div[@type = 'article'])][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'article'][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = 'bill']" mode="m_index">
        <!-- this bibl should probably be wrapped in  a tei:ref -->
        <tei:item>
            <tei:ref target="{concat( substring-after(base-uri(),'/xml/'),'#',@xml:id)}">
                <tei:bibl>
                    <xsl:attribute name="xml:lang" select="@xml:lang"/>
                    <tei:title level="a">
                        <xsl:attribute name="corresp">
                            <xsl:value-of select="concat( substring-after(base-uri(),'/xml/'),'#',@xml:id)"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="child::tei:head" mode="m_plain-text"/>
                    </tei:title>
                    <xsl:text> </xsl:text>
                    <tei:biblScope unit="page">
                        <xsl:variable name="v_preceding-pb" select="preceding::tei:pb[@ed='print'][1]"/>
                        <xsl:attribute name="n">
                            <xsl:value-of select="$v_preceding-pb/@n"/>
                        </xsl:attribute>
                        <xsl:attribute name="corresp">
                            <xsl:value-of select="concat( substring-after(base-uri(),'/xml/'),'#',$v_preceding-pb/@xml:id)"/>
                        </xsl:attribute>                
                        <tei:num value="{$v_preceding-pb/@n}">
                            <xsl:value-of select="translate($v_preceding-pb/@n,$v_string-transcribe-from_ijmes,$v_string-transcribe-to_arabic)"/>
                        </tei:num>
                    </tei:biblScope>
                </tei:bibl>
            </tei:ref>
        </tei:item>
    </xsl:template>
    
    <!-- plain text output: beware that heavily marked up nodes will have most whitespace omitted -->
    <xsl:template match="text()" mode="m_plain-text">
        <xsl:value-of select="replace(.,'(\w)[\s|\n]+','$1 ')"/>
    </xsl:template>
    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="m_plain-text">
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <!-- prevent notes in div/head from producing output -->
    <xsl:template match="tei:head/tei:note" mode="m_plain-text" priority="100"/>
    
    <!-- suppress output for some divs. As the XPath expression is less specific then others, it will act as a fall-back option -->
    <xsl:template match="tei:div" mode="m_index"/>
    
    <!-- suppress output for notes in heads -->
    <xsl:template match="tei:note" mode="m_index"/>
    
</xsl:stylesheet>