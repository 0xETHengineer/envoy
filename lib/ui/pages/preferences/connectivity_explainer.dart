// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/ui/indicator_shield.dart';
import 'package:envoy/ui/pages/preferences/notifications_explainer.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:envoy/ui/templates/onboarding_page.dart';
import 'package:envoy/ui/home/settings/setting_toggle.dart';
import 'package:envoy/business/settings.dart';

class ConnectivityExplainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var s = Settings();
    return OnboardingPage(
      key: Key("connectivity_explainer"),
      text: [
        OnboardingText(
            header: "Envoy uses Tor to protect your privacy",
            text:
                "Tor, short for The Onion Router, is free and open-source software for enabling anonymous communication online."),
        IndicatorShield(),
        OnboardingText(
            header: "Shield determines your connection status",
            text:
                "Right now your shield is blue which means that you are connected to the Tor network and your communication is secure"),
        SettingToggle(s.torEnabled, s.setTorEnabled),
      ],
      buttons: [
        OnboardingButton(
            label: "Continue",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return NotificationsExplainer();
              }));
            }),
      ],
    );
  }
}
