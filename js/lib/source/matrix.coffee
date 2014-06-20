@debug = false	

# @mlbc = JSON.parse '{"k":3,"n":27,"l":11,"r":13,"G1":[[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,1],[0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,1,1,1,0,0,1]],"Ht":[[0,1,1,1,1,1,1,1,0,0,0,0,1],[1,1,0,1,1,0,0,0,1,0,0,0,0],[1,0,0,1,0,1,1,1,1,1,0,0,1],[1,0,1,0,1,1,1,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,1,0,0,1],[1,1,0,0,1,0,1,0,1,1,1,1,1],[0,1,1,0,0,0,1,0,1,1,0,0,1],[0,1,1,0,0,0,0,0,0,1,0,0,1],[1,0,1,0,0,1,0,0,1,0,0,0,0],[0,0,1,0,0,0,1,0,1,1,0,0,0],[0,1,0,1,1,1,0,1,1,0,1,1,0],[1,1,0,1,1,0,0,0,1,0,0,1,0],[1,0,1,0,0,1,0,0,0,0,0,1,0],[1,0,0,1,0,0,1,0,1,1,1,0,1],[1,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,1]],"Jt":[[1,0,0],[0,1,0],[0,0,1],[1,1,1],[1,0,0],[0,1,0],[0,0,0],[0,1,1],[1,1,0],[0,0,0],[0,1,0],[0,0,0],[1,1,0],[1,0,1],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]],"G0":[[1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,0,1,1,0,0,0],[1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0],[0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,1],[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,1,1,0,0,1],[0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,0,0,0,0],[1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0],[0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,1,0,0,1,1,0],[0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,1,1,0,0,0,1,0,0,1,0],[1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,1,1],[1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,1,0,0,0,1,0,1]]}'

@reduceAxb = (A, b) ->
	console.log "Asked to row reduce"
	console.log @matrixString A
	console.log @matrixString b
	m = @height(A)
	n = @width(A)

	mb = @height(b)
	nb = @width(b)

	for k in [0..m-1]
		# console.log "Looking at column "+k+" in"
		# console.log @matrixString A
		# Find pivot for column k
		i_max = -1
		for i in [k..m-1]
			if A[i][k] == 1
				i_max = i
		# console.log "The lowest 1 is in the "+i_max+"th position"
		if i_max == -1
			# console.log "Matrix is singular, continue trying anyway."
		else
			# console.log "Swap rows "+k+" and " + i_max+". Before:"
			# console.log @matrixString A
			# console.log @matrixString b
			swap = A[i_max][..]
			A[i_max] = A[k]
			A[k] = swap
			swap = b[i_max][..]
			b[i_max] = b[k]
			b[k] = swap
			# console.log "After:"
			# console.log @matrixString A
			# console.log @matrixString b
			# console.log "Subtract pivot row from all rows below pivot where there is a 1 in the "+k+"th column"
			if k+1 <= m-1
				for i in [k+1..m-1]
					if A[i][k] == 1
						for j in [0..n-1]
							A[i][j] = (A[i][j] + A[k][j])%2
						for j in [0..nb-1]
							b[i][j] = (b[i][j] + b[k][j])%2	
	# 		console.log "After subtracting:"
	# 		console.log @matrixString A
	# 		console.log @matrixString b
	console.log "Finished row reducing!"
	console.log @matrixString A
	console.log @matrixString b
	return {A: A, b: b}

@width = (m) ->
	m[0].length

@height = (m) ->
	m.length

@multiplyMatrices = (m1, m2) ->
	console.log "Dimentions don't match in multiplication" if width(m1) != height(m2) 
	m = @newMatrix(height(m1), width(m2))
	for m2column in [0..width(m2)-1]
		for m1row in [0..height(m1)-1]
			for m1column in [0..width(m1)-1]
				m[m1row][m2column] = ((m1[m1row][m1column] * m2[m1column][m2column]) + m[m1row][m2column]) % 2
	return m

@multiplyMatricesAtPos = (m1, m2, row, col) ->
	result = 0
	for m1column in [0..width(m1)-1]
		result = (result + (m1[row][m1column] * m2[m1column][col])) % 2
	return result

@addMatrices = (m1, m2) ->
	console.log "Dimentions don't match in addition" if width(m1) != width(m2) || height(m1) != height(m2)
	m = @newMatrix(height(m1), width(m1))
	for row in [0..height(m1)-1]
		for column in [0..width(m1)-1]
			m[row][column] = (m1[row][column] + m2[row][column])%2
	return m

@scale = (m, factor) ->
	console.log "Factor is invalid" if isNaN(factor)
	for row in m
		for block in row
			block = block * factor

@identity = (n) ->
	m = @newMatrix(n, n)
	for i in [0..n-1]
		m[i][i] = 1
	return m

@newMatrix = (height, width) ->
	m = new Array(height)
	for row in m
		row = new Array(width)
		for block in row
			block = 0

