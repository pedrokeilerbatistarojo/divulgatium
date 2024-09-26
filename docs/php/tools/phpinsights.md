# phpinsights

PHP Insights was carefully crafted to simplify the analysis of your code
directly from your terminal, and is the perfect starting point to analyze
the code quality of your PHP projects.


Install:

```
composer require nunomaduro/phpinsights --dev
php artisan vendor:publish --provider="NunoMaduro\PhpInsights\Application\Adapters\Laravel\InsightsServiceProvider"
```

Run the analysis:

```
php artisan insights
```



