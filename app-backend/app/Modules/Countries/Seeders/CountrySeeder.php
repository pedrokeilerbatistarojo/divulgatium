<?php

namespace App\Modules\Countries\Seeders;

use App\Modules\Countries\Models\Country;
use Illuminate\Database\Seeder;

class CountrySeeder extends Seeder
{
    private array $countries = [
        "Argentina",
        "Australia",
        "Brazil",
        "Canada",
        "Chile",
        "Colombia",
        "Egypt",
        "France",
        "Germany",
        "India",
        "Italy",
        "Japan",
        "Mexico",
        "Peru",
        "Portugal",
        "Spain",
        "United Kingdom",
        "United States"
    ];

    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        foreach ($this->countries as $countryName){
            Country::create([
                'name' => $countryName
            ]);
        }
    }
}
