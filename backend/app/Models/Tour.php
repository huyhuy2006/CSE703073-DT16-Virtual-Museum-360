<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Tour extends Model
{
    protected $table = 'tours';

    protected $fillable = [
        'code',
        'name',
    ];

    public function sessions(): HasMany
    {
        return $this->hasMany(TourSession::class);
    }
}
