###
controller示例
- 文件命名：模块名.子模块.coffee
- 如 home.example.coffee
###


# 默认路由的请求方法，小写，可选，默认为get
exports.method = 'get'

# controller名称，如果不写则以文件名中的模块名作为默认名称
exports.name = 'home'

# 整个文件的前置中间件，只有一个可以写成函数形式，多个写成数组
exports.before = [
	(req, res, next) -> next()
]

# 后置中间件
exports.after = []

###
action数组 可以是一个返回值为数组的方法，也可以是一个数组，如果是一个数组的话，里面用到的变量需要先在代码前面定义
数组内每一项应当为如下形式
['路由路径', '请求方法', fun1, fun2, fun3.....]

1. 路由路径，字符串：
	有以下几种形式
	'/path'	- 会创建/n/path 的路由
	'path'	- 会创建/n/home/path 的路由
	'index'	- 会创建/n/home/index 和 /n/home 的路由
	其他配置方法和express默认路由配置一致

2. 请求方法，字符串
	可选，不写默认为exports.method

3. 中间件集合
	传入的fun1,fun2...按顺序执行

###
exports.actions = () -> [

	['index', (req, res, next)->
		res.send "hello"
	]

	['test', 'post', (req, res, next) ->
		res.send 'post'
	]

]
