class DynamicObject
	constructor : ->

	set : (state) ->

class @Container extends DynamicObject
	constructor : ->
		@blocks = @items = {}

	set : (state) ->
		for index, data of state
			@[index] = data

	putBlock : (id) ->
		@blocks[id] ?= 0

		@blocks[id]++

	putItem : (id) ->
		@items[id] ?= 0

		@items[id]++
