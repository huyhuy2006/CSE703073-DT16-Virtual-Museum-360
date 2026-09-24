<?php

namespace App\Services;

use App\Exceptions\BookingConflictException;
use App\Models\TourBooking;
use App\Models\TourBookingStatusLog;
use App\Models\TourSession;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class BookingService
{
    public const HOLD_MINUTES = 15;

    public function hold(
        User $user,
        int $tourSessionId,
        int $quantity
    ): TourBooking {
        if ($quantity < 1 || $quantity > 5) {
            throw new BookingConflictException(
                'Số lượng khách phải từ 1 đến 5.'
            );
        }

        return DB::transaction(function () use (
            $user,
            $tourSessionId,
            $quantity
        ): TourBooking {
            $session = TourSession::query()
                ->whereKey($tourSessionId)
                ->lockForUpdate()
                ->first();

            if (! $session) {
                throw new BookingConflictException(
                    'Không tìm thấy ca tham quan.'
                );
            }

            if (! $session->isOpen()) {
                throw new BookingConflictException(
                    'Ca tham quan hiện không mở đặt chỗ.'
                );
            }

            $this->expireForSession($session);

            $availableSeats = $session->availableSeats();

            if ($availableSeats < $quantity) {
                throw new BookingConflictException(
                    'Không đủ chỗ trống cho số lượng khách đã chọn.'
                );
            }

            $booking = TourBooking::query()->create([
                'booking_code' => (string) Str::uuid(),
                'user_id' => $user->id,
                'tour_session_id' => $session->id,
                'quantity' => $quantity,
                'status' => 'pending_payment',
                'expires_at' => now()->addMinutes(self::HOLD_MINUTES),
                'metadata' => [
                    'source' => 'virtual-museum-360',
                    'mode' => 'guided-tour',
                ],
            ]);

            $session->held_count += $quantity;
            $session->save();

            TourBookingStatusLog::query()->create([
                'tour_booking_id' => $booking->id,
                'from_status' => null,
                'to_status' => 'pending_payment',
                'note' => 'Tạo giữ chỗ trong 15 phút.',
                'created_at' => now(),
            ]);

            return $booking->fresh([
                'tourSession.tour',
            ]);
        });
    }

    public function confirm(
        User $user,
        int $bookingId
    ): TourBooking {
        return DB::transaction(function () use (
            $user,
            $bookingId
        ): TourBooking {
            $bookingPreview = TourBooking::query()
                ->whereKey($bookingId)
                ->where('user_id', $user->id)
                ->first();

            if (! $bookingPreview) {
                throw new BookingConflictException(
                    'Không tìm thấy phiếu đặt chỗ.'
                );
            }

            $session = TourSession::query()
                ->whereKey($bookingPreview->tour_session_id)
                ->lockForUpdate()
                ->first();

            if (! $session) {
                throw new BookingConflictException(
                    'Ca tham quan không còn tồn tại.'
                );
            }

            $this->expireForSession($session);

            $booking = TourBooking::query()
                ->whereKey($bookingId)
                ->where('user_id', $user->id)
                ->lockForUpdate()
                ->first();

            if (! $booking) {
                throw new BookingConflictException(
                    'Không tìm thấy phiếu đặt chỗ.'
                );
            }

            if ($booking->status !== 'pending_payment') {
                throw new BookingConflictException(
                    'Phiếu đặt chỗ không còn ở trạng thái chờ xác nhận.'
                );
            }

            if (
                $booking->expires_at === null
                || $booking->expires_at->isPast()
            ) {
                throw new BookingConflictException(
                    'Giữ chỗ đã hết hạn.'
                );
            }

            if ($session->held_count < $booking->quantity) {
                throw new BookingConflictException(
                    'Dữ liệu giữ chỗ không hợp lệ.'
                );
            }

            $fromStatus = $booking->status;

            $session->held_count -= $booking->quantity;
            $session->confirmed_count += $booking->quantity;
            $session->save();

            $booking->status = 'confirmed';
            $booking->confirmed_at = now();
            $booking->expires_at = null;
            $booking->save();

            TourBookingStatusLog::query()->create([
                'tour_booking_id' => $booking->id,
                'from_status' => $fromStatus,
                'to_status' => 'confirmed',
                'note' => 'Xác nhận đặt chỗ trong môi trường thử nghiệm.',
                'created_at' => now(),
            ]);

            return $booking->fresh([
                'tourSession.tour',
            ]);
        });
    }

    public function cancel(
        User $user,
        int $bookingId
    ): TourBooking {
        return DB::transaction(function () use (
            $user,
            $bookingId
        ): TourBooking {
            $bookingPreview = TourBooking::query()
                ->whereKey($bookingId)
                ->where('user_id', $user->id)
                ->first();

            if (! $bookingPreview) {
                throw new BookingConflictException(
                    'Không tìm thấy phiếu đặt chỗ.'
                );
            }

            $session = TourSession::query()
                ->whereKey($bookingPreview->tour_session_id)
                ->lockForUpdate()
                ->first();

            if (! $session) {
                throw new BookingConflictException(
                    'Ca tham quan không còn tồn tại.'
                );
            }

            $this->expireForSession($session);

            $booking = TourBooking::query()
                ->whereKey($bookingId)
                ->where('user_id', $user->id)
                ->lockForUpdate()
                ->first();

            if (! $booking) {
                throw new BookingConflictException(
                    'Không tìm thấy phiếu đặt chỗ.'
                );
            }

            if (
                ! in_array(
                    $booking->status,
                    ['pending_payment', 'confirmed'],
                    true
                )
            ) {
                throw new BookingConflictException(
                    'Phiếu đặt chỗ không thể hủy ở trạng thái hiện tại.'
                );
            }

            $fromStatus = $booking->status;

            if ($booking->status === 'pending_payment') {
                if ($session->held_count < $booking->quantity) {
                    throw new BookingConflictException(
                        'Dữ liệu giữ chỗ không hợp lệ.'
                    );

                }

                $session->held_count -= $booking->quantity;
            }

            if ($booking->status === 'confirmed') {
                if ($session->confirmed_count < $booking->quantity) {
                    throw new BookingConflictException(
                        'Dữ liệu xác nhận không hợp lệ.'
                    );
                }

                $session->confirmed_count -= $booking->quantity;
            }

            $session->save();

            $booking->status = 'cancelled';
            $booking->cancelled_at = now();
            $booking->expires_at = null;
            $booking->save();

            TourBookingStatusLog::query()->create([
                'tour_booking_id' => $booking->id,
                'from_status' => $fromStatus,
                'to_status' => 'cancelled',
                'note' => 'Khách hủy phiếu đặt chỗ.',
                'created_at' => now(),
            ]);

            return $booking->fresh([
                'tourSession.tour',
            ]);
        });
    }

    public function expireForSession(
        TourSession $session
    ): int {
        $expiredBookings = TourBooking::query()
            ->where('tour_session_id', $session->id)
            ->where('status', 'pending_payment')
            ->whereNotNull('expires_at')
            ->where('expires_at', '<=', now())
            ->lockForUpdate()
            ->get();

        $count = 0;

        foreach ($expiredBookings as $booking) {
            if ($session->held_count >= $booking->quantity) {
                $session->held_count -= $booking->quantity;
            } else {
                $session->held_count = 0;
            }

            $booking->status = 'expired';
            $booking->expires_at = null;
            $booking->save();

            TourBookingStatusLog::query()->create([
                'tour_booking_id' => $booking->id,
                'from_status' => 'pending_payment',
                'to_status' => 'expired',
                'note' => 'Giữ chỗ tự động hết hiệu lực.',
                'created_at' => now(),
            ]);

            $count++;
        }

        if ($count > 0) {
            $session->save();
        }

        return $count;
    }
}
