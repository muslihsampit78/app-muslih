<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    if (file_exists(public_path('index.html'))) {
        return response()->file(public_path('index.html'));
    }

    return view('welcome');
});

Route::get('/{any}', function () {
    if (file_exists(public_path('index.html'))) {
        return response()->file(public_path('index.html'));
    }

    abort(404);
})->where('any', '^(?!admin|api|livewire|storage|sanctum).*$');
