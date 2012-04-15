global ?= window

## Global

# Swap two variables
global.swap = (one, two) ->
	temp = one

	one = two
	two = temp

# Make namespace
global.namespace = (name, body) ->
	space = @[name] ?= {}
	space.namespace ?= global.namespace
	body.call space

## Function

# Define setter
Function::set = (prop, callback) ->
	@::__defineSetter__ prop, callback
	
# Define getter
Function::get = (prop, callback) ->
	@::__defineGetter__ prop, callback

# Define both setter and getter
Function::both = (prop, opts) ->
	@::__defineSetter__ prop, opts.set
	@::__defineGetter__ prop, opts.get 

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

## Array

# Short forEach
Array::each = Array::forEach

Array.both 'first',
	get : (      -> return @[0]),
	set : ((val) -> @[0] = val )

Array.both 'last',
	get : (      -> return @[@length]),
	set : ((val) -> @[@length] = val )

Array.both 'second',
	get : (      -> return @[1]),
	set : ((val) -> @[1] = val )

Array.both 'penult',
	get : (      -> return @[@length-1]),
	set : ((val) -> @[@length-1] = val )

## Dom

# Short querySelector
global.$ = (query) ->
	global.document.querySelector(query)

# Short querySelectorAll
global.$$ = (query) ->
	global.document.querySelectorAll(query)

# Set display style
global.toggleDisplay = (element, type) ->
	element.style.display = type

global.preventDefaults = (element, event) ->
	element[event] = ->
		return false

# Short createElement
global.make = (tag, className = '', id = '') ->
	elem = global.document.createElement tag

	elem.id        = id
	elem.className = className

	return elem

global.resetClassNamesFor = (elements) ->
	elements.each (element) ->
		element.className = ''

# Iterator for NodeList
NodeList      ::each = Array::each
HTMLCollection::each = Array::each

# Remove all rows from table
global.removeItemsFrom = (table) ->
	while table.rows.length
		table.deleteRow 0

## Array + Paper

# Make point/vector from array
Array::point = ->
	new global.paper.Point @

## Paper

# Patching Project::draw for translating without artefacts
draw = global.paper.Project::draw

global.paper.Project::draw = (context, matrix) ->
	camera = @view.camera
	size   = @view.size

	# Adding camera coordinates to zero point
	context.clearRect(camera.x, camera.y, size.width, size.height)
	
	draw.call(@, context, matrix)

# paper.View::scrollBy more optimised analog
global.paper.View::translate = (point) ->
	{x, y} = point

	@_context.translate -x, -y
	
	@camera.x += x
	@camera.y += y

# Allias
global.paper.View::translateTo = global.paper.View::translate

global.paper.View::resetCamera = ->
	@camera = [0, 0].point()

global.paper.View::cancelTranslation = ->
	vector = [-@camera.x, 0].point()

	@translate vector

global.paper.View::applyTranslation = ->
	@translate @camera

# Multiply @
global.paper.Point::multiply = (n) ->
	new global.paper.Point @x*n, @y*n

# Divide @
global.paper.Point::divide = (n) ->
	new global.paper.Point @x/n, @y/n

# Floor @
global.paper.Point::floor = ->
	new global.paper.Point @x.floor(), @y.floor()