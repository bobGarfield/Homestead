## Constants
cellSize  = 40         #[px]
hcellSize = cellSize/2 #[px]

## Blocks
hollow = '0'
dirt   = '1'
stone  = '2'
wood   = '3'

## Items
door       = 'd'
container  = 'c'

## Neighbor locations
left  = -1
right =  1

## Functions

# Interpret block type to block id
translate = (type) ->
	switch type
		when dirt   then 'dirt'
		when stone  then 'stone'
		when wood   then 'wood'
		else null

# Translate block id to block type
interpret = (id) ->
	switch id
		when 'dirt'   then dirt
		when 'stone'  then stone
		when 'wood'   then wood
		else null

namespace "Map", ->

	class @Location
		constructor : (@matrix, @index) ->
			@points = {}

			# TODO: Do something with this
			@points.left  = @absoluteFrom([3,         3].point())
			@points.right = @absoluteFrom([@width-4,  3].point())
			@points.end   = @absoluteFrom([@width-20, 0].point())

			@cellSize = cellSize
			@blocks   = []

			# Filling @blocks
			@height.times (y) =>
				@blocks[y] = []
				@width.times (x) =>
					@blocks[y][x] = null


		checkX : (point, side) ->
			# Here we have to use round
			relative = point.divide(cellSize).round()

			{x, y} = relative
			
			x += side

			return @matrix[y]?[x] is hollow

		checkY : (point, side) ->
			relative = @relativeFrom point

			{x, y} = relative
			
			y += side

			return @matrix[y]?[x] is hollow

		checkBorder : (point) ->
			relative = @relativeFrom point

			{x, y} = relative

			switch x
				# Left side
				when 0
					return left

				# Right side
				when @width-1
					return right

				# Nothing
				else
					return null

		# Check if x less than @width
		checkWidth  : (x) ->
			x = x/cellSize

			return x < @width

		# Check if y less than @height
		checkHeight : (y) ->
			y = y/cellSize

			return y < @height

		# Destroy block at point
		destroyBlockAt : (point) ->
			# Adjusting for one cell
			point = point.add(-cellSize/4)

			relative = @relativeFrom point

			{x, y} = relative

			@matrix[y][x] = hollow

			do @blocks[y][x]?.remove

		destroy : () ->
			@blocks.each (row) ->
				row.each (block) ->
					do block?.remove


		# Get block id at point
		blockAt : (point) ->
			relative = @relativeFrom point

			{x, y} = relative

			type = @matrix[y]?[x]
			
			return 'null' unless type

			id   = translate type

			return id

		# Put block to point
		putBlockTo  : (point, id, shape) ->		
			return unless shape

			type     = interpret id
			relative = @relativeFrom point

			# Adding, because it is center point
			shape.position = @absoluteFrom(relative).add(hcellSize)

			{x, y} = relative

			@matrix[y][x] = type
			@blocks[y][x] = shape

		# Spawn existing block
		spawnBlockAt : (point, shape) ->
			relative = @relativeFrom point

			# Adding, because it is center point
			shape.position = @absoluteFrom(relative).add(hcellSize)

			{x, y} = relative

			@blocks[y][x] = shape

		## Map-depending methods

		# Get relative coordinates from absolute coordinates
		relativeFrom : (absolute) ->
			absolute.divide(cellSize).floor()

		# Get absolute coordinates from absolute coordinates
		absoluteFrom : (relative) ->
			relative.multiply(cellSize)

		# Get absolute from relative coordinates
		floorFrom    : (absolute) ->
			@absoluteFrom absolute.divide(cellSize).floor()

		@get 'height', ->
			@height_ ?= @matrix.length

		@get 'width',  ->
			@width_  ?= @matrix[0].length