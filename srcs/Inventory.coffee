class @Inventory

	constructor : ->
		@container = new Container

		@block  = null
		@weapon = null

		@equipment =
			head : null
			body : null

	init : (set) ->
		{weapon    } = set
		{body, head} = set.equipment

		@put part for part in [body, head, weapon]

		@selectWeapon    weapon.id
		@selectEquipment head.id
		@selectEquipment body.id

	put : (object) ->
		return unless object
		@container.put object

	selectBlock : (id) ->
		return if id is @block?.id

		@block = id

	selectWeapon : (id) ->
		return if id is @weapon?.id

		do @weapon?.hide

		@weapon = @container.take 'weapon', id

		do @weapon.show

	selectEquipment : (id) ->
		{place} = @container.equipments[id].first
		current = @equipment[place]

		return if id is current?.id

		current?.hide()

		@container.put current
		@equipment[place] = @container.take 'equipment', id

		@equipment[place].show()

	select : (type, id) ->
		@["select#{type.upFirst()}"] id

	used : (type, id) ->
		{equipment, weapon, block} = @

		return [equipment.head, equipment.body, weapon, block].some (object) -> object?.id is id or object is id

	@get 'currentBlock', ->
		return @container.take 'block', @block

	@get 'shapes', ->
		[@equipment.body.shape, @equipment.head.shape, @weapon.shape]

	@get 'objects', ->
		[@equipment.body, @equipment.head, @weapon]