xquery version "3.0";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace html="http://www.w3.org/1999/xhtml";
declare option exist:serialize "method=xml";
declare option exist:serialize "indent=yes";
declare option exist:serialize "omit-xml-declaration=no";
declare option exist:serialize "process-xsl-pi=yes";


import module namespace kwic="http://exist-db.org/xquery/kwic";


(: try to search for terms using lucence and kwic :)

(: the term(s) to be searched for :)
let $v_collection :=request:get-parameter('col','Muqtabas')

(: Call data sources :)
let $v_library := collection(concat('/db/',$v_collection,'/xml/'))
let $v_file := doc (concat('/db/',$v_collection,'/xml/oclc_4770057679-i_63.TEIP5.xml'))
let $v_teis := $v_library/descendant-or-self::tei:TEI
let $v_divs := $v_library/descendant::tei:body/descendant::tei:div[@type='article']

(: call stylesheet :)
let $v_teibp := doc('/db/Muqtabas/boilerplate/teibp.xsl')

(: the search function :)
let $v_query := request:get-parameter('search', 'المرأة')
(: this defines the leading wildcard option of ft:query, which, however seems not to work with kwic :)
let $v_ft-query-option := <options><default-operator>and</default-operator><leading-wildcard>yes</leading-wildcard></options>
(: what are the properties of ft:query? it allows for Bolean operators! ft:query(., $v_query, $v_ft-query-option) :)
let $v_hits := 
    <teiCorpus xmlns:tei="http://www.tei-c.org/ns/1.0">
        <teiHeader xml:lang="en"/>
            {for $v_tei in $v_teis[ft:query(descendant::tei:div[@type='article']/descendant::node()[not(self::tei:div)], $v_query, $v_ft-query-option)]
                let $v_id := string($v_tei/@xml:id)
                order by $v_id
                return 
                <TEI>
                {$v_tei/tei:teiHeader, $v_tei/tei:facsimile}
                <text xml:lang="ar">
                    <front>{$v_id}</front>
                    <body>
                    {
                    for $v_div in $v_tei/descendant::tei:div[@type='article'][ft:query(descendant::node()[not(self::tei:div)], $v_query, $v_ft-query-option)]
                        let $v_head := $v_div/tei:head[1]
                        let $v_id-div := concat($v_id,'.TEIP5.xml#',$v_div/@xml:id)
                        let $v_pb-preceding := $v_div/preceding::tei:pb[@ed='print'][1]
                        order by $v_head
                        return 
                        <div>
                           <!--  {$v_pb-preceding} -->
                        <div type="article">
                            {$v_head}
                            <!-- link to complete issue -->
                            <a href="../xml/{$v_id-div}" target="_blank" lang="en">source</a>
                            {for $v_node in $v_div/descendant::node()[not(self::tei:div)][ft:query(., $v_query, $v_ft-query-option)]
                                let $v_pb-preceding := $v_node/preceding::tei:pb[@ed='print'][1]
                                return 
                                ($v_pb-preceding, $v_node)
                            }
                        </div>
                        </div>
                    }
                    </body>
                </text>
                </TEI>
                }
    </teiCorpus>
            
return transform:transform($v_hits, $v_teibp,())
(: return $v_hits :)