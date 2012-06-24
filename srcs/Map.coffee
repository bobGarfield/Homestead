class @Map

	## Private
	cellSize  = 40 #[px]
	hcellSize = 20 #[px]
	qcellSize = 10 #[px]

	translate = (number) ->
		switch number
			when '1' then 'dirt'
			when '2' then 'stone'
			when '3' then 'wood'
			else null

	interpret = (id) ->
		switch id
			when 'dirt'  then '1'
			when 'stone' then '2'
			when 'wood'  then '3'
			else null

	relativeFrom = (absolute) ->
		absolute.divide(cellSize).floor()

	absoluteFrom = (relative) ->
		relative.multiply cellSize

	## Public
	constructor : (mesh) ->
		{@matrix, @index, points} = mesh

		@points =
			'left'  : absoluteFrom points.player.first
			'right' : absoluteFrom points.player.last

	compose : (objectManager) ->
		{matrix} = @
		{width, height} = matrix

		filled = []

		matrix.each (row, y) ->
			filled[y] = []
			row.each (symbol, x) ->
				id = translate symbol
				block = objectManager.make('block', id) or null
				block?.coordinate = absoluteFrom([x, y].point()).add hcellSize

				filled[y][x] = block

		@matrix = filled

	decompose : ->
		{matrix} = @
		{width, height} = matrix

		empty = []

		matrix.each (row, y) ->
			empty[y] = []
			row.each (block, x) ->
				do block?.destroy

				empty[y][x] = interpret block?.id

		@matrix = empty

	checkX : (points..., direction) ->
		return points.every (point) =>
			relative = relativeFrom point.add hcellSize

			{x, y} = relative
			
			x += direction

			return @matrix[y]?[x] is null

	checkY : (points..., direction) ->
		return points.every (point) =>
			relative = relativeFrom point

			{x, y} = relative
			
			y += direction

			return @matrix[y]?[x] is null

	checkBorder : (point, side) ->
		relative = relativeFrom point

		{x} = relative

		return side is 'left' and x is 0 or side is 'right' and x is @width-1

	checkWidth  : (x) ->
		x /= cellSize

		return x < @width

	checkHeight : (y) ->
		y /= cellSize

		return y < @height

	delete : (point) ->
		return null unless block = @at point

		relative = relativeFrom point

		{x, y} = relative

		copy = block.clone()

		block.destroy()

		@matrix[y][x] = null

		return copy

	at : (point) ->
		relative = relativeFrom point

		{x, y} = relative

		return @matrix[y]?[x]

	insert : (block, point) ->
		return unless block

		relative = relativeFrom point

		block.coordinate    = absoluteFrom(relative).add hcellSize
		block.shape.visible = yes

		{x, y} = relative

		@matrix[y][x] = block

		console.log block

	@get 'height', ->
		@height_ ?= @matrix.height

	@get 'width',  ->
		@width_  ?= @matrix.width

	@get 'cellSize', -> cellSize

	@get 'absoluteFrom', -> absoluteFrom
	@get 'relativeFrom', -> relativeFrom

