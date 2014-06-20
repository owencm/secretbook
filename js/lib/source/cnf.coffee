# fn = function (array) {
#   console.log("p cnf #vars "+array.length);
#   var buf;
#   for (var i = 0; i<array.length; i++) {
#     buf = "";
#     for (var j = 0; j<array[i].length; j++) {
#       buf+=array[i][j]+" ";
#     }
#     console.log(buf+" 0");
#   }
# }

@toSat = (variablesAndZArray) ->
	@columnToSat = (variables, z) ->
		x = variables[0]
		xs = variables[1..variables.length-1]
		if variables.length == 1
			if z == 0
				return ["not", ["var", x]]
			else
				return ["var", x]
		else
			left = ["and", ["not", ["var", x]], @columnToSat(xs, z)]
			right = ["and", ["var", x], @columnToSat(xs, (z+1)%2)]
			return ["or", left, right]
			
	result = ["and"]
	for vAndZ in variablesAndZArray
		variables = vAndZ.variables
		z = vAndZ.z
		result.push @columnToSat(variables, z)
	return result

@formulaToString = (formula) ->
	type = formula[0]
	if type == "var"
		return formula[1]+""
	else if type == "not"
		return "-"+@formulaToString(formula[1])
	else if type == "and"
		return "("+(formula[1..formula.length-1].map (clause) -> @formulaToString(clause)).join(" && ")+")"
	else if type == "or"
		return "("+(formula[1..formula.length-1].map (clause) -> @formulaToString(clause)).join(" || ")+")"

@toCNF = (formula) ->
	type = formula[0]
	subs = formula[1..formula.length-1]

	if type == "var" 
		result = formula
	else if type == "not"
		result = formula #TODO: handle case where not is applied to a non-variable
	else if type == "and"
		subsInCNF = subs.map (sub) -> @toCNF(sub)

		#This loop flattens ANDs
		i = 0
		while i < subsInCNF.length
			sub = subsInCNF[i]
			if sub[0] == "and"
				subsInCNF[i] = subsInCNF[subsInCNF.length-1]
				subsInCNF.length--
				subsInCNF = subsInCNF.concat sub[1..sub.length-1]
			else 
				i++
				
		if subsInCNF.length == 1
			result = subsInCNF[0]
		else
			result = ["and"].concat subsInCNF
	else if type == "or"
		left = @toCNF subs[0]
		right = @toCNF subs[1]
		leftClauses = @CNFToArray(left)
		rightClauses = @CNFToArray(right)
		result = ["and"]
		for lClause in leftClauses
			for rClause in rightClauses 
				skip = false
				if lClause[0] == "var" && rClause[0] == "not" && rClause[1][1] == lClause[1]
					skip = true
				if lClause[0] == "not" && rClause[0] == "var" && rClause[1] == lClause[1][1]
					skip = true
				if skip == false
					if lClause[0] == "var" && rClause[0] == "var" && lClause[1] == rClause[1]
						result.push lClause
					else
					result.push ["or", lClause, rClause]
	return @simplify result

@getVariablesInFormula = (formula) ->
	type = formula[0]
	if type == "var"
		return [formula[1]]
	else if type == "not"
		return [-formula[1][1]]
	else if type == "or"
		resultWithDuplicates = @getVariablesInFormula(formula[1]).concat(@getVariablesInFormula(formula[2]))
		resultWithDuplicates.sort()
		result = []
		for variable in resultWithDuplicates
			if variable != last
				result.push variable
			last = variable
		return result

@variablesArrayToFormula = (variables) ->

	i = 0
	variable = variables[i]
	while variable < 0
		variable = variables[i]
		if variables.indexOf(-variable) > -1
			return null
		i++

	first = variables[0]
	if variables.length == 1
		if first < 0
			result = ["not", ["var", -variables[0]]]
			return result
		else 
			return ["var", variables[0]]
	else
		result = ["or"]
		if first < 0
			result.push ["not", ["var", -first]]
		else 
			result.push ["var", first]
		formula = @variablesArrayToFormula(variables[1..variables.length-1])
		result.push formula if formula != null
		return result

@simplify = (formula) ->

	# This simplifies the variables
	array = @CNFToArray(formula)
	result = ["and"]
	for clause in array
		tempFormula = @variablesArrayToFormula(@getVariablesInFormula(clause))
		if tempFormula != null
			result.push tempFormula

	# This removes any duplicate clauses
	seenArray = []
	for sub in result[1..result.length-1]
		vars = @getVariablesInFormula(sub)
		seenArray.push vars

	for seenOne in seenArray
		for seenTwo in seenArray
			if seenTwo.redundant != false
				if seenOne != seenTwo
					seenTwoIsSubset = true
					for variable in seenTwo
						if seenOne.indexOf(variable) == -1
							seenTwoIsSubset = false
							break
					if seenTwoIsSubset
						seenOne.redundant = true
						break

	seenArray = seenArray.filter((elem) -> elem.redundant != true)
	
	result = ["and"]
	for array in seenArray
		result.push @variablesArrayToFormula(array)

	return result

@CNFToArray = (cnf) ->
	if cnf[0] != "and"
		return [cnf] 

	flattened = []
	for sub in cnf[1..cnf.length-1]
		if sub[0] != "and"
			flattened.push sub
		else
			flattened = flattened.concat (@CNFToArray sub)
	return flattened

@ArrayToSatProblem = (CNFArray) ->

	@flattenForSat = (clause) ->
		type = clause[0]
		remaining = clause[1..clause.length-1]
		if type == "var" 
			return [remaining[0]]
		else if type == "not"
			return [-remaining[0][1]] #The negative value of the notted variable
		else if type == "or"
			if remaining.length > 2
				console.log "Too many subs in or"
			return @flattenForSat(remaining[0]).concat(@flattenForSat(remaining[1]))

	return CNFArray.map (clause) -> @flattenForSat(clause)