@newRandomMatrix = (height, width) ->
	@newWeightedRandomMatrix(height, width, 0.5)

@newWeightedRandomMatrix = (height, width, p) ->
	m = @newMatrix(height, width)
	for row in m
		for block in row
			block = @binaryRandom(p)

@binaryRandom = (p) -> Math.floor(Math.random() + p)

@matrixString = (m) ->
	buff = ""
	for row in m
		for block in row
			buff += block + "  "
		buff += "\n"
	return buff.substr(0, buff.length-1)

@transpose = (m) ->
	mTrans = @newMatrix(width(m), height(m)) 
	for rowIndex in [0..height(m)-1]
		for columnIndex in [0..width(m)-1]
			mTrans[columnIndex][rowIndex] = m[rowIndex][columnIndex] 
	return mTrans

@horisontalJoin = (m1, m2) ->
	console.log "Dimentions don't match in horisontal join" if height(m1) != height(m2) 
	m = @newMatrix(height(m1), width(m1) + width(m2))
	for rowIndex in [0..height(m1)-1]
		for m1ColumnIndex in [0..width(m1)-1]
			m[rowIndex][m1ColumnIndex] = m1[rowIndex][m1ColumnIndex]
		for m2ColumnIndex in [0..width(m2)-1]
			m[rowIndex][m2ColumnIndex+width(m1)] = m2[rowIndex][m2ColumnIndex]
	return m

@verticalJoin = (m1, m2) ->
	console.log "Dimentions don't match in vertical join" if width(m1) != width(m2) 
	m = @newMatrix(height(m1) + height(m2), width(m1))
	for columnIndex in [0..width(m1)-1]
		for m1RowIndex in [0..height(m1)-1]
			m[m1RowIndex][columnIndex] = m1[m1RowIndex][columnIndex]
		for m2RowIndex in [0..height(m2)-1]
			m[m2RowIndex+height(m1)][columnIndex] = m2[m2RowIndex][columnIndex]
	return m

@equalMatrix = (m1, m2) ->
	return false if width(m1) != width(m2) || height(m1) != height(m2)
	for rowIndex in [0..height(m1)-1]
		return false if !equalVector(m1[rowIndex], m2[rowIndex])
	return true

@equalVector = (v1, v2) ->
	return v1.join() == v2.join()

@columnRank = (m) ->
	@rowRank @transpose m

@rowRank = (m) ->
	rank = 0
	nrows = @height(m)
	seen = new Array()
	for rowIndex in [0..nrows-1]
		if seen[m[rowIndex].join()] == undefined
			seen[m[rowIndex].join()] = true
			rank++
	return rank

@hammingWeight = (m) ->
	count = 0
	for row in m
		for block in row
			if block == 1
				count++
	return count

@allVectors = (n) -> #These MUST return with the all zeroes first
	@allVectors.cached = [] if @allVectors.cached == undefined
	return @allVectors.cached[n] if @allVectors.cached[n] != undefined
	vectors = []
	return vectors if n == 0
	vectors[0] = [0]
	vectors[1] = [1]
	return vectors if n == 1
	for i in [0..n-2]
		count = vectors.length
		for j in [0..count-1] 
			vectors[j+count] = vectors[j][..] #Copy the array to a new location
			vectors[j].push 0 #In the first copy add a 0 on the end
			vectors[j+count].push 1 #In the second copy add a 1 on the end
	@allVectors.cached[n] = vectors
	return vectors

@allVectorsWithMaxHammingDist = (n, h) ->
	@allVectorsWithMaxHammingDist.cache = [] if @allVectorsWithMaxHammingDist.cache == undefined
	@allVectorsWithMaxHammingDist.cache[n] = [] if @allVectorsWithMaxHammingDist.cache[n] == undefined
	if @allVectorsWithMaxHammingDist.cache[n][h] != undefined
		return @allVectorsWithMaxHammingDist.cache[n][h] 

	vectors = []
	return vectors if n == 0
	vectors[0] = [0]
	vectors[0].dist = 0
	vectors[1] = [1]
	vectors[1].dist = 1
	return vectors if n == 1
	for i in [0..n-2]
		offset = 0
		count = vectors.length
		# console.log "i: " + i + " count: " + count
		for j in [0..count-1]
			# console.log j if (j%5000) == 0
			if vectors[j].dist < h
				vectors[j+count-offset] = vectors[j][..] #Copy the array to a new location
				vectors[j+count-offset].dist = vectors[j].dist #copy the hamming dist
				vectors[j+count-offset].push 1 #In the second copy add a 1 on the end
				vectors[j+count-offset].dist++ #increment the dist since we pushed 1
			else 
				offset++
			vectors[j].push 0 #In the first copy add a 0 on the end

	@allVectorsWithMaxHammingDist.cache[n][h] = vectors
	return vectors

