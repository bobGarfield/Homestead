{Inventory} = @

class @Player
	## Private
	shapeHeight = 80
	shapeWidth  = 40

	## Public
	constructor : ->
		@inventory = new Inventory

		@direction = 1

	init : (set, point) ->
		{inventory} = @

		inventory.init set

		@spawn point

	spawn : (point) ->
		@coordinate = point.clone()

	reverse : ->
		return unless ~@direction
		shape.scale -1, 1 for shape in @inventory.shapes
		@direction = -1

		@coordinate = @body

	straighten : ->
		return if ~@direction
		shape.scale -1, 1 for shape in @inventory.shapes
		@direction = 1

		@coordinate = @body

	move : (vector) ->
		@coordinate = @body.add vector

	pick : (objects...) ->
		{inventory} = @

		inventory.put object for object in objects

	@set 'coordinate', (point) ->
		{weapon, equipment} = @inventory

		@coordinate_ = point.clone()

		weapon.coordinate         = @hand
		equipment.head.coordinate = @head
		equipment.body.coordinate = @body

	@get 'body', ->
		return @coordinate_.clone()

	@get 'hand', ->
		point = @coordinate_.clone()

		point.x += 33*@direction
		point.y -= 11

		return point

	@get 'head', ->
		point = @coordinate_.clone()

		point.y -= 27

		return point



