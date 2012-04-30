# Make an item in list
makeItem = (args...) ->
	item = make 'tr'

	args.each (text, index) ->
		cell = item.insertCell index
		cell.textContent = text

	return item

class @Interface
	
	constructor : ->

	init : (@app) ->
		preventDefaults $('body'), 'oncontextmenu'

		# Setting current section to menu section
		@current = @elements.menu

		do @bindEvents

	## Agregates operations

	# Link all parts
	linkParts : (pack) ->
		elements = {}
		buttons  = {}

		element = /#/
		button  = /\./

		pack.each (part) ->
			elements[part.replace element, ''] = $(part)  if element.test part
			buttons[part.replace button, '']   = $$(part) if button.test part

		@elements = elements
		@buttons  = buttons

	# Link agregates
	linkAggregates : (@aggregates) ->

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
		buttons.launchGame.each (button) =>
			button.onclick = =>
				open elements.game

				do app.launchGame

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

		buttons.stopGame.each (button) =>
			button.onclick = =>
				open elements.menu

				do app.stopGame

		return
		
	# Make section current
	open : (section) ->
		{current} = @

		toggleDisplay current, 'none'
		toggleDisplay section, 'block'

		@current = section

	## Dom operations

	# Draw player's journal
	drawJournal : ->
		{inventory    } = @aggregates
		{inventoryList} = @elements
		{container    } = inventory

		removeItemsFrom inventoryList

		for id, quantity of container.blocks
			item = makeItem(id, quantity)

			item.id        = id
			item.className = if id is inventory.current then 'currentItem' else 'item'

			item.onclick = ->
				resetClassNamesFor inventoryList.children

				inventory.currentBlock = @id
				@className = 'currentItem'

			inventoryList.appendChild item

	# Draw App's loader
	drawLoader : ->
		{app       } = @
		{loaderList} = @elements

		saves = app.getSaves()

		removeItemsFrom loaderList

		for time of saves
			item = makeItem time

			item.id = time
			item.className = 'savegame'

			item.onclick = -> 
				app.loadGame @id

			loaderList.appendChild item