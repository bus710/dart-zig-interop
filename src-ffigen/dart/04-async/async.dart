// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

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

void main() async {
  print('Hello from Dart');

  Future<String> helloWorldAsync(String helloWorld) async {
    await Future.delayed(Duration(seconds: 3));
    final helloWorldPointer = helloWorld.toNativeUtf8();

    // Create the NativeCallable.listener.
    final completer = Completer<String>();
    late final NativeCallable<NativeHelloWorldCallback> callback;

    void onResponse(Pointer<Utf8> responsePointer) {
      // Null check
      final Pointer<Void> nullptr = Pointer.fromAddress(0);
      if (responsePointer.address == nullptr.address) {
        return;
      }

      print('Hello from callback: ' + responsePointer.toDartString());
      completer.complete(responsePointer.toDartString());

      // Release the pointer if allocated in heap.
      // calloc.free(responsePointer);

      // Release, always
      calloc.free(helloWorldPointer);

      // Remember to close the NativeCallable once the native API is
      // finished with it, otherwise this isolate will stay alive
      // indefinitely.
      callback.close();
    }

    callback = NativeCallable<NativeHelloWorldCallback>.listener(onResponse);

    nativeHelloWorldAsync(helloWorldPointer, callback.nativeFunction);

    return completer.future;
  }

  Isolate.run(() => helloWorldAsync('string as a param'));

  for (var i = 10; i > 0; i--) {
    print("Wait for ${i} seconds");
    sleep(Duration(seconds: 1));
  }
  print("Bye");
}
