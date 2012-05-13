# Singleton
class @Interface

	## Private
	a = null

	constructor : (@parts) ->
		@b = $ 'body'

	init : (app) ->
		a = app

		@b.bind 'contextmenu', false

		do @loadParts
		do @bindParts

	linkAggregates : (@aggregates) ->

	loadParts : ->
		{parts} = @

		for type, selectors of parts
			for name, selector of selectors
				parts[type][name] = $ selector

	bindParts : ->
		{buttons, sections, lists} = @parts

		switcher = /switch/

		for button, dom of buttons
			if switcher.test button
				dom.bind 'click', ->
					for section, dom of sections then do dom.close

					key = @className.replace(switcher, '').toLowerCase()

					do sections[key].switch

		buttons.switchJournal.bind 'click', =>
			do @drawJournal

		buttons.switchLoader.bind 'click', =>
			do @drawLoader

		buttons.launchGame.bind 'click', ->
			for section, dom of sections then do dom.close
			do sections.game.switch

			do a.launchGame

		buttons.saveGame.bind 'click', ->
			do a.saveGame

		buttons.stopGame.bind 'click', ->
			for section, dom of sections then do dom.close
			do sections.menu.switch

			do a.stopGame

	showMessage : (text) ->
		message = make 'div'

		message.className   = 'message'
		message.textContent = text

		message.onclick = -> b.removeChild @

		b.appendChild message

	drawJournal : ->
		{inventory} = @aggregates
		{container} = inventory
		{blockList, weaponList} = @parts.lists

		do $('.item').destroy

		for type, quantity of container.blocks
			item = $.createRow(type, quantity)

			.attr
				id : type

			.addClass('item')

			.bind 'click', ->
				$(@parentNode.children).removeClass 'current'
				inventory.currentBlock = @id
				$(@).addClass 'current'

			item.addClass 'current' if type is inventory.currentBlock

			item.appendTo blockList

	# Draw App's loader
	drawLoader : ->
		{saveList} = @parts.lists

		do $('.item').destroy

		saves = a.getSaves()

		for key of saves
			$.createRow(key)

			.attr
				id : key

			.addClass('item')

			.bind 'click', ->
				a.loadGame @id

			.appendTo saveList