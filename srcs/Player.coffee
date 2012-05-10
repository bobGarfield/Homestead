{Inventory} = @

class @Player
	## Private
	shapeHeight = 80

	## Public
	constructor : (@inventory) ->		
		@shape = null
		@coord = null

		@inventory = new Inventory

	spawn : (point) ->
		@coordinate      = point.clone()
		@shape?.position = point.clone()

	move : (distance) ->
		@shape.position.x += distance
		@coordinate.x     += distance

	jump : (height) ->
		@shape.position.y += height
		@coordinate.y     += height

	fall : (height) ->
		@shape.position.y += height
		@coordinate.y     += height

	reset : ->
		do @shape.remove

	@get 'head', ->
		head    = @coordinate.clone()
		head.y -= shapeHeight/2

		return head

	@get 'body', ->
		return @coordinate