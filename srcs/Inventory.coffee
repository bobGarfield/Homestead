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
		
	extract : ->
		{equipment, weapon, block} = @
		
		{blocks, weapons, equipments} = @container
		
		packedBlocks     = {}
		packedWeapons    = {}
		packedEquipments = {}
		
		for id, array of blocks
			packedBlocks[id] = array.map (object) -> return object.pack()
			
		for id, array of weapons
			packedWeapons[id] = array.map (object) -> return object.pack()
			
		for id, array of equipments
			packedEquipments[id] = array.map (object) -> return object.pack()
		
		components =
			'used':
				'equipment':
					'head' : equipment.head.pack()
					'body' : equipment.body.pack()
				
				'weapon' : weapon.pack()
				'block'  : block or null
			
			'stored':
				'blocks'     : packedBlocks
				'weapons'    : packedWeapons
				'equipments' : packedEquipments
		
		console.dir components
		
		return components
		
	involve : (components, objectManager) ->
		{used, stored} = components
		{blocks, weapons, equipments} = @container
		
		object.destroy() for object in [@weapon, @equipment.body, @equipment.head]
		
		@weapon         = null
		@equipment.body = null
		@equipment.head = null
		
		for id, array of blocks
			array.each (object) -> object.destroy()
			
		for id, array of weapons
			array.each (object) -> object.destroy()
		
		for id, array of equipments
			array.each (object) -> object.destroy()
			
		@container.blocks     = {}
		@container.weapons    = {}
		@container.equipments = {}
		
		for sort, pack of stored
			for id, array of pack
				array.each (data) =>	
					@put objectManager.make data.type, data.id
					
		[used.weapon, used.equipment.head, used.equipment.body].each (data) =>
			{type, id} = data
			
			@put objectManager.make type, id
			@select type, id
			
		@select 'block', used.block
		
		console.dir @

	@get 'currentBlock', ->
		return @container.take 'block', @block

	@get 'shapes', ->
		[@equipment.body.shape, @equipment.head.shape, @weapon.shape]

	@get 'objects', ->
		[@equipment.body, @equipment.head, @weapon]