{{-- resources/views/home.blade.php --}}
@extends('layouts.app')

@section('content')
<div class="d-flex justify-content-center align-items-center">
    <div class="card border-0 shadow p-4" style="width: 100%; max-width: 400px;">
        <div class="card-body">
            <h3 class="card-title mb-4 text-center">Login</h3>

            <form method="POST" action="{{ route('login') }}">
                @csrf

                @if ($errors->any())
                <div class="alert alert-danger">
                    {{ $errors->first() }}
                </div>
                @endif


                {{-- Email --}}
                <div class="mb-4">
                    <label for="email" class="form-label">Email address</label>
                    <input
                        type="email"
                        class="form-control @error('email') is-invalid @enderror"
                        id="email"
                        name="email"
                        value="{{ old('email') }}"
                        autofocus>
                    @error('email')
                    <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                {{-- Password --}}
                <div class="mb-4">
                    <label for="password" class="form-label">Password</label>
                    <input
                        type="password"
                        class="form-control @error('password') is-invalid @enderror"
                        id="password"
                        name="password">
                    @error('password')
                    <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>


                <button type="submit" class="btn btn-warning w-100">Login</button>
            </form>
        </div>
    </div>
</div>
@endsection