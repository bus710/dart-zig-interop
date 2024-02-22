// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io' show Directory;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

// Example of handling a simple C struct
final class Coordinate extends Struct {
  @Double()
  external double latitude;

  @Double()
  external double longitude;
}

// Example of a complex struct (contains a string and a nested struct)
final class Place extends Struct {
  external Coordinate coordinate;
  external Pointer<Utf8> dummy;
  external Pointer<Utf8> name;
}

// C function: char *hello_world();
// There's no need for two typedefs here, as both the
// C and Dart functions have the same signature
typedef HelloWorld = Pointer<Utf8> Function();

// C function: char *reverse(char *str, int length)
typedef ReverseNative = Pointer<Utf8> Function(Pointer<Utf8> str, Int32 length);
typedef Reverse = Pointer<Utf8> Function(Pointer<Utf8> str, int length);

// C function: void free_string(char *str)
typedef FreeStringNative = Void Function(Pointer<Utf8> str);
typedef FreeString = void Function(Pointer<Utf8> str);

// C function: struct Coordinate create_coordinate(double latitude, double longitude)
typedef CreateCoordinateNative = Coordinate Function(
    Double latitude, Double longitude);
typedef CreateCoordinate = Coordinate Function(
    double latitude, double longitude);

// C function: struct Place create_place(char *name, double latitude, double longitude)
typedef CreatePlaceNative = Place Function(
    Pointer<Char> dummy, Pointer<Char> name, Double latitude, Double longitude);
typedef CreatePlace = Place Function(
    Pointer<Char> dummy, Pointer<Char> name, double latitude, double longitude);

typedef DistanceNative = Double Function(Coordinate p1, Coordinate p2);
typedef Distance = double Function(Coordinate p1, Coordinate p2);

typedef PrintNameNative = Pointer<Utf8> Function(Pointer<Utf8> name);
typedef PrintName = Pointer<Utf8> Function(Pointer<Utf8> name);

void main() {
  // Open the dynamic library
  var libraryPath = path.join(
      Directory.current.path, '../../library/zig-out/lib', 'libstructs.so');
  final dylib = DynamicLibrary.open(libraryPath);

  final helloWorld =
      dylib.lookupFunction<HelloWorld, HelloWorld>('hello_world');
  final message = helloWorld().toDartString();
  print(message);

  final reverse = dylib.lookupFunction<ReverseNative, Reverse>('reverse');
  final backwards = 'backwards';
  final backwardsUtf8 = backwards.toNativeUtf8();
  final reversedMessageUtf8 = reverse(backwardsUtf8, backwards.length);
  final reversedMessage = reversedMessageUtf8.toDartString();
  calloc.free(backwardsUtf8);
  print('$backwards reversed is $reversedMessage');

  final freeString =
      dylib.lookupFunction<FreeStringNative, FreeString>('free_string');
  freeString(reversedMessageUtf8);

  final createCoordinate =
      dylib.lookupFunction<CreateCoordinateNative, CreateCoordinate>(
          'create_coordinate');
  final coordinate = createCoordinate(3.5, 4.6);
  print(
      'Coordinate is lat ${coordinate.latitude}, long ${coordinate.longitude}');

  final myHomeUtf8 = 'BBB'.toNativeUtf8().cast<Char>();

  final printName =
      dylib.lookupFunction<PrintNameNative, PrintName>('print_name');
  printName("printName".toNativeUtf8());
  printName("printName".toNativeUtf8());
  printName("printName".toNativeUtf8());

  final createPlace =
      dylib.lookupFunction<CreatePlaceNative, CreatePlace>('create_place');
  final place = createPlace(myHomeUtf8, myHomeUtf8, 1.0, 2.0);

  var name2 = place.name.cast<Char>();
  print(name2.value.toString());

  print("++ " + place.name.toDartString(length: 2));
  final name = place.name.toDartString(length: 2);

  calloc.free(myHomeUtf8);

  final coord = place.coordinate;
  print(
      'The name of my place is $name at ${coord.latitude}, ${coord.longitude}');
  final distance = dylib.lookupFunction<DistanceNative, Distance>('distance');
  final dist = distance(createCoordinate(2.0, 2.0), createCoordinate(5.0, 6.0));
  print("distance between (2,2) and (5,6) = $dist");
}
