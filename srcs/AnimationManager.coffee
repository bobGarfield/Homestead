# Singleton
class @AnimationManager

	## Private
	p = null

	## Public
	constructor : ->

	init : (paper) ->
		p = paper

	makeAnimation : (id, sprites) ->
		@[id] = new p.SpriteAnimation sprites

	animate : (object) ->
		@[object.id].animate object.shape

	hold : (object) ->
		@[object.id].hold object.shape