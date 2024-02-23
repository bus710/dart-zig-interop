// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io' show Directory;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

// Example of a complex struct (contains a string)
final class Data extends Struct {
  external Pointer<Utf8> Text;
}

typedef CreateDataNative = Data Function(
    Pointer<Uint8> Text);
typedef CreateList= Data Function(
    Pointer<Uint8> Text);

void main() {
  // Open the dynamic library
  var libraryPath = path.join(
      Directory.current.path, './', 'libstructs.so');
  final dylib = DynamicLibrary.open(libraryPath);

  final myHomeUtf8 = 'ABB'.toNativeUtf8();

  final createdata =
      dylib.lookupFunction<CreateDataNative, CreateData>('create_data');
  final list = createList(myHomeUtf8);

  list.array;

  for(int index = 0; index < length; index++){
    array[index] = list.array[index];
  }

  print(array);
  print(array);

  //

  // final createPlace =
  //     dylib.lookupFunction<CreatePlaceNative, CreatePlace>('create_place');
  // final place = createPlace(myHomeUtf8, myHomeUtf8, 1.0, 2.0);
  //
  // var name2 = place.name.toString();
  // print(name2);
  //
  // print("++ " + place.name.toDartString(length: 2));
  // final name = place.name.toDartString(length: 2);

  // var name = myHomeUtf8;
  // calloc.free(myHomeUtf8);
  //
  // final coord = place.coordinate;
  // print(
  //     'The name of my place is $name at ${coord.latitude}, ${coord.longitude}');
  // final distance = dylib.lookupFunction<DistanceNative, Distance>('distance');
  // final dist = distance(createCoordinate(2.0, 2.0), createCoordinate(5.0, 6.0));
  // print("distance between (2,2) and (5,6) = $dist");
}
