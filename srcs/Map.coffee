## Constants
cellSize = 40 #[px]

## Materials
hollow = 0
dirt   = 1
stone  = 2
wood   = 3

## Functions

# Interpret block type to block name
interpret = (type) ->
	switch type
		when 1 then dirt
		when 2 then stone
		when 3 then wood

# Translate block name to block type
translate = (name) ->
	switch name
		when dirt  then 1
		when stone then 2
		when wood  then 3

# Get relative coordinates from absolute coordinates
getRelative = (abs) ->
	rel = abs.multiply(1/cellSize).floor()

class @Map
		
	constructor : (@matrix) ->
		@spawnPoint = matrix.spawnPoint.multiply(cellSize)
		@cellSize   = cellSize

		@blocks = []

		@height.times (y) =>
			@blocks[y] = []
			@width.times (x) =>
				@blocks[y][x] = hollow


	checkX : (point, side) ->		
		# Here we have to use round, because player shape
		# must not collide with block shape
		rel = point.multiply(1/cellSize).round()

		x   = rel.x + side
		y   = rel.y

		return @matrix[y][x] is hollow

	checkY : (point, side) ->
		rel = getRelative point

		x   = rel.x
		y   = rel.y + side

		return @matrix[y][x] is hollow

	destroyBlockAt : (point) ->
		rel = getRelative point

		x   = rel.x
		y   = rel.y

		@matrix[y][x] = hollow

		do @blocks[y][x].remove

	blockAt : (point) ->
		point.x -= cellSize/2

		rel = getRelative point

		x = rel.x
		y = rel.y

		type = @blocks[y][x]
		name = interpret type

		return name

	putBlockTo : (coord, block) ->


	@get 'height', ->
		@height_ ?= @matrix.length

	@get 'width',  ->
		@width_  ?= @matrix[0].length