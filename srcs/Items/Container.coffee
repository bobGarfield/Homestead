namespace 'Items', ->

	class @Container
		constructor : ->
			# Blocks and Items must be sorted
			@blocks = {}
			@items  = {}

		# Put block to blocks
		putBlock : (id) ->
			# Checking if undefined
			@blocks[id] ?= 0

			++@blocks[id]

		# Put item to items
		putItem : (id) ->
			# Checking if undefined
			@items[id] ?= 0

			++@items[id]
