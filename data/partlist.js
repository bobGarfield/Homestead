var partRegistrator = new Resources.Registrator

partRegistrator.register
(
	// Sections
	'#menu',
	'#loader',
	'#options',
	'#game',
	'#journal',
	'#ingame',
		
	// Other parts
	'#inventoryList',
	'#loaderList',

	// Special buttons
	'.launchGame',
	'.stopGame',
	'.saveGame',
	'.switchJournal',
	'.switchLoader',

	// Regular buttons
	'.openOptions',
	'.openGame',
	'.openMenu',
	'.openIngame'
)