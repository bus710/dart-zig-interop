2024/02/15  
I need to learn how to return a pointer or null/void to the caller, especially when it is being used within this interop situation.  
Until then, this repo should be closed.  


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


