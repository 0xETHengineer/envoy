// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/ui/background.dart';
import 'package:envoy/ui/shield.dart';
import 'package:flutter/material.dart';

class OnboardPageBackground extends StatelessWidget {
  final Widget child;

  const OnboardPageBackground({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _shieldTop = MediaQuery.of(context).padding.top + 6.0;
    double _shieldBottom = MediaQuery.of(context).padding.bottom + 6.0;
    return Stack(
      children: [
        AppBackground(),
        Padding(
          padding: EdgeInsets.only(
              right: 5.0, left: 5.0, top: _shieldTop, bottom: _shieldBottom),
          child: Hero(
            tag: "shield",
            transitionOnUserGestures: true,
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  return flightDirection == HeroFlightDirection.push
                      ? Stack(children: [
                          Opacity(
                              opacity: 1 - animation.value,
                              child: fromHeroContext.widget),
                          Opacity(
                              opacity: animation.value,
                              child: toHeroContext.widget)
                        ])
                      : Stack(children: [
                          Opacity(
                            opacity: 1 - animation.value,
                            child: toHeroContext.widget,
                          ),
                          Opacity(
                              opacity: animation.value,
                              child: Shield(
                                child: SizedBox.expand(),
                              ))
                        ]);
                },
              );
            },
            child: Shield(
              child: Padding(
                  padding: const EdgeInsets.only(
                      right: 15, left: 15, top: 15, bottom: 50),
                  child: SizedBox.expand(
                    child: child,
                  )),
            ),
          ),
        )
      ],
    );
  }
}
