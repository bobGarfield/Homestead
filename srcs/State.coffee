class @State
	constructor : (@data, key) ->
		@key = key or (new Date).toString()

	stringify : ->	
		@data = JSON.stringify @data

		return @

	parse : ->
		@data = JSON.parse @data

		return @