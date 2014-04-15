# 载入express
express    = require 'express'
app        = express()

# 载入配置
require './config'

# Express配置
app.set "view engine", CONST.get('express:view engine')
app.set "view cache", CONST.get('express:view cache')
app.set "json spaces", CONST.get('express:json spaces')
app.set "x-powered-by", CONST.get('express:x-powered-by')
app.set "trust proxy", CONST.get('express:trust proxy')

# 模版配置
app.locals = CONST.get 'view'

# 载入日志记录配置
logger = require './lib/logger'
logger.init()

# 中间件
app.use express.timeout(CONST.get('timeout'))
app.use express.responseTime()
app.use express.bodyParser(CONST.get('bodyParser'))
app.use express.methodOverride()
app.use express.cookieParser()

# i18n
i18n = require 'i18n'
i18n.configure CONST.get('i18n')
app.use i18n.init

# redis做session存储
###
redisStore = require('connect-redis')(express)
app.use express.session {
	store: new redisStore({
		host: CONST.get('redis:host')
		port: CONST.get('redis:port')
	})
	secret: CONST.get('session:secret')
	key: CONST.get('session:key') 
}
###
app.use express.session {
    secret: CONST.get('session:secret')
    key: CONST.get('session:key')
}

# post请求需要csrfToken
app.use express.csrf()

# 自定义中间件

# 根据Controller生成路由
controller = require('./lib/controller')
controller(CONST.get('route:base'), app)

# 处理404
app.all '*', (req, res) -> 
	res.locals.title = '404 NotFound'
	res.render 'error/error'

# 错误处理
errorHandler = require './lib/middlewares/errorHandler'
app.use errorHandler()

module.exports = app


