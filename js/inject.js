function getImage() {
	var image;
	try 
	{
		jqueryImage = $(".spotlight").first();
		image = jqueryImage[0];
		if (image === undefined) {
			throw("Couldn't find the spotlight image");
		} else {
			if (jqueryImage.hasClass("hidden_elem") === true) {
				throw("We found the spotlight image but it was hidden");
			}
		}
	} 
	catch (err) //If we couldn't find it in the spotlight, look in the other place
	{
		image = $("#fbPhotoImage")[0];
	}

	if (image !== undefined) {
		return image.src;
	} else {
		throw("Couldn't find an image");
	}
}

function activate() {
	try {
		var url = getImage();
		var password = prompt("Please enter your password to decode the message.", "");
		var message = decodeMessage(url, password);
		alert(message);
	} catch (err) { // Couldn't find the image
		openStegoObjectCreation();
	}
}

function openStegoObjectCreation() {
	wrapper = document.createElement("div");
	$(wrapper).css({"width": "100%", "position: fixed", "z-index": "9999", "top": "20px"});

	iframe = document.createElement("iframe");
	$(iframe).css({"width": "600px", "height": "400px", "background-color": "white", "margin": "0 auto", "display": "block", "border": 0});

	iframe.src = chrome.extension.getURL("index.html");
	wrapper.appendChild(iframe);
	document.body.appendChild(wrapper);
}

function decodeMessage(url, password) {
	return "This is the decoded message from "+url+" with password: "+password;
}

key('ctrl+alt+a', function(){ activate(); });