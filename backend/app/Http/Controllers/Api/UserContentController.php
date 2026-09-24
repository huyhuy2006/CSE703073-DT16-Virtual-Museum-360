<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UserContentController extends Controller
{
    public function collections(Request $request): JsonResponse
    {
        $collections = DB::table('collections')
            ->where('user_id', $request->user()->id)
            ->orderByDesc('id')
            ->get();

        return response()->json([
            'data' => $collections,
        ]);
    }

    public function guestbook(Request $request): JsonResponse
    {
        $entries = DB::table('guestbook_entries')
            ->where('user_id', $request->user()->id)
            ->orderByDesc('id')
            ->get();

        return response()->json([
            'data' => $entries,
        ]);
    }
}
