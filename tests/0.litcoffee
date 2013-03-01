Test out basic functionality

	tt = require('../')
	console.log typeof tt, Object.keys(tt)
	result = tt '0.txt', 'test', 'test'
	console.log(result)

