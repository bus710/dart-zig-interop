Problem: currently the `toDartString` gets panicked.  
It seems like there is some pointer address issue in FFI.

<br/>
<br/>
<br/>
<br/>

# Dart Zig Interop

There are some examples for Dart and C FFI:
- https://dart.dev/interop/c-interop
- https://github.com/dart-lang/samples/ffi

This repo repeats the examples, but for Dart and Zig FFI.

<br/>

## How to run

For the hello world example:
```sh
# Test and build the library
$ cd src/01-hello-world/hello_library
$ zig run hello.zig
$ zig build-lib -dynamic hello.zig

# Install packages and run the caller
$ cd src/01-hello-world
$ dart pub get
$ dart run hello.dart
```

For the primitives example:
```sh
# Test and build the library
$ cd src/02-primitives/primitives_library
$ zig run primitives.zig
$ zig build-lib -dynamic primitives.zig

# Install packages and run the caller
$ cd src/02-primitives
$ dart pub get
$ dart run primitives.dart
```
