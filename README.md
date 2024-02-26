# Dart Zig Interop

Unlike the [Dart-C FFI](https://dart.dev/interop/c-interop), this repo shows some demo for the `Dart-Zig FFI`. 

Used those versions as of Feb 2024:
- Zig SDK: 0.12.0-dev.2250
- Dart SDK: 3.4.0-00.0.dev (Flutter 3.19.0-0.3.pre)
- Debian Sid

<br/>
<br/>

## How to run

To build all the Zig libraries:
```sh
# Build the library
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

For the async example:
```sh
# Install packages and run the caller
$ cd src/dart/04-async
$ dart pub get
$ dart run async.dart
```
