<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TourSession;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TourCatalogController extends Controller
{
    public function sessions(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'keyword' => ['nullable', 'string', 'max:120'],
            'tour_id' => ['nullable', 'integer', 'min:1'],
            'date_from' => ['nullable', 'date_format:Y-m-d'],
            'date_to' => ['nullable', 'date_format:Y-m-d', 'after_or_equal:date_from'],
            'available_only' => ['nullable', 'boolean'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:20'],
        ]);

        $query = DB::table('tour_sessions as ts')
            ->join('tours as t', 't.id', '=', 'ts.tour_id')
            ->select([
                'ts.id',
                'ts.tour_id',
                'ts.session_code',
                'ts.starts_at',
                'ts.ends_at',
                'ts.capacity',
                'ts.held_count',
                'ts.confirmed_count',
                'ts.status',
                't.code as tour_code',
                't.name as tour_name',
                DB::raw(
                    '(ts.capacity - ts.held_count - ts.confirmed_count) AS available_seats'
                ),
            ])
            ->where('ts.status', 'open');

        $query->when(
            $validated['keyword'] ?? null,
            function ($q, $keyword) {
                $like = '%' . addcslashes($keyword, '%_\\') . '%';

                $q->where(function ($subQuery) use ($like) {
                    $subQuery
                        ->whereRaw('t.name LIKE ?', [$like])
                        ->orWhereRaw('t.code LIKE ?', [$like])
                        ->orWhereRaw('ts.session_code LIKE ?', [$like]);
                });
            }
        );

        $query->when(
            $validated['tour_id'] ?? null,
            fn ($q, $tourId) => $q->where('ts.tour_id', $tourId)
        );

        $query->when(
            $validated['date_from'] ?? null,
            fn ($q, $date) => $q->whereDate('ts.starts_at', '>=', $date)
        );

        $query->when(
            $validated['date_to'] ?? null,
            fn ($q, $date) => $q->whereDate('ts.starts_at', '<=', $date)
        );

        if ($request->boolean('available_only')) {
            $query->whereRaw(
                'ts.capacity - ts.held_count - ts.confirmed_count > 0'
            );
        }

        $perPage = (int) ($validated['per_page'] ?? 10);

        $sessions = $query
            ->orderBy('ts.starts_at')
            ->orderBy('ts.id')
            ->paginate($perPage)
            ->withQueryString();

        return response()->json($sessions);
    }

    public function session(int $session): JsonResponse
    {
        $result = DB::table('tour_sessions as ts')
            ->join('tours as t', 't.id', '=', 'ts.tour_id')
            ->select([
                'ts.id',
                'ts.tour_id',
                'ts.session_code',
                'ts.starts_at',
                'ts.ends_at',
                'ts.capacity',
                'ts.held_count',
                'ts.confirmed_count',
                'ts.status',
                't.code as tour_code',
                't.name as tour_name',
                DB::raw(
                    '(ts.capacity - ts.held_count - ts.confirmed_count) AS available_seats'
                ),
            ])
            ->where('ts.id', $session)
            ->first();

        if (! $result) {
            return response()->json([
                'message' => 'Không tìm thấy ca tham quan.',
            ], 404);
        }

        return response()->json([
            'data' => $result,
        ]);
    }
}
