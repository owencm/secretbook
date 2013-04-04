//USER INTERFACE CODE

function proceed(mlbcForEncodingAndDecoding) {

  function decodeImageClicked () {
    decodeImage('canvas', coverURL, createDecodingDctFunction(mlbcForEncodingAndDecoding), function(){});
  }

  function promptDownload(uri) {
    setTimeout(function() {
      alert("Please add \".jpg\" to the end of the file name.");
      var downloadUrl = uri.replace("image/jpeg", "image/octet-stream");
      top.location.replace(downloadUrl);
    }, 100); //This isn't call straight away to avoid a chrome bug.
  }

  function requestEncoding(cover, message, password, callback) {
    chrome.extension.sendMessage({action: "encode", coverURL: coverURL, message: message, password: password}, function(response) {
      console.log(response);
      callback(response.uri)
    });
  }

  function requestImageDimensions(coverURL, callback) {
    chrome.extension.sendMessage({action: "getDimensions", coverURL: coverURL}, function(response) {
      callback(response.dimensions)
    });
  }

  function encodeImageClicked() {
    var message = document.getElementById("message").value;
    var password = document.getElementById("password").value;
    if ((message.length > 0)&&(password.length > 0)&&coverURL) {
      // updateStatus("Recompressing image. Please wait...");
        requestEncoding(coverURL, message, password, promptDownload)
    } else {
      alert("Please ensure you have chosen an image and set both the message and the password.");
    }
  }

  var coverURL;
  function handleFileSelect(evt) {
    if (evt.target.files.length>0) {
      files = evt.target.files;
      f = files[0];
      coverURL = window.webkitURL.createObjectURL(f);
      evt.target.files = [];
      function imageDimensionsCallback(size) {
        if (size.width % 16 != 0 || size.height % 16 != 0) {
          alert("Error: please select an image with width and height as a multiple of 16 (e.g. 960*720).");
        } else {
          var coefficientCount = (size.width * size.height / 64) - Math.floor(1+5*3*8*mlbcForEncodingAndDecoding.n/mlbcForEncodingAndDecoding.k);
          var maxLength = Math.floor(coefficientCount/8*mlbcForEncodingAndDecoding.k/mlbcForEncodingAndDecoding.n);
          setTimeout(function() {alert("This image has space for "+maxLength+" characters of hidden message");},100);//This timeout avoids a Chrome bug
          document.getElementById("message").value = document.getElementById("message").value.slice(0, maxLength);
          document.getElementById("message").setAttribute("maxlength", maxLength);
        }
      }
      requestImageDimensions(coverURL, imageDimensionsCallback);
      //document.getElementById("encoded").src = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==";
    } else {
      coverURL = undefined;
    }
  }

  function closeIframe() {
    chrome.extension.sendMessage({action: "closeIframe"});
  }

  document.getElementById("cancel-button").addEventListener("click", closeIframe)
  document.getElementById("image-select").addEventListener("change", handleFileSelect, false);
  document.getElementById("encode-button").addEventListener("click", encodeImageClicked);
}

chrome.extension.sendMessage({action: "getMLBC"}, function(response) {
  proceed(response.mlbc);
});