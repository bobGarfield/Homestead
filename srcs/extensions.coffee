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
	{width, height, box} = @view.camera

	context.clearRect(box.x, box.y, width, height)
	
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

class PaperScope::Camera

	## Private
	context = null

	## Public
	constructor : (@ctx) ->
		{@height, @width} = ctx.canvas

		@point = [@width/2, @height/2].point()

	observe : (point) ->
		{width, height} = @

		p = point.clone()

		p.x = width/2  if p.x < width/2
		p.y = height/2 if p.y < height/2

		vector = p.subtract @point

		@translate vector

	reset : ->
		@translate @box.negate()

	translate : (vector) ->
		{x, y} = vector

		@ctx.translate -x, -y

		@point = @point.add vector

	@get "box", ->
		p = @point.clone()

		p.x -= @width/2
		p.y -= @height/2

		return p