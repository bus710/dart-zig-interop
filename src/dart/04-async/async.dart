// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Directory;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

//
typedef NativeHelloWorldCallback = Void Function(Pointer<Utf8>);

typedef HelloWorldAsyncNative = Void Function(
    Pointer<Utf8>, Pointer<NativeFunction<NativeHelloWorldCallback>>);
typedef HelloWorldAsync = void Function(
    Pointer<Utf8>, Pointer<NativeFunction<NativeHelloWorldCallback>>);

final libraryPath = path.join(
    Directory.current.path, '../../library/zig-out/lib', 'libasync.so');

final dylib = DynamicLibrary.open(libraryPath);

final nativeHelloWorldAsync =
    dylib.lookupFunction<HelloWorldAsyncNative, HelloWorldAsync>(
        'hello_world_async');

void main() {
  print('Hello from Dart');

  Future<String> helloWorldAsync(String helloWorld) async {
    final helloWorldPointer = helloWorld.toNativeUtf8();

    // Create the NativeCallable.listener.
    final completer = Completer<String>();
    late final NativeCallable<NativeHelloWorldCallback> callback;

    void onResponse(Pointer<Utf8> responsePointer) {
      print('Hello from callback');
      completer.complete(responsePointer.toDartString());
      calloc.free(helloWorldPointer);
      calloc.free(responsePointer);

      // Remember to close the NativeCallable once the native API is
      // finished with it, otherwise this isolate will stay alive
      // indefinitely.
      callback.close();
    }

    callback = NativeCallable<NativeHelloWorldCallback>.listener(onResponse);

    nativeHelloWorldAsync(helloWorldPointer, callback.nativeFunction);

    return completer.future;
  }

  helloWorldAsync('Hello World as a param');
}
