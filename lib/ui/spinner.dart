// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class Spinner extends StatefulWidget {
  const Spinner({Key? key}) : super(key: key);

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/spinner.json',
      controller: _controller,
      onLoaded: (composition) {
        // Configure the AnimationController with the duration of the
        // Lottie file and start the animation.
        print(composition.duration);

        _controller.duration = composition.duration;
        _controller.animateTo(0.5);
        },
    );
  }
}
