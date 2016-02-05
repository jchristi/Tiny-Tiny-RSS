vtest:
	@vagrant up
	@vagrant ssh
	@composer install
	@phpunit --verbose --bootstap includes/autoload.php tests/

test:
	@phpunit --verbose --bootstrap tests/bootstrap.php --colors tests/

