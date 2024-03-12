// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io' show Directory;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'generated_bindings.dart';

void main() {
  // Open the dynamic library
  var libraryPath = path.join(
      Directory.current.path, '../../library/zig-out/lib', 'libstructs.so');
  final dylib = DynamicLibrary.open(libraryPath);
  final structs = Structs(dylib);

  final message = structs.hello_world().cast<Utf8>().toDartString();
  print("message: " + message);

  final backwards = 'backwards';
  final backwardsUtf8 = backwards.toNativeUtf8();
  final reversedMessageUtf8 =
      structs.reverse(backwardsUtf8.cast<Char>(), backwards.length);
  final reversedMessage = reversedMessageUtf8.cast<Utf8>().toDartString();
  calloc.free(backwardsUtf8);
  print('$backwards reversed is $reversedMessage');

  structs.free_string(reversedMessageUtf8);

  //
  final aaa = "AAA".toNativeUtf8();
  final Pointer<Place> place = calloc<Place>();
  place.ref.name = aaa.cast<Char>();
  final Coordinate coordicate = calloc<Coordinate>().ref;
  place.ref.coordinate = coordicate;
  place.ref.coordinate.latitude = 1.1;
  place.ref.coordinate.longitude = 2.34;

  final place2 = structs.create_place(place);

  final name = place2.ref.name.cast<Utf8>().toDartString();
  final coord = place2.ref.coordinate;
  final lat = place2.ref.coordinate.latitude;
  final long = place2.ref.coordinate.longitude;

  // The coord won't be correct after free
  print('The name of my place is $name at ' +
      '${coord.latitude}, ' +
      '${coord.longitude}');

  calloc.free(place);

  // Those lat and long are stil available as those are copied in Dart stack.
  print('lat: ' + lat.toString());
  print('long: ' + long.toString());
}
