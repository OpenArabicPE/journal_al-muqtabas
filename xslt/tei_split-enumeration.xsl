<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    
    <xsl:param name="p_string">
        <xsl:text> ورشيد رضا ورفيق العظم وعبد الحميد الزهراوي وعبد العزيز جاويش وصالح حمدي حماد ولبيب البتنوني وفريد وجدي ومحمد فريد وعلي يوسف وأحمد تيمور وزكي مغامز وشاكر شقير وسامي قصيري وشحادة شحادة وسعيد الشرتوني ورشيد الشرتوني وفرح انطون وجرجي بني وإبراهيم النجار وأديب اسحق ونعوم لبكي ونعوم مكرزل وأحمد فؤاد وسعيد أبو جمرة ومصطفى الغلاييني وعبد الباسط فتح الله ومحمد بيرم وخير الدين </xsl:text>
    </xsl:param>
    <xsl:param name="p_element" select="'persName'" as="xs:string"></xsl:param>
    
    
    <xsl:template match="/">
        <!--<xsl:analyze-string select="$p_string" regex="(\s+و)(.[^(\s+و)]+)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:element name="persName"><xsl:value-of select="regex-group(2)"/></xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>-->
        <TEI>
        <text>
            <body>
                <ab>
                    <xsl:for-each select="tokenize($p_string,'\sو')">
                        <xsl:text> و</xsl:text>
                        <xsl:element name="{$p_element}"><xsl:value-of select="."/></xsl:element>
                    </xsl:for-each>
                </ab>
            </body>
        </text>
        </TEI>
    </xsl:template>
    
</xsl:stylesheet>