@allSparceVectorsWithMaxOnes = (n, maxOnes) ->
	return [] if n == 0
	vectors = [[],[0]]
	return vectors if n == 1
	currentLength = 1
	for i in [0..n-2]
		offset = 0
		count = vectors.length
		for j in [0..count-1]
			if vectors[j].length < maxOnes
				vectors[j+count-offset] = vectors[j][..] #Copy the array to a new location
				vectors[j+count-offset].push currentLength #In the second copy add a 1 on the end
			else 
				offset++
		currentLength++
	return vectors

@sparceVectorToVector = (vector, vectorLength) ->
	newVector = []
	current = 0
	for i in [0..vectorLength - 1]
		if vector[current] == i 
			newVector.push 1
			current++
		else
			newVector.push 0
	return newVector

@allColumnsWithMaxHammingDist = (n, h) ->
	allVectorsWithMaxHammingDist(n, h).map (vector) -> z = []; z.push vector; z

@allColumns = (n) ->
	allVectors(n).map (vector) -> z = []; z.push vector; z

@minimizeWetBits = (G0, stream, origMessage) ->
	vectors = @allVectorsWithMaxHammingDist(@height(G0), @height(G0))
	minFailCount = 9999999
	stuckBits = @width(stream) - @hammingWeight(stream)

	for vector in vectors
		matrix = [vector]
		messageToSend = @addMatrices(@multiplyMatrices(matrix, G0), origMessage)

		stuckFailCount = 0
		for column in [0..@width(stream)-1]
			if stream[0][column] == 0
				if messageToSend[0][column] != 0
					stuckFailCount++

		if stuckFailCount < minFailCount 
			minFailCount = stuckFailCount
			bestVector = vector
			if minFailCount == 0
				break

	console.log "Best we can do is have "+minFailCount+" stuck bits remaining from a starting "+stuckBits

	result = @addMatrices(@multiplyMatrices([bestVector], G0), origMessage)

	console.log "origMessage: "+origMessage.toString()+", stream: "+stream.toString()+", result: "+result.toString()

	return result

# This takes an array of objects [{A: A, B:B}] where Aix=B for all i and returns a satisfying x
@solveMatrixEquations = (arr) ->
	clone = (obj) ->
		if not obj? or typeof obj isnt 'object'
			return obj

		if obj instanceof Date
			return new Date(obj.getTime()) 

		if obj instanceof RegExp
			flags = ''
			flags += 'g' if obj.global?
			flags += 'i' if obj.ignoreCase?
			flags += 'm' if obj.multiline?
			flags += 'y' if obj.sticky?
			return new RegExp(obj.source, flags) 

		newInstance = new obj.constructor()

		for key of obj
			newInstance[key] = clone obj[key]

		return newInstance

	if arr.length == 0
		console.log "ERROR: ASKED TO SOLVE NO EQUATIONS"

	constraints = []

	for equation in arr
		A = equation.A
		B = equation.B

		# reduced = @reduceAxb(A, clone(B))
		# reducedA = reduced.A
		# reducedB = reduced.b

		# Add the constraints find the vector x such that x^t * A^t = Bt
		At = @transpose A
		Bt = @transpose B

		# console.log "Solving xt * At = Bt where"
		# console.log "At ="
		# console.log @matrixString At
		# console.log "Bt = "
		# console.log @matrixString Bt

		if atHeight == undefined
			atHeight = @height(At)
		else if atHeight != @height(At)
			console.log "Matrices asked to solve are the wrong dimention"
			return

		if xt == undefined #Do this the first time
			xt = []
			xtHeight = @height(Bt)
			xtWidth = @height(At)
			for row in [0..xtHeight-1]
				xt[row] = []

		for row in [0..xtHeight-1]
			for column in [0..@width(At)-1]
				constraint = {elements: [], mustXorTo: Bt[row][column]}
				for xtColARow in [0..@height(At)-1]
					if At[xtColARow][column] == 1
						constraint.elements.push (xtColARow + row*xtWidth) #col: xtColARow, row: row
				if constraint.elements.length > 0
					# console.log "We ensure that " + constraint.elements.toString() + " xor to " + constraint.mustXorTo
					constraints.push constraint

	# console.log constraints
	xtAsVector = @solveConstraints(xtWidth*xtHeight, constraints, false)

	for assignedVariable, i in xtAsVector
		row = Math.floor(i/xtWidth)
		column = i % xtWidth
		xt[row][column] = assignedVariable

	x = @transpose(xt)

	# console.log "We solved and found: "
	# console.log @matrixString x

	#Verify we did this correctly
	correct = true
	for equation in arr
		A = equation.A
		B = equation.B
		# console.log "Verify Ax = B"
		# console.log "A: "
		# console.log @matrixString A
		# console.log "x: "
		# console.log @matrixString x
		# console.log "B: "
		# console.log @matrixString B
		# console.log "Ax:"
		# console.log @matrixString @multiplyMatrices(A, x)
		if !@equalMatrix(@multiplyMatrices(A, x), B)
			correct = false
			break
	if correct == false
		console.log "OUR SOLVER WENT WRONG"
	else
		return x

