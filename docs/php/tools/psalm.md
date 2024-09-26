# Psalm

It’s easy to make great things in PHP, but bugs can creep in 
just as easily. Psalm is a free & open-source static analysis
tool that helps you identify problems in your code, so you can
sleep a little better.

> requires php >= 7.4.0

Install:

```
# with composer
composer require --dev vimeo/psalm

# composer to install the Phar
composer require --dev psalm/phar

# using phar
wget https://github.com/vimeo/psalm/releases/latest/download/psalm.phar
chmod +x psalm.phar
```

Generate a config file:

```
# using vendors
./vendor/bin/psalm --init

#using phar
./psalm.phar --init
```

Usage:

```
# using vendors
./vendor/bin/psalm

#using phar
./psalm.phar
```



