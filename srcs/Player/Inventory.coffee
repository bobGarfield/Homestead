Container = @Items.Container

namespace 'Player', ->

	class @Inventory

		constructor : ->
			@container = new Container

		put : (thing) ->
			contr = @container
			digit = /\d/

			if digit.test thing
				contr.blocks[thing]++
			else
				contr.items.push thing