# This takes arguments A, B and returns x where Ax = B
@solveMatrixEquation = (A, B) ->
	@solveMatrixEquations [{A:A, B:B}]

# Generate a random MLBC
@newRandomMLBC = (n, k, l, stats) ->
	@debugOutput "This is an "+"("+n+", "+k+", "+l+") code with sending rate " + k/n

	r = n - k - l

	if (2^r) > n
		@debugOutput "Increase n or decrease k or decrease l. You can't make H full rank with this."
		return {success: false}

	valid = false
	count = 0
	while valid != true
		G0 = @newRandomMatrix(l, n)
		G1 = @newRandomMatrix(k, n)

		# Generate G by joining G0, G1
		# Require rank(G) = k + l
		G = @verticalJoin(G0, G1)

		# H is an r*n matrix
		# Require GHt = 0
		# Row rank of Ht must be full
		Ht = @solveMatrixEquation(G, @newMatrix(k+l, r))

		# Jt is a n*k matrix
		# Require G0Jt = 0, G1Jt = I
		Jt = @solveMatrixEquations [{A: G0, B: @newMatrix(l, k)}, {A: G1, B: @identity(k)}] 

		# hRank = @columnRank(H)
		# goodHeuristic = (hRank == n) 
		# Verify the code is valid
		valid = @verifyMLBCCorrectness(G, G0, G1, Ht, Jt, n, k, l, r)

		count++
		console.log "Now tried "+count+" sets of matrices" if (count%10000) == 0
		if count > 10000
			@debugOutput "We tried over 10000. Giving up."
			return {success: false}

	@debugOutput "Attempted " + count + " sets of matrices to generate full-rank H"
	@debugOutput "G1:" 
	@debugOutput matrixString G1	
	@debugOutput "G0:" 
	@debugOutput matrixString G0 
	@debugOutput "H^t:"
	@debugOutput matrixString Ht
	@debugOutput "J^t:"
	@debugOutput matrixString Jt

	if stats
		mlbcStats = @mlbcStats(G0, Ht)
		u = mlbcStats.u
		t = mlbcStats.t
		console.log "This code can fix any " + u + " (" +Math.round((u*100/n)*10)/10+ "%) error(s) and withstand any " + t + " (" +Math.round((t*100/n)*10)/10+ "%) stuck bit(s)"

	{success: true, k: k, n: n, r: r, l: l, G1: G1, Ht: Ht, Jt: Jt, G0: G0, u: u, t: t}

# Generate symmetric MLBC
@newMLBC = (n, k, l, stats) ->
	@debugOutput "This is an "+"("+n+", "+k+", "+l+") code with sending rate " + k/n

	r = n - k - l

	if (2^r) > n
		@debugOutput "Increase n or decrease k or decrease l. You can't make H full rank with this."
		return {success: false}

	goodHeuristic = false
	count = 0
	while goodHeuristic != true
		R = @newWeightedRandomMatrix(l,k, 0.5)
		Q = @newWeightedRandomMatrix(l,r, 0.5)
		# Generate G1 according to spec
		Ik = @identity k 
		zeroskl = @newMatrix k, l 
		P = @newRandomMatrix(k,r)
		G1 = @horisontalJoin(@horisontalJoin(Ik, zeroskl),P)

		# Generate G0 according to spec
		Il = @identity(l)
		G0 = @horisontalJoin(@horisontalJoin(R, Il), Q)

		# Generate H according to spec
		Pt = @transpose P
		RP = @multiplyMatrices(R,P)
		QplusRPt = @transpose (@addMatrices(Q, RP))
		Ir = @identity r
		H = @horisontalJoin(@horisontalJoin(Pt, QplusRPt), Ir)

		hRank = @columnRank(H)
		kZerosVector = @newMatrix(1, k)

		goodHeuristic = (hRank == n) 
		count++
		console.log "Now tried "+count+" sets of matrices" if (count%10000) == 0
		if count > 100000
			@debugOutput "We tried over 100000. Giving up."
			return {success: false}

	@debugOutput "Attempted " + count + " sets of matrices to generate full-rank H"
	@debugOutput "G1:" 
	@debugOutput matrixString G1	
	@debugOutput "G0:" 
	@debugOutput matrixString G0 
	@debugOutput "H:"
	@debugOutput matrixString H 

	# Generate J according to spec
	Ik = @identity k
	Rt = @transpose R
	zeroskr = @newMatrix(k,r)
	J = @horisontalJoin(@horisontalJoin(Ik, Rt), zeroskr)
	@debugOutput "J:"
	@debugOutput matrixString J

	# Generate G by joining G0, G1
	G = @verticalJoin(G0, G1)

	# Generate more useful things for later use
	Ht = @transpose H
	Jt = @transpose J

	# Verify the checks work:
	if !@verifyMLBCCorrectness(G, G0, G1, Ht, Jt, n, k, l, r)
		console.log "MLBC is invalid"

	if !stats
		return {success: true, k: k, n: n, l: l, r: r, G1: G1, Ht: Ht, Jt: Jt, G0: G0}
	else
		
		mlbcStats = @mlbcStats(G0, Ht)

		u = mlbcStats.u
		t = mlbcStats.t

		console.log "This code can fix any " + u + " (" +Math.round((u*100/n)*10)/10+ "%) error(s) and withstand any " + t + " (" +Math.round((t*100/n)*10)/10+ "%) stuck bit(s)"

		return { success: true, u: u, t: t, k: k, n: n, l: l, r: r,  G1: G1, Ht: Ht, Jt: Jt, G0: G0}

