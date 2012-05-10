## Global
global = window

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
	get : (      -> return @[@length-1]),
	set : ((val) -> @[@length-1] = val )

Array.both 'second',
	get : (      -> return @[1]),
	set : ((val) -> @[1] = val )

Array.both 'penult',
	get : (      -> return @[@length-2]),
	set : ((val) -> @[@length-2] = val )

Array.get 'width',  ->
	return @first.length

Array.get 'height', ->
	return @length

Array::rand = ->
	return @[@length.rand()]

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