var igeClientConfig = {
	include: [
		'./js/entities/Grid.js',
		'./js/entities/Light.js',
		'./js/entities/Tile.js',
		'./js/client.js',
		'./js/load.js',
		'../howler/howler.min.js',
		'./index.js',
	]
};

if (typeof(module) !== 'undefined' && typeof(module.exports) !== 'undefined') { module.exports = igeClientConfig; }