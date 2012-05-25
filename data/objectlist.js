var objectRegistrator = new Registrator;

objectRegistrator.register({
	type  : 'equipment',
	place : 'body',
	id    : 'shirt',

	animatable : true,

	armor : 10
});

objectRegistrator.register({
	type : 'weapon',
	id   : 'drill',

	damage : 10
});

objectRegistrator.register({
	type  : 'equipment',
	place : 'head',
	id    : 'helmet',

	armor : 5
});

objectRegistrator.register({
	type : 'block',
	id   : 'dirt',

	health : 5
});

objectRegistrator.register({
	type : 'block',
	id   : 'stone',

	health : 10
});

