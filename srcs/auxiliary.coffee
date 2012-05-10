namespace "Maps", ->
	## Constants

	# Sizes
	cellSize  = @cellSize  = 40 #[px]
	hcellSize = @hcellSize = 20 #[px]
	qcellSize = @qcellSize = 10 #[px]

	# Materials
	hollow = @hollow = '0'
	dirt   = @dirt   = '1'
	stone  = @stone  = '2'
	wood   = @wood   = '3'

	# Interpret block type to block id
	@translate = (type) ->
		switch type
			when dirt   then 'dirt'
			when stone  then 'stone'
			when wood   then 'wood'
			else null

	# Translate block id to block type
	@interpret = (id) ->
		switch id
			when 'dirt'   then dirt
			when 'stone'  then stone
			when 'wood'   then wood
			else null

	# Get relative coordinates from absolute coordinates
	@relativeFrom = (absolute) ->
		absolute.divide(cellSize).floor()

		# Get absolute coordinates from absolute coordinates
	@absoluteFrom = (relative) ->
		relative.multiply(cellSize)
