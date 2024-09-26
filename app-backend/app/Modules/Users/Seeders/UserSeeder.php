<?php

namespace App\Modules\Users\Seeders;

use App\Modules\Users\Enums\RolesEnum;
use App\Modules\Users\Models\User;
use App\Modules\Countries\Models\Country;
use Faker\Generator;
use Illuminate\Database\Seeder;
use Models\Category;


class UserSeeder extends Seeder
{

    public function __construct(
        protected Generator $faker){
    }

    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        if (User::count() !== 0) {
            return;
        }

        User::updateOrCreate([
            'username' => 'Admin',
        ], [
            'username' => 'Admin',
            'name' => 'admin',
            'email' => 'admin@localhost.loc',
            'password' => '777',
            'role_id' => RolesEnum::ADMIN,
            'phone' => $this->faker->phoneNumber,
            'code' => $this->faker->numberBetween(1000000, 99999999),
            'active' => 1
        ]);

        User::updateOrCreate([
            'username' => 'Popularizer',
        ], [
            'username' => 'Popularizer',
            'name' => 'popularizer',
            'email' => 'popularizer@localhost.loc',
            'password' => '777',
            'role_id' => RolesEnum::POPULARIZER,
            'category_id' => Category::query()->first()->id,
            'country_id' => Country::query()->find(13)->id,//Mexico
            'phone' => $this->faker->phoneNumber,
            'code' => $this->faker->numberBetween(1000000, 99999999),
            'active' => 1
        ]);
    }
}
