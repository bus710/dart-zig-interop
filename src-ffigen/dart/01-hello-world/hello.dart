import 'dart:ffi' as ffi;
import 'dart:io' show Directory;

import 'package:path/path.dart' as path;

import 'generated_bindings.dart';

void main() {
  // Open the dynamic library
  var libraryPath =
      path.join(Directory.current.path, '../../library/zig-out/lib', 'libhello.so');

  final dylib = ffi.DynamicLibrary.open(libraryPath);
  final hello = Hello(dylib);

  // Call the function
  hello.hello_world(); 
}
