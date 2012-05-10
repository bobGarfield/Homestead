# Singleton
class @Interface

	## Private
	b = null
	a = null

	makeItem = (args...) ->
		item = make 'tr'

		args.each (text, index) ->
			cell = item.insertCell index
			cell.textContent = text

		return item
	
	constructor : ->
		b = $ 'body'

	init : (app) ->
		a = app

		@showMessage 'Now more interactive!'

		preventDefaults b, 'oncontextmenu'

		# Setting current section to menu section
		@current = @elements.menu

		do @bindEvents

	## Interactive

	# Show text message
	showMessage : (text) ->
		message = make 'div'

		message.className   = 'message'
		message.textContent = text

		message.onclick = -> b.removeChild @

		b.appendChild message

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
		{buttons, elements} = @

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

				do a.launchGame

		buttons.saveGame.each (button) =>
			button.onclick = =>
				do a.saveGame

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

				do a.stopGame

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
		{loaderList} = @elements

		saves = a.getSaves()

		removeItemsFrom loaderList

		for time of saves
			item = makeItem time

			item.id = time
			item.className = 'savegame'

			item.onclick = -> 
				a.loadGame @id

			loaderList.appendChild item