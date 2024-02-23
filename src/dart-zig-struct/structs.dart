// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io' show Directory;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

// Example of a complex struct (contains an array of 8 uint8 and a nested struct)
final class Data extends Struct {
  external Pointer<Utf8> Text;
}

// C function: char *hello_world();
// There's no need for two typedefs here, as both the
// C and Dart functions have the same signature
typedef HelloWorld = Pointer<Utf8> Function();

// C function: void free_string(char *str)
typedef FreeStringNative = Void Function(Pointer<Utf8> str);
typedef FreeString = void Function(Pointer<Utf8> str);

typedef CreateDataNative = Pointer<Data> Function(Pointer<Data> Text);
typedef CreateData = Pointer<Data> Function(Pointer<Data> Text);

void main() {
  // Open the dynamic library
  var libraryPath = path.join(Directory.current.path, './', 'libstructs.so');
  final dylib = DynamicLibrary.open(libraryPath);

  final helloWorld =
      dylib.lookupFunction<HelloWorld, HelloWorld>('hello_world');
  final message = helloWorld().toDartString();
  print(message);

  final aaa = "AAA".toNativeUtf8();

  final Pointer<Data> data = calloc<Data>();
  data.ref.Text = aaa;

  final createData =
      dylib.lookupFunction<CreateDataNative, CreateData>('create_data');
  final data2 = createData(data);

  // print(data);
  final text = data2.ref.Text.toDartString();
  print(text);
  calloc.free(data);
  // calloc.free(data2);
}
