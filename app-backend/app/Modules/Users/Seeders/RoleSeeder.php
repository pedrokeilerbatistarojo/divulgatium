<?php

namespace App\Modules\Users\Seeders;

use App\Modules\Users\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        if (Role::count() !== 0) {
            return;
        }

        $roles = [
            'admin', 'popularizer', 'client',
        ];

        foreach ($roles as $role){
            Role::query()->create(['name' => $role]);
        }

    }
}
