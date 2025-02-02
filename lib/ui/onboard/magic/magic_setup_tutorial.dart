// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/ui/embedded_video.dart';
import 'package:envoy/ui/envoy_button.dart';
import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/onboard/magic/magic_recover_wallet.dart';
import 'package:envoy/ui/onboard/magic/wallet_security/wallet_security_modal.dart';
import 'package:envoy/ui/onboard/onboard_page_wrapper.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:envoy/generated/l10n.dart';
import 'dart:io';
import 'package:envoy/ui/onboard/magic/magic_setup_generate.dart';
import 'package:envoy/ui/widgets/blur_dialog.dart';

class MagicSetupTutorial extends StatefulWidget {
  const MagicSetupTutorial({Key? key}) : super(key: key);

  @override
  State<MagicSetupTutorial> createState() => _MagicSetupTutorialState();
}

class _MagicSetupTutorialState extends State<MagicSetupTutorial> {
  GlobalKey<EmbeddedVideoState> _playerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool _iphoneSE = MediaQuery.of(context).size.height < 700;
    return OnboardPageBackground(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoNavigationBarBackButton(
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: TextButton(
                child: Text(S().magic_setup_tutorial_ios_skip,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black)),
                onPressed: () {
                  OnboardingPage.goHome(context);
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      EmbeddedVideo(
                        path: "assets/videos/magic_backups.mp4",
                        key: _playerKey,
                      ),
                      Padding(padding: EdgeInsets.all(_iphoneSE ? 8 : 16)),
                      Text(
                        S().magic_setup_tutorial_ios_heading,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Padding(padding: EdgeInsets.all(_iphoneSE ? 0 : 24)),
                      LinkText(
                        text: Platform.isAndroid
                            ? S().magic_setup_tutorial_android_subheading
                            : S().magic_setup_tutorial_ios_subheading,
                        onTap: () {
                          _playerKey.currentState?.pause();
                          showEnvoyDialog(
                              context: context,
                              dialog: WalletSecurityModal(
                                onLastStep: () {
                                  Navigator.pop(context);
                                },
                              ));
                        },
                      ),
                    ],
                  ),
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OnboardingButton(
                        fontWeight: FontWeight.w600,
                        type: EnvoyButtonTypes.secondary,
                        label: S().magic_setup_tutorial_ios_CTA2,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                color: EnvoyColors.darkTeal,
                                fontWeight: FontWeight.w600),
                        onTap: () {
                          _playerKey.currentState?.pause();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MagicRecoverWallet();
                          }));
                        }),
                    OnboardingButton(
                        fontWeight: FontWeight.w600,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                color: EnvoyColors.white100,
                                fontWeight: FontWeight.w600),
                        label: S().magic_setup_tutorial_ios_CTA1,
                        onTap: () {
                          _playerKey.currentState?.pause();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MagicSetupGenerate();
                          }));
                          // showCreateWarning(context);
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }

// void showCreateWarning(BuildContext context) {
//   showEnvoyDialog(
//     context: context,
//     dismissible: true,
//     builder: Builder(builder: (context) {
//       return Container(
//         width: MediaQuery.of(context).size.width * 0.8,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(padding: EdgeInsets.all(24)),
//               Column(
//                 children: [
//                   Icon(EnvoyIcons.exclamation_warning,
//                       color: EnvoyColors.darkCopper, size: 56),
//                   Padding(padding: EdgeInsets.all(12)),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Text(
//                       Platform.isAndroid
//                           ? S()
//                               .magic_setup_generate_wallet_modal_android_subheading
//                           : S()
//                               .magic_setup_generate_wallet_modal_ios_subheading,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//               OnboardingButton(
//                   label: Platform.isAndroid
//                       ? S().magic_setup_generate_wallet_modal_android_CTA
//                       : S().magic_setup_generate_wallet_modal_ios_CTA,
//                   onTap: () async {
//                     Navigator.pop(context);
//                     Navigator.of(context)
//                         .push(MaterialPageRoute(builder: (context) {
//                       return MagicSetupGenerate();
//                     }));
//                   }),
//               Padding(padding: EdgeInsets.all(12)),
//             ],
//           ),
//         ),
//       );
//     }),
//   );
// }
}
