// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/ui/pages/preferences/connectivity_explainer.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:envoy/ui/templates/onboarding_page.dart';
import 'package:envoy/ui/home/settings/setting_toggle.dart';
import 'package:envoy/business/settings.dart';

class NotificationsExplainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var s = Settings();
    return OnboardingPage(
      key: Key("notifications_explainer"),
      text: [
        OnboardingText(
            header: "Envoy would like to send you notifications",
            text:
                "This is only used to notify you of Passport Firmware updates"),
        SettingToggle(
            s.pushNotificationsEnabled, s.setPushNotificationsEnabled),
      ],
      buttons: [
        OnboardingButton(
            label: "Continue",
            onTap: () {
              OnboardingPage.goHome(context);
            }),
      ],
    );
  }
}
