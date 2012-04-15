textures = 
	# Terrain
	dirt0  : 'ress/textures/dirt0.png' ,
	dirt1  : 'ress/textures/dirt1.png' ,
	dirt2  : 'ress/textures/dirt2.png' ,
	dirt3  : 'ress/textures/dirt3.png' ,
	stone0 : 'ress/textures/stone0.png',
	stone1 : 'ress/textures/stone1.png',
	stone2 : 'ress/textures/stone2.png',
	stone3 : 'ress/textures/stone3.png',

	# Characters
	player        : 'ress/textures/player_right.png'    ,
	playerLeft    : 'ress/textures/player_left.png'     ,
	playerRun     : 'ress/textures/player_run_right.png',
	playerRunLeft : 'ress/textures/player_run_left.png'


namespace "Resources", ->

	class @Storage
		constructor : ->

		# Load images
		load : ->
			# Replacing strings with images
			for name of textures
				image     = new Image
				image.src = textures[name]
				
				textures[name] = image

			@textures = textures
