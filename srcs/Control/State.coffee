namespace "Control", ->

	class @State
		constructor : (data) ->
			@time = new Date

			{matrix, index} = data.location
			{coord        } = data.player 
			{container    } = data.player.inventory
			{camera       } = data
			
			location = 
				'_matrix' : matrix
				'_index'  : index
			
			player   =
				'_coord'     : coord
				'_container' : container

			view     =
				'_camera' : camera

			@data    = 
				'location' : location
				'player'   : player
				'view'     : view

		stringify : ->
			{time, data} = @

			@data = JSON.stringify data

			return @

		parse     : ->
			{time, data} = @

			@data = JSON.parse data

			return @