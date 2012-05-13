block = /(dirt|stone|wood)/

class @Inventory

	constructor : ->
		@container = new Container

		@currentBlock = null
		@currentItem  = null

	put : (id) ->
		return unless id

		if block.test id
			@container.putBlock id
		else
			@container.putItem  id

	takeBlock : ->
		{blocks      } = @container
		{currentBlock} = @

		return blocks[currentBlock] and blocks[currentBlock]-- and currentBlock or null

	takeWeapon : (id) ->
		{items} = @container

		@currentItem = items[id] or null