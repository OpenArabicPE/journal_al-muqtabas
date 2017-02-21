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
    
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet generates a <tei:att>xml:id</tei:att> for every node based on its name, position in the document and generate-id(). The position is used to provide leverage against the slight chance that generate-id() generates an ID already present in the document. An <tei:att>xml:id</tei:att> wil thus look like "div_1.d1e1786"</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    <xsl:preserve-space elements="*"/>
    
    <!-- identify the author of the change by means of a @xml:id -->
    <xsl:param name="p_id-editor" select="'pers_TG'"/>
    
    <!--  -->
    <xsl:param name="p_step" select="10"/>
    <xsl:param name="p_start" select="10"/>
    <xsl:param name="p_stop" select="90"/>
    
<!--    <xsl:param name="pRegex">
        <xsl:text>(و?سنة|و?عام) ((و? ??(ثل[إأٱآا]?ث ?م[إأٱآا]?[ؤئءوي][هة]|خمس ?م[إأٱآا]?[ؤئءوي][هة]|[إأٱآا]لف|م[إأٱآا]?[ؤئءوي]?ت([يى]|[إأٱآا])ن|[إأٱآا]ربع ?م[إأٱآا]?[ؤئءوي][هة]|تسع ?م[إأٱآا]?[ؤئءوي][هة]|ست ?م[إأٱآا]?[ؤئءوي][هة]|سبع ?م[إأٱآا]?[ؤئءوي][هة]|ثم[إأٱآا]ن[يى]? ?م[إأٱآا]?[ؤئءوي][هة]|تسعين|ثم[إأٱآا]نين|سن[هة]|[إأٱآا]و ?|ويق[إأٱآا]ل|وقيل|عشرين|سبعين|م[إأٱآا]?[ؤئءوي][هة]|ثل[إأٱآا]ثين|[إأٱآا]ربعين|ستين|خمسين|عشر[هة]?|ثم[إأٱآا]ن|ثم[إأٱآا]نية?|تسعة?|[إأٱآا]ثنت?ين?|[إأٱآا]ثنت?[إأٱآا]ن?|[إأٱآا]ربعة?|سبعة?|خمسة?|[إأٱآا]حد[يى]|ستة?|ثل[إأٱآا]ثة?)[إأٱآا]? )+)</xsl:text>
    </xsl:param>-->
    
    
    
    <xsl:variable name="v_numbers">
        <!--<num value="1"><xsl:value-of select="'[إأٱآا]حد[يى]?|١'"/></num>
        <num value="2"><xsl:value-of select="'[إأٱآا]ثنت?[إأٱآا]ن?|[إأٱآا]ثنت?ين?|٢'"/></num>
        <!-\-<num value="3"><xsl:value-of select="'ثل[إأٱآا]ثة?'"/></num>
        <num value="4"><xsl:value-of select="'[إأٱآا]ربعة?'"/></num>
        <num value="5"><xsl:value-of select="'خمسة?'"/></num>
        <num value="6"><xsl:value-of select="'ستة?'"/></num>
        <num value="7"><xsl:value-of select="'سبعة?'"/></num>
        <num value="8"><xsl:value-of select="'ثم[إأٱآا]ن|ثم[إأٱآا]نية?'"/></num>
        <num value="9"><xsl:value-of select="'تسعة?'"/></num>-\->
        <num value="3"><xsl:value-of select="'ثل[إأٱآا]ث[هة]?|٣'"/></num>
        <num value="4"><xsl:value-of select="'[إأٱآا]ربع[هة]?|٤'"/></num>
        <num value="5"><xsl:value-of select="'خمس[هة]?|٥'"/></num>
        <num value="6"><xsl:value-of select="'ست[هة]?|٦'"/></num>
        <num value="7"><xsl:value-of select="'سبع[هة]?|٧'"/></num>
        <num value="8"><xsl:value-of select="'ثم[إأٱآا]ني[هة]?|٨'"/></num>
        <num value="9"><xsl:value-of select="'تسع[هة]?|٩'"/></num>
        <num value="10"><xsl:value-of select="'عشر[هة]?|١٠'"/></num>-->
        <!--        <num value="10"><xsl:value-of select="'عشرة'"/></num>-->
        <num value="1"><xsl:value-of select="'[إأٱآا]حد[يى]?|١'"/></num>
        <num value="2"><xsl:value-of select="'[إأٱآا]ثنت?[إأٱآا]ن?|[إأٱآا]ثنت?ين?|٢'"/></num>
        <xsl:variable name="v_3" select="'ثل[إأٱآا]?ث[هة]?'"/>
        <xsl:variable name="v_4" select="'[إأٱآا]ربع[هة]?'"/>
        <xsl:variable name="v_5" select="'خمس[هة]?'"/>
        <xsl:variable name="v_6" select="'ست[هة]?'"/>
        <xsl:variable name="v_7" select="'سبع[هة]?'"/>
        <xsl:variable name="v_8" select="'ثم[إأٱآا]ني[هة]?'"/>
        <xsl:variable name="v_9" select="'تسع[هة]?'"/>
        <xsl:variable name="v_10" select="'عشر[هة]?'"/>
        <num value="3"><xsl:value-of select="concat($v_3,'|٣')"/></num>
        <num value="4"><xsl:value-of select="concat($v_4,'|٤')"/></num>
        <num value="5"><xsl:value-of select="concat($v_5,'|٥')"/></num>
        <num value="6"><xsl:value-of select="concat($v_6,'|٦')"/></num>
        <num value="7"><xsl:value-of select="concat($v_7,'|٧')"/></num>
        <num value="8"><xsl:value-of select="concat($v_8,'|٨')"/></num>
        <num value="9"><xsl:value-of select="concat($v_9,'|٩')"/></num>
        <num value="10"><xsl:value-of select="concat($v_10,'|١٠')"/></num>
        <num value="20"><xsl:value-of select="'عشر[يو]ن|٢٠'"/></num>
        <num value="30"><xsl:value-of select="'ثل[إأٱآا]ث[يو]ن|٣٠'"/></num>
        <num value="40"><xsl:value-of select="'[إأٱآا]ربع[يو]ن|٤٠'"/></num>
        <num value="50"><xsl:value-of select="'خمس[يو]ن|٥٠'"/></num>
        <num value="60"><xsl:value-of select="'ست[يو]ن|٦٠'"/></num>
        <num value="70"><xsl:value-of select="'سبع[يو]ن|٧٠'"/></num>
        <num value="80"><xsl:value-of select="'ثم[إأٱآا]ن[يو]ن|٨٠'"/></num>
        <num value="90"><xsl:value-of select="'تسع[يو]ن|٩٠'"/></num>
        <xsl:variable name="v_100" select="'م[إأٱآا]?[ؤئءوي][هة]'"/>
        <num value="100"><xsl:value-of select="concat($v_100,'|١٠٠')"/></num>
        <num value="200"><xsl:value-of select="'م[إأٱآا]?[ؤئءوي]?ت([يى]|[إأٱآا])ن|٢٠٠'"/></num>
        <!--<num value="300"><xsl:value-of select="concat('٣٠٠|ثل[إأٱآا]ث ?',$v_100)"/></num>
        <num value="400"><xsl:value-of select="concat('٤٠٠|[إأٱآا]ربع ?',$v_100)"/></num>
        <num value="500"><xsl:value-of select="concat('٥٠٠|خمس ?',$v_100)"/></num>
        <num value="600"><xsl:value-of select="concat('٦٠٠|ست ?',$v_100)"/></num>
        <num value="700"><xsl:value-of select="concat('٧٠٠|سبع ?',$v_100)"/></num>
        <num value="800"><xsl:value-of select="concat('٨٠٠|ثم[إأٱآا]ن[يى]? ?',$v_100)"/></num>
        <num value="900"><xsl:value-of select="concat('٩٠٠|تسع ?',$v_100)"/></num>-->
        <num value="300"><xsl:value-of select="concat($v_3,' ?',$v_100,'|٣٠٠')"/></num>
        <num value="400"><xsl:value-of select="concat($v_4,' ?',$v_100,'|٤٠٠')"/></num>
        <num value="500"><xsl:value-of select="concat($v_5,' ?',$v_100,'|٥٠٠')"/></num>
        <num value="600"><xsl:value-of select="concat($v_6,' ?',$v_100,'|٦٠٠')"/></num>
        <num value="700"><xsl:value-of select="concat($v_7,' ?',$v_100,'|٧٠٠')"/></num>
        <num value="800"><xsl:value-of select="concat($v_8,' ?',$v_100,'|٨٠٠')"/></num>
        <num value="900"><xsl:value-of select="concat($v_9,' ?',$v_100,'|٩٠٠')"/></num>
        <xsl:variable name="v_1000" select="'[إأٱآا]ل[إأٱآا]?ف'"/>
        <num value="1000"><xsl:value-of select="concat($v_1000,'|١٠٠٠')"/></num>
        <num value="2000"><xsl:value-of select="'[إأٱآا]لف([يى]|[إأٱآا])ن|٢٠٠٠'"/></num>
        <!-- <num value="3000"><xsl:value-of select="concat('٣٠٠٠|ثل[إأٱآا]ث ?',$v_1000)"/></num>
        <num value="4000"><xsl:value-of select="concat('٤٠٠٠|[إأٱآا]ربع ?',$v_1000)"/></num>
        <num value="5000"><xsl:value-of select="concat('٥٠٠٠|خمس ?',$v_1000)"/></num>
        <num value="6000"><xsl:value-of select="concat('٦٠٠٠|ست ?',$v_1000)"/></num>
        <num value="7000"><xsl:value-of select="concat('٧٠٠٠|سبع ?',$v_1000)"/></num>
        <num value="8000"><xsl:value-of select="concat('٨٠٠٠|ثم[إأٱآا]ن[يى]? ?',$v_1000)"/></num>
        <num value="9000"><xsl:value-of select="concat('٩٠٠٠|تسع ?',$v_1000)"/></num>-->
        <num value="3000"><xsl:value-of select="concat($v_3,' ?',$v_1000,'|٣٠٠٠')"/></num>
        <num value="4000"><xsl:value-of select="concat($v_4,' ?',$v_1000,'|٤٠٠٠')"/></num>
        <num value="5000"><xsl:value-of select="concat($v_5,' ?',$v_1000,'|٥٠٠٠')"/></num>
        <num value="6000"><xsl:value-of select="concat($v_6,' ?',$v_1000,'|٦٠٠٠')"/></num>
        <num value="7000"><xsl:value-of select="concat($v_7,' ?',$v_1000,'|٧٠٠٠')"/></num>
        <num value="8000"><xsl:value-of select="concat($v_8,' ?',$v_1000,'|٨٠٠٠')"/></num>
        <num value="9000"><xsl:value-of select="concat($v_9,' ?',$v_1000,'|٩٠٠٠')"/></num>
    </xsl:variable>
    
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:text">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()" mode="m_nlp"/>
            </xsl:copy>
    </xsl:template>
    <xsl:template match="@* | node()" mode="m_nlp">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="m_nlp"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()[not(parent::tei:num)]" mode="m_nlp">
        <xsl:variable name="vText-num_d4">
            <xsl:call-template name="t_nlp-numbers">
                <xsl:with-param name="p_input" select="."/>
                <xsl:with-param name="p_step" select="1000"/>
                <xsl:with-param name="p_start" select="1000"/>
                <xsl:with-param name="p_stop" select="9000"/>
                <xsl:with-param name="p_type" select="'d4'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="vText-num_d3">
            <xsl:for-each select="$vText-num_d4/node()">
                <xsl:choose>
                    <xsl:when test="self::text()[not(parent::tei:num)]">
                        <xsl:call-template name="t_nlp-numbers">
                            <xsl:with-param name="p_input" select="."/>
                            <xsl:with-param name="p_step" select="100"/>
                            <xsl:with-param name="p_start" select="100"/>
                            <xsl:with-param name="p_stop" select="900"/>
                            <xsl:with-param name="p_type" select="'d3'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
       <!-- <xsl:variable name="vText-num_d3">
            <xsl:call-template name="t">
                <xsl:with-param name="p_input" select="."/>
                <xsl:with-param name="p_step" select="100"/>
                <xsl:with-param name="p_start" select="100"/>
                <xsl:with-param name="p_stop" select="900"/>
                <xsl:with-param name="p_type" select="'d3'"/>
            </xsl:call-template>
        </xsl:variable>-->
        <xsl:variable name="vText-num_d2">
            <xsl:for-each select="$vText-num_d3/node()">
                <xsl:choose>
                    <xsl:when test="self::text()[not(parent::tei:num)]">
                        <xsl:call-template name="t_nlp-numbers">
                            <xsl:with-param name="p_input" select="."/>
                            <xsl:with-param name="p_step" select="10"/>
                            <xsl:with-param name="p_start" select="10"/>
                            <xsl:with-param name="p_stop" select="90"/>
                            <xsl:with-param name="p_type" select="'d2'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="vText-num_d1">
            <xsl:for-each select="$vText-num_d2/node()">
                <xsl:choose>
                    <xsl:when test="self::text()[not(parent::tei:num)]">
                        <xsl:call-template name="t_nlp-numbers">
                            <xsl:with-param name="p_input" select="."/>
                            <xsl:with-param name="p_step" select="1"/>
                            <xsl:with-param name="p_start" select="1"/>
                            <xsl:with-param name="p_stop" select="9"/>
                            <xsl:with-param name="p_type" select="'d1'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$vText-num_d1"/>
    </xsl:template>
    
    <!-- the template counts DOWN! -->
    <xsl:template name="t_nlp-numbers">
        <xsl:param name="p_input"/>
        <xsl:param name="p_start" select="1"/>
        <xsl:param name="p_stop" select="10"/>
        <xsl:param name="p_step" select="1"/>
        <xsl:param name="p_type" select="'d1'"/>
        <!-- problem: as the regex matches  -->
        <xsl:analyze-string select="." regex="(\sو?ا?ل?)({$v_numbers/tei:num[@value=$p_stop]})([\s\.,:\?])">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:element name="num">
                    <xsl:attribute name="xml:lang" select="'ar'"/>
                    <xsl:attribute name="type" select="'auto-markup'"/>
                    <xsl:attribute name="subtype" select="$p_type"/>
                    <xsl:attribute name="resp" select="concat('#',$p_id-editor)"/>
                    <xsl:attribute name="value" select="$p_stop"/>
                    <xsl:value-of select="regex-group(2)"/>
                </xsl:element>
                <xsl:value-of select="regex-group(3)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:choose>
                    <!--<xsl:when test="$p_start &lt; $p_stop">
                        <xsl:call-template name="t_nlp-numbers">
                            <xsl:with-param name="p_input" select="."/>
                            <xsl:with-param name="p_start" select="$p_start + $p_step"/>
                            <xsl:with-param name="p_stop" select="$p_stop"/>
                            <xsl:with-param name="p_step" select="$p_step"/>
                            <xsl:with-param name="p_type" select="$p_type"/>
                        </xsl:call-template>
                    </xsl:when>-->
                    <xsl:when test="$p_stop &gt; $p_start">
                        <xsl:call-template name="t_nlp-numbers">
                            <xsl:with-param name="p_input" select="."/>
                            <xsl:with-param name="p_start" select="$p_start"/>
                            <xsl:with-param name="p_stop" select="$p_stop - $p_step"/>
                            <xsl:with-param name="p_step" select="$p_step"/>
                            <xsl:with-param name="p_type" select="$p_type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:element name="change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="$p_id-editor"/>
                <xsl:text>Added automated mark-up of Arabic numerals from </xsl:text>
                <xsl:value-of select="$p_start"/><xsl:text> to </xsl:text> <xsl:value-of select="$p_stop"/><xsl:text> in increments of </xsl:text><xsl:value-of select="$p_step"/><xsl:text> as </xsl:text>
                <xsl:element name="gi">tei:num</xsl:element>
                <xsl:text>and </xsl:text>
                <xsl:element name="att">xml:value</xsl:element>
                <xsl:text>recording the normalised value.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>