// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:math';

import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/envoy_icons.dart';
import 'package:envoy/ui/onboard/expert/encrypted_storage_setup.dart';
import 'package:envoy/ui/onboard/expert/widgets/wordlist.dart';
import 'package:envoy/ui/onboard/onboard_page_wrapper.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/ui/onboard/expert/widgets/seed_word_verification.dart';
import 'package:envoy/ui/widgets/blur_dialog.dart';
import 'package:envoy/util/haptics.dart';
import 'package:flutter/material.dart';

class GenerateSeedScreen extends StatefulWidget {
  const GenerateSeedScreen({Key? key}) : super(key: key);

  @override
  State<GenerateSeedScreen> createState() => _GenerateSeedScreenState();
}

class _GenerateSeedScreenState extends State<GenerateSeedScreen> {
  PageController _pageController = PageController();
  List<String> seed = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Random random = Random();
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        seed = List.generate(
            12, (index) => seed_en[random.nextInt(seed_en.length)]);
      });
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardPageBackground(
      child: Material(
        color: Colors.transparent,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildSeedGenerating(context),
            _buildMnemonicGrid(context),
            VerifySeedPuzzleWidget(
                seed: seed,
                onVerificationFinished: (bool verified) async {
                  //TODO: Show
                  if (verified) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => StorageSetupPage()));
                  } else {
                    await Future.delayed(Duration(milliseconds: 100));
                    Haptics.heavyImpact();
                    showVerificationFailedDialog(context);
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedGenerating(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(padding: EdgeInsets.all(14)),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: EnvoyColors.darkTeal,
              ),
              Padding(padding: EdgeInsets.all(14)),
              Text("Generating Seed",
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMnemonicGrid(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text("Write Down the 12 Worlds",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center),
              ),
              SliverPadding(padding: EdgeInsets.all(24)),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  crossAxisSpacing: 34.0,
                  mainAxisSpacing: 34,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final TextStyle textTheme = TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold);
                  return Container(
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints(maxWidth: 200, maxHeight: 12),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Text("${index + 1}. ", style: textTheme),
                        Expanded(
                            child: Text("${seed[index]}", style: textTheme)),
                      ],
                    ),
                  );
                }, childCount: seed.length),
              ),
              SliverPadding(padding: EdgeInsets.all(32)),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OnboardingButton(
                      onTap: () {
                        _pageController.animateToPage(2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      label: "Done",
                    )
                  ],
                ),
              )
            ],
          ),
        ))
      ],
    );
  }

  void showVerificationFailedDialog(BuildContext context) {
    showEnvoyDialog(
      context: context,
      dismissible: false,
      builder: Builder(builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.38,
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.all(24)),
                Expanded(
                    child: Column(
                  children: [
                    Icon(EnvoyIcons.exclamation_warning,
                        color: EnvoyColors.brown, size: 56),
                    Padding(padding: EdgeInsets.all(12)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "That seed appears to be invalid.\nPlease check the words you wrote,\nincluding the order they are in and\ntry again.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )),
                OnboardingButton(
                    label: "Go back",
                    onTap: () async {
                      await Navigator.maybePop(context);
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 320),
                          curve: Curves.easeInSine);
                    }),
                Padding(padding: EdgeInsets.all(12)),
              ],
            ),
          ),
        );
      }),
    );
  }
}