# Setup local env for dev

Clone repo:

```
git clone https://project-user@github.com/l1br3th1nk3r/marvel.git
```

Edit `apivixi/.git/config` and add:

```
[user]
	name = Project user
	email = project-user@mail.com
```

Setup:

```
cd marvel/app-backend
touch .env
```

Edit .env:

```
#TODO
```

Update database and run dev server:

```
composer update
php artisan migrate
php artisan db:seed
php artisan queue:work &
php artisan serve --port=8000 &
```

## Test endpoints

* To see endpoints:
```sh
php artisan route:list
```

* Run tests:
```sh
#TODO
```
 