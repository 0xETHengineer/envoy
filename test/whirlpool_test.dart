// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:test/test.dart';
import 'package:whirlpool/whirlpool.dart';

void main() async {
  test('Start whirlpool', () async {
    var whirlpool = Whirlpool();

    print(whirlpool);
  });
}