@mlbcStats = (G0, Ht) ->
	# Now we calculate d0 and d1 in order to find it's error and stuck bit capacity
	# To find d1 we need xG0^t = 0, more efficient to find x^tG0 = 0 by row reduction and then use the solver for x

	# Two versions are implemented here: The first row reduces the matrices and then uses the constraints solver. This will be good for random matrices. The second doesn't row reduce first.

	# #Given A, b of an equation Ax=b this reduces A and b fully. Use it to solve x^tG0 = 0
	# reduced = @reduceAxb(G0, @newMatrix(l, 1))
	# reducedG0 = reduced.A
	# reducedb = reduced.b
	# #Use the magic constraints matrix solver to find the vector x with minimum hamming distance such that xG0t = 0 by using our reduced form x^tG0 = 0 and the solver
	# # d0 = min hammingWeight(x) for x != 0, xG0^T = 0
	# constraints = []
	# for row in [0..@height(reducedG0)-1]
	# 	constraint = {elements: [], mustXorTo: reducedb[row][0]}
	# 	for column in [0..@width(reducedG0)-1]
	# 		if reducedG0[row][column] == 1 
	# 			constraint.elements.push column
	# 	constraints.push constraint
	# x = @minimumMatrixSoln(@width(reducedG0), constraints, false)
	# console.log constraints
	# d0 = @hammingWeight([x])

	# #Given A, b of an equation Ax=b this reduces A and b fully. Use it to solve x^tH = 0
	# reduced = @reduceAxb(H, @newMatrix(r, 1))
	# reducedH = reduced.A
	# reducedb = reduced.b
	# # Use the magic constraints matrix solver to find the vector x with minimum hamming distance such that xHt = 0
	# # d1 = min hammingWeight(x) for x != 0, xH^T = 0
	# constraints = []
	# for row in [0..@height(reducedH)-1]
	# 	constraint = {elements: [], mustXorTo: reducedb[row][0]}
	# 	for column in [0..@width(reducedH)-1]
	# 		if reducedH[row][column] == 1
	# 			constraint.elements.push column
	# 	constraints.push constraint
	# x = @minimumMatrixSoln(@width(reducedH), constraints, false)
	# d1 = @hammingWeight([x])

	# Use the magic constraints matrix solver to find the vector x with minimum hamming distance such that xG0t = 0
	G0t = @transpose(G0)
	constraints = []
	for column in [0..@width(G0t)-1]
		constraint = {elements: [], mustXorTo: 0}
		for row in [0..@height(G0t)-1]
			if G0t[row][column] == 1 
				constraint.elements.push row
		constraints.push constraint
	x = @solveConstraintsMinimally(@height(G0t), constraints, false, true)
	# d0 = min hammingWeight(x) for x != 0, xG0^T = 0
	d0 = @hammingWeight([x])

	# Use the magic constraints matrix solver to find the vector x with minimum hamming distance such that xHt = 0
	constraints = []
	for column in [0..@width(Ht)-1]
		constraint = {elements: [], mustXorTo: 0}
		for row in [0..@height(Ht)-1]
			if Ht[row][column] == 1 
				constraint.elements.push row
		constraints.push constraint
	x = @solveConstraintsMinimally(@height(Ht), constraints, false, true)
	# d1 = min hammingWeight(x) for x != 0, xH^T = 0
	d1 = @hammingWeight([x])

	t = Math.max(d0 - 1, 0)
	u = Math.floor(d1/2-0.5)

	return {u: u, t: t}


@verifyMLBCCorrectness = (G, G0, G1, Ht, Jt, n, k, l, r) ->
	correct = true
	@debugOutput "Now we verify the various requirements of the code"
	if ! @equalMatrix(@multiplyMatrices(G0, Jt), @newMatrix(l, k))
		@debugOutput "ERROR: G0 * Jt != 0" 
		correct = false
	else 
		@debugOutput "G0 * Jt == 0" 
	if ! @equalMatrix(@multiplyMatrices(G1, Jt), @identity k)
		@debugOutput "ERROR: G1 * Jt != Ik" 
		correct = false
	else 
		@debugOutput "G1 * Jt == Ik" 
	if ! @equalMatrix(@multiplyMatrices(G, Ht), @newMatrix(k+l, r))
		@debugOutput "ERROR: G * Ht != 0" 
		correct = false
	else 
		@debugOutput "G * Ht == 0" 
	if @rowRank(G) != (k+l)
		correct = false
		@debugOutput "G's rank is too small (rank: " + @rowRank(G) + ", goal: " + (k+l) + ")"
	else
		@debugOutput "RowRank(G) == " + @rowRank(G)
	# if @rowRank(Ht) != n
	# 	correct = false
	# 	@debugOutput "H's rank is too small (rank: " + @rowRank(Ht) + ", goal: " + n + ")"
	# else
	# 	@debugOutput "RowRank(Ht) == " + @rowRank(Ht) 
	return correct

