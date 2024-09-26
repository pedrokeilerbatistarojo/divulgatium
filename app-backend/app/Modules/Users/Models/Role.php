<?php

namespace App\Modules\Users\Models;

use App\Modules\Shared\Traits\HasOptimisticLocking;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Role extends Model
{
    use HasOptimisticLocking;

    public $timestamps = false;

    protected $table = 'roles';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'code',
    ];

    /**
     * The relations to eager load on every query.
     *
     * @var array
     */
    protected $with = [
        //'users'
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array
     */
    protected $casts = [
        'name' => 'string',
        'code' => 'string',
    ];

    /**
     * Create a new Eloquent model instance.
     *
     * @return void
     */
    public function __construct(array $attributes = [])
    {
        //Set default values
        $this->setRawAttributes([
            'name' => '',
            'code' => '',
        ], true);

        parent::__construct($attributes);
    }

    // 1 .. N
    public function users(): HasMany
    {
        return $this->hasMany(\App\Modules\Users\Domain\Models\User::class, 'role_id', 'id');
    }
}
