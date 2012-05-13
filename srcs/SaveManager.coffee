class @SaveManager

	constructor : ->
		do localStorage.clear

	save : (state) ->
		{key, data} = state.stringify()

		localStorage.setItem key, data

	load : (key) ->
		data = localStorage.getItem key

		return false unless data

		state = new State data, key

		return state

	@get 'saves', ->
		states = {}

		for key, data of localStorage
			states[key] = JSON.parse data

		return states