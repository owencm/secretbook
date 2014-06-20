# Constraints is an array of objects like {elements: [0,1,2], mustXorTo: 1}
@minimumMatrixSoln = (variableCount, constraints) ->

	satisfies = (constraint, assignment) ->
		xor = 0
		for element in constraint.elements
			if assignment[element] == undefined #If one of the variables hasn't been assigned
				return true
			xor = (xor+assignment[element])%2
		return xor == constraint.mustXorTo

	allZero = (assignment) ->
		for i in [0..variableCount-1]
			return false if assignment[i] == 1 || assignment[i] == undefined
		return true

	assignment = []
	validBacktracks = []
	looped = 0
	loopLimit = 10000000
	maxOnes = 1
	currentOnes = 0

	current = 0

	while current < variableCount
		looped++
		break if looped > loopLimit

		# console.log "Current: "+current+" assignment: "+assignment.toString()+" validBacktracks: "+validBacktracks.toString()+" currentOnes: "+currentOnes+" maxOnes: "+maxOnes

		if (looped%500000) == 0
			console.log "On our " + looped + "th step while solving"

		if assignment[current] == undefined
			assignment[current] = 0
			validBacktracks.push current
		else if assignment[current] == 0
			assignment[current] = 1
			currentOnes++
		else if assignment[current] == 1
			console.log "ERRORRR!!!!!! Shouldn't end up in this case"

		backtrack = false
		for constraint in constraints
			if !satisfies(constraint, assignment)
				backtrack = true
				break
		if allZero(assignment)
			backtrack = true
		if currentOnes > maxOnes
			backtrack = true

		if backtrack
			# console.log "We assigned "+current+" to "+assignment[current]+" and it violated so backtrack to the last pos in ["+validBacktracks.toString()+"]" 
			if validBacktracks.length > 0
				current = validBacktracks.pop()
				if current+1 <= variableCount-1
					for i in [current+1..variableCount-1]
						if assignment[i] == 1
							currentOnes--
				assignment.length = current + 1
			else 
				if maxOnes < variableCount
					# console.log "Nowhere to backtrack to so increment maxOnes and go back to the start"
					maxOnes++ 
					assignment.length = 0
					current = 0
					currentOnes = 0
				else
					# console.log "Nowhere to backtrack to and maxOnes is already "+variableCount+" so no assignment is valid"
					return
		else
			# console.log "We assigned "+current+" to "+assignment[current]+" and didn't violate so continue." 
			current++ #We didn't have to backtrack and we're not done, increment and loop!

	console.log "GAVE UP OPTIMISING!!!!!!!!!!!!!!!!!" if looped > loopLimit
	console.log "Loop finished because we assigned the last variable and it didn't violate. We took "+looped+" loops" 
	return assignment
