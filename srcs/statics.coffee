class StaticObject
	constructor : (stats, @shape) ->
		for property, value of stats
			@[property] = value

	hide : ->
		@shape.visible = no

	show : ->
		@shape.visible = yes

	destroy : ->
		do @shape.remove

	clone : ->
		stats = {}

		for property, value of @ then do ->
			if typeof value isnt 'function'
				stats[property] = value

		copy = new @constructor stats

		copy.shape = @shape.clone()

		copy.hide()

		return copy
		
	pack : ->
		data = {}
		
		for property, value of @ then do ->
			if typeof value isnt 'function'
				data[property] = value unless property is 'shape' or property is 'coordinate'
		
		return data

	@access 'coordinate',
		get : ->
			return @shape.position
		set : (point) ->
			@shape.position = point

class @Equipment extends StaticObject
	constructor : (stats, @shape) ->
		super

class @Weapon extends StaticObject
	constructor : (stats, @shape) ->
		super

class @Block extends StaticObject
	constructor : (stats, @shape) ->
		super
