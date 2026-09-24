<?php

use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\HealthController;
use App\Http\Controllers\Api\MuseumController;
use App\Http\Controllers\Api\TourCatalogController;
use App\Http\Controllers\Api\UserContentController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/health', HealthController::class)
        ->middleware('throttle:60,1');

    Route::prefix('auth')->group(function () {
        Route::post('/login', [AuthController::class, 'login'])
            ->middleware('throttle:10,1');

        Route::middleware('auth:sanctum')->group(function () {
            Route::get('/me', [AuthController::class, 'me']);

            Route::post('/logout', [AuthController::class, 'logout']);
        });
    });

    Route::get('/spaces', [MuseumController::class, 'spaces'])
        ->middleware('throttle:60,1');

    Route::get('/spaces/{space}', [MuseumController::class, 'space'])
        ->whereNumber('space')
        ->middleware('throttle:60,1');

    Route::get('/spaces/{space}/panoramas', [
        MuseumController::class,
        'panoramas',
    ])
        ->whereNumber('space')
        ->middleware('throttle:60,1');

    Route::get('/spaces/{space}/artifacts', [
        MuseumController::class,
        'artifacts',
    ])
        ->whereNumber('space')
        ->middleware('throttle:60,1');

    Route::get('/panoramas/{panorama}/hotspots', [
        MuseumController::class,
        'hotspots',
    ])
        ->whereNumber('panorama')
        ->middleware('throttle:60,1');

    Route::get('/panoramas/{panorama}/transitions', [
        MuseumController::class,
        'transitions',
    ])
        ->whereNumber('panorama')
        ->middleware('throttle:60,1');

    Route::get('/panoramas/{panorama}/audio', [
        MuseumController::class,
        'audio',
    ])
        ->whereNumber('panorama')
        ->middleware('throttle:60,1');

    Route::get('/languages', [MuseumController::class, 'languages'])
        ->middleware('throttle:60,1');

    Route::get('/tours', [MuseumController::class, 'tours'])
        ->middleware('throttle:60,1');

    Route::get('/tours/{tour}', [MuseumController::class, 'tour'])
        ->whereNumber('tour')
        ->middleware('throttle:60,1');

    Route::get('/tour-sessions', [
        TourCatalogController::class,
        'sessions',
    ])
        ->middleware('throttle:60,1');

    Route::get('/tour-sessions/{session}', [
        TourCatalogController::class,
        'session',
    ])
        ->whereNumber('session')
        ->middleware('throttle:60,1');

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/collections', [
            UserContentController::class,
            'collections',
        ]);

        Route::get('/guestbook', [
            UserContentController::class,
            'guestbook',
        ]);

        Route::prefix('bookings')
            ->middleware('throttle:30,1')
            ->group(function () {
                Route::get('/', [
                    BookingController::class,
                    'index',
                ]);

                Route::get('/{booking}', [
                    BookingController::class,
                    'show',
                ])->whereNumber('booking');

                Route::post('/', [
                    BookingController::class,
                    'store',
                ]);

                Route::post('/{booking}/confirm', [
                    BookingController::class,
                    'confirm',
                ])->whereNumber('booking');

                Route::post('/{booking}/cancel', [
                    BookingController::class,
                    'cancel',
                ])->whereNumber('booking');
            });

        Route::prefix('admin')
            ->middleware('role:admin')
            ->group(function () {
                Route::get('/check', [
                    AdminController::class,
                    'check',
                ]);

                Route::get('/users', [
                    AdminController::class,
                    'users',
                ]);

                Route::patch('/users/{userId}/status', [
                    AdminController::class,
                    'updateStatus',
                ])->whereNumber('userId');
            });
    });
});
