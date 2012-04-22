## HTML Tags
row  = 'tr'
body = 'body'

## HTML events
onContextMenu = 'oncontextmenu'

## CSS Classes
itemClass        = 'item'
savegameClass    = 'savegame'
currentItemClass = 'currentItem'

## Constant interface elements
elements =
	# Sections
	menu    : '#menu'
	loader  : '#loader'
	options : '#options'
	game    : '#game'
	journal : '#journal'
	ingame  : '#ingame'
	
	# Other Elements
	inventoryList : '#inventoryList'
	loaderList    : '#loaderList'

## Constant buttons
buttons = 
	startGame     : '.startGame'
	saveGame      : '.saveGame'
	switchJournal : '.switchJournal'
	switchLoader  : '.switchLoader'
	openOptions   : '.openOptions'
	openGame      : '.openGame'
	openMenu      : '.openMenu'
	openIngame    : '.openIngame'

## Auxiliary functions

# Make an item in list
makeItem = (args...) ->
	item = make row

	args.each (text, index) ->
		cell = item.insertCell index
		cell.textContent = text

	return item


class @Interface
	
	constructor : ->
		preventDefaults($(body), onContextMenu)

	importElements : ->
		# Every interface element must single
		for id of elements
			elements[id] = $(elements[id])

		# Every button may not be single, so we must get each element
		for type of buttons
			buttons[type] = $$(buttons[type])

		@elements = elements
		@buttons  = buttons

	bindEvents : ->
		{buttons, elements, app} = @

		open   = @open.bind @
		prefix = /(open)/g

		for type, collection of buttons then do ->
			collection.each (button) ->
				section = elements[type.replace(prefix, '').toLowerCase()]

				# Check if button is special
				return unless section

				button.onclick = -> open section

		# Setting up special handlers
		buttons.startGame.each (button) =>
			button.onclick = =>
				open elements.game

				do app.start

		buttons.saveGame.each (button) =>
			button.onclick = =>
				do app.saveGame

		buttons.switchJournal.each (button) =>
			button.onclick = =>
				open elements.journal

				do @drawJournal

		buttons.switchLoader.each (button) =>
			button.onclick = =>
				open elements.loader

				do @drawLoader

	# Init interface
	init : (@app) ->
		do @importElements
		do @bindEvents

		# Setting current section to menu section
		@current = @elements.menu
		
	# Make section current
	open : (section) ->
		{current} = @

		toggleDisplay current, 'none'
		toggleDisplay section, 'block'

		@current = section

	## Dom operations

	# Draw player's journal
	drawJournal : ->
		{container         } = @
		{inventoryList     } = @elements

		removeItemsFrom inventoryList

		for id, quantity of container.blocks
			item = makeItem(id, quantity)

			item.id        = id
			item.className = id is container.current && currentItemClass || itemClass

			item.onclick = ->
				resetClassNamesFor inventoryList.children

				container.current = @id
				@className        = currentItemClass

			inventoryList.appendChild item

	# Draw App's loader
	drawLoader : ->
		{app       } = @
		{loaderList} = @elements

		saves = app.getSaves()

		removeItemsFrom loaderList

		for time of saves
			item = makeItem(time)

			item.id = time
			item.className = savegameClass

			item.onclick = -> 
				app.loadGame @id

			loaderList.appendChild item