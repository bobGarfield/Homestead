class DynamicObject
	constructor : ->

class @Container extends DynamicObject
	constructor : ->
		@blocks     = {}
		@weapons    = {}
		@equipments = {}

	set : (state) ->
		for index, data of state
			@[index] = data

	put : (object) ->
		return unless object

		{type, id} = object

		@["#{type}s"][id] ?= []

		@["#{type}s"][id].push object

	take : (type, id) ->
		vector = @["#{type}s"][id]

		if vector?.length
			object = vector.pop()

			delete @["#{type}s"][id] if vector.length is 0

			return object

