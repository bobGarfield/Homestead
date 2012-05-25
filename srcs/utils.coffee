## Global
global = window

# Make namespace
global.namespace = (name, body) ->
	space = @[name] ?= {}
	space.namespace ?= global.namespace
	body.call space

# Alias for atom.dom
global.$ = atom.dom

## Function + Atom

# Define setter
Function::set = (prop, callback) ->
	atom.accessors.define @::, prop, 'set' : callback
	
# Define getter
Function::get = (prop, callback) ->
	atom.accessors.define @::, prop, 'get' : callback

# Define both setter and getter
Function::access = (prop, opts) ->
	atom.accessors.define @::, prop,
		'set' : opts.set
		'get' : opts.get

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

## String
String::up = ->
	return @toUpperCase()

String::upFirst = ->
	return @[0].toUpperCase() + @[1...]

String::low = ->
	return @toLowerCase()

## Array

# Short forEach
Array::each = Array::forEach

Array.access 'first',
	get : (      -> return @[0]),
	set : ((val) -> @[0] = val )

Array.access 'last',
	get : (      -> return @[@length-1]),
	set : ((val) -> @[@length-1] = val )

Array.access 'second',
	get : (      -> return @[1]),
	set : ((val) -> @[1] = val )

Array.access 'penult',
	get : (      -> return @[@length-2]),
	set : ((val) -> @[@length-2] = val )

Array.get 'width',  ->
	return @first.length

Array.get 'height', ->
	return @length

Array::rand = ->
	return @[@length.rand()]

global.resetClassNamesFor = (elements) ->
	elements.each (element) ->
		element.className = ''

atom.dom.createRow = (texts...) ->
	row = $.create 'tr'

	texts.each (text) ->
		col = $.create 'td'
		col.text text
		col.appendTo row.first

	return row

atom.dom::switch = ->
	@removeClass 'invisible'

atom.dom::close = ->
	@addClass 'invisible'
