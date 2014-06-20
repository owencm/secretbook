# Constraints is an array of objects like {elements: [0,1,2], mustXorTo: 1}
@solveConstraintsMinimally = (variableCount, constraints, canBeAllZeros, minimizeHammingDist) ->

	solve = (variableCount, constraints) ->
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

		nowBacktracking = false

		while current < variableCount
			looped++
			break if looped > loopLimit

			# console.log "Current: "+current+" assignment: "+assignment.toString()+" validBacktracks: "+validBacktracks.toString()+" currentOnes: "+currentOnes+" maxOnes: "+maxOnes

			if (looped%500000) == 0
				console.log "On our " + looped + "th step while solving"
				console.log "Our current assignment is "+assignment.toString()

			if assignment[current] == undefined
				if minimizeHammingDist
					assignment[current] = 0
				else
					assignment[current] = Math.floor(Math.random() + 0.5)
					if assignment[current] == 1
						currentOnes++
				validBacktracks.push current
			else if nowBacktracking # assignment[current] == 0 in min hamming world 
				assignment[current] = (assignment[current] + 1)%2 # assignment[current] = 1 in min hamming world
				if assignment[current] == 1
					currentOnes++
			else if !nowBacktracking
				console.log "ERRORRR!!!!!! Shouldn't end up in this case"

			backtrack = false
			for constraint in constraints
				if !satisfies(constraint, assignment)
					backtrack = true
					break
			# In case the call specifies it must be a non-zero matrix
			if !canBeAllZeros && allZero(assignment)
					backtrack = true
			# In case the call specifies it must have the minimum hamming distance
			if minimizeHammingDist && currentOnes > maxOnes
				backtrack = true

			if backtrack
				# console.log "We assigned "+current+" to "+assignment[current]+" and it violated so backtrack to the last pos in ["+validBacktracks.toString()+"]" 
				nowBacktracking = true
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
						throw "Nowhere to backtrack to and maxOnes is already "+variableCount+" so no assignment is valid"
						return -1
			else
				nowBacktracking = false
				# console.log "We assigned "+current+" to "+assignment[current]+" and didn't violate so continue." 
				current++ #We didn't have to backtrack and we're not done, increment and loop!

		if looped > loopLimit
			throw "ERROR: TRYING TO SOLVE SOME MATRIX EQUATION TOOK TOO LONG"
			return -1
		return assignment


	#This reorders the variables to most restrictive first before feeding them into the backtracker
	variableCountArray = []
	for i in [0..variableCount-1]
		variableCountArray[i] = 0
	#each constraint is of the form {elements: [0,1,2], mustXorTo: 1}
	for constraint in constraints
		for element in constraint.elements
			variableCountArray[element]++
	variablesWithCount = []
	for count, i in variableCountArray
		variablesWithCount[i] = {variable: i, count: count}
	variablesWithCount.sort((x, y) -> y.count - x.count)
	variableInverseMap = variablesWithCount.map (varAndCount) -> varAndCount.variable
	variableMap = []
	for variable, i in variableInverseMap
		variableMap[variable] = i
	#Now modify the constraints in accordance with the variable map
	for constraint in constraints
		for element, i in constraint.elements
			constraint.elements[i] = variableMap[element]
	assignment = solve(variableCount, constraints)
	mappedAssignment = []
	for assignedTo, i in assignment
		mappedAssignment[variableInverseMap[i]] = assignedTo
	return mappedAssignment
