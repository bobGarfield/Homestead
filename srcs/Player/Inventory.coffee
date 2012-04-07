## Import
{Container} = @Items

## Auxiliary regexp patterns
block = /(dirt|stone|wood)/

namespace 'Player', ->

	class @Inventory

		constructor : ->
			@container = new Container
			@current   = null

		# Allocate and put item
		put : (id) ->
			return unless id

			if block.test id
				@container.putBlock id
			else
				@container.putItem  id

		# Return current block and decrease it's quantity
		takeBlock : ->
			{blocks, current} = @container

			if blocks[current]
				--blocks[current]
				
				return current