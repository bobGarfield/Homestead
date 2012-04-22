namespace "Resources", ->
	
	class @Registrator

		constructor : ->
			@pack = []

		register : (someData) ->
			data = parseArray arguments

			@pack.push data...