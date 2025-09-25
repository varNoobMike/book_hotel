<!DOCTYPE html>
<html lang="en">
<head>
    @include('templates.head')
</head>
<body>
    @include('templates.navbar')

    <div class="container mt-5">
        @yield('content')
    </div>

</body>
</html>
