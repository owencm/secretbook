@repCodeEncode = (message, n) ->
	result = []
	for bit in message
		for i in [0..n-1]
			result.push bit
	return result

@repCodeDecode = (message, n) ->
	result = []
	if message.length % n != 0
		console.log "Message is the wrong length"
		return
	current = 0
	total = 0
	for i in [0..message.length-1]
		total += message[i]
		current++
		if current == n
			result.push Math.floor(total/n+0.5)
			total = 0
			current = 0
	return result

@stuckBitEncode = (stream, message, n) ->
	result = []
	errors = 0
	for bit in message
		section = stream.splice(0,n)
		if bit == 0
			result = result.concat(newZerosArray(n))
		else #bit == 1
			if allZeros(section)
				errors++
				result = result.concat(section)
			else
				result = result.concat(section)
	console.log "We caused "+errors+" errors (" +errors/(message.length*n)*100+ "%) ourselves conforming to wet bits"
	return result

@stuckBitDecode = (stream, n) ->
	result = []
	if (stream.length % n != 0)
		console.log "Stream is the wrong length!"
		return
	for i in [0..stream.length/n - 1]
		section = stream.splice(0,n)
		if allZeros(section)
			result.push 0
		else
			result.push 1
	return result

@stuckBitEncode2 = (stream, message) ->
	result = []
	errors = 0
	for bit in message
		section = stream.splice(0,2)
		if bit == 0
			if section[0] == 0 && section[1] == 0 || section[0] == 1 && section[1] == 1
				result = result.concat(section)
			else
				result = result.concat([0,0])
		else # Sending a 1
			if section[0] == 1 && section[1] == 1
				result = result.concat([0,1])
			else if section[0] == 0 && section[1] == 0
				errors++
				result = result.concat(section)
			else
				result = result.concat(section)
	console.log "We caused "+errors+" errors (" +errors/(message.length*2)*100+ "%) ourselves conforming to wet bits"
	return result

@stuckBitDecode2 = (stream) ->
	result = []
	if (stream.length % 2 != 0)
		console.log "Stream is the wrong length!"
		return
	for i in [0..stream.length/2 - 1]
		section = stream.splice(0,2)
		if allZeros(section) || section[0] == 1 && section[0] == 1
			result.push 0
		else
			result.push 1
	return result

@causeErrors = (stream, p) ->
	for i in [0..stream.length-1]
		if Math.floor(Math.random()+p) == 1
			stream[i] = (stream[i]+1)%2
	return stream

@test = (messageLength, repBitN, stuckBitN, wetBitRate, errorRate) ->
	console.log "Transmitting "+messageLength+" random bits ("+Math.floor(messageLength/8)+" characters) using a "+repBitN+"-repition code and a "+stuckBitN+"-stuck bit code. Wet bit rate: "+wetBitRate+" and error rate: "+errorRate
	stream = newWeightedRandomMatrix(1,messageLength*stuckBitN*repBitN,1-wetBitRate)[0]
	# console.log "Stream: "+stream.toString()
	message = newWeightedRandomMatrix(1,messageLength,0.5)[0]
	# console.log "Message: "+message.toString()
	repEncodedMessage = repCodeEncode(message, repBitN)
	# console.log "repEncodedMessage: "+repEncodedMessage.toString()
	stuckBitEncodedMessage = stuckBitEncode(stream, repEncodedMessage, stuckBitN)

	zeros = 0
	for bit in stuckBitEncodedMessage
		if bit == 0
			zeros++
	console.log "The coefficients will be "+zeros/stuckBitEncodedMessage.length*100+"% zeros"

	# console.log "stuckBitEncodedMessage: "+stuckBitEncodedMessage.toString()
	transmitted = causeErrors(stuckBitEncodedMessage, errorRate)
	# console.log "transmitted: "+transmitted.toString()
	stuckBitDecodedMessage = stuckBitDecode(transmitted, stuckBitN)
	# console.log "stuckBitDecodedMessage: "+stuckBitDecodedMessage.toString()
	decodedMessage = repCodeDecode(stuckBitDecodedMessage, repBitN)
	# console.log "decodedMessage: "+decodedMessage.toString()

	errors = 0
	for i in [0..message.length-1]
		if message[i] != decodedMessage[i]
			errors++

	console.log (errors + " errors occurred = "+errors/messageLength*100+"%")


allZeros = (array) ->
	for elem in array
		if elem != 0
			return false
	return true

newZerosArray = (n) ->
	result = []
	for i in [0..n-1]
		result.push 0
	return result