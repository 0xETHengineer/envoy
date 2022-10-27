// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'dart:io' show Platform;
import 'dart:typed_data';

typedef WhirlpoolRust = Pointer<Uint8> Function();
typedef WhirlpoolDart = Pointer<Uint8> Function();

typedef StopRust = Pointer<Uint8> Function(Pointer<Uint8>);
typedef StopDart = Pointer<Uint8> Function(Pointer<Uint8>);

DynamicLibrary load(name) {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('lib$name.so');
  } else if (Platform.isLinux) {
    return DynamicLibrary.open('target/debug/lib$name.so');
  } else if (Platform.isIOS || Platform.isMacOS) {
    // iOS and MacOS are statically linked, so it is the same as the current process
    return DynamicLibrary.process();
  } else {
    throw NotSupportedPlatform('${Platform.operatingSystem} is not supported!');
  }
}

class NotSupportedPlatform implements Exception {
  NotSupportedPlatform(String s);
}

class Whirlpool {
  static late String _libName = "whirlpool_ffi";
  static late DynamicLibrary _lib;

  Pointer<Uint8> _self = Pointer<Uint8>.fromAddress(0);


  Whirlpool() {
    _lib = load(_libName);

    final rustFunction =
    _lib.lookup<NativeFunction<WhirlpoolRust>>('whirlpool');
    final dartFunction = rustFunction.asFunction<WhirlpoolDart>();

    _self = dartFunction();
  }
}

