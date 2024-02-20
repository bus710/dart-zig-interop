Problem: currently the `toDartString` gets panicked if it is executed against to Zig struct (Zig string doesn't have any problem).  
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
$ cd src/library
$ zig build --summary all
```

```sh
# Install packages and run the caller
$ cd src/dart/01-hello-world
$ dart pub get
$ dart run hello.dart
```

For the primitives example:
```sh
# Install packages and run the caller
$ cd src/dart/02-primitives
$ dart pub get
$ dart run primitives.dart
```

For the structs example:
```sh
# Install packages and run the caller
$ cd src/dart/03-structs
$ dart pub get
$ dart run structs.dart
```


