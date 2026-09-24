<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => [
                'required',
                'string',
                'email',
                'max:180',
            ],
            'password' => [
                'required',
                'string',
                'min:8',
                'max:128',
            ],
        ]);

        $email = Str::lower(trim($data['email']));

        $rateKey = sprintf(
            'login:%s|%s',
            $email,
            $request->ip()
        );

        if (RateLimiter::tooManyAttempts($rateKey, 5)) {
            $seconds = RateLimiter::availableIn($rateKey);

            return response()->json([
                'message' => 'Qua nhieu lan dang nhap. Vui long thu lai sau.',
                'retry_after' => $seconds,
            ], 429);
        }

        $user = User::query()
            ->where('email', $email)
            ->first();

        $validCredentials = $user
            && $user->is_active
            && Hash::check(
                $data['password'],
                $user->password_hash
            );

        if (! $validCredentials) {
            RateLimiter::hit($rateKey, 60);

            return response()->json([
                'message' => 'Thong tin dang nhap khong dung.',
            ], 401);
        }

        if (Hash::needsRehash($user->password_hash)) {
            $user->password_hash = Hash::make($data['password']);
        }

        RateLimiter::clear($rateKey);

        $user->last_login_at = now();
        $user->save();

        $token = $user->createToken(
            'dt16-api-token'
        )->plainTextToken;

        return response()->json([
            'message' => 'Dang nhap thanh cong.',
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => $this->userPayload($user),
        ], 200);
    }

    public function me(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        return response()->json([
            'user' => $this->userPayload($user),
        ], 200);
    }

    public function logout(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $user->currentAccessToken()?->delete();

        return response()->json([
            'message' => 'Dang xuat thanh cong.',
        ], 200);
    }

    private function userPayload(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'is_active' => (bool) $user->is_active,
            'preferred_language_id' => $user->preferred_language_id,
            'last_login_at' => $user->last_login_at?->toISOString(),
        ];
    }
}
