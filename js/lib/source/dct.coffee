# JPEG FUNCTIONS

@encodeData = (theImgData, qf, dctFunction, callback) ->
  encoder = new JPEGEncoder()
  jpegURI = encoder.encode(theImgData, qf, dctFunction)
  callback jpegURI

@decodeImage = (url, decodingFunction, callback) ->
  j = new JpegImage()
  j.onload = (DU_DCT_ARRAY) ->
    
    # Hack to handle the luma sometimes being 0 index and sometimes 1 indexed
    if DU_DCT_ARRAY[0] is `undefined`
      decodingFunction DU_DCT_ARRAY[1], DU_DCT_ARRAY[1].length, callback
    else
      decodingFunction DU_DCT_ARRAY[0], DU_DCT_ARRAY[0].length, callback

  j.load url, true

# DCT FUNCTIONS AND THEIR WRAPPERS

@encodingDctFunction = (DU_DCT_ARRAY, blocks, message, password, mlbc) ->
  makeChanges = (messageToHide, LUMA_ARRAY) ->
    stuckBitErrors = 0
    i = 0

    while i < messageToHide.length
      pos = intToPair(coeffs[i])
      unless Math.abs(LUMA_ARRAY[pos.block][pos.k] % 2) is messageToHide[i]
        unless LUMA_ARRAY[pos.block][pos.k] is 0 # If the bit isn't stuck
          if LUMA_ARRAY[pos.block][pos.k] < 0 #F5 embedding
            LUMA_ARRAY[pos.block][pos.k] += 1
          else
            LUMA_ARRAY[pos.block][pos.k] -= 1
        else
          stuckBitErrors++
      i++
    stuckBitErrors

  coeffsToStuckBitStream = (coeffs, LUMA_ARRAY) ->
    stream = []
    i = 0

    while i < coeffs.length
      pos = intToPair(coeffs[i])
      if LUMA_ARRAY[pos.block][pos.k] is 0
        stream.push 0
      else
        stream.push 1
      i++
    stream
  LUMA_ARRAY = DU_DCT_ARRAY[0]
  coeffs = getValidCoeffs(LUMA_ARRAY, blocks)
  console.log "We have " + coeffs.length + " coeffs within to encode data"
  shuffle coeffs, password
  stream = coeffsToStuckBitStream(coeffs, LUMA_ARRAY)
  messageToHide = encodeLongMessage(mlbc, message, stream)
  stuckBitErrors = makeChanges(messageToHide, LUMA_ARRAY)
  errorRateCaused = stuckBitErrors / messageToHide.length
  console.log "We caused " + stuckBitErrors + " (" + errorRateCaused * 100 + "%) errors to occur in unavoidable stuck bits"
  
  #TODO: Refactor status
  # if errorRateCaused > 0.01
  #   updateStatus "Encoding almost complete although the cover is very bad. We recommend choosing a new one or reducing the size of your message and trying again."
  # else if errorRateCaused > 0.005
  #   updateStatus "Encoding almost complete, although the image is not an ideal cover and the message may have a higher than expected error rate. Tip: images with large areas of a single colour, such as sky, are not suitable for steganography."
  # else
  #   updateStatus "Encoding complete."

@decodingDctFunction = (LUMA_ARRAY, blocks, password, mlbc, callback) ->
  coeffsToStream = (coeffs, LUMA_ARRAY) ->
    stream = []
    i = 0
    for i in [0..coeffs.length-1]
      pos = intToPair(coeffs[i])
      stream.push Math.abs(LUMA_ARRAY[pos.block][pos.k] % 2)
    return stream
  coeffs = getValidCoeffs(LUMA_ARRAY, blocks)
  console.log coeffs.length + " coefficients were available for storing."
  console.log coeffs[..]
  shuffle coeffs, password
  console.log coeffs[..]
  stream = coeffsToStream(coeffs, LUMA_ARRAY)
  console.log stream
  message = decodeLongMessage(mlbc, stream)
  callback message

@createEncodingDctFunction = (message, password, mlbc) ->
  (DU_DCT_ARRAY, blocks) ->
    encodingDctFunction DU_DCT_ARRAY, blocks, message, password, mlbc

@createDecodingDctFunction = (password, mlbc) ->
  (DU_DCT_ARRAY, blocks, callback) ->
    decodingDctFunction DU_DCT_ARRAY, blocks, password, mlbc, callback

# ENCODING AND DECODING HELPERS
@getValidCoeffs = (arr, blocks) ->
  coeffs = []
  block = 0

  while block < blocks
    for k in [1..1] # Enable using more modes here
      coeffs.push pairToInt(block, k)
    block++
  coeffs

@intToPair = (i) -> # Used to convert coefficient block, mode pairs to integers
  block = Math.floor(i / 64)
  k = i % 64
  block: block
  k: k

@pairToInt = (block, k) -> # Used to convert integers to coefficient block, mode pairs
  64 * block + k

@random = (from, to) -> # Used in shuffling
  from + Math.floor(0.5 + Math.random() * (to - from))

@shuffle = (arr, password) -> # Knuth shuffle
  Math.seedrandom password
  i = arr.length - 1

  while i > 0
    j = random(0, i)
    swap = arr[j]
    arr[j] = arr[i]
    arr[i] = swap
    i--
  Math.seedrandom()
  arr

# JPEG HELPER FUNCTIONS
@getImageDimensions = (url, callback) ->
  img = document.createElement("img")

  img.onload = ->
    cvs = document.createElement("canvas")
    cvs.width = img.width
    cvs.height = img.height
    ctx = cvs.getContext("2d")
    ctx.drawImage img, 0, 0
    @resizeImage(cvs)
    callback 
      width: cvs.width
      height: cvs.height
  img.src = url # Set source path

@encodeCanvas = (canvasId, qf, dctFunction) ->
  cvs = document.getElementById(canvasId)
  ctx = cvs.getContext("2d")
  theImgData = (ctx.getImageData(0, 0, cvs.width, cvs.height))
  encodeData canvasId, qf, dctFunction

@resizeImage = (canvas) ->
  maxWidth = 960;
  maxHeight = 720;
  ratio = 1
  ctx = canvas.getContext("2d");

  if (canvas.width > maxWidth)
    ratio = maxWidth / canvas.width
  if (canvas.height > maxHeight)
    if (maxHeight / canvas.height < ratio)
      ratio = maxHeight / canvas.height

  tempCanvas = document.createElement("canvas")
  tempCtx = tempCanvas.getContext("2d")
  tempCanvas.width = canvas.width
  tempCanvas.height = canvas.height
  tempCtx.drawImage(canvas, 0, 0)

  canvas.width = canvas.width * ratio
  canvas.width = 16 * Math.floor(canvas.width/16)
  canvas.height = canvas.height * ratio
  canvas.height = 16 * Math.floor(canvas.height/16)
  ctx.drawImage(tempCanvas, 0, 0, tempCanvas.width, tempCanvas.height, 0, 0, canvas.width, canvas.height)

@getImageDataFromURL = (URL, callback, resize) ->
  img = document.createElement("img")

  img.onload = =>
    cvs = document.createElement("canvas")
    cvs.width = img.width
    cvs.height = img.height
    ctx = cvs.getContext("2d")
    ctx.drawImage img, 0, 0
    @resizeImage(cvs);
    window.data = ctx.getImageData(0, 0, cvs.width, cvs.height)
    callback ctx.getImageData(0, 0, cvs.width, cvs.height)
  img.src = URL # Set source path