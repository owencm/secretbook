# Constraints is an array of objects like {elements: [0,1,2], mustXorTo: 1}
@minimumMatrixSoln = (variableCount, constraints) ->

	@debugText = ""

	satisfies = (constraint, assignment) ->
		elements = constraint.elements
		mustXorTo = constraint.mustXorTo
		xor = 0
		for element in elements
			if assignment[element] == -1 #If one of the variables hasn't been assigned
				return true
			xor = (xor+assignment[element])%2
		if xor == mustXorTo
			return true
		else
			return false

	allZero = (assignment) ->
		total = 0
		for value in assignment
			return false if value == 1 || value == -1
		return true

	hammingMin = (x, y) ->
		@debugText = @debugText + "Comparing: ["+x.toString()+"] and ["+y.toString()+"]" + "\n"
		xHamming = 0
		for value in x
			xHamming += value
		yHamming = 0
		for value in y
			yHamming += value
		if x.length == 0
			@bestHammingWeight = yHamming
			return y
		if y.length == 0
			@bestHammingWeight = xHamming
			return x
		if yHamming < xHamming
			@bestHammingWeight = yHamming
			return y
		else
			@bestHammingWeight = xHamming
			return x

	bestAssignment = []
	@bestHammingWeight = 99999999
	assignment = []
	for i in [0..variableCount-1]
		assignment[i] = -1 #Null assignment
	mightBacktrack = []
	mustBacktrack = []
	fixed = []
	looped = 0
	loopLimit = 1000000

	optionalOnes = 0

	current = 0

	while current < variableCount
		looped++
		break if looped > loopLimit

		if (looped%50000) == 0
			console.log "On our " + looped + "th step while solving"

		if optionalOnes < -1
			@debugText += "NEGATIVE OPTIONAL ONES\n"
			console.log "NEGATIVE OPTIONAL ONES!!"
			return

		@debugText = @debugText + "Current: "+current+", assignment: "+assignment.toString()+", mightBacktrack: "+mightBacktrack.toString()+", mustBacktrack: "+mustBacktrack.toString()+", bestAssignment: "+@bestHammingWeight+", optionalOnes: "+optionalOnes+", fixed: "+fixed.toString() + "\n"

		backtrackForced = false

		if assignment[current] == -1
			assignment[current] = 0
			mightBacktrack.push current #We can always change this
		else if assignment[current] == 0
			isCurrentFixedModifier = fixed.indexOf(current) > -1?-1:0
			if (fixed.length + optionalOnes + isCurrentFixedModifier) < @bestHammingWeight
				assignment[current] = 1
				if mightBacktrack.length == 0 #If we have no backtracking option
					if fixed.indexOf(current) == -1
						fixed.push current #This is fixed
				else
					if fixed.indexOf(current) < 0 #Hack to account for the fact that we set fixed at the bottom but it's only fixed here but we don't want to mark it optional
						optionalOnes++ #Note that we chose to assign a one instead of backtracking
					if optionalOnes > 1 #Since backtracking would give us an extra one, only add as a must if we have more than 1 optional ones
						#We must backtrack to the 0 with the least index
						for i in [0..current-1]
							if fixed.indexOf(i) == -1
								if mustBacktrack.indexOf(i) < 0
									mustBacktrack.push i
						mustBacktrack.sort((a, b) -> a-b)
			else
				@debugText = @debugText + "This route will never beat the best, must force a backtrack to mustBacktrack" + "\n"
				if mustBacktrack.length == 0
					@debugText = @debugText + "Don't have to backtrack so returning the assignment" + "\n"
					console.log "We took "+looped+" loops."
					return bestAssignment
				else
					backtrackForced = true
		else if assignment[current] == 1
			if bestAssignment.length == 0
				@debugText = @debugText + "No solution exists" + "\n"
				return
			else
				if mustBacktrack.length == 0
					@debugText = @debugText + "Found an assignment and mustBacktrack is empty so returning" + "\n"
					console.log "We took "+looped+" loops."
					return bestAssignment

		if !backtrackForced #If we haven't already discovered we're forced to backtrack

			backtrack = false
			for constraint in constraints
				if !satisfies(constraint, assignment)
					backtrack = true
					break
			if allZero(assignment)
				backtrack = true

			if backtrack
				# if !isLaterVariableFixed #If we're asked to backtrack but the current variable is fixed then carry out a must backtrack
				@debugText = @debugText + "We assigned "+current+" to "+assignment[current]+" and it violated so backtrack." + "\n"
				if mightBacktrack != []
					current = mightBacktrack.pop()
					isLaterVariableFixed = false
					for assigned in [current..variableCount-1]
						if fixed.indexOf(assigned) > -1
							isLaterVariableFixed = true
							break
					if !isLaterVariableFixed
						if current<variableCount-1 #Only reset the later variables if you're not the last one!
							for variableIndex in [current+1..variableCount-1] #Reset the assignment to the later variables
								if fixed.indexOf(variableIndex) > 0
									fixed.splice(fixed.indexOf(variableIndex), 1)
								else if assignment[variableIndex] == 1
									optionalOnes--
								assignment[variableIndex] = -1
						if mustBacktrack.indexOf(current) > -1 #Remove the need to backtrack here later if we're going now
							mustBacktrack.splice(mustBacktrack.indexOf(current),1)
					else 
						@debugText = @debugText + "We were asked to backtrack to " + current + " but a larger value was already fixed so mustBacktrack" + "\n"
						backtrackForced = true
				else 
					@debugText = @debugText + "Nowhere to backtrack to and we failed assignment. Give up" + "\n"
					return
			else
				if current == variableCount-1
					@debugText = @debugText + "We've assigned the final variable (" + current + " to " + assignment[current] +  ") and it works. Should now backtrack to mustBacktrack" + "\n"
					bestAssignment = hammingMin(bestAssignment, assignment)[..]
					if mustBacktrack.length == 0
						@debugText = @debugText + "Don't have to backtrack so returning the assignment"
						console.log "We took "+looped+" loops."
						return bestAssignment
					else
						backtrackForced = true
				else
					@debugText = @debugText + "We assigned "+current+" to "+assignment[current]+" and didn't violate so continue." + "\n"
					current++ #We didn't have to backtrack and we're not done, increment and loop!

		if backtrackForced
			current = mustBacktrack.pop()
			while assignment[current] == 1
				current = mustBacktrack.pop()
			if fixed.indexOf(current) == -1
				fixed.push current
			#Remove all optional backtracks which occur after where we've backtracked to
			newMightBacktrack = []
			for option in mightBacktrack
				newMightBacktrack.push option if option < current
			mightBacktrack = newMightBacktrack
			if current<variableCount-1 #Only reset the later variables if you're not the last one!
				for variableIndex in [current+1..variableCount-1] #Reset the assignment to the later variables
					if fixed.indexOf(variableIndex) > -1
						fixed.splice(fixed.indexOf(variableIndex), 1)
					else if assignment[variableIndex] == 1
						optionalOnes--
					assignment[variableIndex] = -1

	console.log + "GAVE UP OPTIMISING!!!!!!!!!!!!!!!!!" if looped > loopLimit
	if bestAssignment.length == 0
		@debugText = @debugText + "WE COULDNT FIND A VALID ASSIGNMENT!" + "\n"
	@debugText = @debugText + "Came out the other end because no values we can set have a lower hamming dist than the best." + "\n"
	console.log "We took "+looped+" loops."
	return bestAssignment


