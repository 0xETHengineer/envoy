// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EnvoyIcons {
  static const IconData accounts = IconData(0xE903, fontFamily: 'EnvoyIcons');
  static const IconData devices = IconData(0xE906, fontFamily: 'EnvoyIcons');
  static const IconData lightbulb = IconData(0xE900, fontFamily: 'EnvoyIcons');
  static const IconData qr_scan = IconData(0xE904, fontFamily: 'EnvoyIcons');
  static const IconData copy_paste = IconData(0xE902, fontFamily: 'EnvoyIcons');
  static const IconData exclamation_warning =
      IconData(0xE901, fontFamily: 'EnvoyIcons');
}

class EnvoyIcon extends StatelessWidget {
  final String icon;
  final double size;

  EnvoyIcon({required this.icon, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/${this.icon}",
      width: this.size,
      height: this.size,
    );
  }
}
