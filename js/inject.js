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
		decodeMessage(url, password);
	} catch (err) { // Couldn't find the image
		toggleStegoObjectCreation();
	}
}

var wrapper;

function closeIframe() {
     $(wrapper).remove();
     wrapper = undefined;
}

function toggleStegoObjectCreation() {
	if (!wrapper) {
		wrapper = document.createElement("div");
		$(wrapper).css({"width": "100%", "position": "fixed", "z-index": "9999", "top": "20px"});

		iframe = document.createElement("iframe");
		$(iframe).css({"width": "600px", "height": "350px", "background-color": "white", "margin": "0 auto", "display": "block", "border": "medium double rgb(59, 89, 152)"});

		iframe.src = chrome.extension.getURL("index.html");
		document.body.appendChild(wrapper);
		wrapper.appendChild(iframe);
	} else {
		closeIframe()
	}
}

function decodeMessage(url, password) {
	chrome.extension.sendMessage({action: "decode", url: url, password: password}, function(response) {
    	setTimeout(function() {
    		if (response.message) {
	    		alert("Message decoded: " + response.message);
	    	} else {
	    		alert("No message could be found.");
	    	}
    	}, 100);
    });
}

chrome.extension.onMessage.addListener(
  function(request, sender, sendResponse) {
    console.log(sender.tab ?
                "from a content script:" + sender.tab.url :
                "from the extension");
    if (request.action == "closeIframe")
      closeIframe()
});

key('ctrl+alt+a', function(){ activate(); });