@oldTest = (mlbc) ->

	console.log "Running our old tests"

	# d1 = min hammingWeight(x) for x != 0, xH^T = 0
	d1 = 99999999
	d0 = 99999999
	G0t = @transpose mlbc.G0
	rZerosVector = @newMatrix(1, mlbc.r)
	lZerosVector = @newMatrix(1, mlbc.l)

	current = 1
	while current < Math.min(mlbc.n, Math.max(d0, d1))
		@debugOutput "current: " + current + " d0: "+d0 + " d1: "+d1
		allZeros = true #First returned vector will be all zeros. Spec says this isn't allowed. Filter it out.

		for vector in allSparceVectorsWithMaxOnes(mlbc.n, current) #Sparce format needs conversion
			x = [@sparceVectorToVector(vector, mlbc.n)] #Give it the sparce format and it's length
			if !allZeros
				Hwx = current
				if Hwx < d1
					if @equalMatrix(@multiplyMatrices(x, mlbc.Ht), rZerosVector)
						d1 = Math.min(Hwx, d1)
				if Hwx < d0
					if @equalMatrix(@multiplyMatrices(x, G0t), lZerosVector)
						d0 = Math.min(Hwx, d0)
				break if (d0 == 0) && (d1 == 1)
			else
				allZeros = false
		current++

	u = Math.floor(d1/2-0.5)
	t = Math.max(d0 - 1, 0)

	console.log "This code can fix any " + u + " error(s), aka withstand up to " + Math.round((u*100/mlbc.n)*10)/10 + "% error rate"
	console.log "This code can withstand any " + t + " stuck bit(s), aka withstand up to " + Math.round((t*100/mlbc.n)*10)/10 + "% wet rate"	

@toBin = (str) ->
	arr = []
	len = str.length
	for i in [1..len]
		d = str.charCodeAt(len-i)
		for j in [0..7]
			st = d%2 == '0' ? "class='zero'" : "" 
			arr.push d%2 
			d = Math.floor(d/2)
	arr.reverse()

@toStr = (bin) ->
	ascii_string = ''
	if (bin.length % 8 != 0) 
		return 'Binary length is not divisible by eight.'
	else
		to = (bin.length/8)-1
		for i in [0..to]
			current_byte = bin.slice(i*8, (i*8)+8).join('')
			ascii_string += String.fromCharCode(parseInt(current_byte, 2))
		return ascii_string

@decodeLongMessage = (MLBC, stream) ->
	console.log MLBC
	lastDecodedChar = undefined
	decodedBinaryInCode = []
	i = 0
	while lastDecodedChar != "`" && stream.length > MLBC.n
		encodedMessage = stream.splice(0,MLBC.n)
		decodedBinaryPartInCode = @decodeMessage(MLBC, [encodedMessage])[0]
		decodedBinaryInCode = decodedBinaryInCode.concat decodedBinaryPartInCode
		decodedBinary = []
		if 0 < Math.floor(decodedBinaryInCode.length/3)-1
			for blockIndex in [0..Math.floor(decodedBinaryInCode.length/3)-1]
				bitTotal = decodedBinaryInCode[blockIndex*3] + decodedBinaryInCode[blockIndex*3+1] + decodedBinaryInCode[blockIndex*3+2]
				console.log "Received "+Math.floor(bitTotal/3 + 0.5)+" from "+decodedBinaryInCode[blockIndex*3]+""+decodedBinaryInCode[blockIndex*3+1]+""+decodedBinaryInCode[blockIndex*3+2]
				decodedBinary.push Math.floor(bitTotal/3 + 0.5)
		console.log decodedBinary.toString()
		lastDecodedBlockEnd = 8*Math.floor(decodedBinary.length/8) - 1
		if lastDecodedBlockEnd > 0
			messageSoFar = @toStr decodedBinary[0..lastDecodedBlockEnd]
			console.log messageSoFar
			lastDecodedChar = messageSoFar[messageSoFar.length-1]
			if lastDecodedChar != "`" && isNaN(parseInt(lastDecodedChar))
				console.log "The header is corrupt or there is nothing there."
				return
		if i > 1000
			console.log "The header is corrupt or there is nothing here."
			return
		i++

	if stream.length < MLBC.n && lastDecodedChar != "`"
		console.log "The header was corrupt. We reached the end of the stream without seeing `."
		return

	messageBlocks = parseInt(messageSoFar[0..messageSoFar.length-2])
	if isNaN(messageBlocks)
		console.log "The header was corrupt. Fail."
		return
	else
		console.log "The message is "+messageBlocks+" long"

	decodedBinary = []
	for i in [0..messageBlocks-1]
		console.log "i: "+i
		encodedMessage = stream.splice(0,MLBC.n)
		console.log "We're decoding: "+encodedMessage.toString()
		decodedBinaryPart = @decodeMessage(MLBC, [encodedMessage])
		decodedBinary = decodedBinary.concat decodedBinaryPart[0]
		console.log "It decoded to "+decodedBinaryPart.toString()
		console.log "So far we have "+decodedBinary.toString()
	#Discard the padding we did
	decodedBinary = decodedBinary[0..8*Math.floor(decodedBinary.length/8)-1]
	console.log "Message received: " + @toStr decodedBinary
	@toStr decodedBinary

