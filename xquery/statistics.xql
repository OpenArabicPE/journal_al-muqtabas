xquery version "3.0";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";

declare option exist:serialize 'method=xhtml media-type=text/html indent=yes';

(: the term(s) to be searched for :)
let $v_query :=request:get-parameter('col','Muqtabas')

(: Call data sources :)
let $v_library := collection(concat('/db/',$v_query,'/xml/'))
let $v_file-example := doc ('/db/Muqtabas/xml/oclc_4770057679-i_60.TEIP5.xml')

(: divs :)
let $v_divs := $v_library/descendant::tei:text/tei:body/descendant::tei:div
let $v_heads-section := $v_divs[@type='section'][not(ancestor::tei:div[@type='article'])][not(ancestor::tei:div[@type='bill'])]/tei:head/text()
let $v_authors-article := $v_divs[@type='article'][not(ancestor::tei:div[@type='section'])][not(ancestor::tei:div[@type='bill'])]/tei:byline/tei:persName


(: return results :)
return 
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Statistics: {$v_query}</title>
       <link rel="stylesheet" href="../css/basic.css" type="text/css"></link>
    </head>
    <body>
        <div>
            <h2>general statistics</h2>
            <p>date, volume #, issue #, sections, articles in sections, articles in sections with author, independent articles, independent articles with author, articles (total), articles with author (total)</p>
            {
            (: generate basic information on each issue :)
            for $v_TEI in $v_library/descendant::tei:TEI
                (: variables at the issue level :)
                let $v_biblSource := $v_TEI/tei:teiHeader//tei:sourceDesc/tei:biblStruct
                let $v_date := $v_biblSource/tei:monogr//tei:date[1]/@when
                let $v_volume := number($v_biblSource/tei:monogr/tei:biblScope[@unit='volume']/@n)
                let $v_issue := number($v_biblSource/tei:monogr/tei:biblScope[@unit='issue']/@n)
                (: variables at the div level :)
                let $v_div := $v_TEI/tei:text/tei:body/descendant::tei:div
                let $v_div-section := $v_div[@type='section'][not(ancestor::tei:div[@type='article'])][not(ancestor::tei:div[@type='bill'])]
                let $v_div-section-article := $v_div[@type='article'][ancestor::tei:div[@type='section']][not(ancestor::tei:div[@type='bill'])]
                let $v_div-article := $v_div[@type='article'][not(ancestor::tei:div[@type='section'])][not(ancestor::tei:div[@type='bill'])]
                let $v_div-article-total := $v_div[@type='article'][not(ancestor::tei:div[@type='bill'])]
                (: let $v_div-author := $v_div/tei:byline :)
                order by $v_volume and $v_issue
                return 
                    <p>{string($v_date)}, {$v_volume}, {$v_issue}, {count($v_div-section)}, {count($v_div-section-article)}, {count($v_div-section-article[child::tei:byline])}, {count($v_div-article)}, {count($v_div-article[child::tei:byline])}, {count($v_div-article-total)}, {count($v_div-article-total[child::tei:byline])}</p>
        }
        </div>
        <div>
            <h2>section names</h2>
            <p>name of section, #</p>
            {
            for $v_head in distinct-values($v_heads-section)
                let $v_count := count($v_heads-section[.=$v_head])
                order by $v_count, $v_head
                return
                <p>{$v_head}, {$v_count}</p>
            }
        </div>
        <div>
            <h2>author names</h2>
            <p>author, # of articles</p>
            {
            for $v_author in distinct-values($v_authors-article)
                let $v_count := count($v_authors-article[.=$v_author])
                order by $v_count, $v_author
                return
                <p>{$v_author}, {$v_count}</p>
            }
        </div>
    </body>
</html>