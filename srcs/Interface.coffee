## Elements
raw    = 'tr'
column = 'td'

## Classes
item = 'item'

## Auxiliary functions

# Make a position in list
makeUnit = (id, text, number) ->
	elem = make raw
	elem.class = item
	elem.id    = id

	name = make column
	name.textContent = text

	num  = make column
	name.textContent = number

	elem.appendChild name

	console.log 'here'

class @Interface
	
	constructor : ->

	init : (@app, opts) ->
		for elem of opts
			@[elem] = $(opts[elem])

		@current = @menu

		@bStartGame.onclick = =>
			do @openGame
			do @app.start

		preventDefaults(@game, 'oncontextmenu')
		
	openGame : ->
		toggleDisplay @current, 'none'
		toggleDisplay @game,    'block'

		@current = @game

	openJournal : ->
		toggleDisplay @current, 'none'
		toggleDisplay @journal, 'block'

		@current = @journal

	drawContainer : (container) ->
		container.blocks.each (number, block) =>
			name   = makeName(block)

			makeUnit(block, name, number)