@encodeLongMessage = (MLBC, message, stream) ->
	console.log "The stream is: "+stream.toString()
	messageBin = @toBin message
	while (messageBin.length%MLBC.k != 0)
		messageBin.push 0
	length = messageBin.length / MLBC.k # This is the length of the message to be sent in binary
	console.log "The encoded message (without header) to be sent is "+length+" chunks long"
	header = @toBin (length + "`")
	encodedHeader = []
	for i in [0..header.length-1]
		encodedHeader.push header[i]
		encodedHeader.push header[i]
		encodedHeader.push header[i]
	messageBin = encodedHeader.concat(messageBin)
	console.log "We're gonna encode and transmit: "+messageBin.toString()
	messages = []
	for i in [0..messageBin.length/MLBC.k - 1] # Break it up into k-bit messages
		messages[i] = []
		messages[i][0] = messageBin.slice(i*MLBC.k, (i*MLBC.k)+MLBC.k)
	encodedMessage = []
	for i in [0..messages.length-1]
		streamSection = stream.splice(0, MLBC.n)
		encodedSection = @encodeMessage(MLBC, messages[i], streamSection)
		encodedMessage = encodedMessage.concat encodedSection
		console.log "Encoding: "+messages[i][0].toString()+" as "+encodedSection.toString()
	console.log "The total message to be sent is "+encodedMessage.length+" bits long and is "+encodedMessage.toString()
	return encodedMessage

@encodeMessage = (MLBC, message, stream) ->
	encodedMessage = @multiplyMatrices(message, MLBC.G1)
	@minimizeWetBits(MLBC.G0, [stream], encodedMessage)[0]

@getElemsFromArray = (arr, elems, n) ->
	elems.reverse()
	result = []
	for i in [0..n-1]
		result.push arr[elems.pop()]
	elems.reverse()
	return result

@decodeMessage = (MLBC, y) ->
	n = MLBC.n
	k = MLBC.k
	G1 = MLBC.G1
	Ht = MLBC.Ht
	Jt = MLBC.Jt

	S = @multiplyMatrices(y, Ht)
	@debugOutput "S = yH^t = " + @matrixString S

	# To decode we must find z with minimum hamming distance such that zHt = S

	# Use the magic constraints matrix solver to find the vector z with minimum hamming distance such that zHt = S
	constraints = []
	for column in [0..@width(Ht)-1]
		constraint = {elements: [], mustXorTo: S[0][column]}
		for row in [0..@height(Ht)-1]
			if Ht[row][column] == 1 
				constraint.elements.push row
		constraints.push constraint
	z = [@solveConstraintsMinimally(@height(Ht), constraints, true, true)]
	zHammingWeight = @hammingWeight(z)

	# # attempt = Math.floor(n/8)
	# maxOnes = errorCount #Since we're modelling, lets just go ahead and use the right value.
	# while z == undefined && maxOnes <=n
	# 	minDist = 99999999
	# 	for vector in @allSparceVectorsWithMaxOnes(n, maxOnes)
	# 		z = [@sparceVectorToVector(vector, n)]
	# 		fail = false
	# 		for column in [0..@width(Ht)-1]
	# 			if @multiplyMatricesAtPos(z, Ht, 0, column) != S[0][column]
	# 				fail = true
	# 				break
	# 		if fail == false
	# 			distance = hammingWeight(z)
	# 			if distance < minDist
	# 				minDist = distance
	# 				minz = z
	# 			break if minDist == 0
	# 	z = minz
	# 	if z == undefined
	# 		maxOnes += 1
	# 		console.log "Generating vectors with " + attempt + " or more 1s"

	# This version is less optimised but more clear
	# # attempt = Math.floor(n/8)
	# attempt = errorCount
	# while z == undefined && attempt <=n
	# 	minDist = 99999999
	# 	for z in @allColumnsWithMaxHammingDist(n, attempt)
	# 		zHt = @multiplyMatrices(z,Ht)
	# 		if @equalMatrix(zHt, S)
	# 			distance = hammingWeight(z)
	# 			if distance < minDist
	# 				minDist = distance
	# 				minz = z
	# 			break if minDist == 0
	# 	z = minz
	# 	if z == undefined
	# 		attempt += 1
	# 		console.log "Generating vectors with " + attempt + " or more 1s"

	@debugOutput "Errors minimised by z = " + (@matrixString z) + " with hammingWeight " + zHammingWeight

	xNew = @addMatrices(y, z)
	@debugOutput "Attempted to fix errors, xNew = " + @matrixString xNew

	xNewJt = @multiplyMatrices(xNew, Jt)
	@debugOutput "Recovered message w' = xNewJt = " + @matrixString xNewJt

	return xNewJt

