import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'generated_bindings.dart';

void main() {
  // Open the dynamic library
  var libraryPath =
      path.join(Directory.current.path, '../../library/zig-out/lib', 'libprimitives.so');
  final dylib = DynamicLibrary.open(libraryPath);
  final prim = Primitives(dylib);

  // Calls int sum(int a, int b);
  print('3 + 5 = ${prim.sum(3, 5)}');

  // Calls int subtract(int *a, int b);
  // Create a pointer
  final p = calloc<Int>();
  // Place a value into the address
  p.value = 3;
  print('3 - 5 = ${prim.subtract(p, 5)}');

  // Free up allocated memory.
  calloc.free(p);

  // calls int *multiply(int a, int b);
  final resultPointer = prim.multiply(3, 5);
  // Fetch the result at the address pointed to
  final int result = resultPointer.value;
  print('3 * 5 = $result');

  // Free up allocated memory. This time in C, because it was allocated in C.
  prim.free_pointer(resultPointer);
}
