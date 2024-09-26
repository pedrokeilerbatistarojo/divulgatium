<?php

namespace App\Modules\Auth\Actions;

use App\Modules\Users\Models\User;
use App\Modules\Auth\Dto\LoginResponse;
use Illuminate\Contracts\Validation\Factory;
use Illuminate\Support\Carbon;

class LoginUser
{
    public function __construct(
        private readonly Factory $validatorFactory){
    }

    /**
     * @throws \Exception
     */
    public function __invoke(array $data): LoginResponse
    {
        $validator = $this->validatorFactory->make($data, $this->rules());

        $validator->validate();

        $token = auth('api')->attempt([
            'username' => $data['username'],
            'password' => $data['password'],
            'active' => true,
        ]);

        if (! $token) {
            throw new \Exception('Invalid credentials');
        }

        $user = User::query()->where('username', $data['username'])->first();
        if (! $user) {
            throw new \Exception('Invalid user');
        }

        $user->last_login = Carbon::now();
        $user->save();

        return new LoginResponse( $user, $token);

    }

    /**
     * @return array
     */
    private function rules(): array
    {
        return [
            'username' => 'required',
            'password' => 'required',
        ];
    }

}
