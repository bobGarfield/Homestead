# Singleton
class @ShapeManager

	## Private
	p = null
	s = null
	
	## Public
	constructor : ->

	init : (paper, storage) ->
		p = paper
		s = storage

	makeBlock : (id) ->
		texture = s.consecutiveTextures(id).rand()

		return new p.Raster texture

	makeCreature : (id) ->
		texture = s.textures[id]

		return new p.Raster texture

	makeRay : (color, from, to) ->
		ray = new p.Path.Line from, to
		ray.strokeColor = color

		setTimeout (=> ray.remove()), 25





