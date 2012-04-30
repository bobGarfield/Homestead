namespace 'Player', ->
	## Constants
	height = 80 #[px]

	## Import
	{Inventory} = @

	class @Hero
		constructor : ->
			@inventory = new Inventory
			
			@shape = null
			@coord = null

		spawn : (@coord) ->
			@shape.position = coord

		move : (dist) ->
			@shape.position.x += dist
			@coord.x += dist

		jump : (height) ->
			@shape.position.y += height
			@coord.y += height

		fall : (height) ->
			@shape.position.y += height
			@coord.y += height

		reset : ->
			do @shape.remove

			@coord     = null
			@shape     = null

			@inventory = new Inventory

		@get 'head', ->
			head    = @coord.clone()
			head.y -= height/2

			return head

		@get 'body', ->
			body = @coord
			
			return body