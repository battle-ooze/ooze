###
错误处理中间件
###

express = require 'express'
logger = require('../logger').getLogger('unknownError')
util = require 'util'
env = CONST.get('NODE_ENV') || 'development'

module.exports = () ->

	(err, req, res, next) ->
		accept = req.headers.accept || ''

		content = util.format '%s %s %s %j %j %s',
			req.ip, req.url, req.method, req.body, req.get('user-agent'), err.stack
		logger.error(content)
		err.message = 'internalServerError'

		error =
			error: err.message
			error_text: err.text
			error_data: err.data or undefined

		if env isnt 'production'
			error.error_stack = err.stack

		if req.get('content-type') and ~['application/x-www-form-urlencoded', 'multipart/form-data'].indexOf(req.get('content-type').split(';')[0])
			res.set('Content-Type', 'text/plain')

		if req.xhr or ~accept.indexOf('json')
			res.send 599, error
		else if env is 'production'
			res.locals.title = '500 Internal Server Error'
			res.render 'error/error'
		else
			express.errorHandler()(err, req, res, next)