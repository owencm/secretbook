
var mlbcForEncodingAndDecoding = JSON.parse('{"k":3,"n":27,"l":11,"r":13,"G1":[[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,1],[0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,1,1,1,0,0,1]],"Ht":[[0,1,1,1,1,1,1,1,0,0,0,0,1],[1,1,0,1,1,0,0,0,1,0,0,0,0],[1,0,0,1,0,1,1,1,1,1,0,0,1],[1,0,1,0,1,1,1,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,1,0,0,1],[1,1,0,0,1,0,1,0,1,1,1,1,1],[0,1,1,0,0,0,1,0,1,1,0,0,1],[0,1,1,0,0,0,0,0,0,1,0,0,1],[1,0,1,0,0,1,0,0,1,0,0,0,0],[0,0,1,0,0,0,1,0,1,1,0,0,0],[0,1,0,1,1,1,0,1,1,0,1,1,0],[1,1,0,1,1,0,0,0,1,0,0,1,0],[1,0,1,0,0,1,0,0,0,0,0,1,0],[1,0,0,1,0,0,1,0,1,1,1,0,1],[1,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,1]],"Jt":[[1,0,0],[0,1,0],[0,0,1],[1,1,1],[1,0,0],[0,1,0],[0,0,0],[0,1,1],[1,1,0],[0,0,0],[0,1,0],[0,0,0],[1,1,0],[1,0,1],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]],"G0":[[1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,0,1,1,0,0,0],[1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0],[0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1],[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,1,1,0,0,1],[0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,0,0,0,0],[1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0],[0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,1,0,0,1,1,0],[0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,1,1,0,0,0,1,0,0,1,0],[1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,1,1],[1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,1,0,0,0,1,0,1]]}');

//USER INTERFACE CODE

function decodeImageClicked () {
  decodeImage('canvas', objectURL, createDecodingDctFunction(mlbcForEncodingAndDecoding), function(){});
}

function promptDownload(uri) {
  window.open(uri, 'asdf');
}

function encodeImageClicked() {
  if (document.getElementById("message").value.length > 0) {
    // updateStatus("Recompressing image. Please wait...");
      getImageDataFromURL(objectURL, 
        function(data) {
          var message = document.getElementById("message").value;
          var password = document.getElementById("password").value;
          encodeData(data, 75, createEncodingDctFunction(message, password, mlbcForEncodingAndDecoding), promptDownload);
        }
      );
  } else {
    // updateStatus("Please type a message to be sent.");
  }
}

var objectURL;
function handleFileSelect(evt) {
  if (evt.target.files.length>0) {
    files = evt.target.files;
    f = files[0];
    objectURL = window.webkitURL.createObjectURL(f);
    evt.target.files = [];
    getImageDimensions(objectURL, function(size) {
      if (size.width % 16 != 0 || size.height % 16 != 0) {
        // updateStatus("Error: please select an image with width and height as a multiple of 16 (e.g. 960*720).")
      } else {
        var coefficientCount = (size.width * size.height / 64) - Math.floor(1+5*3*8*mlbcForEncodingAndDecoding.n/mlbcForEncodingAndDecoding.k);
        var maxLength = Math.floor(coefficientCount/8*mlbcForEncodingAndDecoding.k/mlbcForEncodingAndDecoding.n);
        // updateStatus("This image has space for "+maxLength+" characters of hidden message");
        document.getElementById("message").value = document.getElementById("message").value.slice(0, maxLength);
        document.getElementById("message").setAttribute("maxlength", maxLength);
      }
    });
    document.getElementById("encoded").src = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==";
  }
}


setTimeout( function() {
document.getElementById("image-select").addEventListener("change", handleFileSelect, false);
document.getElementById("encode-button").addEventListener("click", encodeImageClicked);
},100);