xquery version "3.0";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";

declare option exist:serialize 'method=xhtml media-type=text/html indent=yes';

(: the term(s) to be searched for :)
let $v_collection :=request:get-parameter('col','muqtabas')

(: Call data sources :)
let $v_library := collection(concat('/db/DAPE/xml_',$v_collection))
let $v_file := doc (concat('/db/DAPE/xml_',$v_collection,'/oclc_4770057679-i_63.TEIP5.xml'))

(: the term(s) to be searched for :)
let $v_query :=request:get-parameter('search','دمشق')
let $v_section := 'مخطوطات ومطبوعات'

(: Query the data sources :)
let $vBibls := for $vHit in
    $v_library/descendant::tei:div[@type='section'][child::tei:head/text()=$v_section]/descendant::tei:bibl[ft:query(.,$v_query)]
    return $vHit

(: Call stylesheets to transform the results :)
let $xslTei2Html-bibl := doc('/db/DAPE/xslt/tei2html-bibl.xsl')
let $xslTei2Html-bibl2 := doc('/db/DAPE/xslt/test.xsl')
let $xslTei2BibTeX-bibl := doc('/db/DAPE/xslt/tei2bibtex-bibl.xsl')

(: return results :)
return 
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Titles mentioned in Majallat al-Muqtabas</title>
       <link rel="stylesheet" href="../css/basic.css" type="text/css"></link>
       <link rel="stylesheet" href="../css/mods-bp.css" type="text/css"></link>
    </head>
    <body>
        <div lang="en">
        <h2>Statistics</h2>
        <form action="reviews.xql" method="get">
            <p>Search: 
            <input type="text" name="search" size="80" value="{$v_query}"/> <input class="gobox" type="submit" value="GO" /></p>
            </form>
        <p>number of works: {count($vBibls/descendant-or-self::tei:bibl)}</p>
        </div>
        <div>
        <ol lang="ar">{
        for $vBibl in $vBibls/descendant-or-self::tei:bibl
            let $vTitle := $vBibl/tei:title[not(@type='sub')][1]
            let $vAuthor := $vBibl/tei:author
            let $vPublisher := $vBibl/tei:publisher
            let $vPlace := $vBibl/tei:pubPlace
            
            order by $vTitle
            
        return 
            <li>
                <div>
                    {transform:transform($vBibl, $xslTei2Html-bibl,())}
                    <!-- <p>{$vBibl//text()}</p> --> 
                    <!-- <p lang="en">{transform:transform($vBibl, $xslTei2BibTeX-bibl,())}</p> -->
                </div>
            </li>
        }</ol>
        </div>
    </body>
</html>