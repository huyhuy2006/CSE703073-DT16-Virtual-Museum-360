<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class AdminController extends Controller
{
    public function check(Request $request): JsonResponse
    {
        return response()->json([
            'message' => 'Admin authorization PASS.',
            'user' => [
                'id' => $request->user()->id,
                'name' => $request->user()->name,
                'role' => $request->user()->role,
            ],
        ], 200);
    }

    public function users(): JsonResponse
    {
        $users = User::query()
            ->select([
                'id',
                'name',
                'email',
                'role',
                'is_active',
                'last_login_at',
            ])
            ->orderBy('id')
            ->get();

        return response()->json([
            'data' => $users,
        ]);
    }

    public function updateStatus(
        Request $request,
        int $userId
    ): JsonResponse {
        $data = $request->validate([
            'is_active' => [
                'required',
                'boolean',
            ],
        ]);

        $user = User::query()->find($userId);

        if (! $user) {
            return response()->json([
                'message' => 'Khong tim thay nguoi dung.',
            ], 404);
        }

        if ($user->id === $request->user()->id) {
            return response()->json([
                'message' => 'Khong cho phep tu khoa tai khoan admin hien tai.',
            ], 422);
        }

        $user->is_active = (bool) $data['is_active'];
        $user->save();

        Log::info('Admin cap nhat trang thai user', [
            'admin_id' => $request->user()->id,
            'target_user_id' => $user->id,
            'is_active' => $user->is_active,
        ]);

        return response()->json([
            'message' => 'Cap nhat trang thai thanh cong.',
            'user' => [
                'id' => $user->id,
                'email' => $user->email,
                'role' => $user->role,
                'is_active' => $user->is_active,
            ],
        ], 200);
    }
}
