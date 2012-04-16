namespace "Control", ->

	class @State
		constructor : (@data) ->
			@time = new Date

		stringify : ->
			{data} = @

			@data = JSON.stringify data

			return @

		parse     : ->
			{data} = @

			@data = JSON.parse data

			return @