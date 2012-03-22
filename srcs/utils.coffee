global ?= window

## Dom

# Short querySelector
global.$ = (query) ->
	global.document.querySelector(query)

# Set display style
global.toggleDisplay = (element, type) ->
	element.style.display = type

global.preventDefaults = (element, event) ->
	element[event] = ->
		return false

global.make = (tag) ->
	return global.document.createElement tag

## Number

# Get random number less than @
Number::rand = ->
	Math.floor Math.random()*@

# Call callback @ times
Number::times = (callback) ->
	callback(i) for i in [0...@] by 1
	return

# Floor @
Number::floor = ->
	Math.floor @

# Round @
Number::round = ->
	Math.round @

## Global

# Make namespace
global.namespace = (name, body) ->
	space = @[name] ?= {}
	space.namespace ?= global.namespace
	body.call space

## Array + Paper

# Make point/vector from array
Array::point = ->
	new global.paper.Point @

# Short forEach
Array::each = ->

## Paper

# Patching Project::draw for translating without artefacts
draw = global.paper.Project::draw

global.paper.Project::draw = (context, matrix) ->
	camera = @view.camera
	size   = @view.size

	context.clearRect(camera.x, camera.y, size.width, size.height)
	
	draw.call(@, context, matrix)

# paper.View::scrollBy canvas analog
global.paper.View::translate = (point) ->
	x = point.x
	y = point.y

	@_context.translate x, y
	
	@camera.x -= x
	@camera.y -= y

# Multiply
global.paper.Point::multiply = (n) ->
	new global.paper.Point @x*n, @y*n

# Add
global.paper.Point::floor = ->
	new global.paper.Point @x.floor(), @y.floor()

## Accessor for Major Browsers
Function::set = (prop, callback) ->
	@::__defineSetter__ prop, callback
	
Function::get = (prop, callback) ->
	@::__defineGetter__ prop, callback

Function::duo = (prop, opts) ->
	@::__defineSetter__ prop, opts.set
	@::__defineGetter__ prop, opts.get 