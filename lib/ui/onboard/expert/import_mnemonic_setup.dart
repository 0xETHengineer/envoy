// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/envoy_button.dart';
import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/envoy_icons.dart';
import 'package:envoy/ui/onboard/expert/widgets/mnemonic_grid_widget.dart';
import 'package:envoy/ui/onboard/onboard_page_wrapper.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/ui/widgets/blur_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ImportMnemonicSeed extends StatefulWidget {
  final SeedLength seedLength;

  const ImportMnemonicSeed({Key? key, required this.seedLength})
      : super(key: key);

  @override
  State<ImportMnemonicSeed> createState() => _ImportMnemonicSeedState();
}

class _ImportMnemonicSeedState extends State<ImportMnemonicSeed> {
  bool hasPassphrase = false;
  String passPhrase = "";

  List<String> currentWords = [];


  @override
  Widget build(BuildContext context) {
    return OnboardPageBackground(
      child: Material(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.chevron_left, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    S().manual_setup_import_12_word_seed_done_heading,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.59,
                  child: MnemonicEntryGrid(
                      seedLength: widget.seedLength,
                      onSeedWordAdded: (List<String> words) {
                        currentWords = words;
                      }),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(2)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          hasPassphrase = !hasPassphrase;
                          if (hasPassphrase == true) {
                            showPassPhraseWarningDialog(context);
                          } else {
                            passPhrase = "";
                          }
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            checkColor: EnvoyColors.white100,
                            activeColor: EnvoyColors.darkTeal,
                            value: hasPassphrase,
                            onChanged: (value) {
                              setState(() {
                                hasPassphrase = value ?? false;
                              });
                              if (value == true) {
                                showPassPhraseWarningDialog(context);
                              } else {
                                passPhrase = "";
                              }
                            },
                          ),
                          Text(
                            S().manual_setup_import_12_word_seed_done_checkbox,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                        child: OnboardingButton(
                            label: S()
                                .manual_setup_import_12_word_seed_modify_seedword_1_2_CTA,
                            light: false,
                            onTap: () {
                              // IGOR: validate and go forth
                              if (!hasPassphrase) {
                                print(currentWords);
                              }
                              //TODO: validate bip39
                            }))
                  ],
                ),
              )
            ],
          ),
          color: Colors.transparent),
    );
  }

  void showPassPhraseWarningDialog(BuildContext context) {
    showEnvoyDialog(
            dialog: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 400,
                child: _buildPassphraseWarning(context)),
            context: context)
        .then((value) {
      setState(() {
        hasPassphrase = passPhrase.isNotEmpty;
      });
    });
  }

  void showPassphraseDialog(BuildContext context) {
    showEnvoyDialog(
            dialog: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 330,
                child: SeedPassPhraseEntry(onPassPhraseEntered: (value) {
                  print("Passphrase $value");
                  setState(() {
                    passPhrase = value;
                  });
                  //TODO: BIP39 passphrase
                  Navigator.pop(context);
                })),
            context: context)
        .then((value) {
      setState(() {
        hasPassphrase = passPhrase.isNotEmpty;
      });
    });
  }

  Widget _buildPassphraseWarning(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  hasPassphrase = false;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(EnvoyIcons.exclamation_warning,
                  color: EnvoyColors.darkCopper, size: 60),
              Padding(padding: EdgeInsets.all(4)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 6),
          child: Text(
            S().manual_setup_import_24_word_seed_verify_seedword_passphrase_warning_subheading,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
          child: Column(
            //Temporarily Disable Tor
            children: [
              EnvoyButton(
                S().manual_setup_import_24_word_seed_verify_seedword_verify_passphrase_CTA,
                onTap: () async {
                  Navigator.of(context).pop();
                  showPassphraseDialog(context);
                },
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }
}

class SeedPassPhraseEntry extends StatefulWidget {
  final Function(String passPhrase) onPassPhraseEntered;

  SeedPassPhraseEntry({Key? key, required this.onPassPhraseEntered})
      : super(key: key);

  @override
  State<SeedPassPhraseEntry> createState() => _SeedPassPhraseEntryState();
}

class _SeedPassPhraseEntryState extends State<SeedPassPhraseEntry> {
  TextEditingController _textEditingController = TextEditingController();
  PageController _pageController = PageController();
  bool verify = false;
  String passPhrase = "";
  bool hasError = false;
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildInput("Enter Passphrase", context),
        _buildInput("Verify Passphrase", context),
      ],
    );
  }

  Widget _buildInput(String title, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28).add(EdgeInsets.only(top: -6)),
      constraints: BoxConstraints(
        minHeight: 360,
        maxWidth: MediaQuery.of(context).size.width * 0.80,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.centerRight.add(Alignment(.1, 0)),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 0),
            child: Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 22)),
          ),
          Padding(padding: EdgeInsets.all(8)),
          Text(
              S().manual_setup_import_24_word_seed_verify_seedword_verify_passphrase_subheading,
              textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.all(8)),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                  focusNode: _focusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingController,
                  validator: (value) {
                    return null;
                  },
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    // Disable the borders
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  )),
            ),
          ),
          hasError
              ? Text("Passphrase did not match",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red))
              : SizedBox.shrink(),
          Padding(padding: EdgeInsets.all(12)),
          EnvoyButton(
            S().recovery_scenario_CTA,
            light: false,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            onTap: () {
              if (!verify && _textEditingController.text.isNotEmpty) {
                verify = true;
                passPhrase = _textEditingController.text;
                _textEditingController.text = "";
                _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              } else {
                setState(() {
                  hasError = passPhrase != _textEditingController.text;
                  if (!hasError) {
                    widget.onPassPhraseEntered(passPhrase);
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
