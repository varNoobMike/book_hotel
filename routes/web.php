<?php

use Illuminate\Support\Facades\Route;

Route::get('/', [App\Http\Controllers\HomeController::class, 'index']);

Route::get('/login', [App\Http\Controllers\AuthController::class, 'login'])->name('login');
Route::post('/login', [App\Http\Controllers\AuthController::class, 'authenticate'])->name('login.submit');  // processes login

Route::post('/logout', [App\Http\Controllers\AuthController::class, 'logout'])->name('logout');


Route::get('/register', [App\Http\Controllers\AuthController::class, 'register'])->name('register');