# Dart Zig Interop

Unlike the [Dart-C FFI](https://dart.dev/interop/c-interop), this repo shows some demo for the **Dart-Zig FFI**. 

Used those versions as of Feb 2024:
- Zig SDK: 0.12.0-dev.2250
- Dart SDK: 3.4.0-00.0.dev (Flutter 3.19.0-0.3.pre)
- Debian Sid

<br/>

There are 2 different ways:
- Manual FFI (under the src directory)
- Automatic FFI with the ffigen command (under the src-ffigen directory)

<br/>

## How to run the manual FFI demos

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

<br/>

## How to run the automatic FFI demos

To build all the Zig libraries:
```sh
# Build the library
$ cd src-ffigen/library
$ zig build --summary all
```

Manually update the header files:
```sh
$ nv src-ffigen/library/zig-cache/hello.h
$ mv src-ffigen/library/zig-cache/hello.h src-ffigen/dart/01-hello-world
```

Update the `pubspec.yaml`:
```sh
$ nv src-ffigen/app/01-hello-world/pubspec.yaml
```

Generate the ffi file:
```sh
$ cd src-ffigen/app/01-hello-world
$ dart run ffigen
```

Run the demo:
```sh
$ dart run hello.dart
```

:warning: the async demo doesn't work with the ffigen command, but other 3 demos work well.
