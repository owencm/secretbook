var mlbcForEncodingAndDecoding = JSON.parse('{"k":3,"n":27,"l":11,"r":13,"G1":[[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,1],[0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,1,1,1,0,0,1]],"Ht":[[0,1,1,1,1,1,1,1,0,0,0,0,1],[1,1,0,1,1,0,0,0,1,0,0,0,0],[1,0,0,1,0,1,1,1,1,1,0,0,1],[1,0,1,0,1,1,1,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,1,0,0,1],[1,1,0,0,1,0,1,0,1,1,1,1,1],[0,1,1,0,0,0,1,0,1,1,0,0,1],[0,1,1,0,0,0,0,0,0,1,0,0,1],[1,0,1,0,0,1,0,0,1,0,0,0,0],[0,0,1,0,0,0,1,0,1,1,0,0,0],[0,1,0,1,1,1,0,1,1,0,1,1,0],[1,1,0,1,1,0,0,0,1,0,0,1,0],[1,0,1,0,0,1,0,0,0,0,0,1,0],[1,0,0,1,0,0,1,0,1,1,1,0,1],[1,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,1]],"Jt":[[1,0,0],[0,1,0],[0,0,1],[1,1,1],[1,0,0],[0,1,0],[0,0,0],[0,1,1],[1,1,0],[0,0,0],[0,1,0],[0,0,0],[1,1,0],[1,0,1],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]],"G0":[[1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,0,1,1,0,0,0],[1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0],[0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1],[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,1,1,0,0,1],[0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,0,0,0,0],[1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0],[0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,1,0,0,1,1,0],[0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,1,1,0,0,0,1,0,0,1,0],[1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,1,1],[1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,1,0,0,0,1,0,1]]}');

chrome.extension.onMessage.addListener(
  function(request, sender, sendResponse) {
    console.log(request);
    console.log(sender.tab ?
                "From a content script: " + sender.tab.url :
                "From the extension");
    
    if (request.action === "getMLBC")
      sendResponse({mlbc: mlbcForEncodingAndDecoding});

    if (request.action === "closeIframe") {
        chrome.tabs.getSelected(null, function(tab) {
            chrome.tabs.sendMessage(tab.id, {action: "closeIframe"});
        });
    }

    if (request.action === "encode") {
        getImageDataFromURL(request.coverURL, 
          function(data) {
            encodeData(data, 75, createEncodingDctFunction(request.message, request.password, mlbcForEncodingAndDecoding), function (uri) { sendResponse({uri: uri}); } );
          }
        );
        return true; // To allow for a delayed response from the callback
    }

    if (request.action === "getDimensions") {
        console.log("The user requested dimensions");
        getImageDimensions(request.coverURL, function(dimensions) { sendResponse({dimensions: dimensions}); });
        return true; // To allow for a delayed response from the callback
    }

    if (request.action === "decode") {
        decodeImage(request.url, createDecodingDctFunction(request.password, mlbcForEncodingAndDecoding), function(message){sendResponse({message: message})});
        return true;
    }

});