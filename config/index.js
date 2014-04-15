/**
 * 载入config
 */

var nconf = require('nconf'), 
	fs = require('fs'), 
	path = require('path'),
	shortstop = require('shortstop'),
	resolver = shortstop.create();

require('jsonminify');

nconf.env()
var env = nconf.get('NODE_ENV') || 'development';

/**
 * 把相对路径转换为绝对路径
 */
resolver.use('path', function(value) {
    if (path.resolve(value) === value) {
        return value;
    }
    return path.join(process.cwd(), value);
})

/**
 * 读取文件内容
 */
resolver.use('file', function(value) {
	return fs.readFileSync(value);
})

/**
 * 遍历配置文件
 */
function findConfig(dir) {
	var files = {defaults:[]};
	fs.readdirSync(dir).forEach(function(name) {
		var filepath = dir + '/' + name,
			env = '';
		if (fs.existsSync(filepath) && !fs.lstatSync(filepath).isDirectory()) {
			if (/\.json$/i.test(path.extname(name))) {
				env = name.split('.')[1]
				if (env !== 'json') {
					files[env] = files[env] || []
					files[env].push(filepath)
				} else {
					files['defaults'].push(filepath)
				}
			}
		}
	})	
	return files;
}

/**
 * 解析json配置文件
 */
function getJson(filepath) {
	var content;
	if (fs.existsSync(filepath)) {
		content = fs.readFileSync(filepath, 'utf8');
		try {
			content = JSON.parse(JSON.minify(content));
			content = resolver.resolve(content);
		} catch(e) {
			console.log(e)
			return undefined;
		}
		return {
			type: 'literal',
			store: content
		};
	}
	return undefined;
}

/**
 * 载入配置
 */
function loadConfig() {
	var files = findConfig(__dirname);

	if (files[env]) {
		files[env].forEach(function(filepath) {
			nconf.use(filepath, getJson(filepath));
		})	
	}

	files.defaults.forEach(function(filepath) {
		nconf.use(filepath, getJson(filepath));
	})	
}

fs.watch(__dirname, function(event, filename) {
	if (event === 'change' && /\.json$/i.test(filename)) {
		loadConfig();
	}
})

loadConfig();
nconf.use('memory');
global.__defineGetter__("CONST", function() {return nconf})