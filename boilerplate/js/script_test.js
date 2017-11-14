// assign a variable to the search button
var theButton =document.getElementById('b_toggle');
console.log(theButton);

function toggleLineBeginnings() {
	// check if the button was clicked
	console.log("You pressed me?")
	// generate a variable holding <br/> elements
	var theBreaks = document.getElementsByTagName('lb');
	// console.log(theBreaks)
	theBreaks.innerHTML = "hello world!";
	console.log(theBreaks)
}

// do something upon clicking the button
//theButton.addEventListener('click',toggleLineBeginnings);

function insertHTML_ByXPath( xpath, position, newElement) {
    var element = document.evaluate(xpath, window.document, null, 9, null ).singleNodeValue;
    element.insertAdjacentHTML(position, newElement);
    // element.style='border:3px solid orange';
}

var xpath_DOMElement = '//*[@id="answer-33669996"]/table/tbody/tr[1]/td[2]/div';
var childHTML = '<div id="Yash">Hi My name is <B>\"YASHWANTH\"</B></div>';
var position = 'beforeend';

// insertHTML_ByXPath(xpath_DOMElement, position, childHTML);

// do something upon clicking the button
// theButton.addEventListener('click',insertHTML_ByXPath('//lb[1]',position,'<span>hello world</span>'))

function addCSS(tag) {
    window.document.getElementsByTagName(tag)[1].style.cssText += "display: block;";
}
//theButton.addEventListener('click',addCSS('lb'));

function addElement(tag, addedElement, style, innerHTML){
    var elemDiv = document.createElement(addedElement);
    // elemDiv.style.cssText = style;
    elemDiv.style.cssText = 'width:100%;height:10%;background:rgb(192,192,192);';
    elemDiv.innerHTML = innerHTML; 
    window.document.body.insertBefore(elemDiv, window.document.body.getElementsByTagName(tag));
    // document.body.appendChild(elemDiv); // appends last of that element
}

//theButton.addEventListener('click',addElement('lb','span','display:block;','test'))
