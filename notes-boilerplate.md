---
title: "Troubleshoot boilerplate JS"
author: Till Grallert
date: 2015-12-01 17:44:26
---

# TO DO

- add back-links to page breaks
- add link to the main page of the repository

# Select which facsimile to display

This can be donw with javascript, jQuery, and a radio box HTML form. Somewhere at the top of the page, a form should be embedded:

~~~{.html}
<form id="select-facs">
    <input type="radio" name="facs" value="off" checked>none</input>
    <input type="radio" name="facs" value="local">local</input>
    <input type="radio" name="facs" value="online">online</input>
</form>
~~~

The spans for the facsimiles could look thus (building upon the original TEI boilerplate code):

~~~{.html}
<span xmlns="http://www.w3.org/1999/xhtml" lang="en" class="-teibp-pb" id="pb_2.d1e1545">
    <span class="-teibp-pageNum">
        <span lang="en" class="-teibp-pbNote">
            <text>page: </text>
        </span>2 
    </span>
    <span class="-teibp-pbFacs">
        <a class="gallery-facs" rel="prettyPhoto[gallery1]" onclick="showFacs('2','http://eap.bl.uk/EAPDigitalItems/EAP119/EAP119_1_4_5-EAP119_muq191102_002_L.jpg','pb_2.d1e1545')">
            <img alt="view page image(s)" class="-teibp-thumbnail cFacs-1" src="http://eap.bl.uk/EAPDigitalItems/EAP119/EAP119_1_4_5-EAP119_muq191102_002_L.jpg"/>
            <img alt="view page image(s)" class="-teibp-thumbnail  cFacs-2" src="http://eap.bl.uk/EAPDigitalItems/EAP119/EAP119_1_4_5-EAP119_muq191102_003_L.jpg"/>
        </a>
    </span>
</span>
~~~

The javascript in the `<head>` of the page should look like this:

~~~{.javascript}
$(document).ready(function(){
// deal with facsimiles
    var radioValue = $('input[name="facs"]:checked').val();        
    //alert(radioValue); 
    if (radioValue == 'off'){
        $('.cFacs-1').hide();
        $('.cFacs-2').hide();
    }
    else {
        if (radioValue =='local'){
            $('.cFacs-1').show();
            $('.cFacs-2').hide();
        }
        else{
            $('.cFacs-1').hide();
            $('.cFacs-2').show();
        }
    }
    $('input[name="facs"]').on('change', function() {
        var radioValue = $('input[name="facs"]:checked').val();        
        //alert(radioValue); 
        if (radioValue == 'off'){
            $('.cFacs-1').hide();
            $('.cFacs-2').hide();
        }
        else {
            if (radioValue =='local'){
                $('.cFacs-1').show();
                $('.cFacs-2').hide();
            }
            else{
                $('.cFacs-1').hide();
                $('.cFacs-2').show();
            }
        }
    });
});  
~~~

# sticky headers

