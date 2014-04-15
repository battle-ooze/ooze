###
载入Controller 
###

fs = require 'fs'
path = require 'path'
_ = require 'lodash'

logger = require('./logger').getLogger('unknownError')

module.exports = (base, app) ->

	extendRoute = (controller, action) ->
		(req, res, next) ->
			req.route.controller = controller
			req.route.action = action
			req.route.base = base
			next()

	# 读取所有controller
	fs.readdirSync(__dirname + '/../controllers').forEach (name) =>
		return if /\.js$|\.coffee$/.test(path.extname(name)) is false
		try
			controller = require("../controllers/#{name}")
		catch e
			logger.error "load controller '#{name}' " + e.stack
			return

		name = controller.name or name.split('.')[0]
		route = "#{base}/#{name}"
		method = controller.method or 'get'

		beforeFilter = controller.before or (req, res, next) -> next()
		afterFilter = controller.after or (req, res, next) -> next()
		if not controller.actions then return

		if _.isFunction controller.actions 
			try
				actions = controller.actions()
			catch e
				logger.error "load controller '#{name}' " + e.stack
				return
		else if _.isArray controller.actions
			actions = controller.actions
		else
			return

		actions.forEach (params) ->
			try
				_route = params[0]
				if _route.indexOf('/') isnt 0
					_route = route + '/' + _route

				if _.isString params[1] 
					_method = params[1]
					_actions = params[2...]
				else
					_method = method
					_actions = params[1...]

				if not _.isArray beforeFilter then beforeFilter = [beforeFilter]
				if not _.isArray afterFilter then afterFilter = [afterFilter]
				
				_actions = [extendRoute(name, params[0])]
					.concat(beforeFilter, _actions, afterFilter)
				app[_method].apply(app, ["#{_route}"].concat(_actions))
				if params[0] is 'index'
					app[_method].apply(app, [route].concat(_actions))
			catch e 
				logger.error "load '#{name}'s action " + e.stack
				return
