# Dart Zig Interop

:exclamation: Caution: currently the `toDartString` gets panicked if it is executed against to a string included in Zig struct (Getting a Zig string doesn't have any problem). It seems like there is some pointer address issue in Dart FFI.

<br/>
<br/>

There are some examples for Dart and C FFI:
- https://dart.dev/interop/c-interop
- https://github.com/dart-lang/samples/ffi

This repo repeats the same as the examples, but for Dart and Zig FFI.

Used versions as of Feb 2024:
- Zig SDK: 0.12.0-dev.2250
- Dart SDK: 3.4.0-00.0.dev

<br/>

## How to run

To build all the Zig libraries:
```sh
# Test and build the library
$ cd src/library
$ zig build --summary all
```

For the hello world example:
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


