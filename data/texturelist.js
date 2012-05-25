var textureRegistrator = new Registrator;

4..times(function(i)
{
	textureRegistrator.register
	(
		'dirt' +i,
		'stone'+i
	);
});

6..times(function(i)
{
	textureRegistrator.register
		(
			'shirt'+i
		);
});

textureRegistrator.register
(
	'shirt',
	'helmet',
	
	'drill'
);