@testMLBC = (MLBC, errorRate) ->
	n = MLBC.n
	k = MLBC.k
	G1 = MLBC.G1
	Ht = MLBC.Ht
	Jt = MLBC.Jt

	# Generate a message to send
	w = @newRandomMatrix(1, k)
	@debugOutput "\nNow we encode w = " + @matrixString w

	# Encode the message - this is simply x = @multiplyMatrices(w, G1)
	x = @encodeMessage(MLBC, w)
	@debugOutput "x = wG1 = " + @matrixString x

	# Generate some errors
	y = x 
	errorCount = 0
	for i in [0..y[0].length-1]
		if Math.random() < errorRate
			y[0][i] = (y[0][i] + 1) % 2
			errorCount++
	@debugOutput "Introduced "+errorCount + " errors"
	@debugOutput "Now make " + @perc(errorRate) + " errors occur, let y = x + z = " + @matrixString y

	# Decode the message
	xNewJt = @decodeMessage(MLBC, y, errorCount) #Pass the errorCount as a hack to allow faster decoding.

	# Count the number of errors
	errors = 0
	for i in [0..@width(w)-1]
		errors += w[0][i] ^ xNewJt[0][i]
	@debugOutput errors + " errors occurred"

	return errors

@calculateOfficialRates = (times) ->
	result = []
	for n in [5..14]
		for k in [Math.max(Math.floor(n/6),1)..Math.round(2*n/3)-2]
			for l in [1..Math.round(2*(n-k)/3)-1]
				maxResults(n, k, l, times)
		
@bestMLBC = (n, k, l, times) ->
	u = 0
	t = 0
	success = false
	topScore = 0
	for i in [0..(times-1)]
		mlbc = @newMLBC(n,k,l, true)
		success = mlbc.success
		if success == true
			if (mlbc.u+mlbc.t)>topScore
				topScore = mlbc.u+mlbc.t
				u = mlbc.u
				t = mlbc.t
				bestMlbc = mlbc
		else break
	if success == true
		console.log n + ", " + k + ", " + l + ": " + @perc(u/n) + " error rate, " + @perc(t/n) + " wet bit rate"
	else
		console.log "fail"
	return bestMlbc

@testMLBCnTimes = (config) ->
	n = config.n; k = config.k; l = config.l; tests = config.tests; errorRate = config.errorRate; abandonRate = config.abandonRate; debug = config.debug; mlbcAttempts = config.mlbcAttempts;
	errorsExperiencedTotal = 0
	success = true
	attempt = 0
	mlbc = @bestMLBC(n,k,l, mlbcAttempts)
	for attempt in [1..tests]
		success = mlbc.success
		break if !success
		errorsExperiencedTotal += testMLBC(mlbc, errorRate)
		errorsExperiencedOnAverage = errorsExperiencedTotal/attempt
		errorRateSoFar = errorsExperiencedOnAverage/k
		console.log @perc(attempt/tests) + " complete. " + @perc(errorRateSoFar) + " error rate" if debug == true
		if errorRateSoFar > abandonRate
			success = false
			break
	if success
		errorsExperiencedOnAverage = errorsExperiencedTotal/tests
		console.log n+", "+k+", "+l+": " + @perc(errorsExperiencedOnAverage/k) + " error rate when experiencing "+@perc(errorRate)+" errors. Transmission rate: "+@perc(k/n)


@testRates = (config) -> 
	tests = config.tests
	errorRate = config.errorRate
	abandonRate = config.abandonRate
	result = []
	for n in [10..30]
		console.log "Now working on n = "+n
		for k in [1..Math.round(n/2)-2]
			for l in [Math.max(Math.floor(n/10),1)..Math.round((n-k)/4)-1]
				testMLBCnTimes({n: n, k: k, l: l, tests: tests, errorRate: errorRate, abandonRate: abandonRate, debug: false})

@decPlaces = (number, places) ->
	Math.round(number*Math.pow(10,places))/Math.pow(10,places)

@perc = (number) ->
	Math.round(number*10000)/100 + "%"

@debugOutput = (m) ->
	console.log m if @debug

# @mlbc = newRandomMLBC(10,2,2)

# @decodeLongMessageTest(mlbc, @encodeLongMessage(mlbc, "Hello"))