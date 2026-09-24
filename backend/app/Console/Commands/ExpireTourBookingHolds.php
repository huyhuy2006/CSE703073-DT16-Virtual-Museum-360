<?php

namespace App\Console\Commands;

use App\Models\TourBooking;
use App\Models\TourBookingStatusLog;
use App\Models\TourSession;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ExpireTourBookingHolds extends Command
{
    protected $signature = 'tour-bookings:expire';

    protected $description = 'Tự động hết hạn các giữ chỗ tour đã quá thời gian.';

    public function handle(): int
    {
        $expiredCount = 0;

        TourBooking::query()
            ->where('status', 'pending_payment')
            ->whereNotNull('expires_at')
            ->where('expires_at', '<=', now())
            ->orderBy('id')
            ->chunkById(100, function ($bookings) use (&$expiredCount) {
                foreach ($bookings as $booking) {
                    DB::transaction(function () use (
                        $booking,
                        &$expiredCount
                    ) {
                        $session = TourSession::query()
                            ->whereKey($booking->tour_session_id)
                            ->lockForUpdate()
                            ->first();

                        if (! $session) {
                            return;
                        }

                        $freshBooking = TourBooking::query()
                            ->whereKey($booking->id)
                            ->lockForUpdate()
                            ->first();

                        if (
                            ! $freshBooking
                            || $freshBooking->status !== 'pending_payment'
                            || ! $freshBooking->expires_at
                            || $freshBooking->expires_at->isFuture()
                        ) {
                            return;
                        }

                        $session->held_count = max(
                            0,
                            $session->held_count - $freshBooking->quantity
                        );

                        $session->save();

                        $freshBooking->status = 'expired';
                        $freshBooking->expires_at = null;
                        $freshBooking->save();

                        TourBookingStatusLog::query()->create([
                            'tour_booking_id' => $freshBooking->id,
                            'from_status' => 'pending_payment',
                            'to_status' => 'expired',
                            'note' => 'Cron scheduler tự động hết hạn giữ chỗ.',
                            'created_at' => now(),
                        ]);

                        $expiredCount++;
                    });
                }
            });

        $this->info(
            "Da xu ly {$expiredCount} phieu giu cho het han."
        );

        return self::SUCCESS;
    }
}
