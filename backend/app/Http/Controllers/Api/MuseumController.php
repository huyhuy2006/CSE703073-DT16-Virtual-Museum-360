<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class MuseumController extends Controller
{
    public function spaces(): JsonResponse
    {
        $spaces = DB::table('museum_spaces')
            ->where('is_active', 1)
            ->orderBy('display_order')
            ->get();

        return response()->json([
            'data' => $spaces,
        ]);
    }

    public function space(int $space): JsonResponse
    {
        $museumSpace = DB::table('museum_spaces')
            ->where('id', $space)
            ->where('is_active', 1)
            ->first();

        if (! $museumSpace) {
            return response()->json([
                'message' => 'Khong tim thay khong gian bao tang.',
            ], 404);
        }

        $panoramas = DB::table('panoramas')
            ->where('museum_space_id', $space)
            ->where('is_active', 1)
            ->orderByDesc('is_primary')
            ->orderBy('id')
            ->get();

        $artifacts = DB::table('artifacts')
            ->where('museum_space_id', $space)
            ->where('is_active', 1)
            ->orderByDesc('is_featured')
            ->orderBy('name')
            ->get();

        return response()->json([
            'data' => [
                'space' => $museumSpace,
                'panoramas' => $panoramas,
                'artifacts' => $artifacts,
            ],
        ]);
    }

    public function panoramas(int $space): JsonResponse
    {
        $exists = DB::table('museum_spaces')
            ->where('id', $space)
            ->where('is_active', 1)
            ->exists();

        if (! $exists) {
            return response()->json([
                'message' => 'Khong tim thay khong gian bao tang.',
            ], 404);
        }

        $panoramas = DB::table('panoramas')
            ->where('museum_space_id', $space)
            ->where('is_active', 1)
            ->orderByDesc('is_primary')
            ->orderBy('id')
            ->get();

        return response()->json([
            'data' => $panoramas,
        ]);
    }

    public function artifacts(int $space): JsonResponse
    {
        $exists = DB::table('museum_spaces')
            ->where('id', $space)
            ->where('is_active', 1)
            ->exists();

        if (! $exists) {
            return response()->json([
                'message' => 'Khong tim thay khong gian bao tang.',
            ], 404);
        }

        $artifacts = DB::table('artifacts')
            ->where('museum_space_id', $space)
            ->where('is_active', 1)
            ->orderByDesc('is_featured')
            ->orderBy('name')
            ->get();

        return response()->json([
            'data' => $artifacts,
        ]);
    }

    public function hotspots(int $panorama): JsonResponse
    {
        $exists = DB::table('panoramas')
            ->where('id', $panorama)
            ->where('is_active', 1)
            ->exists();

        if (! $exists) {
            return response()->json([
                'message' => 'Khong tim thay panorama.',
            ], 404);
        }

        $hotspots = DB::table('hotspots')
            ->where('panorama_id', $panorama)
            ->where('is_active', 1)
            ->orderBy('id')
            ->get();

        return response()->json([
            'data' => $hotspots,
        ]);
    }

    public function transitions(int $panorama): JsonResponse
    {
        $exists = DB::table('panoramas')
            ->where('id', $panorama)
            ->where('is_active', 1)
            ->exists();

        if (! $exists) {
            return response()->json([
                'message' => 'Khong tim thay panorama.',
            ], 404);
        }

        $transitions = DB::table('space_transitions')
            ->where(function ($query) use ($panorama) {
                $query
                    ->where('source_panorama_id', $panorama)
                    ->orWhere('target_panorama_id', $panorama);
            })
            ->where('is_active', 1)
            ->orderBy('id')
            ->get();

        return response()->json([
            'data' => $transitions,
        ]);
    }

    public function tours(): JsonResponse
    {
        $tours = DB::table('tours')
            ->where('is_active', 1)
            ->orderBy('id')
            ->get();

        return response()->json([
            'data' => $tours,
        ]);
    }

    public function tour(int $tour): JsonResponse
    {
        $record = DB::table('tours')
            ->where('id', $tour)
            ->where('is_active', 1)
            ->first();

        if (! $record) {
            return response()->json([
                'message' => 'Khong tim thay tour.',
            ], 404);
        }

        $stops = DB::table('tour_stops')
            ->where('tour_id', $tour)
            ->orderBy('stop_order')
            ->get();

        return response()->json([
            'data' => [
                'tour' => $record,
                'stops' => $stops,
            ],
        ]);
    }

    public function audio(int $panorama): JsonResponse
    {
        $exists = DB::table('panoramas')
            ->where('id', $panorama)
            ->where('is_active', 1)
            ->exists();

        if (! $exists) {
            return response()->json([
                'message' => 'Khong tim thay panorama.',
            ], 404);
        }

        $audio = DB::table('audio_narrations')
            ->where('panorama_id', $panorama)
            ->orderBy('language_id')
            ->orderBy('id')
            ->get();

        return response()->json([
            'data' => $audio,
        ]);
    }

    public function languages(): JsonResponse
    {
        $languages = DB::table('languages')
            ->orderBy('id')
            ->get();

        return response()->json([
            'data' => $languages,
        ]);
    }
}
