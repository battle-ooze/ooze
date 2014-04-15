###
日志
###

log4js = require 'log4js'

exports.init = () ->
	appenders = [
		{type: 'console'}
		{type: 'file', filename:'logs/fatalError.log', category: 'fatalError'}
		{type: 'file', filename:'logs/unknownError.log', category: 'unknownError'}
	]

	log4js.configure({
		appenders:appenders
	})

exports.getLogger = (name) ->
	logger = log4js.getLogger(name)
	level = CONST.get('logger:level')
	logger.setLevel(level)
	return logger
