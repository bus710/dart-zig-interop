// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:typed_data';
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

// Example of a complex struct (contains an array of 8 uint8 and a nested struct)
final class MyList extends Struct {
  external Coordinate coordinate;

  external Pointer<Uint8> array;
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
    Array<Uint8> dummy, Pointer<Char> name, Double latitude, Double longitude);
typedef CreatePlace = Place Function(
    Pointer<Char> dummy, Pointer<Char> name, double latitude, double longitude);

typedef CreateListNative = MyList Function(
    Pointer<Uint8> array ,  Double latitude, Double longitude);
typedef CreateList= MyList Function(
    Pointer<Uint8> array, double latitude, double longitude);


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

  // final myHomeUtf8 = 'ABB'.toNativeUtf8().cast<Char>();

  final printName =
      dylib.lookupFunction<PrintNameNative, PrintName>('print_name');
  printName("printName".toNativeUtf8());
  printName("printName".toNativeUtf8());
  printName("printName".toNativeUtf8());


  // https://github.com/dart-archive/ffi/issues/127
  final array = Uint8List.fromList([0,0,1,0]);

  final length = array.length;
  final pointer = calloc<Uint8>(length + 1); // +1 if null-terminated.
  for (int index = 0; index < length; index++) {
    pointer[index] = array[index];
  }

  final createList =
      dylib.lookupFunction<CreateListNative, CreateList>('create_list');
  final list = createList(pointer, 1.0, 2.0);

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
