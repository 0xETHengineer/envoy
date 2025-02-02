// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:io';

import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/onboard/onboard_page_wrapper.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/ui/onboard/wallet_setup_success.dart';
import 'package:envoy/ui/envoy_method_channel.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:envoy/business/envoy_seed.dart';
import 'package:envoy/business/settings.dart';

class MagicSetupGenerate extends StatefulWidget {
  const MagicSetupGenerate({Key? key}) : super(key: key);

  @override
  State<MagicSetupGenerate> createState() => _MagicSetupGenerateState();
}

class _MagicSetupGenerateState extends State<MagicSetupGenerate> {
  final walletGenerated = EnvoySeed().walletDerived();

  StateMachineController? stateMachineController;
  PageController _pageController = PageController();
  late int step;

  List<String> stepsHeadings = [
    Platform.isAndroid
        ? S().magic_setup_generate_envoy_key_android_heading
        : S().magic_setup_generate_envoy_key_ios_heading,
    S().magic_setup_generate_backup_heading,
    S().magic_setup_send_backup_to_envoy_server_heading,
  ];

  List<String> stepSubHeadings = [
    Platform.isAndroid
        ? S().magic_setup_generate_envoy_key_android_subheading
        : S().magic_setup_generate_envoy_key_ios_subheading,
    S().magic_setup_generate_backup_subheading,
    S().magic_setup_send_backup_to_envoy_server_subheading,
  ];

  bool isRiveInitialized = false;

  _onRiveInit(Artboard artboard) {
    stateMachineController =
        StateMachineController.fromArtboard(artboard, 'STM');
    artboard.addController(stateMachineController!);
    if (walletGenerated) {
      stateMachineController?.findInput<bool>('ShowKey')?.change(false);
      stateMachineController?.findInput<bool>('showLock')?.change(true);
      stateMachineController?.findInput<bool>('showShield')?.change(false);
    }
    if (!isRiveInitialized) {
      _initiateWalletCreate();
      isRiveInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    step = walletGenerated ? 1 : 0;
  }

  void _initiateWalletCreate() async {
    if (!walletGenerated) {
      Settings().syncToCloud = true;
      Settings().store();

      await EnvoySeed().generate();
    }

    if (!walletGenerated) {
      await Future.delayed(Duration(seconds: 2));
      if (mounted)
        setState(() {
          step = 1;
        });
      _updateProgress();
      //delay
    }
    _updateProgress();
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      step = 2;
    });
    _updateProgress();

    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MagicRecoveryInfo(skipSuccessScreen: walletGenerated);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: OnboardPageBackground(
        child: Material(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 280,
                    width: 280,
                    child: RiveAnimation.asset(
                      'assets/envoy_magic_setup.riv',
                      stateMachines: ["STM"],
                      onInit: _onRiveInit,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 280,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        ...stepsHeadings.map((heading) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  heading,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 44, horizontal: 22),
                                  child: Text(
                                    stepSubHeadings[
                                        stepsHeadings.indexOf(heading)],
                                    key: ValueKey<String>(
                                      stepSubHeadings[
                                          stepsHeadings.indexOf(heading)],
                                    ),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  ),
                )
              ],
            ),
            color: Colors.transparent),
      ),
    );
  }

  //Update page view and state machine
  _updateProgress() async {
    if (walletGenerated) {
      stateMachineController?.findInput<bool>('ShowKey')?.change(step == 0);
      stateMachineController?.findInput<bool>('showLock')?.change(step == 1);
      stateMachineController?.findInput<bool>('showShield')?.change(step == 2);
    } else {
      stateMachineController?.findInput<bool>('showLock')?.change(step != 2);
      stateMachineController?.findInput<bool>('showShield')?.change(step == 2);
    }
    _pageController.animateToPage(step,
        duration: Duration(milliseconds: 580), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    stateMachineController?.dispose();
    super.dispose();
  }
}

class MagicRecoveryInfo extends StatelessWidget {
  final bool skipSuccessScreen;
  final GestureTapCallback? onContinue;

  const MagicRecoveryInfo(
      {Key? key, this.skipSuccessScreen = false, this.onContinue = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Platform.isAndroid;
    bool _iphoneSE = MediaQuery.of(context).size.height < 700;
    return OnboardPageBackground(
      child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Image.asset(
                  "assets/exclamation_icon.png",
                  height: 180,
                  width: 180,
                ),
                height: _iphoneSE ? 220 : 250,
              ),
              isAndroid
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            S().android_backup_info_heading,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Padding(padding: EdgeInsets.all(12)),
                          LinkText(
                            text: S().android_backup_info_subheading,
                            onTap: () {
                              openAndroidSettings();
                            },
                            linkStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 14, color: EnvoyColors.blue),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : _iosBackupInfo(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnboardingButton(
                  label: S().component_continue,
                  onTap: () {
                    if (onContinue != null) {
                      onContinue!.call();
                      return;
                    }
                    if (skipSuccessScreen) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WalletSetupSuccess();
                      }));
                    }
                  },
                ),
              ),
            ],
          ),
          color: Colors.transparent),
    );
  }

  _iosBackupInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Platform.isAndroid
                ? S().recovery_scenario_android_subheading
                : S().recovery_scenario_ios_heading,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(padding: EdgeInsets.all(12)),
          Text(
            Platform.isAndroid
                ? S().recovery_scenario_android_subheading
                : S().recovery_scenario_ios_subheading,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
          Padding(padding: EdgeInsets.all(12)),
          ListTile(
            minLeadingWidth: 20,
            dense: true,
            leading: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: EnvoyColors.teal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "1",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
            title: Text(
              Platform.isAndroid
                  ? S().recovery_scenario_ios_instructions1
                  : S().recovery_scenario_ios_instructions1,
              textAlign: TextAlign.start,
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
            ),
          ),
          ListTile(
            minLeadingWidth: 20,
            dense: true,
            leading: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: EnvoyColors.teal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "2",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
            title: Text(
              Platform.isAndroid
                  ? S().recovery_scenario_ios_instructions2
                  : S().recovery_scenario_ios_instructions2,
              textAlign: TextAlign.start,
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
            ),
          ),
          ListTile(
            minLeadingWidth: 20,
            dense: true,
            leading: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: EnvoyColors.teal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("3",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white)),
            ),
            title: Text(
              Platform.isAndroid
                  ? S().recovery_scenario_android_instructions3
                  : S().recovery_scenario_ios_instructions3,
              textAlign: TextAlign.start,
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
