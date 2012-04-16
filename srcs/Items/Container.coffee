namespace 'Items', ->

	class @Container
		constructor : ->
			# Blocks and Items must be sorted
			@blocks = @items = {}

		# Apply other container
		set : (container) ->
			for index, data of container
				@[index] = data

		# Put block to blocks
		putBlock : (id) ->
			# 0 if undefined
			@blocks[id] ?= 0

			++@blocks[id]

		# Put item to items
		putItem : (id) ->
			# 0 if undefined
			@items[id] ?= 0

			++@items[id]
