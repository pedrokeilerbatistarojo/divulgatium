# Laravel Pint

Laravel Pint is an opinionated PHP code style fixer for minimalists.
Pint is built on top of PHP-CS-Fixer and makes it simple to ensure 
that your code style stays clean and consistent.

> requires php ^8.1.0

Install:

```
composer require laravel/pint --dev
```

Usage: 

```
# all project
./vendor/bin/pint

# with folders
./vendor/bin/pint app/Models

# with files
./vendor/bin/pint app/Models/User.php

# verbose output
./vendor/bin/pint -v

# dry run
./vendor/bin/pint --test

# only modify the files that have uncommitted changes according to Git
./vendor/bin/pint --dirty
```

Links:

- [laravel/pint](https://laravel.com/docs/10.x/pint)
