<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TourBooking extends Model
{
    protected $table = 'tour_bookings';

    protected $fillable = [
        'booking_code',
        'user_id',
        'tour_session_id',
        'quantity',
        'status',
        'expires_at',
        'confirmed_at',
        'cancelled_at',
        'metadata',
    ];

    protected $casts = [
        'user_id' => 'integer',
        'tour_session_id' => 'integer',
        'quantity' => 'integer',
        'expires_at' => 'datetime',
        'confirmed_at' => 'datetime',
        'cancelled_at' => 'datetime',
        'metadata' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function tourSession(): BelongsTo
    {
        return $this->belongsTo(TourSession::class);
    }

    public function statusLogs(): HasMany
    {
        return $this->hasMany(TourBookingStatusLog::class);
    }

    public function isPending(): bool
    {
        return $this->status === 'pending_payment';
    }

    public function isConfirmed(): bool
    {
        return $this->status === 'confirmed';
    }

    public function isExpired(): bool
    {
        return $this->status === 'expired';
    }
}
