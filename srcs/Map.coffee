class @Map

	## Private
	cellSize  = 40 #[px]
	hcellSize = 20 #[px]
	qcellSize = 10 #[px]

	hollow = '0'
	dirt   = '1'
	stone  = '2'
	wood   = '3'

	translate = (type) ->
		switch type
			when dirt   then 'dirt'
			when stone  then 'stone'
			when wood   then 'wood'
			else null

	interpret = (id) ->
		switch id
			when 'dirt'   then dirt
			when 'stone'  then stone
			when 'wood'   then wood
			else null

	relativeFrom = (absolute) ->
		absolute.divide(cellSize).floor()

	absoluteFrom = (relative) ->
		relative.multiply cellSize

	## Public
	constructor : (mesh, @index) ->
		{@matrix, points} = mesh
		{width, height  } = @

		@points =
			'left'  : absoluteFrom points.player.first
			'right' : absoluteFrom points.player.last

		blocks = []
		
		height.times (y) ->
			blocks[y] = []
			width.times (x) ->
				blocks[y][x] = null

		@blocks = blocks

	checkX : (points..., direction) ->
		return points.every (point) =>
			relative = point.divide(cellSize).round()

			{x, y} = relative
			
			x += direction

			return @matrix[y]?[x] is hollow

	checkY : (points..., direction) ->
		return points.every (point) =>
			relative = relativeFrom point

			{x, y} = relative
			
			y += direction

			return @matrix[y]?[x] is hollow

	checkBorder : (point, side) ->
		relative = relativeFrom point

		{x} = relative

		return side is 'left' and x is 0 or side is 'right' and x is @width-1

	checkWidth  : (x) ->
		x = x/cellSize

		return x < @width

	checkHeight : (y) ->
		y = y/cellSize

		return y < @height

	destroy : ->
		@blocks.each (row) ->
			row.each (block) ->
				do block?.remove

	destroyBlockAt : (point) ->
		relative = relativeFrom point

		{x, y} = relative

		@matrix[y][x] = hollow

		do @blocks[y][x]?.remove

	blockAt : (point) ->
		relative = relativeFrom point

		{x, y} = relative

		type = @matrix[y]?[x]

		id = translate type

		return id

	putBlock  : (point, id, shape) ->
		return unless id or shape

		type     = interpret id
		relative = relativeFrom point

		shape.position = absoluteFrom(relative).add hcellSize

		{x, y} = relative

		@blocks[y][x] = shape
		@matrix[y][x] = type

	spawnBlock : (point, shape) ->
		relative = relativeFrom point

		shape.position = absoluteFrom(relative).add hcellSize

		{x, y} = relative

		@blocks[y][x] = shape

	@get 'height', ->
		@height_ ?= @matrix.height

	@get 'width',  ->
		@width_  ?= @matrix.width

	@get 'cellSize', -> cellSize

	@get 'absoluteFrom', -> absoluteFrom
	@get 'relativeFrom', -> relativeFrom