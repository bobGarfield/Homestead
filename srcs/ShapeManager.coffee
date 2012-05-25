# Singleton
class @ShapeManager

	## Private
	p = null
	s = null

	makeBlock = (block) ->
		texture = s.consecutiveTextures(block.id).rand()

		return new p.Raster texture

	makeObject = (object) ->
		texture = s.textures[object.id]

		raster = new p.Raster texture
		raster.visible = no

		return raster
	
	## Public
	constructor : ->

	init : (paper, storage) ->
		p = paper
		s = storage

	make : (data) ->
		if data.type is 'block'
			makeBlock  data
		else
			makeObject data

	drawRay : (color, from, to) ->
		ray = new p.Path.Line from, to
		ray.strokeColor = color

		setTimeout (=> ray.remove()), 25





