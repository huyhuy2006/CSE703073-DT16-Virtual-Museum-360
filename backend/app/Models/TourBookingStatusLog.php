<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TourBookingStatusLog extends Model
{
    public $timestamps = false;

    protected $table = 'tour_booking_status_logs';

    protected $fillable = [
        'tour_booking_id',
        'from_status',
        'to_status',
        'note',
        'created_at',
    ];

    protected $casts = [
        'tour_booking_id' => 'integer',
        'created_at' => 'datetime',
    ];

    public function booking(): BelongsTo
    {
        return $this->belongsTo(
            TourBooking::class,
            'tour_booking_id'
        );
    }
}
