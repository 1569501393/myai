<?php

use Illuminate\Support\Facades\Route;

Route::prefix('students')->group(function () {
    Route::get('/', [\App\Http\Controllers\Api\StudentController::class, 'index']);
    Route::post('/', [\App\Http\Controllers\Api\StudentController::class, 'store']);
    Route::get('/search', [\App\Http\Controllers\Api\StudentController::class, 'search']);
    Route::get('/{id}', [\App\Http\Controllers\Api\StudentController::class, 'show']);
    Route::put('/{id}', [\App\Http\Controllers\Api\StudentController::class, 'update']);
    Route::delete('/{id}', [\App\Http\Controllers\Api\StudentController::class, 'destroy']);
});
