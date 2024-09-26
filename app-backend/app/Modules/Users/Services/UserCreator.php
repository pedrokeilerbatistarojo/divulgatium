<?php

namespace Services;

use Actions\UpsertUser;
use Resources\UserResource;

class UserCreator
{
    public function __invoke(array $data)
    {
        $result = app(UpsertUser::class)($data);

        return UserResource::make($result);
    }
}
