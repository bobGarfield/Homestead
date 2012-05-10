# Singleton
class @AnimationManager

	## Private
	p = null

	## Public
	constructor : ->

	init : (paper) ->
		p = paper

	makeAnimation : (shape, id, sprites) ->
		@[id] = new p.SpriteAnimation shape, sprites

	request : (id) ->
		do @[id]?.request

	cancel  : (id) ->
		do @[id]?.cancel