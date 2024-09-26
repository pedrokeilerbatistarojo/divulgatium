<?php

namespace App\Modules\Auth\Dto;

use App\Modules\Users\Models\User;
use App\Modules\Users\Resources\RoleResource;

class LoginResponse
{
    public int $id = -1;

    //public string $name = '';

    public string $username = '';

    public string $email = '';

    public string $token = '';

    public ?RoleResource $role;

    public mixed $last_login = null;

    public function __construct(User $user, string $token)
    {
        $this->id = $user->id;
        //$dto->name = $user->name;
        $this->username = $user->username;
        $this->email = $user->email;
        $this->token = $token;
        $this->last_login = $user->last_login;
        $this->role = RoleResource::make($user->role);
    }
}
