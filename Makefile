test:
	@mocha --require './config' --compilers coffee:coffee-script

dist:
	@rm -Rf ./dist && coffee --output ./dist --compile . && cp -R config ./dist && cp -R views ./dist
	@find ./lib -regex ".*\..*\.js" | xargs -t -i cp --parent {} ./dist
	@cp package.json ./dist
	@cp pm2.json ./dist
	@rm -Rf ./dist/test

test-cov:
	@rm -Rf ./dist && coffee --output ./dist --compile . && cp -R config ./dist && cp -R views ./dist
	@mocha --require './config' --require blanket --timeout 15000 ./dist/test -R html-cov > coverage.html
	@rm -Rf ./dist

clear:
	@rm -Rf ./dist

.PHONY: test dist
