## HTML Tags
row  = 'tr'
body = 'body'

## HTML events
onContextMenu = 'oncontextmenu'

## CSS Classes
itemClass        = 'item'
currentItemClass = 'currentItem'

## Auxiliary functions

# Make an item in list
makeRow = (id, quantity) ->
	item = make(row, itemClass, id)

	nameCell                 = item.insertCell 0
	nameCell.textContent     = id

	quantityCell             = item.insertCell 1
	quantityCell.textContent = quantity

	return item

class @Interface
	
	constructor : ->
		preventDefaults($(body), onContextMenu)

	importElements : ->
		{buttons, elements} = @

		# Every interface element must single
		for elem of elements
			elements[elem] = $(elements[elem])

		# Every button may not be single, so we must get each element
		for elem of buttons
			buttons[elem] = $$(buttons[elem])

	bindEvents : ->
		{buttons, elements, app} = @

		open = @open.bind @

		# Binding onclick event for startGame buttons
		elements.journal.onopen = =>
			do @drawJournal

		# Binding onclick event for startGame buttons
		buttons.bStartGame.each (button) ->
			button.onclick = ->
				open elements.game
				do app.start

				# Rebinding
				@textContent = 'Continue'
				@onclick     = ->
					open elements.game

		# Binding onclick event for openOptions buttons
		buttons.bOpenOptions.each (button) ->
			button.onclick = ->
				open elements.options

		# Binding onclick event for openJournal buttons
		buttons.bOpenJournal.each (button) ->
			button.onclick = ->
				open elements.journal

				do elements.journal.onopen

		# Binding onclick event for openGame buttons
		buttons.bOpenGame.each (button) ->
			button.onclick = ->
				open elements.game

		# Binding onclick event for openMenu buttons
		buttons.bOpenMenu.each (button) ->
			button.onclick = ->
				open elements.menu

	# Init interface
	init : (@app, @elements, @buttons) ->
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
		{container} = @
		{list     } = @elements

		removeRowsFrom list

		for id, quantity of container.blocks
			item = makeRow(id, quantity)

			item.className = currentItemClass if id is container.current

			item.onclick = ->
				resetClassNamesFor list.children

				container.current = @id
				@className        = currentItemClass

			list.appendChild item

		# TODO: Items visualization in next version
