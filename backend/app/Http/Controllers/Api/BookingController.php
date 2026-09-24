<?php

namespace App\Http\Controllers\Api;

use App\Exceptions\BookingConflictException;
use App\Http\Controllers\Controller;
use App\Models\TourBooking;
use App\Services\BookingService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $bookings = TourBooking::query()
            ->with([
                'tourSession.tour',
                'statusLogs',
            ])
            ->where('user_id', $request->user()->id)
            ->orderByDesc('id')
            ->paginate(10);

        return response()->json($bookings);
    }

    public function show(
        Request $request,
        int $booking
    ): JsonResponse {
        $result = TourBooking::query()
            ->with([
                'tourSession.tour',
                'statusLogs',
            ])
            ->whereKey($booking)
            ->where('user_id', $request->user()->id)
            ->first();

        if (! $result) {
            return response()->json([
                'message' => 'Không tìm thấy phiếu đặt chỗ.',
            ], 404);
        }

        return response()->json([
            'data' => $result,
        ]);
    }

    public function store(
        Request $request,
        BookingService $bookingService
    ): JsonResponse {
        $data = $request->validate([
            'tour_session_id' => [
                'required',
                'integer',
                'min:1',
            ],
            'quantity' => [
                'required',
                'integer',
                'min:1',
                'max:5',
            ],
        ]);

        try {
            $booking = $bookingService->hold(
                $request->user(),
                (int) $data['tour_session_id'],
                (int) $data['quantity']
            );

            return response()->json([
                'message' => 'Giữ chỗ thành công trong 15 phút.',
                'data' => $booking,
            ], 201);
        } catch (BookingConflictException $exception) {
            return response()->json([
                'message' => $exception->getMessage(),
            ], 409);
        }
    }

    public function confirm(
        Request $request,
        int $booking,
        BookingService $bookingService
    ): JsonResponse {
        try {
            $result = $bookingService->confirm(
                $request->user(),
                $booking
            );

            return response()->json([
                'message' => 'Xác nhận đặt chỗ thành công.',
                'data' => $result,
            ]);
        } catch (BookingConflictException $exception) {
            return response()->json([
                'message' => $exception->getMessage(),
            ], 409);
        }
    }

    public function cancel(
        Request $request,
        int $booking,
        BookingService $bookingService
    ): JsonResponse {
        try {
            $result = $bookingService->cancel(
                $request->user(),
                $booking
            );

            return response()->json([
                'message' => 'Hủy đặt chỗ thành công.',
                'data' => $result,
            ]);
        } catch (BookingConflictException $exception) {
            return response()->json([
                'message' => $exception->getMessage(),
            ], 409);
        }
    }
}
