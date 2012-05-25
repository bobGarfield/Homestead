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
			do @buildJournal

		buttons.switchLoader.bind 'click', =>
			do @buildLoader

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
		$.create('div')

		.attr
			class : 'message'

		.bind 'click', ->
			@parentNode.removeChild @

		.text(text)

		.appendTo @b

	createItem : (type, id) ->
		{inventory} = @aggregates
		{container} = inventory

		item = $.createRow(id, (container["#{type}s"][id]?.length or 'used'))

		.attr
			'id' : id

		.addClass('item')

		.bind 'click', ->
			$(@parentNode.children).removeClass 'current'
			inventory.select type, @id
			$(@).addClass 'current'

		item.addClass 'current' if inventory.used type, id

		console.log @parts.lists

		item.appendTo @parts.lists["#{type}List"]

	buildJournal : ->
		{inventory} = @aggregates
		{container} = inventory

		do $('.item').destroy

		for id of container.blocks
			@createItem 'block', id

		for id of container.equipments
			@createItem 'equipment', id

		for id of container.weapons
			@createItem 'weapon', id

		@createItem object.type, object.id for object in inventory.objects

	# Draw App's loader
	buildLoader : ->
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