<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TourSession extends Model
{
    protected $table = 'tour_sessions';

    protected $fillable = [
        'tour_id',
        'session_code',
        'starts_at',
        'ends_at',
        'capacity',
        'held_count',
        'confirmed_count',
        'status',
    ];

    protected $casts = [
        'tour_id' => 'integer',
        'starts_at' => 'datetime',
        'ends_at' => 'datetime',
        'capacity' => 'integer',
        'held_count' => 'integer',
        'confirmed_count' => 'integer',
    ];

    public function tour(): BelongsTo
    {
        return $this->belongsTo(Tour::class);
    }

    public function bookings(): HasMany
    {
        return $this->hasMany(TourBooking::class);
    }

    public function availableSeats(): int
    {
        return max(
            0,
            $this->capacity - $this->held_count - $this->confirmed_count
        );
    }

    public function isOpen(): bool
    {
        return $this->status === 'open';
    }
}
