// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/onboard/onboard_page_wrapper.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class WalletSetupFinish extends StatefulWidget {
  const WalletSetupFinish({Key? key}) : super(key: key);

  @override
  State<WalletSetupFinish> createState() => _WalletSetupFinishState();
}

class _WalletSetupFinishState extends State<WalletSetupFinish> {
  @override
  Widget build(BuildContext context) {
    return OnboardPageBackground(
      child: Material(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 240,
                  height: 240,
                  child: RiveAnimation.asset(
                    "assets/envoy_loader.riv",
                    fit: BoxFit.contain,
                    animations: ["happy"],
                  ),
                ),
                Text(
                  S().wallet_is_setup_heading,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  S().wallet_is_setup_subheading,
                ),
                OnboardingButton(
                    light: false,
                    label: S().wallet_is_setup_CTA,
                    onTap: () {
                      Navigator.of(context).popUntil(ModalRoute.withName("/"));
                    }),
              ],
            ),
          ),
          color: Colors.transparent),
    );
  }
}