It would be nice to make headers sticky once, they reach the top of the page. As the [Google developer blog](https://developers.google.com/web/updates/2012/08/Stick-your-landings-position-sticky-lands-in-WebKit) noted, this can be done in modern browsers with CSS3 only and is gradually implemented:

~~~{.css}
.sticky {
  position: -webkit-sticky;
  position: -moz-sticky;
  position: -ms-sticky;
  position: -o-sticky;
  position: sticky;
  top: 15px;
}
~~~

However, in current (2015-12-02) iterations of Firefox "sticky" elements are all stacked above one another, i.e. the previous `<head>` does not continue slide upwards with the arrival of a new `<head>`, instead it remains below the new arrival. It the latter is small than the former, the edges of the former remain visible.

Another option is to change classes with javascript and jQuery:

~~~{.javascript}
    $(document).ready(function(){
        // sticky headers
        $(window).scroll(function() {
        if ($(this).scrollTop() > 1){  
            $('h1').addClass("sticky");
          }
          else{
            $('h1').removeClass("sticky");
          }
        });
    });
~~~

And then style the two states differently as 

~~~{.css}
h1 {
  position: relative;
  width: 100%;
  text-align: center;
  font-size: 72px;
  line-height: 108px;
  height: 108px;
  background: #335C7D;
  color: #fff;
  font-family: 'PT Sans', sans-serif;
  transition: all 0.4s ease;
}

h1.sticky {
    position: fixed;
  font-size: 24px;
  line-height: 48px;
  height: 48px;
  background: #efc47D;
  text-align: left;
  padding-left: 20px;
}
~~~


Links:

- [Change navigation active state on scroll](http://codepen.io/supersarap/pen/EsAyn): jQuery waypoint
- [fixed sticky](https://github.com/filamentgroup/fixed-sticky)
- [mozilla position css](https://developer.mozilla.org/en-US/docs/Web/CSS/position)
- [demo css sticky](http://html5-demos.appspot.com/static/css/sticky.html)
- [simple on scroll animated header jquery](https://medium.com/web-design-tutorials/simple-on-scroll-animated-header-jquery-4694b254609e#.el9xja7ua)

# Unicode symbols for navigation

See this [link](http://tutorialzine.com/2014/12/you-dont-need-icons-here-are-100-unicode-symbols-that-you-can-use/)

# Problem: not jumping to the correct page

## "solution"

This is a known bug!

>The doc page says "Known Issue: In WebKit-based browsers, e.g., Safari and Chrome, if the `@facs` links are to a remote server (e.g., `<pb n="42" facs="http://www.example.com/images/page057.jpg">`), the facsimile page viewer will always open at the first page of the document, rather than scrolling correctly to the page selected in the transcription. We expect to solve this problem, but haven’t figured it out yet."

## Error description

Somehow the original javascript for displaying the full-page view of facsimiles in a separate browser window was broken: the new window does not jump to the correct page, but always the first facsimile linked in the XML file.

The clickable links for facsimiles are generated by the following XSLT

~~~{.xml}
<span class="-teibp-pbFacs">
    <a class="gallery-facs" rel="prettyPhoto[gallery1]">
        <xsl:attribute name="onclick">
            <xsl:value-of
                select="concat('showFacs(', $apos, $n, $apos, ',', $apos, $vFacs, $apos, ',', $apos, $id, $apos, ')')"
            />
        </xsl:attribute>
        <img alt="{$altTextPbFacs}" class="-teibp-thumbnail">
            <xsl:attribute name="src">
                <xsl:value-of select="$vFacs"/>
            </xsl:attribute>
        </img>
    </a>
</span>
~~~

this translates into the following HTML

~~~{.htm}
<span xmlns="http://www.w3.org/1999/xhtml" class="-teibp-pbFacs">
    <a class="gallery-facs" rel="prettyPhoto[gallery1]" onclick="showFacs('2','http://ngcs.staatsbibliothek-berlin.de/?action=metsImage&amp;format=jpg&amp;metsFile=PPN729542483&amp;divID=PHYS_0004','pb_2')">
        <img alt="view page image(s)" class="-teibp-thumbnail" src="http://ngcs.staatsbibliothek-berlin.de/?action=metsImage&amp;format=jpg&amp;metsFile=PPN729542483&amp;divID=PHYS_0004" />
    </a>
</span>
~~~

- Variables
    + `$vFacs`: URL of the image file
    + `$apos`: string for apostrophs
    + `$n`: passed on through a param; this is the `@n` attribute of the `<pb>`
    + `$id`: passed on through a param; this is the `@xml-id` attribute of the `<pb>`
    + `$altTextPbFacs`

- JS functions:
    + `showFacs`

~~~{.javascript}
function showFacs(num, url, id) {
    facsWindow = window.open ("about:blank")
    facsWindow.document.write("<html>")
    facsWindow.document.write("<head>")
    facsWindow.document.write("<title>TEI Boilerplate Facsimile Viewer</title>")
    facsWindow.document.write($('#maincss')[0].outerHTML)
    facsWindow.document.write($('#customcss')[0].outerHTML)
    facsWindow.document.write("<link rel='stylesheet' href='../js/jquery-ui/themes/base/jquery.ui.all.css'>")
    if ($('#teibp-tagusage-css').length) {
      facsWindow.document.write($('#teibp-tagusage-css')[0].outerHTML)
    }
    if ($('#teibp-rendition-css').length) {
      facsWindow.document.write($('#teibp-rendition-css')[0].outerHTML)
    }
    facsWindow.document.write("<script type='text/javascript' src='../js/jquery/jquery.min.js'></script>")
    facsWindow.document.write("<script type='text/javascript' src='../js/jquery-ui/ui/jquery-ui.js'></script>")
    facsWindow.document.write("<script type='text/javascript' src='../js/jquery/plugins/jquery.scrollTo-1.4.3.1-min.js'></script>")
    facsWindow.document.write("<script type='text/javascript' src='../js/teibp.js'></script>")
    facsWindow.document.write("<script type='text/javascript'>")
    facsWindow.document.write("$(document).ready(function() {")
    facsWindow.document.write("$('.facsImage').scrollTo($('#" + id + "'))")
    facsWindow.document.write("})")
    facsWindow.document.write("</script>")
    facsWindow.document.write("<script type='text/javascript'>  $(function() {$( '#resizable' ).resizable();});</script>")
    facsWindow.document.write("</head>")
    facsWindow.document.write("<body>")
    facsWindow.document.write($("teiHeader")[0].outerHTML)
    //facsWindow.document.write("<teiHeader>" + $("teiHeader")[0].html() + "</teiHeader>")
    //facsWindow.document.write($('<teiHeader>').append($('teiHeader').clone()).html();)
    
    //facsWindow.document.write($("teiHeader")[0].outerHTML)
    facsWindow.document.write("<div id='resizable'>")
    facsWindow.document.write("<div class='facsImage'>")
    $(".-teibp-thumbnail").each(function() {
        facsWindow.document.write("<img id='" + $(this).parent().parent().parent().attr('id') + "' src='" + $(this).attr('src') + "' alt='facsimile page image'/>")
    })
    facsWindow.document.write("</div>")
    facsWindow.document.write("</div>")
    facsWindow.document.write($("footer")[0].outerHTML)
    
    facsWindow.document.write("</body>")
    facsWindow.document.write("</html>")
    facsWindow.document.close()
}
~~~