class @Registrator

	constructor : ->
		@pack = []

	register : (data...) ->
		@pack.push data...