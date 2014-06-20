# Constraints is an array of objects like {elements: [0,1,2], mustXorTo: 1}
@solveConstraints = (variableCount, constraints, canBeAllZeros) ->

	solve = (variableCount, constraints) ->
		satisfies = (constraint, assignment, current) ->
			xor = 0
			for element in constraint.elements
				if element > current #If one of the variables hasn't been assigned
					return true
				xor = (xor+assignment[element])%2
			return xor == constraint.mustXorTo

		conflictSet = (variable) ->
			set = []
			for constraint in constraints
				if constraint.elements.indexOf(variable) > -1
					for element in constraint.elements
						if set.indexOf(element) < 0
							set.push element
			set.sort((x, y) -> y-x)
			return set

		allZero = (assignment) ->
			for i in [0..variableCount-1]
				return false if assignment[i] == 1 || assignment[i] == undefined
			return true

		# uniqueSorted = (array) ->
		# 	result = []
		# 	prevElem = null
		# 	for elem in array
		# 		if elem != prevElem
		# 			result.push elem
		# 			prevElem = elem
		# 	return result

		assignment = []
		validBacktracks = []
		looped = 0
		loopLimit = 1000000

		current = 0

		nowBacktracking = false

		while current < variableCount
			looped++
			break if looped > loopLimit

			# console.log "Current: "+current+" assignment: "+assignment.join('')+" next backtrack: "+validBacktracks[validBacktracks.length-1]

			if (looped%500000) == 0
				console.log "On our " + looped + "th step while solving"
				console.log "Our current assignment is "+assignment.toString()

			if assignment[current] == undefined
				assignment[current] = Math.floor(Math.random() + 0.5)
				validBacktracks.push current
			else if nowBacktracking # assignment[current] == 0 in min hamming world 
				assignment[current] = (assignment[current] + 1)%2 # assignment[current] = 1 in min hamming world
			else if !nowBacktracking # we're just stepping forward. Don't change the previous assignments.
				validBacktracks.push current

			backtrack = false
			# conflictSet = []
			for constraint in constraints
				if !satisfies(constraint, assignment, current)
					backtrack = true
			# 		conflictSet = conflictSet.concat(constraint.elements)
			# conflictSet.sort((x, y) -> y-x) #sorted largest to smallest
			# conflictSet = uniqueSorted(conflictSet)
			# In case the call specifies it must be a non-zero matrix
			if !canBeAllZeros && allZero(assignment)
					backtrack = true

			if backtrack
				# console.log "We assigned "+current+" to "+assignment[current]+" and it violated. backtracks: ["+validBacktracks.toString()+"]" 
				nowBacktracking = true
				if validBacktracks.length > 0
					# Find the next place to backtrack to as the maximal backtrackable element in the conflict set of the current variable
					newCurrent = -1
					for variable in conflictSet(current) # For each variable in the increasing order list of conflicting elements
						for i in [validBacktracks.length-1..0]
							if variable == validBacktracks[i]
								newCurrent = validBacktracks[i]
								# console.log "The largest element it conflicts with in validBacktracks is "+newCurrent
								validBacktracks.splice(i, validBacktracks.length-i)
								break
							if variable > validBacktracks[i]
								break
						if newCurrent != -1
							break
					if newCurrent == -1
						console.log "We have a conflict but there is no conflicting element to change. Give up."
						return
					else
						current = newCurrent
					# assignment.length = current + 1
				else 
					console.log "Nowhere to backtrack to and maxOnes is already "+variableCount+" so no assignment is valid"
					return
			else
				nowBacktracking = false
				# console.log "We assigned (or simply left) "+current+" to (as) "+assignment[current]+" and it didn't violate so continue." 
				current++ #We didn't have to backtrack and we're not done, increment and loop!

		if looped > loopLimit
			console.log "ERROR: TRYING TO SOLVE SOME MATRIX EQUATION TOOK TOO LONG (NON-MINIMAL)" 
			console.log "Our final assignment was "+assignment.toString()
			return
		console.log "We took "+looped+" loops to solve this."
		return assignment

	propogateConstraints = (constraints) ->
		newConstraints = []
		count = 0
		for constrainti, i in constraints
			if (i+1) <= constraints.length-1
				for j in [i+1..constraints.length-1]
					constraintj = constraints[j]
					# Now we have pairs of constraints
					temp = constrainti.elements.concat(constraintj.elements)
					temp = temp.sort((x, y) -> x-y)
					excOrElements = []
					k = 0
					while k < temp.length - 1
						if (k == temp.length-1) || (temp[k] != temp[k+1])
							excOrElements.push temp[k]
							k++
						else
							k += 2
					if (excOrElements.length <= Math.min(constraintj.elements.length,constrainti.elements.length)) && (excOrElements.length > 0)
						mustXorTo = (constrainti.mustXorTo + constraintj.mustXorTo)%2
						newConstraint = {elements: excOrElements, mustXorTo: mustXorTo, expandedFrom: [constraintj.elements.length, constrainti.elements.length]}
						newConstraints.push newConstraint
						count++
					if count > 400
						break
			if count > 400
				break
		newConstraints.concat(constraints)

	# {elements: [0,1,2], mustXorTo: 1}
	# oldConstraintsLength = constraints.length
	# constraints = propogateConstraints(constraints)
	# console.log "Expanded "+oldConstraintsLength+" contraints to "+constraints.length

	# console.log JSON.stringify constraints

	#This reorders the variables to most restrictive first before feeding them into the backtracker
	# variableCountArray = []
	# for i in [0..variableCount-1]
	# 	variableCountArray[i] = 0
	# #each constraint is of the form {elements: [0,1,2], mustXorTo: 1}
	# for constraint in constraints
	# 	for element in constraint.elements
	# 		variableCountArray[element]++
	# variablesWithCount = []
	# for count, i in variableCountArray
	# 	variablesWithCount[i] = {variable: i, count: count}
	# variablesWithCount.sort((x, y) -> y.count - x.count)
	# variableInverseMap = variablesWithCount.map (varAndCount) -> varAndCount.variable
	# variableMap = []
	# for variable, i in variableInverseMap
	# 	variableMap[variable] = i
	# #Now modify the constraints in accordance with the variable map
	# for constraint in constraints
	# 	for element, i in constraint.elements
	# 		constraint.elements[i] = variableMap[element]
	assignment = solve(variableCount, constraints)
	# mappedAssignment = []
	# for assignedTo, i in assignment
	# 	mappedAssignment[variableInverseMap[i]] = assignedTo
	# return mappedAssignment
