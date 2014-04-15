快盘.node
==========


## 注意
> node_modules不会入到库中，需要在目录下执行 `npm install` 安装依赖包


## 目录结构
- **/bin** - 一些可执行文件
- **/config** - 配置文件			
- **/controllers** - 控制器/路由
- **/lib** - 核心类库
- **/locales** - i18n语言文件
- **/logs** - 日志
- **/models** - 模型
- **/node_modules** - npm包
- **/dist** - 编译后的js
- **/tests** - 单元测试
- **/views** - 模版

## Makefile
运行单元测试
`make test`

运行带覆盖率的单元测试
生成coverage.html
`make test-cov`

编译生成js文件，放在dist下
`make dist`

移除dist
`make clear`




