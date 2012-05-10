# Singleton
class @EventManager
	
	## Private
	v = null
	t = null

	## Public
	constructor : ->

	init : (paper) ->
		{view, tool} = paper

		v = view
		t = tool

	setGameloopHandler : (callback) ->
		v.onFrame = callback

	setAnimationOnHandler : (callback) ->
		v.onFrame = callback

	setAnimationOffHandler : (callback) ->
		t.onKeyUp = callback

	setAttackHandler : (callback) ->
		t.onMouseDrag = (event) ->
			return unless event.event.button is 0

			callback event

	setAlternativeHandler : (callback) ->
		t.onMouseDown = (event) ->
			return unless event.event.button is 2

			callback event

