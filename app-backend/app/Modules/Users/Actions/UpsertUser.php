<?php

namespace App\Modules\Users\Actions;

use App\Modules\Users\Models\User;
use Illuminate\Contracts\Validation\Factory;

class UpsertUser
{
    public function __construct(
        private readonly Factory $validatorFactory){
    }

    public function __invoke(array $data): User
    {
        $validator = $this->validatorFactory->make($data, $this->rules($data));

        $validator->validate();

        return User::updateOrCreate(
            ['id' => $data['id'] ?? null],
            $data
        );
    }

    /**
     * @param array $data
     * @return array
     */
    private function rules(array $data): array
    {
        $rules = [
            'name' => 'required|string|max:255|unique:users',
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
            'role_id' => 'required|exists:roles'
        ];

        if (array_key_exists('id', $data)) {
            $rules['id'] = 'required|exists:users';
            $rules['username'] .= ',' . $data['id'] . ',id';
        }

        return $rules;
    }
}
