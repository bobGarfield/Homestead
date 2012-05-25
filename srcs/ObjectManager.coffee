{Equipment, Weapon, Block} = @

# Singleton
class @ObjectManager

	## Private
	s = null

	## Public
	constructor : ->

	init : (storage, shapeManager, animationManager) ->
		s = shapeManager

		for id, object of storage.objects
			@[id] = object

			if object.animatable
				sprites = storage.consecutiveTextures id
				{shape} = @[id]

				animationManager.makeAnimation id, sprites

	make : (type, id) ->
		Type = switch type
			when 'equipment' then Equipment
			when 'weapon'    then Weapon
			when 'block'     then Block

		data = @[id]

		return unless data

		shape = s.make data

		return new Type data, shape