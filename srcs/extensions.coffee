global = window

#### paper.js
{paper} = global

## Point
{Point} = paper

# Make point from array
Array::point = ->
	new paper.Point @

## Project
{Project} = paper

# Patching Project::draw for translating without artefacts
draw = Project::draw

Project::draw = (context, matrix) ->
	{width, height, point} = @view.camera

	# Adding camera coordinates to zero point
	context.clearRect(point.x, point.y, width, height)
	
	draw.call(@, context, matrix)

## PaperScope
{PaperScope} = paper

global.request = do ->
	global.requestAnimationFrame or
	global.mozRequestAnimationFrame or
	global.webkitRequestAnimationFrame

global.cancel  = do ->
	global.cancelAnimationFrame or
	global.mozCancelAnimationFrame or
	global.webkitCancelAnimationFrame

class PaperScope::SpriteAnimation
	
	constructor : (@shape, @frames) ->
		@limit = @frames.length
		@index = 0
		@id    = 0

		@animate = =>
			@index = 0 if @index is @limit

			shape.image = frames[@index]

			@index++

	request : ->
		@id = request @animate

	cancel  : ->
		cancel @id

PaperScope::initCamera  = ->
	@view.camera = new @Camera @view._context

PaperScope::resetCamera = ->
	do @view.camera.revert

	@view.camera = null

class PaperScope::Camera

	constructor : (ctx) ->
		{@height, @width} = ctx.canvas

		@context = ctx

		do @reset

	reset : ->
		@point = [0, 0].point()

	revert : ->
		@translate @point.negate()

	translate : (vector) ->
		{x, y} = vector

		@context.translate -x, -y

		@point = @point.add vector