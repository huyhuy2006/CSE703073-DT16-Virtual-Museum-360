<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Throwable;

class HealthController extends Controller
{
    public function __invoke(): JsonResponse
    {
        try {
            DB::connection()->getPdo();

            return response()->json([
                'status' => 'ok',
                'application' => 'DT-16 Virtual Museum 360',
                'database' => 'connected',
            ], 200);
        } catch (Throwable $e) {
            report($e);

            return response()->json([
                'status' => 'error',
                'application' => 'DT-16 Virtual Museum 360',
                'database' => 'unavailable',
            ], 503);
        }
    }
}
