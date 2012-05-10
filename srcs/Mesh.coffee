## Regexp patterns
space = /\s/
digit = /\d/
empty = ''

class @Mesh
	
	## Private
	parse = (symbol) ->
		switch symbol
			when 'p' then 'player'

	## Public
	constructor : (essence) ->
		@points = {}
		@matrix = []

		@analyze essence

	analyze : (essence) ->
		{points, matrix} = @

		matrix = essence.split space

		matrix.each (row, y) ->
			row = matrix[y] = row.split empty

			row.each (symbol, x) ->
				if digit.test symbol
					row[x] = symbol
				else
					key = parse symbol

					points[key] ?= []
					
					points[key].push [x, y].point()

					row[x] = '0'

		@matrix = matrix