// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/pages/scv/scv_intro.dart';
import 'package:flutter_html/flutter_html.dart';

class TouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //ignore:unused_local_variable

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: OnboardingPage(
        key: Key("tou"),
        text: [
          OnboardingText(header: S().envoy_passport_tou_heading),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.0),
              scrollDirection: Axis.vertical,
              child: FutureBuilder<String>(
                  future: rootBundle.loadString('assets/passport_tou.html'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Html(
                        data: snapshot.data,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
            ),
          )
        ],
        buttons: [
          OnboardingButton(
              label: S().envoy_passport_tou_cta,
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScvIntroPage();
                }));
              }),
        ],
      ),
    );
  }
}
